require "kanaveral/version"
require 'ostruct'
require 'net/ssh'
require 'rainbow'
require 'io/console'
require 'kanaveral/extensions'
require 'kanaveral/output'

module Kanaveral
  using Kanaveral::Extensions
  
  class Server
    attr_accessor :user, :host, :root, :name, :password
    
    def initialize name=nil
      @name = name
    end
  end
  
  class Deploy
    attr_accessor :local_commands, :remote_commands
    
    def initialize context
      @context = context
    end
    
    def local &block
      instance_eval(&block)
    end
    
    def remotes *names, &block
      names.each do |name|
        remote(name, &block)
      end
    end
    
    def remote name, &block
      Kanaveral::Output.deploy(name)
      
      @server = @context.servers[name]
      password = Kanaveral::Output.password(@server.name) if @server.password
      args = [@server.host, @server.user]
      args << { password: password } if password
      
      Net::SSH.start(*args) do |ssh|
        @ssh = ssh
        instance_eval(&block)
      end
      
      @ssh = nil
      @server = nil
    end
    
    def run command, args={}
      cmd = cmd(command).new
      cmd.server = @server
      cmd.context = @context
      cmd.name = command
      
      Kanaveral::Output.command(cmd, args)
      
      output = @ssh ? @ssh.exec!(cmd.instruction(args)) : `#{cmd.instruction(args)}`

      @context.send("#{args[:to]}=", output) if args[:to]

      Kanaveral::Output.cmd_output(output) if @context.output
      output
    end
    
    private
    
    def cmd command
      cmd = Object.const_get %(Kanaveral::Command::#{command.to_s.camelize})
      cmd.send(:attr_accessor, :server)
      cmd.send(:attr_accessor, :name)
      cmd.send(:attr_accessor, :context)
      cmd
    end
  end
  
  class Context < OpenStruct;end
  
  class Base 
    ENV_KEY = 'KANAVERAL_ENV'
    
    def server name
      @servers ||= {}
      server = Server.new(name)
      yield server
      @servers[name] = server
    end
    
    def deploy env=:development, &block
      env_help()
      
      return unless ENV[ENV_KEY] == env.to_s 
      
      @context = Context.new(servers: @servers)
      @deployer = Deploy.new(@context)
      @deployer.instance_eval(&block)
    end
  
    def self.deployer &block
      self.new.instance_eval(&block)
    end
    
    private
    
    def env_help
      Kanaveral::Output.warn("Current environment : #{ENV[ENV_KEY] || 'Not set via KANAVERAL_ENV'}")
      unless ENV[ENV_KEY]
        Kanaveral::Output.warn("Pass Kanaveral environment as shell variable, ie KANAVERAL_ENV=production bundle exec ...")
      end
    end
  end
end
