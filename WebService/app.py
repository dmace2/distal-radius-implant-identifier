from fastapi import FastAPI, File, UploadFile, HTTPException

from fastapi.responses import RedirectResponse
import uvicorn
from PIL import Image
import sys
import io

app = FastAPI()


@app.get("/")
async def root():
    return RedirectResponse(url='/docs')


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    # taken from https://github.com/jabertuhin/image-classification-api
    if file.content_type.startswith('image/') is False:
        raise HTTPException(
            status_code=400, detail=f'File \'{file.filename}\' is not an image.')

    try:
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert('RGB')
        width, height = image.size
        return f"Got {width}x{height} image, prediction to come..."
        # predicted_class = image_classifier.predict(image)

        # logging.info(f"Predicted Class: {predicted_class}")
        # return {
        #     "filename": file.filename,
        #     "contentype": file.content_type,
        #     "likely_class": predicted_class,
        # }
    except Exception as error:
        print(error)
        e = sys.exc_info()[1]
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=1714)
