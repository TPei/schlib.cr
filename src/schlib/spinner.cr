module Schlib
  class Spinner
    def initialize
      @finished = false
    end

    def self.wait_for(&block)
      # TODO: fix -> returns Nil
      self.new.wait_for &block
    end

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
