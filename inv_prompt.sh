#!/bin/bash

# I steal things from the internet and then fail at making them better.
#
# Matt Carr
# matt.carr@utexas.edu
# Variables for Cocoa Dialog

CD="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"
CDI="/Applications/Utilities/CocoaDialog.app/Contents/Resources"

#Absolute Manage Variables
Office=$(defaults read /Library/Preferences/com.poleposition-sw.lanrev_agent UserInfo4)
Building=$(defaults read /Library/Preferences/com.poleposition-sw.lanrev_agent UserInfo3)
UTTag=$(defaults read /Library/Preferences/com.poleposition-sw.lanrev_agent UserInfo0)
AssignedUser=$(defaults read /Library/Preferences/com.poleposition-sw.lanrev_agent UserInfo7)

#Paths for Files
prompt_time="/Users/Shared/.cns_prompt_time"
cns_inv="/Users/shared/.cns_inv"

#Setting Up the Prompt TimeStamp
PromptedOn=$(date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S")
echo "The user was prompted on the following" > $prompt_time
echo $PromptedOn >> $prompt_time

#Checking to see if CocoaDiaog exist, because if it doesnt we might have a problem.
if [ -f $CD ]; then
	echo "Found CocoaDialog, we can continue"
else
	echo "Didn't find CocoaDialog, we're going to have a problem."
	exit 0
fi

#Prompt
Prompt=`$CD textbox --title "CNS OIT Inventory" --no-newline \
        --informative-text "From the CNS Office of Information Technology" \
        --text "
Hello,

As part of our ongoing mission to ensure a high level of customer service we would like to ask that you assist us with keeping our inventory database up to date.
Below is some of the information that we have on file for this workstation. Click the button for Yes if this is accurate, if not please click No. 

If you clicked No then someone from our department will be reaching out to you. Otherwise, have a great rest of your day! 

UT Tag: $UTTag

EID assigned to this computer: $AssignedUser

Current Office: $Building $Office



Thank you for your assistance.


CNS OIT Helpdesk
http://cns.utexas.edu/help 
512-232-1077
" \
--button1 "Yes" --button2 "No"`

if [ "$Prompt" == "1" ]; then
	echo "User agrees that everything is golden" >> $prompt_time
	echo "IsGolden" > $cns_inv
fi

if [ "$Prompt" == "2" ]; then
	echo "User says that somethings wrong and needs updating." >> $prompt_time
	echo "NeedsUpdates" > $cns_inv
fi

cat $cns_inv
cat $prompt_time

exit 0
