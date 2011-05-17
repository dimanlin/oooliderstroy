set :application, "lider_stroy"
set :repository,  "git://github.com/dimanlin/oooliderstroy.git"
set :branch, "master"

set :scm, :git
set :scm_verbose, true

set :user, 'root'
set :use_sudo, false
set :deploy_to, "/var/www/spree/#{application}" # /home/myuser/myproject/deploy
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, "81.17.140.181"                          # Your HTTP server, Apache/etc
role :web, "81.17.140.181"                          # Your HTTP server, Apache/etc
role :db,  "81.17.140.181", :primary => true # This is where Rails migrations will run

# # Директория приложения на удалённом хостинге
set :app_dir, "/var/www/#{application}/" # /home/myuser/myproject/

# # Директория, куда будет делаться checkout из репозитория


# # Настройки репозитория
# set :scm, :subversion # используем subversion
# set :scm_user, 'mysvnuser' # имя пользователя репозитория
# set :scm_url, "svn://svnhost/trunk/#{application}" #
# svn://svnhost/trunk/myproject/
# # Формируем команду svn checkout --username mysvnuser
# svn://host/trunk/myproject
# set :repository, Proc.new { "--username #{scm_user} #{scm_url}"}
#
# task :after_symlink, :roles => :web do
# run "ln -nfs #{release_path}/public #{app_dir}/public_html"
# end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
