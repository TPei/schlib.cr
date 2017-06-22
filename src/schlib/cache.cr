require "json"

module Schlib
  # Cache helps to cache long running computations or I/O. It acts similar
  # to Rails' cache and persists to a file. It is only possible to cache
  # simple data structures like Array, String, Integer, etc...
  # All cached data must work with JSON::Type
  #
  # ```crystal
  # require "schlib/cache"
  #
  # def super_long_running_method
  #   sleep 10
  #   "wow, so long!"
  # end
  #
  # def complicated_stuff
  #   c = Schlib::Cache.new("/tmp/my_cache_file.tmp")
  #   c.cache(:precise_pi) do
  #     super_long_running_method
  #   end
  # end
  #
  # puts complicated_stuff # first call takes long time
  # puts complicated_stuff # successive calls are fast
  # ```
  class Cache
    def initialize(@cache_file = "/tmp/schlib_cache_file.tmp")
    end

    def cache(cache_key : (String | Symbol))
      mutable_cache_data = data
      value = mutable_cache_data[cache_key.to_s] ||= yield.as(JSON::Type)
      File.write cache_file, mutable_cache_data.to_json
      value
    end

    def clear(cache_key : (String | Symbol))
      mutable_cache_data = data
      mutable_cache_data[cache_key.to_s] = nil
      File.write cache_file, mutable_cache_data.to_json
    end

    def clear
      File.delete cache_file
    end

    private getter cache_file

    private def data
      unless File.exists? cache_file
        File.write cache_file, {} of String => JSON::Type
      end
      JSON.parse_raw(File.read(cache_file)).as(Hash)
    end
  end
end
