set :application, 'sounds-spotify'
set :repo_url, 'git@github.com:romainhaenni/sounds-spotify.git'
set :log_level, :info
set :keep_releases, 5

# set :default_env, 'staging'
set :default_env, { path: "~/.rbenv/shims:/usr/bin/rbenv/bin:$PATH" }
set :user, 'deployer'
set :group, 'www'
set :deploy_via, :remote_cache

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}
set :linked_dirs, %w{log public/assets public/system tmp/pids tmp/cache tmp/sockets tmp/sessions}

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: false,
  auth_methods: %w(publickey)
}

set :normalize_asset_timestamps, %{public/assets}

after 'deploy:published', 'custom:make_tmp_writable'
after 'deploy:finishing', 'custom:remove_old_assets'
after 'deploy:publishing', 'custom:restart'
