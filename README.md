```bash
apt update
apt install -y git
mkdir -p /projects/common
mkdir -p /projects/personal
mkdir -p /projects/work
git clone https://github.com/iypetrov/bootstrap.git /projects/common/bootstrap
make -C /projects/common/bootstrap bootstrap
```
