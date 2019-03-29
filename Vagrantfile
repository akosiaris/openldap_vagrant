# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "debian/contrib-stretch64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.vm.provision "shell" do |s|
      s.inline = "apt-get update && apt-get install -y puppet make ldapvi"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
  end

  config.vm.provision "shell" do |ldap|
      ldap.inline = "cd /vagrant ; make"
  end

  config.vm.define "m1" do |m1|
    m1.vm.hostname = "m1"
    m1.vm.network "private_network", ip: "192.168.10.2"
  end
  config.vm.define "m2" do |m2|
    m2.vm.hostname = "m2"
    m2.vm.network "private_network", ip: "192.168.10.3"
  end
  config.vm.define "s1" do |s1|
    s1.vm.hostname = "s1"
    s1.vm.network "private_network", ip: "192.168.10.4"
  end
end
