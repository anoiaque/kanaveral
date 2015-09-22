module Kanaveral
  module Command
    class Bundler
      def instruction args={}
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
    end
  end
end

module Kanaveral
  module Command
    class Newrelic
      def instruction args={}
        p context.commits
        "echo Hello #{context.commits}"
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
        "cd #{server.root} && ls -la"
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
