module Kanaveral
  module Output
    
    def self.password remote
      ask "Password for #{remote} : "
      password = STDIN.noecho(&:gets).chop
      cr
      password
    end
    
    def self.cmd_output text
      text ||= ''
      cr
      print Rainbow(text).cyan
      cr
    end
    
    def self.ask text
      cr
      print Rainbow(text).green
    end
    
    def self.command text
      cr
      text = '-> ' + text
      notice(text)
    end
    
    def self.deploy name
      cr
      title = " Deploy to #{name} "
      banner '-'*(title.length + 1)
      banner title
      banner '-'*(title.length + 1)
    end
    
    def self.banner text
      puts Rainbow(text).cyan
    end
    
    def self.notice text
      puts Rainbow(text).white
    end
    
    def self.warn text
      puts Rainbow(text).yellow.bright.underline
    end
    
    def self.cr
      puts "\n"
    end
  end
end