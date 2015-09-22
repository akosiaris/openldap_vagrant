openldap vagrant
=================

A Vagrant environment to setup a dual master replication setup with a
single slave. SSL setup using snakeoil certs included. The box used is
debian/jessie64

Usage
=====

Make sure you got vagrant and virtualbox. Vagrant version required is at least
1.5 so you if you are using Debian Wheezy you will have to download the .deb
manually. Virtualbox version used during development is 4.3, it might be best to
stick to that, as I have done zero testing with other versions

.. code-block:: bash

    vagrant up

Three VMs: m1, m2, s1. m1, m2 are masters, s1 is a slave. Note that we
are only talking about a dual master setup (mirror), not a true
multi-master setup
