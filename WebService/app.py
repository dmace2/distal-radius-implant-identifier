from doctest import Example
from fastapi import FastAPI, File, UploadFile, HTTPException
from typing import Optional, List
from fastapi.responses import RedirectResponse, FileResponse
import uvicorn
from PIL import Image
import sys, io, os


from .models import *
from .utils import DBService

app = FastAPI()
db = DBService()
print("Getting Implants")
print(db.get_implants("Acumed"))
sys.stdout.flush()




@app.get("/")
async def root():
    return RedirectResponse(url='/docs')


@app.get("/implantExamples/{company}", response_model=List[CompanyImplant])
async def getImplantExamples(company: str):
    
    # get implants from db
    implants = db.get_implants(company)
    
    # format for json and return
    return [CompanyImplant(**implant) for implant in implants]

@app.get("/implantExamples/images/{company}", response_model=List[ImplantImage])
async def getImplantImageExamples(company: str):
    images = db.get_implant_images(company)
    
    return [ImplantImage(**image) for image in images]


if __name__ == "__main__":
    uvicorn.run(app,host='0.0.0.0', port=os.getenv('port', default=33507))

