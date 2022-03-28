from doctest import Example
from fastapi import FastAPI, File, UploadFile, HTTPException
from typing import Optional, List
from fastapi.responses import RedirectResponse, FileResponse
import uvicorn
from PIL import Image
import sys
import io
import os


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


@app.get("/implantExamples/{company}", response_model=Company)
async def getImplantExamples(company: str):
    try:
        # get implants from db
        implants, guides = db.get_implants(company)
        print("___________________________")
        print(implants)
    except AssertionError:
        raise HTTPException(status_code=400, detail="Invalid company name")

    # format for json and return
    return Company(
        companywide_guides=[Guide(**g) for g in guides],
        implants=[Implant(**i) for i in implants]
    )
    
    
    return [CompanyImplant(**implant) for implant in implants]


@app.get("/implantExamples/images/{company}", response_model=List[ImplantImage])
async def getImplantImageExamples(company: str):
    try:
        images = db.get_implant_images(company)
    except AssertionError:
        raise HTTPException(status_code=400, detail="Invalid company name")

    return [ImplantImage(**image) for image in images]


if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=os.getenv('port', default=33507), reload=True)
