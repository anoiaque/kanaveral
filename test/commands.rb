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
    class Assets
      def instruction args={}
      end
    end
  end
end

module Kanaveral
  module Command
    class Unicorn
      def instruction args
      end
    end
  end
end


module Kanaveral
  module Command
    class Changelog
      def instruction args={}
        "pwd"
      end
    end
  end
end

module Kanaveral
  module Command
    class Newrelic
      def instruction args={}
                
      end
    end
  end
end

module Kanaveral
  module Command
    class Git
      def instruction args={}
        "git #{args} origin master"        
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
    class DelayedJob
      def instruction args={}
      end
    end
  end
end
