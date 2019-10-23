import json
import wget
import os.path

with open('urls.json', 'r') as f:
    urls = json.load(f)

for url in urls:
    filename = url.split('https://www.mfe.govt.nz/sites/default/files/media/Consultations/')[1]
    destination = './pdfs/' + filename
    if os.path.isfile(destination):
        1+1
    elif '%' in url:
        print('skipping ' + filename)
    else:
        print('downloading ' + filename)
        wget.download(url, destination)
