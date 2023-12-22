from pydantic import BaseModel, Field
from bson import ObjectId
from typing import Optional

from pydantic import BaseModel, Field
from typing import Optional

class User(BaseModel):
    id: Optional[str] = Field(alias='_id')  # Using str directly for ObjectId
    username: Optional[str] = None
    disabled: Optional[bool] = None
    role: Optional[str] = None
    class Config:
        from_attributes = True
        populate_by_name = True
        json_encoders = {
            ObjectId: lambda oid: str(oid)  # Convert ObjectId to string
        }

class UserCreate(BaseModel):
    username: str
    password: str
    role: str
    disabled: Optional[bool] = None

class UserInDB(User):
    hashed_password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None

class UserInDB(User):
    hashed_password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None
