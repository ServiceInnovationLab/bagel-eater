import json
import wget
import os.path

with open('anonymous-urls.json', 'r') as f:
    urls = json.load(f)

for url in urls:
    filename = url.split('https://www.mfe.govt.nz/sites/default/files/media/Consultations/')[1]
    destination = './pdfs/' + filename
    if os.path.isfile(destination):
        print('already downloaded ' + filename)
    else:
        wget.download(url, destination)
        print('downloaded ' + filename)
