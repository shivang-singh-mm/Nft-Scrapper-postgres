import os
import urllib.request
from uuid import uuid4
import requests
from models import Asset, Collection, Creator, Owner, Trait, CollectionStatus, AssetStatus
from dotenv import load_dotenv
from config import logger
from prometheus_client import Histogram, Counter
import time
import datetime

#counters
collectionCounter = Counter('collection_count','Number of collections added')
assetCounter = Counter('asset_count','Number of assets added')

#histograms for fetching data
collectionHistogram = Histogram('fetch_collection',"Historam for calculating the response time of fetch collections",['http_status'])
assetHistogram = Histogram('fetch_asset','Historam for calculating the response time of fetch assets',['http_status'])
ownersHistogram = Histogram('fetch_owner','Historam for calculating the response time of fetch owners',['http_status'])

#histograms for saving data
dbCreateCollection = Histogram('create_collection','Histogram for saving the collection',['http_status','db_add_status'])
dbCreateAsset = Histogram('create_asset','Histogram for saving the asset',['http_status','db_add_status'])
dbCreateOwner = Histogram('create_owner','Histogram for saving the owner',['http_status','db_add_status'])
dbCreateTraits = Histogram('create_traits','Histogram for saving the traits',['http_status','db_add_status'])
dbCreateCreators = Histogram('create_creators','Histogram for saving the collection',['http_status','db_add_status'])


load_dotenv()

RARIBLE_API_BASE_URL = os.getenv("RARIBLE_API_BASE_URL")
headers = {'X-API-KEY':'74ce5ce0-3a6a-4ef5-93b3-ac9005ea1051'}


def fetch_collections_from_API(collection_offset,collection_size,continuation_token):
    
    GET_COLLECTIONS_URL = f"{RARIBLE_API_BASE_URL}/collections/all?size={collection_size}&continuation={continuation_token}&blockchains={os.getenv('BLOCKCHAIN_NAME')}"
    # headers = {'X-API-KEY':'74ce5ce0-3a6a-4ef5-93b3-ac9005ea1051'}
    start_time=time.time()
    try:
        logger.debug(f"Making GET Request to : {GET_COLLECTIONS_URL}")
        response = requests.get(GET_COLLECTIONS_URL,headers=headers)
        # print(response)
        while response.status_code != 200:
                logger.error(f"Error while Fetching Collections from API: {response.json()['message']}")
                response = requests.get(GET_COLLECTIONS_URL,headers=headers)

        logger.info(f"Fetched Collections {collection_offset} to {collection_offset + collection_size} from API")
        response = response.json()
        collections = response["collections"]
        continuation_token = response.get("continuation",None)
        logger.debug("Sucessfully fetched collections")    
        collectionHistogram.labels(200).observe(time.time()-start_time)
        return collections,continuation_token
    
    except Exception as e:
        logger.error(f"Error while Fetching Collections from API: {e}")
        collectionHistogram.labels(400).observe(time.time()-start_time)
        return [],None


def fetch_assets_from_API(asset_offset,asset_size,continuation_token,collection_uuid,collection_id):

    GET_ASSETS_URL = f"{RARIBLE_API_BASE_URL}/items/byCollection?collection={collection_id}&size={asset_size}&continuation={continuation_token}"
    start_time=time.time()
    try:
        logger.debug(f"Making GET Request to : {GET_ASSETS_URL}")
        response = requests.get(GET_ASSETS_URL,headers=headers)
        while response.status_code != 200:
                logger.error(f"Error while Fetching Assets from collection {collection_uuid} from API: {response.json()['message']}")
                response = requests.get(GET_ASSETS_URL,headers=headers)
        
        logger.info(f"Fetched Assets in collection {collection_uuid} - {asset_offset} to {asset_offset + asset_size} from API")
        response = response.json()
        collections = response["items"]
        continuation_token = response.get("continuation",None)
        logger.debug("Sucessfully Fetched Assets in Collection")    
        assetHistogram.labels(200).observe(time.time()-start_time)
        return collections,continuation_token
    
    except Exception as e:
        logger.error(f"Error while Fetching Assets from collection {collection_uuid} from API: {e}")
        assetHistogram.labels(400).observe(time.time()-start_time)
        return [],None
    

