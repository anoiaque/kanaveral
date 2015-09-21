require 'kanaveral'
require 'commands'

Kanaveral::Base.deployer do

  server 'hopper-0' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/philippe'
  end
  
  server 'hopper-1' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/philippe'
  end

  server 'hopper-2' do |s|
    s.user = 'philippe'
    s.host = 'philae'
    s.root = '/home/philippe'
  end
  
  deploy do
    
    local do
      run :changelog, to: :commits
      run :git, :push
    end 

    remotes('hopper-0', 'hopper-2', 'hopper-1') do
      run :pwd
      run :git, :pull
      run :bundler
      run :assets, :precompile
      run :unicorn, :upgrade
    end
    
    remote('hopper-1') do
      run :delayed_job, :restart
    end
    
    local do
      run :newrelic, use: :commits
    end 
  end

end