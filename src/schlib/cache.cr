require "json"

module Schlib
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
