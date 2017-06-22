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
  # c = Schlib::Cache.new("/tmp/my_cache_file.tmp")
  #
  # def calc_pi(n)
  #   # this caclulation of pi may not be correct :D
  #   if n <= 1
  #     4.0
  #   elsif n.even?
  #     calc_pi(n - 1) + 4.0 / (n * 2 + 1)
  #   elsif n.odd?
  #     calc_pi(n - 1) - 4.0 / (n * 2 + 1)
  #   end
  # end
  #
  # def precise_pi
  #   c.cache(:precise_pi) do
  #     calc_pi 100_000_000_000
  #   end
  # end
  #
  # precise_pi # first call takes long time
  # precise_pi # successive calls are fast
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
