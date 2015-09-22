require 'kanaveral'
require_relative 'commands'

Kanaveral::Base.deployer do
  
  server 'hopper-0' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/philippe'
    s.password = true
  end
  
  server 'hopper-1' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/philippe'
    s.password = true
  end

  server 'hopper-2' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/philippe'
    s.password = true
  end
  
  deploy do
    
    local do
      run :changelog, to: :commits, notice: 'Create changelog from commits'
      run :git_push, notice: 'Push to github origin/master'
    end 

    # remotes('hopper-0', 'hopper-2', 'hopper-1') do
    #   run :pwd
    #   run :git_pull
    #   run :bundler
    #   run :assets_precompile
    #   run :unicorn_upgrade
    # end
    #
    # remote('hopper-1') do
    #   run :delayed_job_restart
    # end
    
    local do
      run :newrelic
    end 
  end

end