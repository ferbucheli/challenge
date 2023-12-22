from motor.motor_asyncio import AsyncIOMotorClient
from library.models.loan import Loan
from library.config.database import loans_collection
from bson import ObjectId
from datetime import datetime, timedelta
from library.config.database import books_collection, loans_collection

async def get_all_loans_from_db():
    loans = []
    cursor = loans_collection.find({})
    async for document in cursor:
        loans.append(Loan(**document))
    return loans

async def insert_loan_to_db(loan: dict):
    existing_loan = await loans_collection.find_one({
        "book_code": loan['book_code'],
        "student_id": loan['student_id'],
        "status": "issued"
    })
    if existing_loan:
        return None 

    new_loan = await loans_collection.insert_one(loan)
    created_loan = await loans_collection.find_one({"_id": new_loan.inserted_id})
    if created_loan:
        created_loan['_id'] = str(created_loan['_id'])
        return Loan(**created_loan)
    else:
        return None

async def update_loan_from_db(loan_id: str, update_data: dict):
    update_request = {key: value for key, value in update_data.items() if value is not None}
    await loans_collection.update_one(
        {"_id": ObjectId(loan_id)},
        {"$set": update_request}
    )
    document = await loans_collection.find_one({"_id": ObjectId(loan_id)})
    if document:
        document['_id'] = str(document['_id'])  # Convert ObjectId to string
        return Loan(**document)
    else:
        return None

async def delete_loan_from_db(loan_id: str):
    await loans_collection.find_one_and_delete({"_id": ObjectId(loan_id)})
    return True

async def reserve_book(book_code: str, student_id: str):
    book = await books_collection.find_one({"code": book_code})
    if not book or book['quantity'] - book.get('reserved_quantity', 0) <= 0 or book['quantity'] <= 0:
        return False  # Book not available

    # Check if the student has already loaned this book
    active_loan = await loans_collection.find_one({"book_code": book_code, "student_id": student_id, "status": "issued"})
    if active_loan:
        return False  # Student already has an active loan for this book

    # Reserve the book
    await books_collection.update_one({"code": book_code}, {"$inc": {"reserved_quantity": 1}})
    return True

async def confirm_loan(book_code: str, student_id: str):
    book = await books_collection.find_one({"code": book_code})
    if not book or book['quantity'] - book.get('reserved_quantity', 0) <= 0 or book['quantity'] <= 0:
        return False  # Book not available
    issue_date = datetime.utcnow()
    return_date = issue_date + timedelta(days=30)  # 30 days for return
    loan = {
        "book_code": book_code,
        "student_id": student_id,
        "issue_date": issue_date,
        "return_date": return_date,
        "status": "issued"
    }
    await books_collection.update_one({"code": book_code}, {"$inc": {"reserved_quantity": -1}})
    await books_collection.update_one({"code": book_code}, {"$inc": {"quantity": -1}})
    result = await loans_collection.insert_one(loan)
    loan["_id"] = str(result.inserted_id)
    loan['issue_date'] = loan['issue_date'].isoformat()
    loan['return_date'] = loan['return_date'].isoformat()
 # Convert ObjectId to string
    return loan

async def cancel_reservation(book_code: str, student_id: str):
    # Cancel the reservation
    await books_collection.update_one({"code": book_code}, {"$inc": {"reserved_quantity": -1}})
    return True

async def return_book(book_code: str, student_id: str):
    # Find the loan for the specified book and student
    loan = await loans_collection.find_one({
        "book_code": book_code,
        "student_id": student_id,
        "status": "issued"  # Assuming 'issued' is the status for active loans
    })

    if not loan:
        return False  # No active loan found

    # Mark the loan as returned
    await loans_collection.update_one(
        {"_id": loan["_id"]},
        {"$set": {"status": "returned", "return_date": datetime.utcnow()}}
    )

    # Decrement the reserved_quantity in the book collection
    await books_collection.update_one(
        {"code": book_code},
        {"$inc": {"quantity": 1}}  # Decrement by 1
    )

    return True

async def get_loans_by_user(student_id: str):
    cursor = loans_collection.find({"student_id": student_id})
    loans = [loan async for loan in cursor]

    for loan in loans:
        # Convert ObjectId to string
        loan['_id'] = str(loan['_id'])
        # Convert datetime objects to string
        if 'issue_date' in loan and isinstance(loan['issue_date'], datetime):
            loan['issue_date'] = loan['issue_date'].isoformat()
        if 'return_date' in loan and isinstance(loan['return_date'], datetime):
            loan['return_date'] = loan['return_date'].isoformat()

    return loans
