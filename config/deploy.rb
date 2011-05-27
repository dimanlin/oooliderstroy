set :application, "oooliderstroy"
set :repository,  "git://github.com/dimanlin/oooliderstroy.git"
set :branch, "master"

set :scm, :git
set :scm_verbose, true

set :user, 'root'
set :use_sudo, false
set :deploy_to, "/var/www/spree_project/#{application}" # /home/myuser/myproject/deploy
set :root_path, "/var/www/spree_project/"
set :shared_host, "oooliderstroy.ru"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, "81.17.140.181"                          # Your HTTP server, Apache/etc
role :web, "81.17.140.181"                          # Your HTTP server, Apache/etc
role :db,  "81.17.140.181", :primary => true # This is where Rails migrations will run


after "deploy:update", "deploy:rake_oooliderstroy_install"
after "deploy:rake_oooliderstroy_install", "deploy:delete_all_css"
after "deploy:delete_all_css", "deploy:migrate"

# # Директория приложения на удалённом хостинге
#set :app_dir, "/var/www/spree_project/#{application}/" # /home/myuser/myproject/

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

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do

  task :rake_oooliderstroy_install, :roles => :web do
    run "cd #{root_path} && rake oooliderstroy:install"
  end

  task :migrate, :roles => :web do
    run "cd #{root_path} && RAILS_ENV='production' rake db:migrate"
  end

  task :restart, :roles => :web do 
    run "touch #{root_path}tmp/restart.txt"
  end

  task :delete_all_css, :roles => :web do
    run "rm #{root_path}public/stylesheets/all.css"
  end


#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
end

# Update data
namespace :update do
  desc "Copy remote production shared files to localhost"
  task :shared do
    run_locally "rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:/var/www/spree_project/public/assets ../public"
  end

  desc "Dump remote production postgresql database, rsync to localhost"
  task :postgresql do
    get("/var/www/spree_project/config/database.yml", "tmp/database.yml")

    remote_settings = YAML::load_file("tmp/database.yml")["production"]
    local_settings  = YAML::load_file("config/database.yml")["development"]

    run "export PGPASSWORD=#{remote_settings["password"]} && pg_dump --host=#{remote_settings["host"]} --port=#{remote_settings["port"]} --username #{remote_settings["username"]} --file #{current_path}/tmp/#{remote_settings["database"]}_dump -Fc #{remote_settings["database"]}"

    run_locally "rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{current_path}/tmp/#{remote_settings["database"]}_dump tmp/"

    run_locally "dropdb -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} #{local_settings["database"]}"
    run_locally "createdb -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} -T template0 #{local_settings["database"]}"
    run_locally "pg_restore -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} -d #{local_settings["database"]} tmp/#{remote_settings["database"]}_dump"
  end

  desc "Dump all remote data to localhost"
  task :all do
    update.shared
    update.postgresql
  end
end

