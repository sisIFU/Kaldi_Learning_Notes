# How to Log Linux CPU Usage to a file?

This document records the linux commands for logging hardware usage of a linux machine including:
* The name of the process that is running e.g. make-mfcc.sh
* CPU Usgae (free CPU / total CPU)
* Memory Usage
* The total running time of each process

## Goal
Write a Linux Shell Script to trace the running commands and also the system performance.
## Working flow
1. Running Kaldi TIMIT scripts
2. In the meantime, record the CPU Usage
3. How long does each command need to execute? (Time Performance)
4. Are many commands running at the same time?

### Do we need CPU benchmarking?

Recording all the commands that are used to running Kaldi
The total time of running and System Performance


## List of Commands for logging 
### ps aux
List all running process
[How to see process created by specific user in Unix/linux](https://unix.stackexchange.com/questions/85466/how-to-see-process-created-by-specific-user-in-unix-linux)
To view only the processes owned by a specific user, use the following command:
```bash
top -U [username]
```
Replace the [username] with the required username

If you want to use ps then:
```bash
ps -u [username]
```

### top -b -n2 | grep "Cpu(s)"|tail -n 1 | awk '{print $2 + $4}'

```bash
top -b | awk -v logfile=/tmp/log.txt '
{
    if($1 == "PID")
    {
        command="date +%T";
        command | getline ts
        close(command);
    }
    if($12 == "redis" || $12 == "logstash" || $12 == "elasticsearch" || $12 == "kibana")
    {
        printf "%s,%s,%s,%s,%s\n",ts,$1,$9,$10,$12 > logfile
    }
}'
```

### grab data from top
```bash
free -h -s 5
```

get cpu usage , I get nice + user cpu usage.
Print free memeory and swap usage every 5 second.
Example output:
              total        used        free      shared  buff/cache   available
Mem:           1.8G        192M        513M         12M        1.1G        1.4G
Swap:          2.0G        123M        1.9G

Trace process and system performance
### How to log finally
#### First run nohup with time command
```bash
time nohup ./run.sh > logs/2017_11_16.log
```
#### Second grep top data every 1 second
```bash
while true; do top -U xfu7 >> logs/topRecord_11_16.log; sleep 1; done
```
