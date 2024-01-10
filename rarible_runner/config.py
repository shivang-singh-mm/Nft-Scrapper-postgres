import logging
import sys
import os
from dotenv import load_dotenv

load_dotenv()

LOGGING_MODE = os.getenv("LOGGING_MODE")

#? For Logging In Console
# logging.basicConfig(level=logging.INFO,format = " [%(asctime)s][%(levelname)s] - %(message)s",stream=sys.stdout)

#? For Logging In File
# logging.basicConfig(level=getattr(logging,LOGGING_MODE),format = " [%(asctime)s][%(levelname)s] - %(message)s",filename="app.log",filemode="w")

#? For Logging in Both File and Console
logging.basicConfig(level=getattr(logging,LOGGING_MODE),format = " [%(asctime)s][%(levelname)s] - %(message)s",handlers = [logging.FileHandler("app.log",mode="w"),logging.StreamHandler(sys.stdout)])

logger = logging.getLogger()