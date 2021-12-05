# Docker for Enron

Create and run a Docker container to develop and run Enron scripts in a consistent environment.

## Prerequisites

* Docker
* Personal SSH Private Key for GitLabs
* SSH keys for AWS and Cartel spaces

## Preparation

You will need your GitLabs SSH private key to clone the Enron repo within the Docker Container. You will also need SSH keys for AWS and Cartel spaces when running remote SSH and SCP commands. Copy your SSH keys to the `to_share` folder and rename where appropriate. For example:

```
> cp ~/.ssh/<personal-git-key> ./to_share/id_rsa_git
> cp ~/.ssh/<personal-cartel-key> ./to_share/id_rsa_cartel
> cp ~/.ssh/<personal-1057-key> ./to_share/id_rsa_1057
> cp ~/.ssh/sawfish.pem ./to_share/sawfish.pem
# Another Option:
cp -r ~/.ssh/* ./to_share/
```

Note that the above SSH keys are set in `.gitignore` so that they __will not__ get checked into source control.

## Docker Scripts

### Building the image

```
> build.sh
```

The `Dockerfile` is configured with everything we need to create a Docker image. If anything is changed within the `Dockerfile`, then update the tag version in the `build.sh` script.

### Running the container for the first time

```
> start_latest.sh
```

This will run the Docker image tagged as `latest` and will drop you into a bash shell session for the running container. You can exit out of the shell using the usual `exit` command or Ctrl+D.

Note: the `to_share` folder will be mapped to `/home/ubuntu/host` within the container

### List Previously Running Containers (will show Container IDs)

```
> list.sh
```

To see available Docker images, run

```
> docker images
```

### Restart a Previously Running Container

```
> restart.sh <container_id>
```

See `list.sh` above for retrieve the appropriate ___container_id___

## Setup within Running Container

Once you have your Enron container running, you will need to perform some extra tasks.

### Clone Enron Repo

From the bash shell of your running container, you will already have a script `~/enron_git_clone` to clone the Enron project. You will be prompted for your ssh key passphrase.

```
> ./enron_git_clone
```

### Setup AWS

Configure AWS CLI. You will need AWS access keys and default region (us-east-1).

```
> aws configure
```

### Setup Git

```
> git config --global user.email "you@example.com"
> git config --global user.name "Your Name"
```

### Add ~/.creds file

This file stores credentials. Please request from OPS team.

### Update User in ~/.ssh/config file to your personal user account

Change usernames or just copy and paste your ssh config file. If you copy your config, make sure your key names match with what you have in the `to_share` directory
```
Host 1057bastion
    ...
    User CHANGE_ME
    ...

Host Cartel*
    ...
    User CHANGE_ME
    ...

```

## Develop and Test Enron Scripts

After all of the above setup is successful, you should be able to develop and run any scripts within `Enron/iac`.

Added bash completion for Git commands.

Added `ssh-agent` startup at login, and `ssh-add-rsaid` alias so you don't have to keep entering your ssh password when running Git commands.

### Proxy for SSH and SCP

Added ssh-proxy-command() and scp-proxy() functions to issue command on remote instance and copy files to remote instance, respectively. These functions require ssh keys to access bastion and any remote instance. See Preparation section for the appropriate SSH keys.

Example of proxying an ssh command:

```
> ssh-proxy-command 1057bastion <remote-instance-name> 'ls -l'
> ssh-proxy-command CartelBastion <remote-instance-name> 'ls -l'
```

Example of proxying an scp command:

```
> scp-proxy 1057bastion <remote-instance-name> <local-path-and-filename> '<remote-path>'
> scp-proxy CartelBastion <remote-instance-name> <local-path-and-filename> '<remote-path>'
```
