require "kanaveral/version"
require 'ostruct'
require 'net/ssh'
require 'kanaveral/extensions'

module Kanaveral
  using Kanaveral::Extensions
  
  class Server
    attr_accessor :user, :host, :root, :name
    
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
      @server = @context.servers[name]
      
      Net::SSH.start(@server.host, @server.user, password:nil) do |ssh|
        @ssh = ssh
        instance_eval(&block)
      end
      
      @ssh = nil
      @server = nil
    end
    
    def run command, args={}
      cmd(command).send(:attr_accessor, :server)
      cmd = cmd(command).new
      cmd.server = @server
      @ssh ? @ssh.exec!(cmd.instruction(args)) : cmd.instruction(args)
    end
    
    private
    
    def cmd command
      Object.const_get %(Kanaveral::Command::#{command.to_s.camelize})
    end
  end
  
  class Context < OpenStruct;end
  
  class Base 
    
    def server name
      @servers ||= {}
      server = Server.new(name)
      yield server
      @servers[name] = server
    end
    
    def deploy &block
      @context = Context.new(servers: @servers)
      @deployer = Deploy.new(@context)
      @deployer.instance_eval(&block)
    end
  
    def self.deployer &block
      self.new.instance_eval(&block)
    end
  end
end
