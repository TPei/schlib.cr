[![Build Status](https://travis-ci.org/TPei/schlib.cr.svg?branch=master)](https://travis-ci.org/TPei/schlib.cr)
![](https://github.com/schasse/schlib/blob/master/logo/schlib_logo.png)

`schlib.cr` is a library with selected useful classes.

## Installation

Add to your shard.yml

```yaml
dependencies:
  schlib.cr:
    github: tpei/schlib.cr
    branch: master
```

and then install the library into your project with

```bash
$ crystal deps
```

## Usage

This shard consists of several helper classes. Require them and use them.

### Cache

Cache helps to cache long running computations or I/O. It acts similar
to Rails' cache and persists to a file. It is only possible to cache
simple data structures like Array, String, Integer, etc...
All cached data must work with JSON::Type

```crystal
require "schlib/cache"

def super_long_running_method
  sleep 10
  "wow, so long!"
end

def complicated_stuff
  c = Schlib::Cache.new("/tmp/my_cache_file.tmp")
  c.cache(:precise_pi) do
    super_long_running_method
  end
end

puts complicated_stuff # first call takes long time
puts complicated_stuff # successive calls are fast
```

### Command

Command is a wrapper around crystal's backticks and enables logging and
raising exceptions on bad exitcodes.

```crystal
require "logger"
require "schlib/command"

Schlib::Command.new.run("wtf", raise_errors: true)
# COMMAND FAILED! (ScriptError)
# 0x101806195: *CallStack::unwind:Array(Pointer(Void)) at ??
# 0x101806131: *CallStack#initialize:Array(Pointer(Void)) at ??
# 0x101806108: *CallStack::new:CallStack at ??
# 0x101805211: *raise<ScriptError>:NoReturn at ??
# 0x101872b06: *Schlib::Command#run<String, Bool>:String at ??
# 0x1017f2c72: __crystal_main at ??
# 0x101802b58: main at ??

logger = Logger.new(STDOUT)
Schlib::Command.new(logger).run "wtf????"
# --: wtf????: command not found
```

### Spinner

![spinner animation](https://github.com/schasse/schlib/raw/master/spinner.gif)

Have a long running command? Use spinner to entertain.

```crystal
require "schlib/spinner"

Schlib::Spinner.wait_for do
  sleep 2
  "well-rested"
end
# Loading ▇ ... done
#
# => "well-rested"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tpei/schlib.cr. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected
to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.


## License

The gem is available as open source under the terms of
the [MIT License](http://opensource.org/licenses/MIT).
