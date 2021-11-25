from fastapi import FastAPI, File, UploadFile, HTTPException
from pydantic import BaseModel
from fastapi.responses import JSONResponse
from typing import Optional, List

from fastapi.responses import RedirectResponse
import uvicorn
from PIL import Image
import sys
import io

app = FastAPI()


@app.get("/")
async def root():
    return RedirectResponse(url='/docs')




class PredictionItem(BaseModel):
    company: str
    confidence: float

class PredictionResults(BaseModel):
    timestamp: str
    filename: str
    contenttype: str
    predictions: List[PredictionItem]

    


@app.post("/predict")
async def predict(file: UploadFile = File(...), response_model=PredictionResults):
    # taken from https://github.com/jabertuhin/image-classification-api
    if file.content_type.startswith('image/') is False:
        raise HTTPException(
            status_code=400, detail=f'File \'{file.filename}\' is not an image.')

    try:
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert('RGB')
        width, height = image.size
        return f"Got {width}x{height} image, prediction to come..."
        
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

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=1714)
