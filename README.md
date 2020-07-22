# custom-cloud-gaming

### Terraform

How to run the terraform file:

First set up your credentials, see: https://www.terraform.io/docs/providers/aws/index.html#environment-variables

From the terraform directory...

~~~
terraform init  # first time only
terraform plan
terraform apply
~~~

To delete

~~~
terraform destroy
~~~


### TMUX

To connect:

~~~
sudo su - minecraft
tmux list-sessions
tmux attach-session -t minecraft
~~~

To say things:

~~~
/say Warning: server shutdown imminent
~~~

To detach:

~~~
Ctrl-B D
~~~

To view logs:

* Note: minecraft.service uses minecraft tag, and screen uses systemd-cat

~~~
journalctl -t minecraft
systemctl status minecraft
~~~


tee explained:

~~~
<cmd> 2>&1 | tee /dev/tty | systemd-cat -t minecraft
~~~

* ```2>&1``` redirects stderr to stdout

* ```tee /dev/tty``` copies stdout to tty (tmux detached window)

* ```systemd-cat -t minecraft``` cats stdin to journalctl, tagging with "minecraft"

### s3 backup

Quick way:

~~~
sudo su - minecraft
export PYTHONPATH=/home/minecraft && /home/minecraft/jmc/minecraft/push_server_backup.py --role-arn arn:aws:iam::482283577367:role/CcgMinecraftAssumedRole --server-folder /home/minecraft/minecraft_server --s3-bucket ccg-minecraft-worlds --s3-object zach_server.tar.gz 2>&1 | systemd-cat -t minecraft
~~~

to gain permission, need to run the following on s3:

~~~
aws sts assume-role --role-arn arn:aws:iam::482283577367:role/CcgMinecraftAssumedRole --role-session-name assumed-s3
export AWS_SECRET_ACCESS_KEY=...
export AWS_ACCESS_KEY_ID=...
export AWS_SESSION_TOKEN=...
aws s3 cp s3://ccg-minecraft-worlds/zach_server.tar.gz zach_server.tar.gz
~~~

to check cron (logs will be sent to journalctl):

~~~
crontab -l
~~~
