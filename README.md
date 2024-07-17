# Using the Makefile

1. ```cp env.example env```  
Note:  Be sure to replace FSA_USERNAME and FSA_PASSWORD with FSA JIRA credentials!

3. Build the image:
```make build```

4. Run the container:
```make start```

5. Access the container:
```make enter```


# Using Dockerfile

1.  Build the image:
```docker build -t docker-freeswitch --build-arg='FSA_USERNAME=<YOUR_FSA_USERNAME>' --build-arg='FSA_PASSWORD=<YOUR_FSA_PASSWORD>'```
Note:  Be sure to replcae FSA_USERNAME and FSA_PASSWORD with your FSA JIRA credentials!

2.  Run/Start the container:
```docker run -it docker-freeswitch```

