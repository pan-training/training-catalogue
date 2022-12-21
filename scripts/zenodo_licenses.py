import urllib.parse
import json
import requests
import time

#script to get the licenses from zenodo and create the .yml file

url = "https://sandbox.zenodo.org/api/licenses/"

dict_dict = {}

num_licences = 453

counter=0

liste_licences = []

while counter<=num_licences:
    counter += 10
    page_number = int(counter/10)
    print(page_number)
    time.sleep(0.5)
    #https://sandbox.zenodo.org/api/licenses/?page=1&size=10, etc
    url = "https://sandbox.zenodo.org/api/licenses/?page="+str(page_number)+"&size=10"
    dict_dict = requests.get(url).json()

    abba = dict_dict["hits"]["hits"] #a list of dicts

    for i, elt in enumerate(abba):
        #print("beginning")
        #print(elt["metadata"]["id"])
        #print(elt["metadata"]["title"])
        #print(elt["metadata"]["url"])
        #print("end")
        liste_licences.append([elt["metadata"]["id"],elt["metadata"]["title"],elt["metadata"]["url"]])

with open('zenodo_licenses.yml', 'w') as f:
    for elt in liste_licences:
        f.write(elt[0]+':')
        f.write('\n')
        f.write('  id: "'+elt[0]+'"')        
        f.write('\n')
        f.write('  title: "'+elt[1]+'"')
        f.write('\n')
        f.write('  url: "'+elt[2]+'"')        
        f.write('\n')


