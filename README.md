# Kanaveral

Kanaveral is a flexible deployment/automation tool.
Its purpose is for app deployment and/or server installation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanaveral'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kanaveral

## Usage

You can see an example under /sample, commands.rb contains the commands you use and kanaveral.rb is 
the deployment script itself which use commands.rb.

The main file must be named kanaveral.rb.
The DSL define 3 main instructions :

- **commands** : indicate the path to load your commands.rb

- **server** : define your servers (user, host, app root ...). Set password to true if you don't use ssh keys.

- **deploy** contain the main instructions block to deploy your application, with **local** blocks for commands to 
run locally and **remote** blocks for commands to run on remote server. You can save outputs of commands to be
used later via the keyword to:. The output result string will be available via context variable passed to
your lambda in commands.rb


### Commands

Simply define a command like that :

```ruby
command(<symbol>) do
  command ->(context) { "my shell command where i get access to context" }
  notice -> { "What i do"}
end
```
if *notice* lambda is not present a default message is displayed. If you don't need
context just skip lambda parameter.

**Example**

```ruby
command(:bundler) do
  command ->(context) { "cd #{context.server.root} && bundle" }
  notice -> { "Run bundle" }
end
```


With *context.server* you get your server configuration, *context.server.user*, *context.server.host* etc...

You can also get variables you define in your deployment script via keyword to: (see after 'Deploy script')

**Example**

```ruby
command(:newrelic) do
  command ->(context) { "echo '#{context.commits}' | newrelic deployments -c" }
end
```

*context.commits* contains the output of the command *run :changelog, to: :commits* (see after 'Deploy script') 

### Deploy script
```ruby
Kanaveral::Base.deployer do
  
  #set the file where commands to be loaded
  commands(File.join(File.dirname(__FILE__), 'commands.rb')) 
  
  #define server 1
  server 'server-1' do |s| 
    s.user = 'user'
    s.host = 'myhost or ip'
    s.root = '/home/www/application'
    s.password = true
  end
  
  #define server 1
  server 'server-2' do |s|
    s.user = 'user'
    s.host = 'myhost'
    s.root = '/home/www/application'
    s.password = true
  end
   
  #deploy commands for production servers  
  deploy(:production) do
    
    #run commands locally
    local do
      run :changelog, to: :commits 
      #save output to commits which will be available in you commands via context.commits
      run :git_push
    end

	#run commands on server-1 and then server-2
    remotes('server-1', 'server-2') do
      run :git_pull
      run :bundler
      run :assets_precompile
      run :unicorn_upgrade
    end
	
	#then run commands on server-2 only
    remote('server-2') do
      run :delayed_job_restart
    end
    
    #at least run a command which use context.commits (this push a deployment
    notification to newrelic with changelog made from commits)
    local do
      run :newrelic
    end 
  end

end

```

Then in order to run just run at the same path where your kanaveral.rb is: 

	$ kanaveral -e production
or 

	$ bundle exec kanaveral -e production


**NOTES**

- **kanaveral command look for a file named kanaveral.rb at the path it is launched**

- *context* and *server* are ruby OpenStruct so, you are free to define what you need. But user, host, root and
password are reserved.

## Todo

- Some generic and often used commands included in gem which can be used for ie rails application deployment(bundler, git commands ...)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anoiaque/kanaveral. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

