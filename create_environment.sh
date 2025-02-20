#!/bin/bash

#this is taking the input name on the directory
read -p "what is your name?:" yourName

#this is the main directory
mkdir submission_reminder_$yourName
cd submission_reminder_$yourName

#these are the subdirectories and the files each directory 
mkdir app
touch app/reminder.sh

#giving a permission  to make it executable
chmod u+x app/reminder.sh

#Filling the reminder.sh
cat << 'EOF' > app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

echo "Assignment: $HOMEWORK"
echo "Days remaining to submit: $SUBMISSION_DAYS days"
echo "--------------------------------------------"

echo "Assignment: $PROJECT"
echo "Days remaining to submit: $TURN_IN days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

mkdir modules
touch modules/functions.sh

#giving a permission  to make it executable
chmod u+x modules/functions.sh

#Filling the function.sh
cat << 'EOF' > modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
        if [[ "$assignment" == "$HOMEWORK" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $HOMEWORK assignment!"
        fi
        if [[ "$assignment" == "$PROJECT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $PROJECT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

mkdir assets
touch assets/submissions.txt

#Filling the submission.txt
cat << 'EOF' > assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Larry, Git, not submitted
Josh, Shell Basics, not submitted
Kyle, Shell Navigation, submitted
Sedem, Git, submitted
Bryan, Shell Basics, not submitted

EOF

mkdir config
touch config/config.env

#Filling the config.env
cat << 'EOF' > config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2

HOMEWORK="Shell Basics"
SUBMISSION_DAYS=1

PROJECT="Git"
TURN_IN=5

EOF

#this is the startup file
touch startup.sh

#giving a permission  to make it executable
chmod u+x startup.sh

#filling the startup.sh
cat << 'EOF' > startup.sh
#!/bin/bash
#this is to run the reminder.sh
./app/reminder.sh

EOF
