from sqlalchemy import DOUBLE, Column, Integer, String, Date, Enum, Text, DECIMAL
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Orders(Base):
    __tablename__ = 'orders'
    id = Column(Integer, primary_key=True , index= True)
    order_items = Column(String(100))
    qty = Column(Integer)
    price = Column(DOUBLE)
    status = Column(Enum("Pending", "Successful", name="order_status"),server_default="Pending",nullable=False,)
    user_id = Column(Integer, nullable=False)


class Items(Base):
    __tablename__ = 'items'
    id = Column(Integer, primary_key=True , index= True, autoincrement=True )
    name = Column(String(100))
    description = Column(String(100))
    qty = Column(Integer)
    price =  Column(DOUBLE)
    status = Column(Enum('Available', 'Unavailable', name='item_status'), default='Available')
    imgLink =  Column(String(600))