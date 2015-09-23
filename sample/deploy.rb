require 'kanaveral'
require_relative 'commands'

#For now run via KANAVERAL_ENV=production ruby deploy.rb 

Kanaveral::Base.deployer do
  
  server 'server-1' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/www/application'
    s.password = true
  end
  
  server 'server-2' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/www/application'
    s.password = true
  end
  
  deploy(:production) do
    
    local do
      run :changelog, to: :commits
      run :git_push
    end 

    remotes('server-1', 'server-2') do
      run :git_pull
      run :bundler
      run :assets_precompile
      run :unicorn_upgrade
    end

    remote('server-2') do
      run :delayed_job_restart
    end
    
    local do
      run :newrelic
    end 
  end

end