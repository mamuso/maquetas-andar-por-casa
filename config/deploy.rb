##########################
#  PARÁMETROS GENERALES  #
##########################
set :application,  "frontdeandarporcasa.mamuso.net"
set :repository,   "git@github.com:mamuso/maquetas-andar-por-casa.git"
set :deploy_to,    "/var/www/#{application}"
set :server_group, 'www-data'
set :runner,       'mamuso'
set :user,         'mamuso'

#########
#  SCM  #
#########
set :scm,         :git
set :branch,      "master"
set :scm_verbose, false    # para depurar
set :scm_user,    'mamuso'

#####################
# FORMA DE DEPLOYAR #
#####################
set :deploy_via, :copy
set :keep_releases, 3
default_run_options[:pty] = true #supuestamente subsana algún que otro error
ssh_options[:paranoid] = false
set :use_sudo, false

role :web, "91.121.229.246"
role :app, "91.121.229.246"

namespace :deploy do
  task :restart do
    #run "touch #{current_path}/tmp/restart.txt" 
  end
end