# Setting up tailscale

## Instructions

First, you need to log in via SSH:

```sh
$ ssh USERNAME@IP
```

When asked for a password, use your account password.

Next, download and install tailscale as described [here](https://tailscale.com/download/linux) with this command:

```sh
User@DXP4800PLUS:~$ curl -fsSL https://tailscale.com/install.sh | sh
```

Finally, start tailscale with

```sh
User@DXP4800PLUS:~$ sudo tailscale up
```

After starting tailscale, I noticed that the NAS could not access any resources on the internet due to a broken DNS configuration. The cause for this issue is that UGOS uses the file `/etc/resolv.conf` to store the default nameserver but tailscale overrides it when launching.

To fix it, I had to restart tailscale with [disabled DNS configuration](https://tailscale.com/kb/1241/tailscale-up)

```sh
User@DXP4800PLUS:~$ sudo tailscale down
User@DXP4800PLUS:~$ sudo tailscale up --accept-dns=false 
```
