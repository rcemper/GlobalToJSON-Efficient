# GlobalToJSON-Efficient
This package offers a utility to load a Global into JSON object and to create a    
Global from this type of JSON object. ***Efficient*** refers to the structure created.     
Only Globals nodes containing data are presented in the generated JSON object.   

<img width="80%" src="https://raw.githubusercontent.com/rcemper/GlobalToJSON-Efficient/master/Globals.png">    

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.
## Installation 
Clone/git pull the repo into any local directory
```
git clone https://github.com/rcemper/GlobalToJSON-Efficient.git
```
Run the IRIS container with your project: 
```
docker-compose up -d --build
```
## How to Test it
This is the pre-loaded Global **^dc.MultiD** for testing.
![](https://raw.githubusercontent.com/rcemper/GlobalToJSON-Efficient/master/Global.JPG)

Open IRIS terminal
```
$ docker-compose exec iris iris session iris
USER>

USER>; generate JSON object from Global

USER>set json=##class(dc.GblToJSON.E).do("^dc.MultiD")

USER>zw json
json={"gbl":[{"node":"^dc.MultiD","val":"5"},{"node":"^dc.MultiD(1)","val":"$lb(\"
Braa,Ted Q.\",5353)"},{"node":"^dc.MultiD(1,\"mJSON\")","val":"{}"},{"node":"^dc.M
ultiD(2)","val":"$lb(\"Klingan,Ua C.\",6459)"},{"node":"^dc.MultiD(2,2,\"Multi\",\
"a\")","val":"1"},{"node":"^dc.MultiD(2,2,\"Multi\",\"rob\",1)","val":"rcc"},{"nod
e":"^dc.MultiD(2,2,\"Multi\",\"rob\",2)","val":"2222"},{"node":"^dc.MultiD(2,\"Mul
ti\",\"a\")","val":"1"},{"node":"^dc.MultiD(2,\"Multi\",\"rob\",1)","val":"rcc"},{
"node":"^dc.MultiD(2,\"Multi\",\"rob\",2)","val":"2222"},{"node":"^dc.MultiD(2,\"m
JSON\")","val":"{\"A\":\"ahahah\",\"Rob\":\"VIP\",\"Rob2\":1111,\"Rob3\":true}"},{
"node":"^dc.MultiD(3)","val":"$lb(\"Goldan,Kenny H.\",4583)"},{"node":"^dc.MultiD(
3,\"mJSON\")","val":"{}"},{"node":"^dc.MultiD(4)","val":"$lb(\"\",\"\")"},{"node":
"^dc.MultiD(4,\"mJSON\")","val":"{\"rcc\":122}"},{"node":"^dc.MultiD(5)","val":"$l
b(\"\",\"\")"},{"node":"^dc.MultiD(5,\"mJSON\")","val":"{}"}]}  ; <DYNAMIC OBJECT>

USER>; this is rather hard to read and follow

USER>write $$Do^ZPretty(json)
{
  "gbl":[
    {
      "node":"^dc.MultiD",
      "val":"5"
    },
    {
      "node":"^dc.MultiD(1)",
      "val":"$lb(\"Braam,Ted Q.\",51353)"
    },
    {
      "node":"^dc.MultiD(1,\"mJSON\")",
      "val":"{}"
    },
    {
      "node":"^dc.MultiD(2)",
      "val":"$lb(\"Klingman,Uma C.\",62459)"
    },
    {
      "node":"^dc.MultiD(2,2,\"Multi\",\"a\")",
      "val":"1"
    },
    {
      "node":"^dc.MultiD(2,2,\"Multi\",\"rob\",1)",
      "val":"rcc"
    },
    {
      "node":"^dc.MultiD(2,2,\"Multi\",\"rob\",2)",
      "val":"2222"
    },
    {
      "node":"^dc.MultiD(2,\"Multi\",\"a\")",
      "val":"1"
    },
    {
      "node":"^dc.MultiD(2,\"Multi\",\"rob\",1)",
      "val":"rcc"
    },
    {
      "node":"^dc.MultiD(2,\"Multi\",\"rob\",2)",
      "val":"2222"
    },
    {
      "node":"^dc.MultiD(2,\"mJSON\")",
      "val":"{\"A\":\"ahahah\",\"Rob\":\"VIP\",\"Rob2\":1111,\"Rob3\":true}"
    },
    {
      "node":"^dc.MultiD(3)",
      "val":"$lb(\"Goldman,Kenny H.\",45831)"
    },
    {
      "node":"^dc.MultiD(3,\"mJSON\")",
      "val":"{}"
    },
    {
      "node":"^dc.MultiD(4)",
      "val":"$lb(\"\",\"\")"
    },
    {
      "node":"^dc.MultiD(4,\"mJSON\")",
      "val":"{\"rcc\":122}"
    },
    {
      "node":"^dc.MultiD(5)",
      "val":"$lb(\"\",\"\")"
    },
    {
      "node":"^dc.MultiD(5,\"mJSON\")",
      "val":"{}"
    }
  ]
}
USER>
```
Now we want to verify the load function.  
First we make a copy of our source and then delete the source   
After the load operation the source Global is completely restored    
```
USER>merge ^keep=^dc.MultiD  

USER>kill ^dc.MultiD

USER>set sc=##class(dc.GblToJSON.E).load(json)

USER>zw sc
sc=1

USER>zw ^dc.MultiD
^dc.MultiD=5
^dc.MultiD(1)=$lb("Braam,Ted Q.",51353)
^dc.MultiD(1,"mJSON")="{}"
^dc.MultiD(2)=$lb("Klingman,Uma C.",62459)
^dc.MultiD(2,2,"Multi","a")=1
^dc.MultiD(2,2,"Multi","rob",1)="rcc"
^dc.MultiD(2,2,"Multi","rob",2)=2222
^dc.MultiD(2,"Multi","a")=1
^dc.MultiD(2,"Multi","rob",1)="rcc"
^dc.MultiD(2,"Multi","rob",2)=2222
^dc.MultiD(2,"mJSON")="{""A"":""ahahah"",""Rob"":""VIP"",""Rob2"":1111,""Rob3"":true}"
^dc.MultiD(3)=$lb("Goldman,Kenny H.",45831)
^dc.MultiD(3,"mJSON")="{}"
^dc.MultiD(4)=$lb("","")
^dc.MultiD(4,"mJSON")="{""rcc"":122}"
^dc.MultiD(5)=$lb("","")
^dc.MultiD(5,"mJSON")="{}"

USER>
```
### New Version 0.1.0 ###
The new version takes care of large Globals that may break your available memory.     
So the JSON Object is exported to a file.    
```
USER>write ##class(dc.GblToJSON.EX).export("^dc.MultiD")
File gbl.json created
```
And the related loader creates the Global  
```
USER>write ##class(dc.GblToJSON.EX).import()
Global ^dc.MultiD loaded
```
and to see the generated file there is a show() method  
```
USER>write ##class(dc.GblToJSON.EX).show()
{"gbl":[
{"node":"^dc.MultiD","val":5},
{"node":"^dc.MultiD(1)","val":"$lb(\"Braam,Ted Q.\",51353)"},
{"node":"^dc.MultiD(1,\"mJSON\")","val":"{}"},
{"node":"^dc.MultiD(2)","val":"$lb(\"Klingman,Uma C.\",62459)"},
{"node":"^dc.MultiD(2,2,\"Multi\",\"a\")","val":1},
{"node":"^dc.MultiD(2,2,\"Multi\",\"rob\",1)","val":"rcc"},
{"node":"^dc.MultiD(2,2,\"Multi\",\"rob\",2)","val":2222},
{"node":"^dc.MultiD(2,\"Multi\",\"a\")","val":1},
{"node":"^dc.MultiD(2,\"Multi\",\"rob\",1)","val":"rcc"},
{"node":"^dc.MultiD(2,\"Multi\",\"rob\",2)","val":2222},
{"node":"^dc.MultiD(2,\"mJSON\")","val":"{\"A\":\"ahahah\",\"Rob\":\"VIP\",\"Rob2\":1111,\"Rob3\":true}"},
{"node":"^dc.MultiD(3)","val":"$lb(\"Goldman,Kenny H.\",45831)"},
{"node":"^dc.MultiD(3,\"mJSON\")","val":"{}"},
{"node":"^dc.MultiD(4)","val":"$lb(\"\",\"\")"},
{"node":"^dc.MultiD(4,\"mJSON\")","val":"{\"rcc\":122}"},
{"node":"^dc.MultiD(5)","val":"$lb(\"\",\"\")"},
{"node":"^dc.MultiD(5,\"mJSON\")","val":"{}"}
]}
***** gbl.json *****
```

**q.a.d.**   

[Article in DC](https://community.intersystems.com/post/globaltojson-efficient)   

[Video](https://youtu.be/8Fz2537FHzc)   
