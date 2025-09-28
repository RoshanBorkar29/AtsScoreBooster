from fastapi import FastAPI, UploadFile, File, Form, HTTPException, status
import io

from models import AtsScoreResult
from processor import extract_text_from_file 
from analyzer import analyze_resume

app = FastAPI(
    title="ATS Score Booster API",
    description="Analyzes a resume against a job title to provide an ATS compatibility score and recommendations."
)

@app.get("/")
def read_root():
    return {"message": "ATS Score Booster API is running."}

@app.post("/process-resume",response_model=AtsScoreResult)
async def process_resume(
    resume_file:UploadFile=File(...),
    job_title:str=Form(...),
):
    if not job_title or job_title.strip()=="":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Job title cannot be empty."
        )
    try:
        file_bytes=await resume_file.read()
        file_type=resume_file.content_type

    except Exception:
        raise HTTPException(
status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Could not read file data."
        )
    try:
        resume_text=extract_text_from_file(file_bytes,file_type)
        if not resume_text or len(resume_text.strip())<50:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Could not extract meaningFul text from resume."
            )
    except HTTPException:
        raise 
    except Exception as e:
          print(f"Error during text processing: {e}")
          raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="An unexpected error occurred during text extraction."
        )
    try:
        result=analyze_resume(resume_text,job_title)
    except Exception as e:
        print(f"Error during analysis: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="An error occurred during score calculation and analysis."
        )

    # 5. Return Structured Result
    return result