import requests


f = open('Logo.png', 'rb')

files = {"file": (f.name, f, 'image/png')}

# r = requests.post('https://distalradius.herokuapp.com/predict', files=files)
r = requests.post('http://localhost:8000/predict', files=files)
print(r.request.headers)
print("__________")
# print(r.request.body)
print(r.json())