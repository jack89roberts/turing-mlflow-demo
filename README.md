# MLFlow Docker Environment with Jupyter Notebook

1. Run ```make build```
1. Edit Makefile to have the correct ports and HOSTMOUNTPOINT. This mountpoint should be on the local drive which means the directory with the database and model examples are stored outside of the docker.
1. Run ```make run```
1. The sqlite database and table demo1_multiclass should have been created. Use a tool such as DBeaver to connect to the database and import the CSV file containing the SEER data. At the moment the populated database is about
109MB in size. In stead of populating the database yourself you can request someone, who has already done it, to send it to you.
1. Unless the ports were changed in step 2 the following ports will be exposed:
    - 5000 : MLFlow
	 - 8080 : Jupyter Notebook
1. Port 1230 to 1240 are available and exposed to serve models when required
