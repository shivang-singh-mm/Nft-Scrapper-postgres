import os
import time
from database import SessionLocal, engine, Base
# from dotenv import load_dotenv
from curd import create_asset, fetch_assets_from_API, fetch_collections_from_API, create_collection
from config import logger
from prometheus_client import start_http_server, Summary, Counter, Histogram

# load_dotenv()

Collection_Offset = 0
Collection_Limit = 300
TOTAL_COLLECTIONS_TO_FETCH = int(os.getenv("TOTAL_COLLECTIONS_TO_FETCH"))
FETCH_ALL_COLLECTIONS = True if os.getenv("FETCH_ALL_COLLECTIONS").lower() == "true" else False

Asset_Offset = 0
Asset_Limit = 300
TOTAL_ASSETS_TO_FETCH = int(os.getenv("TOTAL_ASSETS_TO_FETCH"))
FETCH_ALL_ASSETS = True if os.getenv("FETCH_ALL_ASSETS").lower() == "true" else False

SECONDS_TO_WAIT = float(os.getenv("SECONDS_TO_WAIT"))

if __name__ == '__main__':
    start_http_server(8000)

    try:
        Base.metadata.create_all(bind=engine)
        session = SessionLocal()

        Collection_Continuation_Token = ""
        while Collection_Offset < TOTAL_COLLECTIONS_TO_FETCH or FETCH_ALL_ASSETS == True:

            # c.inc()
            start_time = time.time()
            collections,Collection_Continuation_Token = fetch_collections_from_API(Collection_Offset,min(TOTAL_COLLECTIONS_TO_FETCH - Collection_Offset,Collection_Limit),Collection_Continuation_Token) 
            
            #* All Collections have been fetched
            if len(collections) == 0 or Collection_Continuation_Token == None:
                # logger.info("All Collections have been Fetched")
                break 
            
            for collection in collections:

                Asset_Offset = 0
                Asset_Limit = 300

                new_collection = create_collection(session,collection)
                
                Asset_Continuation_Token = ""
                if new_collection != None:
                    while Asset_Offset < TOTAL_ASSETS_TO_FETCH or FETCH_ALL_ASSETS == True:
                        
                        
                        assets,Asset_Continuation_Token = fetch_assets_from_API(Asset_Offset,min(TOTAL_ASSETS_TO_FETCH - Asset_Offset,Asset_Limit),Asset_Continuation_Token,new_collection.uuid,new_collection.collection_id)

                        #* All Assets from a collection have been fetched
                        if len(assets) == 0 or Asset_Continuation_Token == None:
                            # logger.info(f"All Assets of collection {new_collection.id} have been Fetched")
                            break
                        
                        for asset in assets:
                            create_asset(session,asset,new_collection.uuid)
                        # time.sleep(SECONDS_TO_WAIT)

                        Asset_Offset += Asset_Limit


            Collection_Offset += Collection_Limit

    except Exception as e:
        logger.error(e)
    
# if __name__ == '__main__':
#     # Start up the server to expose the metrics.
#     start_http_server(8000)
    