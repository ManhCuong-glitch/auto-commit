##
## Install ssh-agent if not already installed, it is required by Docker.
## (change apt-get to yum if you use an RPM-based image)
##
which ssh-agent || ( apt-get update -y && apt-get install openssh-client git -y )

##
## Run ssh-agent (inside the build environment)
##
eval $(ssh-agent -s)

##
## Add the SSH key stored in SSH_PRIVATE_KEY variable to the agent store
## We're using tr to fix line endings which makes ed25519 keys work
## without extra base64 encoding.
## https://gitlab.com/gitlab-examples/ssh-private-key/issues/1#note_48526556
##
echo "$SSH_PRIVATE_KEY"
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null

##
## Create the SSH directory and give it the right permissions
##
mkdir -p ~/.ssh
chmod 700 ~/.ssh

##
## Use ssh-keyscan to scan the keys of your private server. Replace gitlab.com
## with your own domain name. You can copy and repeat that command if you have
## more than one server to connect to.
##
ssh-keyscan github.com >> ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts
