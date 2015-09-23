module Kanaveral
  module Command
    
    class Bundler
      def instruction
        ". ~/.profile && cd #{server.root} && bundle --quiet --without development test"
      end
      
      def notice
        "Run bundle"
      end
    end
    
    class AssetsPrecompile
      def instruction
        "echo precompile assets"
      end
    end
    
    class UnicornUpgrade
      def instruction
        "echo upgrade unicron"
      end
    end
    
    class Changelog
      def instruction
        "git log origin/master..master --format=short"
      end
      
      def notice
        "Create changelog from commits"
      end
    end
    
    class Newrelic
      def instruction
        "echo '#{context.commits}' | newrelic deployments -c"
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
      def instruction
        "git pull origin master"        
      end
      
      def notice
        "Pull from origin/master"
      end
    end
    
    class DelayedJobRestart
      def instruction
        "echo DelayedJobRestart"
      end
    end
    
  end
end
