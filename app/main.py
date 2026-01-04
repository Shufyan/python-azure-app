from fastapi import FastAPI
from app.health import router as health_router
from app.config import settings

app = FastAPI(title="My FastAPI Application")

app.include_router(health_router)

@app.get("/")
def root():
    return {
        "service": "fastapi-azure",
        "environment": settings.ENVIRONMENT
    }