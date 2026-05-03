from typing import Any
from fastapi import APIRouter, Depends
from app.api.deps import RequireRole

router = APIRouter(prefix="/metrics", tags=["metrics"])

@router.get("/", dependencies=[Depends(RequireRole(["admin", "manager"]))])
def read_metrics() -> Any:
    """
    Stub endpoint for metrics/insights.
    """
    return {"message": "Here are some metrics!", "data": [1, 2, 3]}
