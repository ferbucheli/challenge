from library.models.book import Book
from library.models.user import User

def serialize_book(book: Book) -> dict:
    if not book:
        return None
    return {
        "code": book.code,
        "title": book.title,
        "description": book.description,
        "author": book.author,
        "quantity": book.quantity,
        "reserved_quantity": book.reserved_quantity
    }


def multiple_serial(books) -> list:
    return [serialize_book(book) for book in books]
