require "spec"
require "../src/schlib.cr"

describe Schlib::Cache do
  describe "::VERSION" do
    Schlib::VERSION.should_not eq nil
    Schlib::VERSION.class.should eq String
  end
end
