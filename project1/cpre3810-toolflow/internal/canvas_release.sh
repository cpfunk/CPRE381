#!/bin/bash -x
#################################################
# Script to upload released toolflow            #
# to Canvas course                              #
################################################# 
set -e
HOMEDIR=`pwd`

cd $HOMEDIR

CANVAS_API_URL=https://canvas.iastate.edu/api/v1/
AUTH_TOKEN=$1
COURSE_ID=$2

FILENAME="cpre3810-toolflow.zip"
FILE_SIZE=`wc -c $FILENAME | awk '{print $1}'`

# Step 1: Telling Canvas about the file upload and getting a token
S1_RESP=`curl "$CANVAS_API_URL/courses/$COURSE_ID/files" \
      -F "name=$FILENAME" \
      -F "size=$FILE_SIZE" \
      -F "parent_folder_path=Labs/" \
      -H "Authorization: Bearer $AUTH_TOKEN"`
#      -F 'content_type=jar' \

echo $S1_RESP

S1_URL=`echo $S1_RESP | grep -o '"upload_url":"[^"]*' | grep -o '"[^"]*' | grep -o '[^"]*' | tail -1`
#S1_KEY=`echo $S1_RESP | grep -o '"key":"[^"]*' | tail -1`
#S1_PARAMS=`echo $S1_RESP | grep -o '"key":"[^"]*' | tail -1`

echo $S1_URL
echo $S1_KEY

# Step 2: Upload the file data to the URL given in the previous response
S2_RESP=`curl $S1_URL \
     -F "filename=cpre3810-toolflow.zip" \
     -F "content_type=application/zip" \
     -F "file=@$FILENAME"`
     #<any other parameters specified in the upload_params response>
     #-F "key=$S1_KEY" \

echo $S2_RESP

S2_URL=`echo $S2_RESP | grep -o '"location":"[^"]*' | grep -o '"[^"]*' | grep -o '[^"]*' | tail -1`

echo $S2_URL

# Step 3: Confirm the upload's success
S3_RESP=`curl -X POST "$S2_URL" \
      -H 'Content-Length: 0' \
      -H "Authorization: Bearer $AUTH_TOKEN"`


echo $S3_RESP

