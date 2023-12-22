from fastapi import APIRouter
from library.models.book import Book, UpdateBook
from library.models.user import Token, User, UserCreate
from library.config.database import books_collection
from library.schema.schemas import serialize_book, multiple_serial
from bson import ObjectId
from fastapi import Depends, HTTPException, status
from library.services.books_crud import (
    get_all_books_from_db, 
    insert_book_to_db, 
    update_book_from_db, 
    delete_book_from_db, 
    get_book_by_code 
)
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from library.services.user_crud import (
  authenticate_user, 
  create_access_token, 
  get_current_active_user, 
  insert_user_to_db, 
  get_password_hash, 
  get_current_admin_user,
  ACCESS_TOKEN_EXPIRE_MINUTES
)
from datetime import timedelta
from library.models.loan import Loan
from library.services.loans_crud import (
    get_all_loans_from_db, 
    insert_loan_to_db, 
    update_loan_from_db, 
    delete_loan_from_db,
    reserve_book,
    cancel_reservation,
    confirm_loan,
    return_book,
    get_loans_by_user
)
from fastapi.responses import JSONResponse

router = APIRouter()

# GET All Books - Only authenticated users can access this route
@router.get("/api/books", response_description="List all books")
async def get_all_books(current_user: User = Depends(get_current_active_user)):
    books = await get_all_books_from_db()
    return multiple_serial(books)

