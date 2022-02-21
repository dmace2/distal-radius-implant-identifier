import tensorflow as tf
import os
from loguru import logger
import numpy as np


def preprocess_prediction_image(image, image_dim):
    logger.debug(f"Image shape: {image.shape}")
    
    # Resize the image to the desired size
    image = tf.image.resize(image, (image_dim, image_dim))
    
    # Normalize the image
    normalization_layer = tf.keras.layers.Rescaling(1./255)
    normalized_image = normalization_layer(image) 
    
    logger.debug(f"Normalized image shape: {normalized_image.shape}")
    
    return normalized_image


@logger.catch
def get_predictions(data):
    """
    A function that reshapes the incoming image, loads the saved model objects
    and returns predicted class and probability.
    :param data: image data
    :return: results dictionary
    """
    
    assert len(data.shape) >= 3, "Image must be in RGB format"
    
    # preprocess the image
    processed_image = preprocess_prediction_image(data[...,:3], image_dim=224)
    processed_image = np.expand_dims(processed_image, axis=0)
    logger.debug('Incoming data successfully standardised with saved object')
    logger.debug(f"Processed image shape: {processed_image.shape}")

    # Load saved keras model
    cwd = dirname = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__))))
    model_dir = os.path.join(cwd, 'saved_model')
    model = tf.keras.models.load_model(model_dir)
    logger.debug('Saved CNN model loaded successfully')
    
    # load labels
    labels = [line.rstrip() for line in open(os.path.join(model_dir, "classes.txt"))]
    


    # Make new predictions from the newly scaled data and return this prediction
    prediction = model.predict(processed_image)[0]
    return labels[np.argmax(prediction)], {labels[i]: prediction[i] for i in range(len(prediction))}