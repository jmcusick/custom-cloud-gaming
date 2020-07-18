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
journalctl -u minecraft
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
