module Schlib
  # Executes a command on the shell and returns the output
  # Optionally, provide your custom logger to logg executions
  # ```
  # Executes a command on the shell and returns the output
  # class MyLogger < Logger
  #   def debug(logline : String)
  #     puts logline
  #   end
  # end
  #
  # Schlib::Command.new(MyLogger.new).run("git flog")
  # ```
  # you can also signify that you want an error to be raised if your command execution failes
  # Schlib::Command.new.run("git flog", raise_errors: true)
  #
  # ```
  class Command
    def initialize(@logger : (Logger | Nil) = nil)
    end

    def run(command, raise_errors = false)
      @logger.as(Logger).debug(command) if @logger
      output = Process.run `#{command}`
      status = $?
      if raise_errors && !status.success?
        raise ScriptError.new "COMMAND FAILED!"
      end
      @logger.as(Logger).debug(output) if @logger
      output
    end
  end
end

abstract class Logger
  abstract def debug(logline : String)
end

class ScriptError < Exception; end
