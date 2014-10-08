# Custom invokations to determine if needed every deployment
namespace :custom do
  desc 'remove assets from old releases'
  task :remove_old_assets do
    on roles(:app) do
      system "find #{shared_path}/public/assets -mtime +1 | xargs rm -Rf"
    end
  end

  desc 'make sure tmp is writable'
  task :make_tmp_writable do
    on roles(:app) do
      execute "chmod -R 775 #{current_path}/tmp"
    end
  end
  
  desc 'test everything before deployment'
  task :testing do
    on roles(:app) do
      test_log = "log/capistrano.test.log"
      info "Running tests, please wait ..."
      system "touch #{test_log}"
      unless system "bundle exec rake cucumber > #{test_log} 2>&1" #' > /dev/null'
        error "Tests failed. Run `cat #{test_log}` for more information."
        exit
      else      
        info "Tests passed"
        system "rm #{test_log}"
      end
    end
  end
  
  desc "Prompt for branch or tag"
  task :git_branch_or_tag do
    on roles(:app) do
      run_locally do
        tag_prompt = "Enter a branch or tag name to deploy: "

        ask(:branch_or_tag, tag_prompt)
        tag_branch_target = fetch(:branch_or_tag)

        info "About to deploy branch or tag '#{tag_branch_target}'"
        set(:branch, tag_branch_target)
      end

    end
  end
  
  desc 'create snapshot on google cloud'
  task :create_snapshot do
    on roles(:app) do
      info "Creating snapshot..."
      system "gcloud compute --project 'hulalabs-oohula' disks snapshot 'https://www.googleapis.com/compute/v1/projects/hulalabs-oohula/zones/europe-west1-b/disks/oohula-production' --zone 'europe-west1-b' --snapshot-names 'release-#{Time.now.strftime('%Y%m%d%H%M%S')}'"
    end
  end
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Restarts Phusion Passenger
      debug "Restarting servers..."
      execute "touch #{current_path}/tmp/restart.txt"
      info "Server restarted"
    end
  end
end