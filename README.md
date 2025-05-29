```bash
sudo su
```

```bash
apt update
apt install -y git
git clone https://github.com/iypetrov/bootstrap.git /projects/common/bootstrap
bash /projects/common/bootstrap/init.sh
```

after the reboot run
```bash
chsh -s $(which zsh)
reboot
```
