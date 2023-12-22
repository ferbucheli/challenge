import motor.motor_asyncio

client = motor.motor_asyncio.AsyncIOMotorClient("mongodb+srv://admin:admin@library-challenge.yl9ej42.mongodb.net/?retryWrites=true&w=majority")

db = client.library_db

books_collection = db["books_collection"]

users_collection = db["users_collection"]

loans_collection = db["loans_collection"]