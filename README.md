# FSA Docker

This repository provides a Docker setup for FreeSWITCH Enterprise (FSE), ensuring reliable and scalable voice applications in a containerized environment.

## About FreeSWITCH Advantage

FreeSWITCH Advantage (FSA) is a professional support plan for FreeSWITCH, designed to ensure high reliability, enterprise-grade stability, and continuous performance improvements. It provides access to expert support and ensures that your voice applications perform optimally.

For more information about FreeSWITCH Advantage, visit the [official page](https://signalwire.com/products/freeswitch-enterprise).

# Pre-Requisite
Place any Debian packages for modules in the mod directory.  These will be copied and installed to the image.

# Using the Makefile

1. ```cp secrets.env.example secrets.env```  
Note:  Be sure to replace FSA_USERNAME and FSA_PASSWORD with FSA JIRA credentials!

3. Build the image:
```make build```

4. Run the container:
```make start```

5. Access the container:
```make enter```


# Using Dockerfile

1. ```cp secrets.env.example secrets.env```  
Note:  Be sure to replace FSA_USERNAME and FSA_PASSWORD with FSA JIRA credentials!

2.  Build the image:
```docker build --secret id=secrets,src=./secrets.env -t docker-freeswitch .```

3.  Run/Start the container:
```docker run -it docker-freeswitch```

