#!/bin/bash

echo In folder $PWD
   
# Clone the examples
git clone --branch master --depth 1 https://github.com/NHERI-SimCenter/quoFEM.git

# Create the working directoy
mkdir tmp.SimCenter
mkdir tmp.SimCenter/templatedir

# Read JSON from file
json_file="data.json"

# Iterate over array elements
jq -c '.Examples[]' "$json_file" | while read -r example; do
  name=$(echo "$example" | jq -r '.name')
  description=$(echo "$example" | jq -r '.description')
  inputfile=$(echo "$example" | jq -r '.inputFile')
  
  echo "Example Name: $name, Description: $age, Input File: $inputfile"
done

cp -a $PWD/Examples/qfem-0001/src/. $PWD/tmp.SimCenter/templatedir/

sudo apt-get install jq

inputfile=$PWD/Examples/qfem-0001/src/input.json

echo "doing jq ================="
echo $(cat $inputfile | jq '. + { "runDir": "'"$PWD/tmp.SimCenter"'" }') > $inputfile
echo $(cat $inputfile | jq '. + { "localAppDir": "'"$PWD/SimCenterBackendApplications"'" }') > $inputfile
echo $(cat $inputfile | jq '. + { "remoteAppDir": "'"$PWD/SimCenterBackendApplications"'" }') > $inputfile
echo $(cat $inputfile | jq '. + { "runType": "runningLocal" }') > $inputfile
echo "did jq ==================="

echo "catting the thing now ==================="
cat $inputfile

ls $PWD/tmp.SimCenter/templatedir

# Run the example in the backend
python $PWD/SimCenterBackendApplications/applications/Workflow/qWHALE.py "runningLocal" $inputfile $PWD/SimCenterBackendApplications/applications/Workflow/WorkflowApplications.json
