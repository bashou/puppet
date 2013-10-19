# Variables d'application
set :application, "puppet"
set :repository,  "https://github.com/bashou/puppet.git"
set :deploy_to,   "/root/#{application}"

set :shared_children, []
set :normalize_asset_timestamps, false
set :scm, :git
set :scm_verbose,  true
set :deploy_via, :remote_cache
set :copy_exclude, [".git/*",".gitignore"]
set :keep_releases, 3

set :rvm_bin_path, "/usr/local/rvm/bin"

set :user, "root"
set :use_sudo, false
default_run_options[:pty] = true

ssh_options[:keys] = [
        File.join(ENV["HOME"], ".ssh", "francetv_key"),
    ]

after "deploy:create_symlink", "deploy:cleanup"

namespace :bootstrap do
  task :default do
    # Specific RVM string for managing Puppet; may or may not match the RVM string for the application
    set :user, "root"
 
    # Set the default_shell to "bash" so that we don't use the RVM shell which isn't installed yet...
    set :default_shell, "bash"
 
    # We tar up the puppet directory from the current directory -- the puppet directory within the source code repository
    system("tar czf 'puppet.tgz' puppet/")
    upload("puppet.tgz","/tmp",:via => :scp)
 
    # Untar the puppet directory, and place at /etc/puppet -- the default location for manifests/modules
    run("tar xzf /tmp/puppet.tgz")
    try_sudo("rm -rf /etc/puppet")
    try_sudo("mv puppet /etc/puppet")
 
    # Bootstrap RVM/Puppet!
    try_sudo("bash /etc/puppet/bootstrap.sh")
  end
end

namespace :puppet do
  task :default do
    # Specific RVM string for managing Puppet; may or may not match the RVM string for the application
    set :rvm_ruby_string, '1.9.3'
    set :rvm_type, :system
    set :user, "root"
 
    # We tar up the puppet directory from the current directory -- the puppet directory within the source code repository
    system("tar czf 'puppet.tgz' puppet/")
    upload("puppet.tgz","/tmp",:via => :scp)
 
    # Untar the puppet directory, and place at /etc/puppet -- the default location for manifests/modules
    run("tar xzf /tmp/puppet.tgz")
    try_sudo("rm -rf /etc/puppet")
    try_sudo("mv puppet/ /etc/puppet")
 
    # Run RVM/Puppet!
    run("rvmsudo -p '#{sudo_prompt}' puppet apply /etc/puppet/manifests/site.pp")
  end
end

namespace :update do
  task :default do
    set :user, "dosu"

    try_sudo("sudo apt-get update")
    try_sudo("sudo apt-get upgrade")

  end
end