from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import slurm_queen

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/v1/run")
def run(config: str):
    return slurm_queen.run(config)

@app.get("/api/v1/queue")
def get_queue():
    return slurm_queen.get_queue()

@app.get("/api/v1/info")
def info():
    return slurm_queen.info()

@app.get("/api/v1/status")
def cancel(id: int):
    return slurm_queen.status(id)

@app.post("/api/v1/cancel")
def cancel(id: int):
    return slurm_queen.cancel(id)

@app.on_event("startup")
def startup_event():
    slurm_queen.create_config()

