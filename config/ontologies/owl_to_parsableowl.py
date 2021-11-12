print("lol")

owlfile = open("blob.owl")


parsed_owlfile = open("a.owl","w")

weinclass=0

for line in owlfile:
    parsed_owlfile.write(line)
    if line.strip()[0:10]=="<owl:Class":
        weinclass=1
        
    if line.strip()[6:11]=="label" and weinclass==1:
        parsed_owlfile.write('        <oboInOwl:inSubset rdf:resource="&oboOther;edam#topics"/>\n')
        weinclass=0
    
    if line.strip()[0:12]=="</owl:Class>":
        #sometimes there are no labels so we still need to put it at 0
        weinclass=0    
        
    print(line.strip()[6:11])
    print(line)
    
    
    
    
    
"""
<owl:Class rdf:about="http://purl.org/pan-science/PaNET/PaNET01325">
<rdfs:subClassOf rdf:resource="http://purl.org/pan-science/PaNET/PaNET01023"/>
<rdfs:subClassOf rdf:resource="http://purl.org/pan-science/PaNET/PaNET01029"/>
<rdfs:subClassOf rdf:resource="http://purl.org/pan-science/PaNET/PaNET01173"/>
<obo:IAO_0000119 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">https://en.wikipedia.org/wiki/Borrmann_effect</obo:IAO_0000119>
<rdfs:label rdf:datatype="http://www.w3.org/2001/XMLSchema#string">borrmann effect</rdfs:label>
</owl:Class>
"""
