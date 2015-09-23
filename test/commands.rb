module Kanaveral
  module Command
    
    class Bundler
      def instruction args={}
        "bundle --quiet --without development test"
      end
      
      def notice
        "Run bundle"
      end
    end
    
    class AssetsPrecompile
      def instruction args={}
      end
    end
    
    class UnicornUpgrade
      def instruction args
      end
    end
    
    class Changelog
      def instruction args={}
        "git log origin/master..master --format=short"
      end
      
      def notice
        "Create changelog from commits"
      end
    end
    
    class Newrelic
      def instruction args={}
        if context.commits.length > 0
          "echo '#{context.commits}' | newrelic deployments -c"
        else
          "echo helo > /dev/null"
        end
      end
    end
    
    class GitPush
      def instruction
        "git push origin master"        
      end
      
      def notice
        "Push to origin/master"
      end
    end
    
    class GitPull
      def instruction args={}
        "git pull origin master"        
      end
    end
    
    class Setup
      def instruction args={}
        "cd #{server.root}"
      end
    end
    
    class DelayedJobRestart
      def instruction args={}
      end
    end
    
  end
end
