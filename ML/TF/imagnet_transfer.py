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
        self.image_dim = int(config.get(profile_name, "image_dim"))
        
        # Generate/Load the model
        self.model = None
        if load_model:
            try:
                self.labels = [line.rstrip() for line in open(os.path.join(self.dirname, 'saved_model', "classes.txt"))]
                
                model_dir = os.path.join(self.dirname, 'saved_model')
                self.model = self.load_full_model(model_dir) # can also use load_model_from_weights if loading from ckpt
                
                self.new_model = False
                print("Loaded Previous Model")
            except Exception as e:
                pass
    
    
    def build_datasets(self):
        """Build the datasets for training and validation

        Returns:
            (tf.data.Dataset, tf.data.Dataset): train and validation datasets
        """
        train, test, classes = utils.generate_datasets(os.path.join(self.dirname, '..', "images_processed_rgb"), self.image_dim, self.batch_size)
        self.labels = classes
        return train, test  # train_ds, val_ds
    
    
    def load_model_from_weights(self, model_dir):
        """Load model from checkpoint

        Args:
            model_dir (string): location of the saved model (not including the checkpoints folder)

        Returns:
            tf.keras.Model: loaded model from weights
        """
        # Create a new model instance
        model = self.build_model()

        # Restore the weights
        ckpt_dir = os.path.join(model_dir, "checkpoints")
        latest = tf.train.latest_checkpoint(ckpt_dir)
        model.load_weights(latest) 
        return model   
    
    def load_full_model(self, model_dir):
        """Load model from .pb file
        
        Args:
            model_dir (string): location of the saved model
            
        Returns:
            tf.keras.Model: loaded model from .pb file
        """
        new_model = tf.keras.models.load_model(model_dir)
        return new_model
        
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
            tf.keras.layers.Rescaling(1./255,input_shape=(self.image_dim, self.image_dim,3),),
            feature_extractor_layer,
            tf.keras.layers.Dense(num_classes, activation='softmax')
        ])

        model.summary()
        
        return model
    
    def predict(self, image):
        """Predict the class of an image

        Args:
            image ([None,None,3]): image to be classified

        Returns:
            string: predicted class
            dictionary: dictionary of probabilities for each class
        """
        assert self.model is not None, "Model has not been loaded"
        
        image = utils.preprocess_prediction_image(image, self.image_dim)
        image = np.expand_dims(image, axis=0)
        prediction = self.model.predict(image)[0]
        print(prediction.shape)
        
        return self.labels[np.argmax(prediction)], {self.labels[i]: prediction[i] for i in range(len(prediction))}
        
        
        
    def train_model(self, save_ckpt = False):
        """Train the model from scratch. ONLY USE IF YOU WISH TO REWRITE THE MODEL FROM SCRATCH.
        """
        # load in test and train datasets
        train_ds, test_ds = self.build_datasets() #sec_train_ds since I combine test and train ds into one train ds


        # build the model
        self.model = self.build_model() #force new model build when resetting it
        self.model.summary()

        # generate loss and metrics
        loss = tf.keras.losses.CategoricalCrossentropy(from_logits=False)

        # create optim
        optimizer = tf.keras.optimizers.Adam(learning_rate=self.lr, beta_1=0.9, beta_2=0.999, epsilon=1e-07, amsgrad=False)
        
        self.model.compile(optimizer=optimizer,
                         loss=loss,
                         metrics=['accuracy', tf.keras.metrics.Precision(), tf.keras.metrics.Recall()])
        
        # create callbacks
        newmodel_dir = os.path.join(os.getcwd(), 'model')
        if save_ckpt: # checkpoint for saving model (Weights Only)
            checkpoint_path = os.path.join(newmodel_dir, "checkpoints", "cp-{epoch:04d}.ckpt")
            c = tf.keras.callbacks.ModelCheckpoint(checkpoint_path, 
                monitor='loss', 
                verbose=1, 
                save_weights_only=True,
                save_best_only=True, 
                save_freq='epoch')
        
        else: # checkpoint for saving model (Full Model)
            c = tf.keras.callbacks.ModelCheckpoint(newmodel_dir, 
                monitor='loss', 
                verbose=1, 
                save_best_only=True, 
                save_freq='epoch')
            
        log_dir = os.path.join(self.dirname, "logs","fit",datetime.datetime.now().strftime("%Y%m%d-%H%M%S"))
        tensorboard_callback = tf.keras.callbacks.TensorBoard(log_dir=log_dir, histogram_freq=1)
        
        # save the labels to a file
        with open (os.path.join(newmodel_dir, "classes.txt"), 'w') as f:
            for item in self.labels:
                f.write("%s\n" % item)

        # train the model
        history = self.model.fit(x=train_ds, epochs=self.epochs, validation_data=test_ds, callbacks=[c, tensorboard_callback])
        
        
        
        
if __name__ == "__main__":
    model = ImageNetModel(load_model=False)
    
    model.train_model()
    
    # image = np.asarray(Image.open("../sample3.png"))[...,:3]
    # results = model.predict(image)
    # print(results)
        
        
