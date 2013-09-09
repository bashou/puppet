require 'capistrano/ext/multistage'
require 'rvm/capistrano'
require 'yaml'
load 'deploy'
load 'config/deploy'

# Chargement des libraries communes
Dir["libs/*.rb"].each do |file|
  load file
end