@router.get("/api/books/{code}", response_description="Get a book by code", response_model=Book)
async def get_book_by_code_route(code: str, current_user: User = Depends(get_current_active_user)):
    try:
        book = await get_book_by_code(code)
        if not book:
            return JSONResponse(
                status_code=404,
                content={
                    "status": "error",
                    "message": "Book not found",
                    "data": None
                }
            )
        return JSONResponse(
            content={
                "status": "success",
                "data": book # Ensure book is serialized properly
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )


# Post a Book - Only authenticated users can access this route
@router.post("/api/books", response_description="Add new book", response_model=Book)
async def create_book(book: Book, current_admin: User = Depends(get_current_admin_user)):   
    try:
        print(book)
        created_book = await insert_book_to_db(serialize_book(book))  # Your logic to fetch the book
        if created_book:
            return JSONResponse(
                content={
                    "status": "success",
                    "data": Book(**created_book).dict()
                }
            )
        return JSONResponse(
            status_code=404,
            content={
                "status": "error",
                "message": "Book not created",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )


# PUT Request - Only authenticated users can access this route
@router.put("/api/books/{code}", response_description="Update a book", response_model=Book)
async def update_book(code: str, book: UpdateBook, current_admin: User = Depends(get_current_admin_user)):
    updated_book = await update_book_from_db(code, serialize_book(book))
    if updated_book:
        return Book(**updated_book)
    raise HTTPException(status_code=404, detail="Book not updated")

# DELETE Request - Only authenticated users can access this route
@router.delete("/api/books/{code}", response_description="Delete a book")
async def delete_book(code: str, current_admin: User = Depends(get_current_admin_user)):
    deleted_book = await delete_book_from_db(code)
    if deleted_book:
        return "Book deleted"
    raise HTTPException(status_code=404, detail=f"Book not found with code {code}")



@router.post("/api/token", response_description="Get token", response_model=Token)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    user = await authenticate_user(form_data.username, form_data.password)
    if not user:
        print("User not found")
        raise HTTPException(
            status_code = status.HTTP_401_UNAUTHORIZED,
            detail = "Incorrect username or password",
            headers = {"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes = ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = await create_access_token(
        data = {"sub": user.username}, expires_delta = access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/api/login", response_description="User login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = await authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password"
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = await create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return JSONResponse(
        content={
            "status": "success",
            "data": {
                "token": access_token,
                "user": user.dict()
            }
        }
    )



@router.get("/api/users/me", response_description="Get current user")
async def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user

@router.get("/api/users/me/items", response_description="Get items of current user")
async def read_own_items(current_user: User = Depends(get_current_active_user)):
    return [{"item_id": "Foo", "owner": current_user.username}]


@router.post("/api/users/create", response_description="Create new user", response_model=User)
async def create_user(user_create: UserCreate):
    user_data = user_create.dict()
    # Handle password hashing and other business logic here
    user_data['hashed_password'] = get_password_hash(user_data.pop('password'))

    user = await insert_user_to_db(user_data)
    if user:
        return User(**user)
    raise HTTPException(status_code=404, detail="User not created")

# GET All Loans - Only authenticated users can access this route
@router.get("/api/loans", response_description="List all loans")
async def get_all_loans(current_admin: User = Depends(get_current_admin_user)):
    try:
        loans = await get_all_loans_from_db()
        if loans:
            return JSONResponse(
                content={
                    "status": "success",
                    "data": loans
                }
            )
        return JSONResponse(
            status_code=404,
            content={
                "status": "error",
                "message": "No loans found",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )


# POST a Loan - Only authenticated users can access this route
@router.post("/api/loans", response_description="Create new loan", response_model=Loan)
async def create_loan(loan: Loan, current_user: User = Depends(get_current_active_user)):
    created_loan = await insert_loan_to_db(loan.dict())
    if created_loan:
        return Loan(**created_loan)
    raise HTTPException(status_code=404, detail="Loan not created")

# PUT Request to Update Loan - Only authenticated users can access this route
@router.put("/api/loans/{loan_id}", response_description="Update a loan", response_model=Loan)
async def update_loan(loan_id: str, loan: Loan, current_user: User = Depends(get_current_active_user)):
    updated_loan = await update_loan_from_db(loan_id, loan.dict())
    if updated_loan:
        return Loan(**updated_loan)
    raise HTTPException(status_code=404, detail="Loan not updated")

# DELETE Request to Delete Loan - Only authenticated users can access this route
@router.delete("/api/loans/{loan_id}", response_description="Delete a loan")
async def delete_loan(loan_id: str, current_user: User = Depends(get_current_active_user)):
    success = await delete_loan_from_db(loan_id)
    if success:
        return {"detail": "Loan deleted"}
    raise HTTPException(status_code=404, detail="Loan not found")

# Reserve a book
@router.post("/api/books/{code}/reserve")
async def reserve_book_route(code: str, current_user: User = Depends(get_current_active_user)):
    try:
        if await reserve_book(code, current_user.id):
            return JSONResponse(
                content={
                    "status": "success",
                    "message": "Book ${code} reserved",
                    "data": None
                }
            )
        return JSONResponse(
            status_code=400,
            content={
                "status": "error",
                "message": "Cannot reserve book",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )

# Confirm a loan
@router.post("/api/loans/{code}/confirm")
async def confirm_loan_route(code: str, current_user: User = Depends(get_current_active_user)):
    try:
        loan = await confirm_loan(code, current_user.id)
        if loan:
            return JSONResponse(
                content={
                    "status": "success",
                    "data": loan
                }
            )
        return JSONResponse(
            status_code=400,
            content={
                "status": "error",
                "message": "Cannot confirm loan",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )


# Cancel a reservation
@router.post("/api/books/{code}/cancel_reservation")
async def cancel_reservation_route(code: str, current_user: User = Depends(get_current_active_user)):
    try:
        if await cancel_reservation(code, current_user.id):
            return JSONResponse(
                content={
                    "status": "success",
                    "message": "Reservation cancelled",
                    "data": None
                }
            )
        return JSONResponse(
            status_code=400,
            content={
                "status": "error",
                "message": "Cannot cancel reservation",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )


@router.post("/api/books/{code}/return")
async def return_book_route(code: str, current_user: User = Depends(get_current_active_user)):
    try:
        success = await return_book(code, current_user.id)
        if success:
            return JSONResponse(
                content={
                    "status": "success",
                    "message": "Book returned successfully",
                    "data": None
                }
            )
        return JSONResponse(
            status_code=404,
            content={
                "status": "error",
                "message": "Active loan not found or book return failed",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )
    
# Get Loans by Student ID
@router.get("/api/users/{user_id}/loans", response_description="Get loans by user")
async def get_loans_by_user_route(user_id: str, current_user: User = Depends(get_current_active_user)):
    try:
        if current_user.id != user_id:
            raise HTTPException(status_code=403, detail="Not authorized to view these loans")
        loans = await get_loans_by_user(user_id)
        if loans:
            return JSONResponse(
                content={
                    "status": "success",
                    "message": f"Loans from user {user_id} found successfully",
                    "data": loans
                }
            )
        return JSONResponse(
            status_code=404,
            content={
                "status": "error",
                "message": "Active loan not found or book return failed",
                "data": None
            }
        )
    except Exception as e:
        # Handle unexpected exceptions
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": f"An unexpected error occurred: {str(e)}",
                "data": None
            }
        )