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


###Screen

To connect:

~~~
sudo su - minecraft
screen -r minecraft
~~~

To say things:

~~~
/say Warning: server shutdown imminent
~~~

To view logs:

* Note: minecraft.service uses minecraft tag, and screen uses systemd-cat

~~~
journalctl -t minecraft
~~~
