Vagrant.configure("2") do |config|

  config.vm.box = "debian-squeeze-607"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box"

  config.vm.network :private_network, ip: "192.168.33.10"
  config.ssh.forward_agent = true

  config.vm.synced_folder "../www", "/vagrant_www"
  config.vm.synced_folder "./files", "/etc/puppet/files"  

  # VirtualBox optimization
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpus", 2]
 #   vb.customize ["modifyvm", :id, "--name", "Sandbox_FTV"]
  end

  config.vm.provision :shell, :inline => "sudo apt-get update"
  config.vm.provision :shell, :inline => "sudo apt-get install -y libaugeas-ruby1.9.1 git-core"

  # Puppet !!!
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "site.pp"
    puppet.facter = { 
          "fqdn" => "fenty.nassi.me",
          "role" => "bdd",
    }
    puppet.pp_path = "/tmp/vagrant-puppet"

    puppet.options = [
#     '--debug',
#     '--verbose',
#     '--hiera_config /vagrant/ftven/puppet/manifests/hiera.yaml',
      '--fileserverconfig /vagrant/fileserver.conf'
    ]
  end
end
