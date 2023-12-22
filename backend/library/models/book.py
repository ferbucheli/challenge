from pydantic import BaseModel
from typing import Optional

class Book(BaseModel):
    code: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    author: Optional[str] = None
    quantity: Optional[int] = None
    reserved_quantity: Optional[int] = 0

class UpdateBook(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    quantity: Optional[int] = None
    reserved_quantity: Optional[int] = 0