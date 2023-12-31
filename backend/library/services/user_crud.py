from motor.motor_asyncio import AsyncIOMotorClient
from library.models.user import User, UserInDB, TokenData
from library.config.database import users_collection
from bson import ObjectId
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from datetime import datetime, timedelta
from fastapi import Depends, HTTPException, status


SECRET_KEY = "226a9980ee5b1fe0bbaedfc696629baf"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/token")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

async def get_user_from_db(id: str):
    user = await users_collection.find_one({"_id": ObjectId(id)})
    if user:
        user['_id'] = str(user['_id'])
        return UserInDB(**user)

async def get_user_from_username(username: str):
    user = await users_collection.find_one({"username": username})
    if user:
        user['_id'] = str(user['_id'])
        return UserInDB(**user)
    
async def authenticate_user(username: str, password: str):
    user = await users_collection.find_one({"username": username})
    if not user:
        return False
    user['_id'] = str(user['_id'])
    user = UserInDB(**user)
    if not verify_password(password, user.hashed_password):
        return False
    return user


async def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
      expire = datetime.utcnow() + timedelta(minutes = 30)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm = ALGORITHM)
    return encoded_jwt

async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code = status.HTTP_401_UNAUTHORIZED,
        detail = "Could not validate credentials",
        headers = {"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms = [ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username = username)
    except JWTError:
        raise credentials_exception
    user = await get_user_from_username(username = token_data.username)
    if user is None:
        raise credentials_exception
    return user

async def get_current_active_user(current_user: User = Depends(get_current_user)):
    if current_user.disabled:
        raise HTTPException(status_code = 400, detail = "Inactive user")
    return current_user

async def get_current_admin_user(current_user: User = Depends(get_current_active_user)):
    if current_user.role != 'admin':
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Insufficient permissions"
        )
    return current_user


async def insert_user_to_db(user: dict):
    try:
        new_user = await users_collection.insert_one(user)
        created_user = await users_collection.find_one({"_id": new_user.inserted_id})
        
        if created_user:
            created_user['_id'] = str(created_user['_id'])
            return created_user
        else:
            return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

