from pydantic import BaseModel
from typing import Optional
from bson import ObjectId
from fastapi.encoders import jsonable_encoder

from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class Loan(BaseModel):
    book_code: str
    student_id: str
    issue_date: datetime
    return_date: datetime
    status: Optional[str] = "issued"
    class Config:
        json_encoders = {
            ObjectId: str
        }
