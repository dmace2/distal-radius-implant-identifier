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

from utils import utils


class ImageNetModel:
    """
    Class containing imagnet model
    """
    def __init__(self, load_model = False):
        """Initializer for ImageNetModel class

        Args:
            load_model (bool, optional): whether to load a previous model checkpoint. Defaults to False.
        """
        self.dirname = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

        # Read config file
        profile_name ='ImageNetModel'
        configfile = os.path.join(self.dirname, 'config.ini')
        config = configparser.RawConfigParser()
        config.read(configfile)

        self.transfer_model_url = config.get(profile_name, 'transfer_model_url')
        self.batch_size = int(config.get(profile_name, "batch_size"))
        self.lr = float(config.get(profile_name, "lr"))
        self.epochs = int(config.get(profile_name, "epochs"))
        # Warmup is a period of time where the learning rate is small and gradually increases--usually helps training.
        self.warmup_prop = float(config.get(profile_name, "warmup_proportion"))
        self.image_dim = int(config.get(profile_name, "image_dim"))
        
        # Generate/Load the model
        self.model = None
        if load_model:
            try:
                model_dir = os.path.join(self.dirname, 'saved_model')
                self.labels = [line.rstrip() for line in open(os.path.join(self.dirname, 'saved_model', "classes.txt"))]
                self.model = tf.keras.models.load_model(model_dir, compile=False)
                self.new_model = False
                print("Loaded Previous Model")
                print(f"Labels: {self.labels}")
            except Exception as e:
                pass
        
        # handles exception if no model is made above
        if self.model == None:
            print("No Previous Model Valid")
            self.labels = [ f.name for f in os.scandir(os.path.join(self.dirname, '..', "images_processed_rgb")) if f.is_dir() ]
            self.model = self.build_model()
            self.new_model=True
            print(f"Labels: {self.labels}")
    
    
    def build_datasets(self):
        train, test = utils.generate_datasets(os.path.join(self.dirname, '..', "images_processed_rgb"), self.image_dim, self.batch_size)
        return train, test  # train_ds, val_ds
    
        
    def build_model(self):
        """Build the model from scratch

        Returns:
            tf.keras.Model: the model to be trained on
        """
        print("Building Model") 
        feature_extractor_layer = hub.KerasLayer(
            self.transfer_model_url,
            input_shape=(self.image_dim, self.image_dim,3),
            trainable=False)
        
        num_classes = len(self.labels)

        model = tf.keras.Sequential([
            feature_extractor_layer,
            tf.keras.layers.Dense(num_classes, activation='softmax')
        ])

        model.summary()
        
        return model
        
    def train_model(self):
        """Train the model from scratch. ONLY USE IF YOU WISH TO REWRITE THE MODEL FROM SCRATCH.
        """
        # load in test and train datasets
        train_ds, test_ds = self.build_datasets() #sec_train_ds since I combine test and train ds into one train ds


        # build the model
        self.model = self.build_model() #force new model build when resetting it
        self.model.summary()

        # generate loss and metrics
        loss = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False)

        # generate train and warmup steps from data size for optimizer
        steps_per_epoch = tf.data.experimental.cardinality(train_ds).numpy()
        num_train_steps = steps_per_epoch * self.epochs
        num_warmup_steps = int(self.warmup_prop*num_train_steps)

        # create optim
        optimizer = tf.keras.optimizers.Adam(learning_rate=self.lr, beta_1=0.9, beta_2=0.999, epsilon=1e-07, amsgrad=False)
        
        self.model.compile(optimizer=optimizer,
                         loss=loss,
                         metrics=['accuracy']
        )

        # checkpoint for saving model
        newmodel_dir = os.path.join( os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))), 'model')
        c = tf.keras.callbacks.ModelCheckpoint(newmodel_dir, monitor='loss', verbose=1, save_best_only=True, save_freq='epoch')
        
        
        # save the labels to a file
        with open (os.path.join(newmodel_dir, "classes.txt"), 'w') as f:
            for item in self.labels:
                f.write("%s\n" % item)

        # train the model
        history = self.model.fit(x=train_ds, epochs=self.epochs, validation_data=test_ds, callbacks=[c])
        
        
        
        
if __name__ == "__main__":
    model = ImageNetModel(load_model = True)
    
    model.train_model()
    # model.predict_image("../images_processed/apple/apple_1.jpg")
    # model.predict_image("../images_processed/apple/apple_2.jpg")
    # model.predict_image("../images_processed/apple/apple_3.jpg")
    # model.predict_image("../images_processed/apple/apple_4.jpg")
    # model.predict_image("../images_processed/apple/apple_5.jpg")
    # model.predict_image("
        
        

