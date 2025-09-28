# scoring/analyzer.py

# Import the response data model
from models import AtsScoreResult##import the structure  of ats score

# Import standard library tools for text handling
import re ## user for pattern matchin and cleaning up text
from collections import Counter ## this counts the frequency of items in a list

def analyze_resume(resume_text:str,job_title:str)->AtsScoreResult:
    ## this will match the keyword matching and calculate teh ats score
    target_keywords=[
        "Python", "FastAPI", "REST API", "SQL", "Cloud", 
        "Software Engineering", "Flutter", "Agile", "Microservices"
    ]
    # Convert to lowercase and remove non-alphanumeric characters for simpler matching
    clean_resume = re.sub(r'[^a-z0-9\s]', '', resume_text.lower())

    matched_keywords=[]
    for keyword in target_keywords:
        if keyword.lower() in clean_resume:
            matched_keywords.append(keyword)
    total_keywords=len(target_keywords)
    matched_count=len(matched_keywords)

    score=int((matched_count/total_keywords)*100) if total_keywords>0 else 0
    keywords_to_add=[
        kw for kw in target_keywords
        if kw not in matched_keywords
    ]

    to_remove=[
        "Remove outdated skills that are not relevant to the job.",
        "Shorten your objective/summary to 3 lines maximum."
    ]
   # 5. Return Structured Result
    return AtsScoreResult(
        score=score,
        matched_keywords=matched_keywords,
        to_add=keywords_to_add,
        to_remove=to_remove,
        message=f"Your score is {score}% for the {job_title} role."
    )