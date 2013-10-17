Vagrant.configure("2") do |config|

  config.vm.box = "vagrant-wheezy-box64"
  config.vm.box_url = "http://kono.nassi.me/vagrant/vagrant-wheezy64.box"

  config.vm.network :private_network, ip: "192.168.33.11"
  config.ssh.forward_agent = true

  config.vm.synced_folder "./puppet/files", "/etc/puppet/files"  

  config.vm.define :perso_default do |t| 
  end

  # VirtualBox optimization
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.provision :shell, :inline => "sudo apt-get update"
  config.vm.provision :shell, :inline => "sudo apt-get install -y libaugeas-ruby1.9.1 git-core"

  # Puppet !!!
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "site.pp"
    puppet.facter = { 
          "fqdn" => "fenty.nassi.me",
          "role" => "web",
          "site" => "uploadfr",
    }

    puppet.options = [
#    '--debug',
#     '--verbose',
#     '--hiera_config /vagrant/ftven/puppet/manifests/hiera.yaml',
    '--fileserverconfig /vagrant/puppet/fileserver.conf'
    ]
  end
end
