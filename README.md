# kernel_stacks_splunk_threads_gt.sh
collect kernel stacks when splunkd threads greater than x (defaults to 1000)


1.) in the /tmp directory of your target Splunk instance, create the script located here: 
https://github.com/rephillips/kernel_stacks_splunk_threads_gt.sh/blob/main/kstack_threads.sh

vi kstack_threads.sh

2.) switch to root user "sudo su" and give the file executable permissions:

chmod +x kstack_threads.sh

3.) run script manually 
./kstack_threads.sh

or run script in the background and keep it running after exiting the terminal session, use the syntax:

nohup ./kstack_threads.sh &


you can now exit the terminal session and log back in and confirm the script is still running: 

ps -ef | grep kstack | grep -v color

[splunker@idx1 ~]$ ps -ef | grep kstack

root     19456  3552 10 20:43 pts/1    00:00:05 /bin/bash ./kstack_threads.sh



The script will continue to run and collect kernel stacks when splunkd threads exceed 1000 until stopped.


to stop the script:
kill -9 pid

ie: 
kill -9 19456
