from fastapi import FastAPI, File, UploadFile, HTTPException
from pydantic import BaseModel
from fastapi.responses import JSONResponse
from typing import Optional, List
import datetime

from fastapi.responses import RedirectResponse, FileResponse
import uvicorn
from PIL import Image
import sys
import io
import os

# from .models import *
from .models import *

app = FastAPI()


@app.get("/")
async def root():
    return RedirectResponse(url='/docs')

    
@app.post("/predict", response_model=Classification)
async def predict(file: UploadFile = File(...)):
    # taken from https://github.com/jabertuhin/image-classification-api
    if file.content_type.startswith('image/') is False:
        raise HTTPException(
            status_code=400, detail=f'File \'{file.filename}\' is not an image.')

    try:
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert('RGB')
        width, height = image.size
        print(f"Got {width}x{height} image, prediction to come...")

        predictions = simulateResults()
        return predictions
        
        # predictions = image_classifier.predict(image)
        # sorted_predictions = predictions.sort(key=lambda x: x[1], reverse=True)
        # predicted_class = sorted_predictions[0][0]

        # logging.info(f"Predicted Class: {predicted_class}")
        # logging.info(f"Predicted Probability: {sorted_predictions[0][1]}")

        # prediction_dict = [{'company': company, confidence: confidence} for (company, confidence) in predictions]
        # return {
        #     "timestamp": str(datetime.datetime.now()),
        #     "filename": file.filename,
        #     "contenttype": file.content_type,
        #     "predictions": prediction_dict
        # }
    except Exception as error:
        print(error)
        e = sys.exc_info()[1]
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/companyExamples/{company}")
async def getCompanyExampleImageInformation(company: str):
    # TODO: get the image information for the given company, not just 2
    return 2

@app.get("/companyExamples/{company}/{exampleNum}")
async def getCompanyExampleImage(company: str, exampleNum: int):
    company = company.lower()
    dirname = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__))))
    return FileResponse(f"{dirname}/static/images/{company}/Example{exampleNum}.png")



@app.get("/implantExamples/{company}")
async def getImplantExamples(company: str):
    # company = company.lower()
    return [
        ExampleImplant(
            name=f"{company} Implant Type 1",
            url=f"http://synthes.vo.llnwd.net/o16/Mobile/Synthes%20North%20America/Product%20Support%20Materials/Technique%20Guides/SUSA/SUTG2.4DRPltJ4569F.pdf",
            tools=[
            Tool(toolName=f"{company} Tool 1"),
            Tool(toolName=f"{company} Tool 2"),
            Tool(toolName=f"{company} Tool 3")]
        ),
        ExampleImplant(
            name=f"{company} Implant Type 2",
            url=f"http://synthes.vo.llnwd.net/o16/LLNWMB8/INT%20Mobile/Synthes%20International/Product%20Support%20Material/legacy_Synthes_PDF/DSEM-TRM-0815-0464-1_LR.pdf",
            tools=[
            Tool(toolName=f"{company} Tool 1"),
            Tool(toolName=f"{company} Tool 2"),
            Tool(toolName=f"{company} Tool 3")]
        )
        
    ]



if __name__ == "__main__":
    uvicorn.run(app,host='0.0.0.0', port=os.getenv('port', default=33507))