def fetch_owners_from_API(asset_id,asset_uuid):
    
    owners = []
    continuation_token = ""
    start_time = time.time()
    while continuation_token is not None:
        try:
            logger.debug(f"Making GET Request to : {GET_ASSET_OWNERSHIP_URL}")
            GET_ASSET_OWNERSHIP_URL = f"{RARIBLE_API_BASE_URL}/ownerships/byItem?itemId={asset_id}&continuation={continuation_token}"
            response = requests.get(GET_ASSET_OWNERSHIP_URL,headers=headers)
            while response.status_code != 200:
                    logger.error(f"Error while Fetching Owners for asset {asset_uuid} from API: {response.json()['message']}")
                    response = requests.get(GET_ASSET_OWNERSHIP_URL,headers=headers)
            
            logger.info(f"Fetched Owners for asset {asset_uuid} from API")
            response = response.json()
            ownerships = response["ownerships"]
            if ownerships is not None or len(ownerships) > 0:
                owners += ownerships 
            continuation_token = response.get("continuation",None)
            ownersHistogram.labels(400).observe(time.time()-start_time)
            logger.debug(f"fetch owners from API sucessfully!")
        except Exception as e:
            logger.error(f"Error while Fetching Owners for asset {asset_id} from API: {e}")
            ownersHistogram.labels(400).observe(time.time()-start_time)
            return []
    
    return owners
        

def create_collection(session,collection):

    start_time = time.time()
    # logger.info(collection)
        
    if collection is None:
        return None
            
    
    # *Checking For Duplicate Collection
    if session.query(Collection.uuid).filter_by(collection_id=collection["id"]).first() is not None:
        logger.info(f'collection {collection["id"]} already exists in DB')
        dbCreateCollection.labels(403,"column_skipped").observe(time.time()-start_time)
        return None
    
    image_url = None
    img = None
    
    # if "meta" in collection and "content" in collection["meta"] and len(collection["meta"]["content"]) > 0:
    #     for content in collection["meta"]["content"]:
    #         if content["@type"] == "IMAGE" and content["representation"] == "ORIGINAL":
    #             image_url = content["url"]
    
    
    # if image_url is not None or image_url != "":
    #     try:
    #         img = urllib.request.urlopen(image_url).read()
    #     except Exception as e:
    #         logger.error(f'Error while saving Image for collection {collection["id"]} in DB: {e}')
    
    # ---------------------------------------############### ---------------------------------------
    
    # #* Saving Contract in DB
    # asset_contract = collection["primary_asset_contracts"][0] if len(collection["primary_asset_contracts"]) > 0 else None
    # new_asset_contract = None
    # if asset_contract is not None:
    #     new_asset_contract = create_contract(session,asset_contract)
    
    # contract_address = None
    # if new_asset_contract is not None:
    #     contract_address = new_asset_contract.address
    
    created_date = None
    description = None
    external_url = None
    
    metadata = collection.get("meta",None)
    if metadata is not None and len(metadata.get("content"))!=0:
        created_date = metadata.get("createdAt",None)    
        description = metadata.get("description",None)    
        external_url = metadata.get("externalUri",None)    
        url = metadata.get("content")[0]
        image_url= url.get("url",None)
        print(f'image is {image_url}')
    
            
    try:    
        new_collection = Collection(
            uuid = uuid4().hex,
            collection_id = collection["id"],
            blockchain = collection["blockchain"], 
            type = collection["type"],
            name = collection["name"],
            created_date = created_date,
            description = description,
            external_url = external_url,
            image_url = image_url,
            image = img,
            contract_address = collection["id"].split(":")[1],
            timestamp = datetime.datetime.now()
        )
        statusCollection = CollectionStatus(
            uuid = uuid4().hex,
            collection_uuid = new_collection.uuid,
            status = 'false',
        )
        
        session.add(new_collection)
        session.add(statusCollection)
        session.commit() 
        logger.debug("Created collection sucessfully!")
        collectionCounter.inc() 
        dbCreateCollection.labels(200,"column_added").observe(time.time()-start_time)
        logger.info(f'Saved collection {collection["id"]} in DB')
        return new_collection  
        
    except Exception as e:
        session.rollback()
        logger.error(f'Error while saving collection {collection["id"]} in DB: {e}')
        dbCreateCollection.labels(400,"internal_error").observe(time.time()-start_time)
        return None
 
    
def create_traits(session,traits,asset_uuid):
    
    if traits == None:
        return 
    
    start_time = time.time()
    for trait in traits:
        
        key = trait.get("key",None)
        value = trait.get("value",None)
        typ = trait.get("type",None)
        format = trait.get("format",None)
        
        try:
            new_trait = Trait(
                uuid = uuid4().hex,
                key = key,
                value = value,
                type = typ,
                format = format,
                asset_uuid = asset_uuid,
                timestamp = datetime.datetime.now()
            )

            session.add(new_trait)
            session.commit()
            logger.debug("Created traits sucessfully")
            dbCreateTraits.labels(200,"column_added").observe(time.time()-start_time)
            logger.info(f'Saved traits of {asset_uuid} in DB')
    
        except Exception as e:
            session.rollback()
            logger.error(f'Error in Saving trait of {asset_uuid} in DB: {e}')
            dbCreateTraits.labels(400,"internal_error").observe(time.time()-start_time)
            
            
