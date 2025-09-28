# models.py
from pydantic import BaseModel

class AtsScoreResult(BaseModel):
    score: int
    matched_keywords: list[str]
    to_add: list[str]
    to_remove: list[str]
    message: str
    # You might also add a model for the input data if you expand it later