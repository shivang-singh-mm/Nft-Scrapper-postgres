from sqlalchemy import Column, DateTime, Integer, String, ForeignKey, TIMESTAMP
from sqlalchemy.dialects.postgresql import BYTEA
from sqlalchemy.orm import relationship
from database import Base


# class Contract(Base):
#     __tablename__ = "contracts"
    
#     address = Column(String(100),primary_key=True)
#     name = Column(String(100))
#     contract_type = Column(String(100))
#     created_date = Column(DateTime())
#     nft_version = Column(String(100))
#     opensea_version = Column(String(100))
#     owner = Column(Integer())
#     schema_name = Column(String(100))
#     symbol = Column(String(100))
#     description = Column(String(10000))
#     external_link = Column(String(10000))
#     img_url = Column(String(10000))
#     img = Column(BYTEA())
#     payout_address = Column(String(100))
    

class Collection(Base):
    __tablename__ = 'collections'
    
    uuid = Column(String(32),primary_key=True)
    collection_id = Column(String(100))
    blockchain = Column(String(20)) 
    type = Column(String(20))
    name = Column(String(1000))
    created_date = Column(DateTime())
    description = Column(String(10000))
    external_url = Column(String(1000))
    image_url = Column(String(1000))
    image = Column(BYTEA())
    contract_address = Column(String(100))
    timestamp = Column(TIMESTAMP(timezone=False))
    
    # collectionStatus = relationship('CollectionStatus',uselist=False, backref='collection')
    
# class User(Base):
#     __tablename__ = "users"
    
#     wallet_address = Column(String(100),primary_key=True)
#     profile_img = Column(BYTEA())
#     profile_img_url = Column(String(1000))
    

class Asset(Base):
    __tablename__ = 'assets'
    
    uuid = Column(String(32), primary_key=True)
    blockchain = Column(String(20)) 
    asset_id = Column(String(200))
    token_id = Column(String(1000))
    name = Column(String(1000))
    image = Column(BYTEA())
    image_url = Column(String(1000))
    description = Column(String(10000))
    external_link = Column(String(1000))
    contract_address = Column(String(100))
    price = Column(String(20))
    is_priced = Column(String(20))
    collection_uuid = Column(String(32),ForeignKey("collections.uuid"))
    # contract_address = Column(String(1000),ForeignKey("contracts.address"))
    # owner_wallet_address = Column(String(100),ForeignKey("users.wallet_address"))
    # creator_wallet_address = Column(String(100),ForeignKey("users.wallet_address"))
    
    collection = relationship("Collection")
    creators = relationship("Creator")
    owners = relationship("Owner")
    timestamp = Column(TIMESTAMP(timezone=False))
    
    # assetStatus = relationship('AssetStatus', uselist:False, backref='assetStatus')
    # assetStatus = relationship('AssetStatus',uselist=False, backref='asset')
    # asset_contract = relationship("Contract")
    # owner = relationship("User",foreign_keys=[owner_wallet_address])
    # creator = relationship("User",foreign_keys=[creator_wallet_address])
    # traits = relationship("Trait")

class Trait(Base):
    __tablename__ = "traits"

    uuid = Column(String(32),primary_key = True)
    key = Column(String(100))    
    value = Column(String(100))    
    type = Column(String(100))        
    format = Column(String(100))
    timestamp = Column(TIMESTAMP(timezone=False))
       
    
    asset_uuid = Column(String(32),ForeignKey("assets.uuid"))
    
class Creator(Base):
    __tablename__ = "creators"
    
    uuid = Column(String(32),primary_key = True)
    wallet_address = Column(String(100))        
    asset_uuid = Column(String(32),ForeignKey("assets.uuid"))
    
class Owner(Base):
    __tablename__ = "owners"
    
    uuid = Column(String(32),primary_key = True)
    wallet_address = Column(String(100))        
    asset_uuid = Column(String(32),ForeignKey("assets.uuid"))

    
class CollectionStatus(Base):
    __tablename__ = "collectionStatus"
    
    uuid = Column(String(32),primary_key = True)
    status = Column(String(6))
    collection = relationship('Collection')
    collection_uuid = Column(String(32),ForeignKey("collections.uuid"))
    
    
        
class AssetStatus(Base):
    __tablename__ = "assetStatus"
    
    uuid = Column(String(32),primary_key = True)
    status = Column(String(6))
    asset = relationship('Asset')
    asset_uuid = Column(String(32),ForeignKey("assets.uuid"))