About
-----

Ansible role for installing zfs package on linux - currently centos/RedHat only, using DKMS style.

Requirements
------------


*	...

Role Variables
--------------

Variables with examples:

```yml
# set zfs system parameters:
zfs_sysparameters_list:
  - name: zfs_arc_max
    value: "{{ (ansible_memtotal_mb * 1024**2 * 0.25) | int }}"

# remove parameters from file /etc/modprobe.d/zfs.conf
zfs_sysparameters_list_remove:
  # - zfs_vdev_raidz_impl

# set to enable / disable timer to scrub all pools
zfs_scrub_enable: yes
zfs_scrub_schedule: monthly

# set to enable / disable timer to trim all pools
zfs_trim_enable: yes
zfs_trim_schedule: weekly

```


Example Usage
-------------

```yml
roles:
  - ansible_role_zfs
```

Acknowledgements
----------------

* thanks to zfsonlinux
* and various other folks on github

See also
--------

...

License
-------

MIT
