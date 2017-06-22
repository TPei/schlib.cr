module Schlib
  # Have a long running command? Use spinner to entertain.
  #
  # ```crystal
  # require "schlib/spinner"
  #
  # Schlib::Spinner.wait_for do
  #   sleep 2
  #   "well-rested"
  # end
  # # Loading ▇ ... done
  #
  # # => "well-rested"
  # ```
  class Spinner
    def initialize
      @finished = false
    end

    # shows a spinner while executing the block
    # return the block return value
    def self.wait_for
      self.new.wait_for { yield }
    end

    # always create a new instance for every spinner
    # best to use `Schlib::Spinner.wait_for`
    def wait_for
      create_spinner_fiber
      value = yield
      @finished = true
      value
    end

    private def create_spinner_fiber
      spawn do
        until @finished
          i = 0
          frames = %w(▁ ▃ ▅ ▆ ▇ █ ▇ ▆ ▅ ▃)
          loop do
            frame = frames[i % frames.size]
            print "\rLoading #{frame} ... "
            sleep 0.1
            i += 1
          end
        end
      end
    end
  end
end
