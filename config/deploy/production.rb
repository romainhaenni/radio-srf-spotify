set :domain, 'spotify.hibiscuslabs.ch'
set :rails_env, 'production'
set :stage, 'production'
set :migration_role, 'db'

server 'spotify.hibiscuslabs.ch', user: 'deployer', roles: %w{web app db}

set :deploy_to, "/var/www/#{fetch(:application)}"

after 'deploy:started', 'custom:git_branch_or_tag'
# after 'deploy:finished', 'custom:create_snapshot'