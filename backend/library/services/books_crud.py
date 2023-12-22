from motor.motor_asyncio import AsyncIOMotorClient
from library.models.book import Book
from library.config.database import books_collection


async def get_all_books_from_db():
    books = []
    cursor = books_collection.find({})
    async for document in cursor:
        books.append(Book(**document))
    return books

async def get_book_by_code(book_code: str):
    book = await books_collection.find_one({"code": book_code})
    if book:
        book['_id'] = str(book['_id'])  # Convert ObjectId to string
    return book

async def insert_book_to_db(book: dict):
    new_book = await books_collection.insert_one(book)
    created_book = await books_collection.find_one({"code": book['code']})
    return created_book

async def update_book_from_db(code: str, book: dict):
    update_request = {key:value for key, value in book.items() if value is not None}
    await books_collection.update_one(
        {"code": code}, 
        {"$set": update_request}, 
    )
    document = await books_collection.find_one({"code": code})
    return document

async def delete_book_from_db(code: str):
    await books_collection.find_one_and_delete({"code": code})
    return True
  