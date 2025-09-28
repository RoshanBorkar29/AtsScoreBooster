import io  #thi are the input/output module
import pdfplumber# this will be used to extract the text
from docx import Document#used to read and manipulate words
from fastapi import HTTPException#use for api

def extract_text_from_file(file_bytes:bytes,file_type:str)->str:
    #this function will extract content from uploaded file bytes
    # this function will return string

    if file_type=="application/pdf":
        try:
            with pdfplumber.open(io.BytesIO(file_bytes)) as pdf:
                text="\n".join(page.extract_text() for page in pdf.pages if page.extract_text())
                return text
        except Exception as e:
            print(f"PDF Extraction Error:{e}")
            raise HTTPException(status_code=500,detail="Failed to process PDF file.")
        ## here first we check if the file we get from frontend is the pdf file
        ## then we wrap the file_bytes in io.bytesIo to create virtual file for pdfplumber to work
        ##then we iterate over every page in wraped pdf and extract texts from each page and joins in new string
    elif file_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
        try:
            document=Document(io.BytesIO(file_bytes))
            text="\n".join([paragraph.text for paragraph in document.paragraphs])
            return text
        except Exception as e:
            print(f"DOCX Extraction Error: {e}")
            raise HTTPException(status_code=500, detail="Failed to process DOCX file.")
    else:
        raise HTTPException(status_code=400, detail="Unsupported file type.")
    
 
 