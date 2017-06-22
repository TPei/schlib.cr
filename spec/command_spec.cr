require "spec"
require "../src/schlib/command"

describe Schlib::Command do
  describe "#run" do
    it "returns the output of the command" do
      Schlib::Command.new.run("ls src/").should eq "schlib\nschlib.cr\n"
    end

    it "raises an error if raising is enabled" do
      expect_raises(ScriptError) do
        Schlib::Command.new.run("wtf", raise_errors: true)
      end
    end

    it "logs command and output even when failing and raising" do
      logger = MyLogger.new(STDOUT)

      expect_raises(LoggerError) do
        Schlib::Command.new(logger).run("wtf", raise_errors: true)
      end
    end
  end
end

class MyLogger < Logger
  def debug(logline : String)
    raise LoggerError.new # couldn't find epect(obj).to receive(:debug)
  end
end

class LoggerError < Exception; end
