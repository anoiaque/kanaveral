require "kanaveral/version"
require 'ostruct'
require 'net/ssh'
require 'rainbow'
require 'io/console'
require 'kanaveral/extensions'
require 'kanaveral/output'

module Kanaveral
  using Kanaveral::Extensions
  
  class MissingCommand < Exception
    def initialize(command)
      @command = command
    end
    
    def message
      "Missing command : #{@command}"
    end
  end
  
  class Command < OpenStruct
    @@commands = {}
    
    def self.load path
      class_eval(File.read(path))
      @@commands
    end
    
    def self.command tag, &block
      cmd = new
      cmd.instance_eval(&block)
      cmd.tag = tag
      cmd.msg ||= -> { "Run #{cmd.tag}" }
      
      @@commands[tag] = cmd
    end
    
    def command cmd
      self.cmd = cmd
    end
    
    def notice msg
      self.msg = msg
    end
    
  end
  
  class Server < OpenStruct;end
  
  class Deploy
    attr_accessor :local_commands, :remote_commands
    
    def initialize context
      @context = context
      @commands = @context.commands
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
      cmd = @commands[command]
      raise MissingCommand.new(command) unless cmd
      
      cmd.context = @context
      cmd.context.server = @server
      
      
      Kanaveral::Output.command(kall(cmd.msg))

      output = @ssh ? @ssh.exec!(kall(cmd.cmd)) : `#{kall(cmd.cmd)}`

      @context.send("#{args[:to]}=", output) if args[:to]

      Kanaveral::Output.cmd_output(output) unless @context.nooutput
      output
    end
    
    private
    
    def kall callee
      callee.arity == 0 ? callee.call : callee.call(@context)
    end
    
  end
  
  class Context < OpenStruct;end
  
  class Base 
    ENV_KEY = 'KANAVERAL_ENV'
    
    def server name
      @servers ||= {}
      server = Server.new
      server.name = name
      yield server
      @servers[name] = server
    end
    
    def deploy env=:development, &block
      env_help()
      
      return unless ENV[ENV_KEY] == env.to_s 

      @context = Context.new(servers: @servers, commands: @commands)
      @deployer = Deploy.new(@context)
      @deployer.instance_eval(&block)
    end
    
    def commands path
      @commands = Command.load(path)
    end
  
    def self.deployer &block
      self.new.instance_eval(&block)
    end
    
    private
    
    def env_help
      Kanaveral::Output.warn("Environment : #{ENV[ENV_KEY] || 'Not set via KANAVERAL_ENV'}")
      unless ENV[ENV_KEY]
        Kanaveral::Output.warn("Pass Kanaveral environment as shell variable, ie KANAVERAL_ENV=production bundle exec ...")
      end
    end
  end
end
