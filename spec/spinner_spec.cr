require "spec"
require "../src/schlib/spinner"

describe Schlib::Spinner do
  describe "#wait_for" do
    it "returns the result of the block" do
      Schlib::Spinner.new.wait_for { 1 }.should eq 1
    end
  end

  describe ".wait_for" do
    it "returns the result of the block" do
      Schlib::Spinner.wait_for { 1 }.should eq 1
    end
  end
end
