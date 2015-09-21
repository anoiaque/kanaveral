module Kanaveral
  module Command
    class Bundler
      def instruction args={}
        p "Run bundler #{args}"
      end
    end
  end
end

module Kanaveral
  module Command
    class Assets
      def instruction args={}
        p "Run assets #{args} on #{server.name}"
      end
    end
  end
end

module Kanaveral
  module Command
    class Unicorn
      def instruction args
        p "Run Unicorn #{args} on #{server.name}"
      end
    end
  end
end


module Kanaveral
  module Command
    class Changelog
      def instruction args={}
        p "Run Changelog #{args}"
        
      end
    end
  end
end

module Kanaveral
  module Command
    class Newrelic
      def instruction args={}
        p "Run Newrelic #{args}"
        
      end
    end
  end
end

module Kanaveral
  module Command
    class Git
      def instruction args={}
        p "Run Git #{args} on #{server.name if server}"
        
      end
    end
  end
end

module Kanaveral
  module Command
    class Pwd
      def instruction args={}
        p "Run Pwd #{args} on #{server.name}"
        
        "cd #{server.root} && ls -la"
      end
    end
  end
end

module Kanaveral
  module Command
    class DelayedJob
      def instruction args={}
        p "Run DelayedJob #{args} on #{server.name}"
      end
    end
  end
end
