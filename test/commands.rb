module Kanaveral
  module Command
    class Bundler
      def instruction args={}
        "bundle --quiet --without development test"
      end
      
      def notice args={}
        "Run bundle"
      end
    end
  end
end

module Kanaveral
  module Command
    class AssetsPrecompile
      def instruction args={}
      end
    end
  end
end

module Kanaveral
  module Command
    class UnicornUpgrade
      def instruction args
      end
    end
  end
end


module Kanaveral
  module Command
    class Changelog
      def instruction args={}
        "git log origin/master..master --format=short"
      end
      
      def notice args={}
        "Create changelog from commits"
      end
    end
  end
end

module Kanaveral
  module Command
    class Newrelic
      def instruction args={}
        if context.commits.length > 0
          "echo '#{context.commits}' | newrelic deployments -c"
        else
          "echo helo > /dev/null"
        end
      end
    end
  end
end

module Kanaveral
  module Command
    class GitPush
      def instruction args={}
        "git push origin master"        
      end
      
      def notice args={}
        "Push to origin/master"
      end
    end
  end
end

module Kanaveral
  module Command
    class GitPull
      def instruction args={}
        "git pull origin master"        
      end
    end
  end
end

module Kanaveral
  module Command
    class Pwd
      def instruction args={}
        "pwd"
      end
    end
  end
end

module Kanaveral
  module Command
    class CdRoot
      def instruction args={}
        "cd #{server.root}"
      end
    end
  end
end

module Kanaveral
  module Command
    class DelayedJobRestart
      def instruction args={}
      end
    end
  end
end
