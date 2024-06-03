#!/bin/bash

# Install trainer as an editable package
cd /project/src/trainer
pip install -e .

# Install src as an editable package (beigemap)
cd /project
pip install -e .
