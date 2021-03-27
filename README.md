[![Actions Status - Master](https://github.com/juju4/ansible-fact/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-fact/actions?query=branch%3Amaster)
[![Actions Status - Devel](https://github.com/juju4/ansible-fact/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-fact/actions?query=branch%3Adevel)

This role will setup The Firmware Analysis and Comparison Tool (formerly known as Fraunhofer's Firmware Analysis Framework (FAF)) is intended to automate most of the firmware analysis process.
* https://github.com/fkie-cad/FACT_core
* https://fkie-cad.github.io/FACT_core/

It is a work in progress to translate python and shell script and provides a reasonably secure setup, mostly through IP Allow-only list and Systemd seccomp hardening.

Requirements
------------

# Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.9
 * 2.10

### Operating systems

Tested on Ubuntu 18.04 and 20.04.

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - juju4.fact
```

## Continuous integration

This role has a molecule setup with limitations as docker backend and role heavily uses docker. Therefore, Molecule can't test everything.

Once you ensured all necessary roles are present, You can test with:
```
$ pip install molecule docker
$ molecule test
$ MOLECULE_DISTRO=ubuntu:20.04 molecule test --destroy=never
```
or
```
$ gem install kitchen-ansible kitchen-lxd_cli kitchen-sync kitchen-vagrant
$ cd /path/to/roles/juju4.fact
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
```

## Troubleshooting & Known issues

## License

BSD 2-clause
