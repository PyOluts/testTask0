from fastapi.testclient import TestClient
from sqlmodel import Session
from app import crud
from app.models import UserCreate
from app.core.config import settings
from tests.utils.utils import random_email, random_lower_string
from tests.utils.user import user_authentication_headers

def create_user_with_role(db: Session, role: str):
    email = random_email()
    password = random_lower_string()
    user_in = UserCreate(email=email, password=password, role=role)
    user = crud.create_user(session=db, user_create=user_in)
    return email, password

def test_member_cannot_access_metrics(client: TestClient, db: Session) -> None:
    email, password = create_user_with_role(db, "member")
    headers = user_authentication_headers(client=client, email=email, password=password)
    r = client.get(f"{settings.API_V1_STR}/metrics/", headers=headers)
    assert r.status_code == 403

def test_manager_can_access_metrics_but_cannot_create_user(client: TestClient, db: Session) -> None:
    email, password = create_user_with_role(db, "manager")
    headers = user_authentication_headers(client=client, email=email, password=password)
    
    # Can access metrics
    r = client.get(f"{settings.API_V1_STR}/metrics/", headers=headers)
    assert r.status_code == 200
    
    # Cannot create user
    data = {"email": random_email(), "password": random_lower_string()}
    r2 = client.post(f"{settings.API_V1_STR}/users/", headers=headers, json=data)
    assert r2.status_code == 403

def test_admin_can_access_metrics_and_create_user(client: TestClient, db: Session) -> None:
    email, password = create_user_with_role(db, "admin")
    headers = user_authentication_headers(client=client, email=email, password=password)
    
    r = client.get(f"{settings.API_V1_STR}/metrics/", headers=headers)
    assert r.status_code == 200
    
    data = {"email": random_email(), "password": random_lower_string()}
    r2 = client.post(f"{settings.API_V1_STR}/users/", headers=headers, json=data)
    assert r2.status_code == 200


