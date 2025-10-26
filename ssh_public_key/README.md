# Use public key authentication for ssh instead of password

Usually, setting up key based authentication for a SSH server is as simple as a single call to [ssh-copy-id](https://manpages.debian.org/bookworm/openssh-client/ssh-copy-id.1.en.html). However, on UGOS, there are some extra steps required to fix the permission issues.

## Instructions

To fix the SSH permissions, we need to define a new system service. First, you need to log in via SSH:

```sh
$ ssh USERNAME@IP
```

When asked for a password, use your account password.

Next, create a new file for the script

```sh
User@DXP4800PLUS:~$ sudo nano /usr/local/bin/check_and_fix_ssh_permissions.sh
```

and paste the content of [usr/local/bin/check_and_fix_ssh_permissions.sh](usr/local/bin/check_and_fix_ssh_permissions.sh) inside. Make sure to replace <USER NAME> with you actual user name.
To make sure that the script can be executed, let's add execution permissions.

```sh
User@DXP4800PLUS:~$ sudo chmod +x /usr/local/bin/check_and_fix_ssh_permissions.sh
```

Next, create the service file

```sh
User@DXP4800PLUS:~$ sudo nano /etc/systemd/system/ssh-permission-monitor.service
```

and paste the content of [etc/systemd/system/ssh-permission-monitor.service](etc/systemd/system/ssh-permission-monitor.service) inside. Again, replace <USER NAME> with you actual user name.

Now reload the systemctl deamon:

```sh
User@DXP4800PLUS:~$ sudo systemctl daemon-reload
```

And enable and start the service:

```sh
User@DXP4800PLUS:~$ sudo systemctl enable ssh-permission-monitor.service
User@DXP4800PLUS:~$ sudo systemctl start ssh-permission-monitor.service
```

You can also look at the service status and troublshoot issues:

```sh
User@DXP4800PLUS:~$ sudo systemctl status ssh-permission-monitor.service
```

After those steps, you key should be accepted even after system reboots or configuration changes through the UGOS web interface.




