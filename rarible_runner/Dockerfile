FROM python:latest
WORKDIR /usr/src/rarible_runner

COPY ["config.py","curd.py","database.py","main.py","models.py","requirements.txt","./"] 
RUN ["python","-m","pip","install","--upgrade","pip"]
RUN ["python","-m","pip","install","-r","requirements.txt"]
#CMD ['python','-m','pip','install','-r','requirements.txt']
# RUN ["python", "main.py"]
EXPOSE 3003