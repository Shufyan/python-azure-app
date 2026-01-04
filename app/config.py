from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    ENVIRONMENT: str = "dev"
    SECRET_VALUE: str = "default"

    class Config:
        env_file = ".env"

settings = Settings()