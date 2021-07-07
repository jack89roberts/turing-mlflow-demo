#!/bin/bash
jupyter notebook --port=8080 --no-browser --ip=0.0.0.0 --allow-root &
mlflow ui --backend-store-uri 'sqlite:////models/mlruns.db' -h 0.0.0.0 
