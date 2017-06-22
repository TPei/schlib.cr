[![Build Status](https://travis-ci.org/TPei/schlib.cr.svg?branch=master)](https://travis-ci.org/TPei/schlib.cr)
![](https://github.com/schasse/schlib/blob/master/logo/schlib_logo.png)

`schlib.cr` is a library with selected useful classes.

## Installation

Add to your shard.yml

```yaml
dependencies:
  circuit_breaker:
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

c = Schlib::Cache.new("/tmp/my_cache_file.tmp")

def calc_pi(n)
  # this caclulation of pi may not be correct :D
  if n <= 1
    4.0
  elsif n.even?
    calc_pi(n - 1) + 4.0 / (n * 2 + 1)
  elsif n.odd?
    calc_pi(n - 1) - 4.0 / (n * 2 + 1)
  end
end

def precise_pi
  c.cache(:precise_pi) do
    calc_pi 100_000_000_000
  end
end

precise_pi # first call takes long time
precise_pi # successive calls are fast
```

### Command

Command is a wrapper around crystal's backticks and enables logging and
raising exceptions on bad exitcodes.

```crystal
require "logger"
require "schlib/command"

c0 = Schlib::Command.new
c0.run "wtf", raise_error: true
# ScriptError: COMMAND FAILED!

logger = Logger.new(STDOUT)
Command.new(logger).run "wtf????"
# D, [2017-01-28T11:51:08.387088 #29538] DEBUG -- : wtf???
# D, [2017-01-28T11:51:08.388694 #29538] DEBUG -- : sh: 1: wtf???: not found
#
# => "sh: 1: wtf???: not found\n"
```

### Spinner

![spinner animation](https://github.com/schasse/schlib/raw/master/spinner.gif)

Have a long running command? Use spinner to entertain.

```crystal
require "schlib/spinner"

Schlib::Spinner.new.wait_for do # .new is important atm!!
  sleep 2
  return 'well-rested'
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
