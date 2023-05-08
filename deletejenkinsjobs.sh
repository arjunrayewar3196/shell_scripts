#!/bin/bash

# Set the number of days to keep jobs
DAYS_TO_KEEP=30

# Get the current timestamp in seconds
CURRENT_TIMESTAMP=$(date +%s)

# Loop through all the jobs in Jenkins
for JOB_NAME in $(java -jar jenkins-cli.jar -s http://jenkins-server/ list-jobs)
do
  # Get the job creation time in seconds
  JOB_TIMESTAMP=$(java -jar jenkins-cli.jar -s http://jenkins-server/ get-job "$JOB_NAME" | grep -m 1 '<createdTime>' | sed 's/<createdTime>//;s/<\/createdTime>//')
  JOB_TIMESTAMP_SECONDS=$(date -d "$JOB_TIMESTAMP" +%s)

  # Calculate the age of the job in days
  AGE_IN_DAYS=$(( ($CURRENT_TIMESTAMP - $JOB_TIMESTAMP_SECONDS) / 86400 ))

  # If the job is older than the specified number of days, delete it
  if [ $AGE_IN_DAYS -gt $DAYS_TO_KEEP ]
  then
    echo "Deleting job: $JOB_NAME"
    java -jar jenkins-cli.jar -s http://jenkins-server/ delete-job "$JOB_NAME"
  fi
done


You'll need to modify the DAYS_TO_KEEP variable to specify the number of days you want to keep jobs. You'll also need to replace http://jenkins-server/ with the URL of your Jenkins server.

The script loops through all the jobs in Jenkins, calculates the age of each job in days, and deletes any job that is older than the specified number of days. The script uses the Jenkins CLI to interact with the Jenkins server, so make sure you have the CLI installed and configured on your machine.
