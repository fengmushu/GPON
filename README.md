### GPON OSGI hotfix-plugin

- git submodule update --init
- update the hotfix files, put them into hotfix DIR
- make
- copy the generated "hotfix.run" to target device /tmp and test ...

### TEST
- hotfix.run --keep

### FAQ
- H3开启kernel log to console:
    - /boot/armbianEnv.txt -> loglevel=7, console=both
- 