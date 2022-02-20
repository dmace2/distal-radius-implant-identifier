import numpy as np
import time

import PIL.Image as Image
import matplotlib.pylab as plt

import tensorflow as tf
import tensorflow_hub as hub

import datetime
import os
import inspect
import configparser


class utils:
    
    def generate_datasets(data_root, image_dim, batch_size):
        # Generate training and validation datasets
        train_ds = tf.keras.utils.image_dataset_from_directory(
            str(data_root),
            label_mode='categorical',
            validation_split=0.2,
            subset="training",
            seed=123,
            image_size=(image_dim, image_dim),
            batch_size=batch_size
        )

        val_ds = tf.keras.utils.image_dataset_from_directory(
            str(data_root),
            label_mode='categorical',
            validation_split=0.2,
            subset="validation",
            seed=123,
            image_size=(image_dim, image_dim),
            batch_size=batch_size
        )
        
        class_names = np.array(train_ds.class_names)
        
        # Normalize the images
        normalization_layer = tf.keras.layers.Rescaling(1./255)
        train_ds = train_ds.map(lambda x, y: (normalization_layer(x), y)) # Where x—images, y—labels.
        val_ds = val_ds.map(lambda x, y: (normalization_layer(x), y)) # Where x—images, y—labels.
        
        # Batch the datasets
        AUTOTUNE = tf.data.AUTOTUNE
        train_ds = train_ds.cache().prefetch(buffer_size=AUTOTUNE)
        val_ds = val_ds.cache().prefetch(buffer_size=AUTOTUNE)
        
        return train_ds, val_ds, class_names
        
    def preprocess_prediction_image(image, image_dim):
        print(image.shape)
        # Resize the image to the desired size
        image = tf.image.resize(image, (image_dim, image_dim))
        print(image.shape)
        
        # Normalize the image
        normalization_layer = tf.keras.layers.Rescaling(1./255)
        normalized_image = normalization_layer(image) 
        
        return normalized_image