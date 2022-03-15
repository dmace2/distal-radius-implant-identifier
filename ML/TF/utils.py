import numpy as np
import random

import PIL.Image as Image
import matplotlib.pylab as plt

import tensorflow as tf
import tensorflow_hub as hub

import datetime
import os, shutil
import inspect
import configparser


class utils:
    
    def generate_sampled_dataset_folder(data_root):
        # get classes
        classes = [f for f in os.listdir(data_root) if not f.startswith('.')]
        print(classes)
        
        # get min number of images of all folders
        class_files = {}
        min = -1
        for c in classes:
            path, dirs, files = next(os.walk(os.path.join(data_root, c)))
            file_count = len(files)
            if min == -1 or file_count < min:
                min = file_count
            class_files[c] = [os.path.join(data_root, c, f) for f in files]
                    
        # get random images from each folder
        
        sampled_files = {}
        for c in classes:
            sampled_names = np.random.choice(class_files[c], min)
            sampled_files[c] = sampled_names
         
        sampled_root = os.path.join(data_root, '..', 'images_sampled') 
        if not os.path.isdir(sampled_root):
            os.mkdir(sampled_root)
         
           
        for c in classes:
            random.shuffle(sampled_files[c])
            class_root = os.path.join(sampled_root, c)
            if not os.path.isdir(class_root):
                os.mkdir(class_root)
            for f in sampled_files[c]:
                shutil.copy(f, os.path.join(sampled_root, c))
            
            
        
        
    
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
        normalization_layer = tf.keras.layers.Rescaling(1./127.5, offset=-1)
        normalized_image = normalization_layer(image) 
        
        return normalized_image
    
    
    
    
if __name__ == "__main__":
    from utils import utils
    utils.generate_sampled_dataset_folder("../images_processed")