def create_creators(session,creators,asset_uuid):
    start_time = time.time()
    for creator in creators:
        try:
            new_creator = Creator(
                uuid = uuid4().hex,
                wallet_address = creator["account"].split(":")[1],
                asset_uuid = asset_uuid
            )
            
            session.add(new_creator)
            session.commit()
            logger.debug("Created creators sucessfully!")
            dbCreateCreators.labels(200,"column_added").observe(time.time()-start_time)
            logger.info(f'Saved creators of {asset_uuid} in DB')

        except Exception as e:
            session.rollback()
            logger.error(f'Error in saving creator of asset {asset_uuid} in DB: {e}')
            dbCreateCreators.labels(400,"internal_error").observe(time.time()-start_time)
            
            
def create_owners(session,owners,asset_uuid):
    start_time = time.time()
    if len(owners) == 0:
        logger.error(f"No Owners found for asset {asset_uuid}")
        dbCreateOwner.labels(403).observe(time.time()-start_time)
        return 
    
    for owner in owners:
        try:
            new_owner = Owner(
                uuid = uuid4().hex,
                wallet_address = owner["owner"].split(":")[1],
                asset_uuid = asset_uuid
            )
            
            session.add(new_owner)
            session.commit()
            logger.debug("created owners sucessfully!")
            dbCreateOwner.labels(200,"column_added").observe(time.time()-start_time)
            logger.info(f'Saved owners of {asset_uuid} in DB')
            
        except Exception as e:
            session.rollback()
            logger.error(f'Error in saving owner of asset {asset_uuid} in DB: {e}')
            dbCreateOwner.labels(400,"internal_error").observe(time.time()-start_time)
            
    
def create_asset(session,asset,collection_uuid):
    start_time = time.time()
    if session.query(Asset.uuid).filter_by(asset_id=asset["id"]).first() is not None:
        logger.info(f'asset {asset["id"]} already exists in DB')
        dbCreateCollection.labels(403,"column_skipped").observe(time.time()-start_time)
        return None
    
    image_url = None
    img = None
    
    # if "meta" in asset and "content" in asset["meta"] and len(asset["meta"]["content"]) > 0:
    #     for content in asset["meta"]["content"]:
    #         if content["@type"] == "IMAGE" and content["representation"] == "ORIGINAL":
    #             image_url = content["url"]
    
    # if image_url is not None or image_url != "":
    #     try:
    #         img = urllib.request.urlopen(image_url).read()
    #     except Exception as e:
    #         logger.error(f'Error in saving Image for asset {asset["id"]} from collection {collection_uuid} in DB: {e}')
    
    name = None
    description = None
    external_url = None
    token_id = None
    traits = None
    price = None
    is_priced = False
    
    metadata = asset.get("meta",None)

    if metadata is not None :
        name = metadata.get("name",None)    
        description = metadata.get("description",None)    
        external_url = metadata.get("externalUri",None)    
        token_id = metadata.get("tokenId",None)    
        traits = metadata.get("attributes",None)
        url = metadata.get("content")[0]
        image_url= url.get("url",None)

    price_data= asset.get("lastSale",None)


    if price_data is not None :
        price = price_data.get("price",None)
        is_priced = True
     
    try:
        new_asset = Asset(
            uuid = uuid4().hex,
            asset_id = asset["id"],
            blockchain = asset["blockchain"],
            token_id = token_id,
            name = name,
            image = img,
            image_url = image_url,
            description = description,
            external_link = external_url,
            collection_uuid = collection_uuid,
            contract_address = asset["collection"].split(":")[1],
            price = price,
            is_priced = is_priced,
            timestamp = datetime.datetime.now()
        )
        statusAsset = AssetStatus(
            uuid = uuid4().hex,
            status = 'false',
            asset_uuid = new_asset.uuid
        )
        
        session.add(new_asset)
        session.add(statusAsset)
        session.commit()
        logger.debug("Create asset sucessfully!")
        assetCounter.inc()
        logger.info(f'Saved asset {asset["id"]} from collection {collection_uuid} in DB')

        create_traits(session,traits,new_asset.uuid)    
        create_creators(session,asset["creators"],new_asset.uuid)
        owners = fetch_owners_from_API(new_asset.asset_id,new_asset.uuid)    
        create_owners(session,owners,new_asset.uuid) 
        dbCreateAsset.labels(200,"column_added").observe(time.time()-start_time)   
        
    except Exception as e:
        session.rollback()
        logger.error(f'Error in saving asset {asset["id"]} from collection {collection_uuid} in DB: {e}')
        dbCreateAsset.labels(400,"internal_error").observe(time.time()-start_time)