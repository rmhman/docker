#! /bin/bash
if [[ $# != 1 ]]; then
  echo -e "\n*** Error: Expecting Container name as arg. Please add a name to your container after ./start_latest.sh. ***\n"
  exit 1
fi

docker run --name $1  -v $PWD/to_share:/home/ubuntu/host -it enron:latest /bin/bash -l
