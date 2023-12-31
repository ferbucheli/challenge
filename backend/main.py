from fastapi import FastAPI
from library.routes.route import router
from fastapi.middleware.cors import CORSMiddleware
from decouple import config

app = FastAPI()

origins =[
  config('FRONTEND_MOBILE_URL')
]

app.add_middleware(
    CORSMiddleware, 
     allow_origins=origins, 
     allow_credentials=True, 
     allow_methods=["*"], 
     allow_headers=["*"],
)

app.include_router(router)