require "spec"
require "../src/schlib/cache.cr"

describe Schlib::Cache do
  describe "#cache" do
    it "persists the value for a cache key" do
      c = Schlib::Cache.new
      le_hash = { "key" => "value", "another_key" => 10_i64 } of String => JSON::Type
      c.cache(:some_key) { le_hash }
      c.cache(:some_key) { "a" }.should eq le_hash
      c.clear
    end
  end

  describe "#clear" do
    context "with given cache key" do
      it "resets the value for a cache key" do
        c = Schlib::Cache.new
        c.cache(:some_key) { 10_i64 }
        c.cache(:some_key) { "a" }.should eq 10_i64
        c.cache(:some_other_key) { "a" }
        c.clear(:some_key)
        c.cache(:some_key) { "a" }.should eq "a"
        c.cache(:some_other_key) { "b" }.should eq "a"
        c.clear
      end
    end

    context "without given cache key" do
      it "deletes the cache file" do
        `mkdir folder`
        c = Schlib::Cache.new("folder/file.tmp")
        c.cache(:some_key) { 10_i64 }

        `ls folder`.should eq "file.tmp\n"

        c.clear

        `ls folder`.should eq ""
        `rmdir folder`
      end
    end
  end
end
