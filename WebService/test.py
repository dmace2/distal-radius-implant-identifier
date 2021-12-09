import requests


f = open('Logo.png', 'rb')

files = {"file": (f.name, f, 'image/png')}

r = requests.post('http://localhost:8000/predict', files=files)
print(r.json())