## Written by Erico P, from ericonotes.blogspot.com
## requires a file named enzylist.csv
from __future__ import print_function  
import httplib  
def findEnzymeInCazy(enzyname):  
  conn = httplib.HTTPConnection("www.cazy.org", 80)  
  conn.connect()
  ## I added ' + "&tag=3"' to search for protein name
  conn.request('GET', "/search?tag=4&recherche=" + enzyname + "&tag=3")  
  lines = conn.getresponse().read().split('\n')  
  for i,line in enumerate(lines):  
    if ( '<tr><td><a href="http://www.cazy.org/' in line ):  
      linkLine = lines[i]  
      j = linkLine.find( '"http://www.cazy.org/' ) + 21  
      k = linkLine.find( '.html"', j )  
      return linkLine[j:k] # beteween first and second double quotes  
  return None  
f = open('saida.csv','w')  
print("enzima     ; rankdomal", file=f)  
print("enzima     ; rankdomal")   
for line in open("enzylist.csv","r"):  
  pieces = line.split(";")  
  enzyname = pieces[0].strip()  
  enzyInCazy = findEnzymeInCazy(enzyname)  
  if ( enzyInCazy != None ):  
    print(enzyname.ljust(15) + '; ' + enzyInCazy.ljust(20), file=f)  
    print(enzyname.ljust(15) + '; ' + enzyInCazy.ljust(20))  
  else:  
    print(enzyname.ljust(15) + '; ' + "not found!", file=f)  
    print(enzyname.ljust(15) + '; ' + "not found!")  
