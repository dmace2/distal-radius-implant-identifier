from fastapi import FastAPI
from typing import List
from fastapi.responses import RedirectResponse
import uvicorn
import sys
import os
from .models import *
from .utils import DBService

app = FastAPI()
db = DBService()
print("Testing get_implants on Acumed:", db.get_implants("Acumed"))
sys.stdout.flush()


@app.get("/")
async def root():
    return RedirectResponse(url='/docs')


@app.get("/implantExamples/{company}", response_model=Company)
async def getImplantExamples(company: str):
    # get implants from db
    implants, guides = db.get_implants(company)
    print("___________________________")
    print(implants)
    # format for json and return
    return Company(
        companywide_guides=[Guide(**g) for g in guides],
        implants=[Implant(**i) for i in implants]
    )


@app.get("/implantExamples/images/{company}", response_model=List[ImplantImage])
async def getImplantImageExamples(company: str):
    images = db.get_implant_images(company)
    return [ImplantImage(**image) for image in images]


if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=os.getenv(
        'port', default=33507), reload=True)
