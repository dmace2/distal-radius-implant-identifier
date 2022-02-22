import tensorflow as tf
import coremltools as ct
import os


# load the model from a SavedModel and then convert
tf_keras_model = tf.keras.models.load_model('TF/saved_model')

# read in class names
class_labels = [line.rstrip() for line in open(os.path.join(os.getcwd(), 'TF', 'saved_model', "classes.txt"))]

# create classifier config to attach class names
classifier_config = ct.ClassifierConfig(class_labels)
mlmodel = ct.convert(tf_keras_model, classifier_config=classifier_config, inputs=[ct.ImageType()])

# get spec to rename top layer
spec = mlmodel.get_spec()
                        
# Edit the spec
ct.utils.rename_feature(spec, 'rescaling_input', 'image')
ct.utils.rename_feature(spec, 'Identity', 'breakdown')
mlmodel = ct.models.MLModel(spec)

output_path = os.path.join(os.getcwd(), 'ImplantClassifier.mlpackage')
mlmodel.save(output_path)