from datetime import date
from decimal import Decimal
from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel
from typing import Annotated, Optional
from database import engine, SessionLocal
from sqlalchemy.orm import Session
import models

app = FastAPI()
models.Base.metadata.create_all(bind=engine)

class Orders(BaseModel):
    # id: Optional[int]
    order_items: Optional[str]
    qty: Optional[int]
    price: Optional[float]
    status: Optional[str]
    user_id: Optional[int]

class Items(BaseModel):
    id: int
    name: Optional[str]
    description: Optional[str]
    qty: Optional[int]
    price: Optional[float]
    status: Optional[str]
    imgLink: Optional[str]

class Items2(BaseModel):
    qty: Optional[int]

    class Config:
        orm_mode = True

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

db_dependency = Annotated[Session, Depends(get_db)]

@app.get("/items", status_code=status.HTTP_200_OK)
async def read_items(db: db_dependency):
    item = db.query(models.Items).filter(models.Items.status == "Available").all()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

@app.post("/AddOrder")
async def add_order(order: Orders, db: db_dependency):
    db_order = models.Orders(
        order_items=order.order_items,
        qty=order.qty,
        price=order.price,
        status=order.status,
        user_id=order.user_id
    )
    db.add(db_order)
    db.commit()
    db.refresh(db_order)
    return db_order

@app.get("/itemsByID/{item_id}", status_code=status.HTTP_200_OK)
async def read_items(item_id: int,db: db_dependency):
    item = db.query(models.Items).filter(models.Items.id == item_id).all()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

#Update part (status)
@app.put("/itemQtUpdate/{item_id}")
def update_user(item_id: int, itemup: Items2):
    db = SessionLocal()
    item = db.query(models.Items).filter(models.Items.id == item_id).first()

    if not item:
        db.close()
        raise HTTPException(status_code=404, detail="item not found")

    # Update item details
    item.qty = itemup.qty
    
    db.commit()
    db.refresh(item)
    db.close()
    
    return {"message": "item updated successfully", "user": item}
