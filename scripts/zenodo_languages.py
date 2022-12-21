import pycountry
#script to generate the zenodo_languages file.

#Jawanese was jw in the original languages.yml but it is actually jv. Fixed it.

list_languages_for_zenodo = []
title = ""

with open('languages.yml', 'r') as f:
    for line in f.readlines():
        #print(line)
        line_parsed = line.strip(" ").strip("\n").split(":")
        if(line_parsed[0]=="title"):
            title = line_parsed[1].strip(" ")        
        if(line_parsed[0]=="code"):
            code = line_parsed[1].strip(" ")
            iso_zenodo_code = pycountry.languages.get(alpha_2=code)
            if iso_zenodo_code!=None:
                list_languages_for_zenodo.append([title,iso_zenodo_code.alpha_3])
                print(iso_zenodo_code,iso_zenodo_code.alpha_3)

print(list_languages_for_zenodo)

with open('zenodo_languages.yml', 'w') as f:
    for elt in list_languages_for_zenodo:
        f.write(elt[1]+':')     
        f.write('\n')
        f.write('  title: "'+elt[0]+'"')
        f.write('\n')
        f.write('  code: "'+elt[1]+'"')        
        f.write('\n')

