import requests


f = open('Logo.png', 'rb')

files = {"file": (f.name, f, 'image/png')}

r = requests.post('http://localhost:33507/predict', files=files)
print(r.request.headers)
print("__________")
print(r.request.body)
print(r.json())