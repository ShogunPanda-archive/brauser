# brauser

[![Gem Version](https://badge.fury.io/rb/brauser.png)](http://badge.fury.io/rb/brauser)
[![Dependency Status](https://gemnasium.com/ShogunPanda/brauser.png?travis)](https://gemnasium.com/ShogunPanda/brauser)
[![Build Status](https://secure.travis-ci.org/ShogunPanda/brauser.png?branch=master)](http://travis-ci.org/ShogunPanda/brauser)
[![Code Climate](https://codeclimate.com/github/ShogunPanda/brauser.png)](https://codeclimate.com/github/ShogunPanda/brauser)

A framework agnostic browser detection and querying helper.

http://sw.cow.tc/brauser

http://rdoc.info/gems/brauser

## Description

Brauser is a framework agnostic helper that helps you in targeting your applications against most diffused browsers.

### Installation

Brauser comes with a Ruby on Rails hooks (more framework to follow), so for Rails you have just to add this to your Gemfile:

```ruby
gem "brauser"
```

Once done that, every controller in your application will have a `browser` method (also extended to views/layout via `helper_method`).

If you don't use Rails, you can instantiate a new browser by including the gem in your code and by doing something like this:

```ruby
browser = Brauser::Browser.new(USER_AGENT_HEADER, ACCEPT_LANGUAGE_HEADER)
```

where the first argument is the HTTP header `User-Agent`, and the second is the HTTP header `Accept-Language`.

For the rest of this document, let's assume you use Chrome 1.2.3 on Mac OS X.

### Getting browser information

Once you instantiate the browser, you can query the browser about `name`, `version` and `platform`. You can also get readable name and platforms via `readable_name` and `platform_name`.

The version is returned as a `String`, and you can use `Brauser::Browser.compare_versions` to compare against another version.

The name and the platform are returned as `Symbol` and can be in the range of names and engines registered via `register_browser`, `register_default_browsers`, `register_platform` and `register_default_platforms`.

Also, you can get global information using `browser.to_s` or `browser.classes`. This will return an array or a string already formatted to be used in your views to scope your CSS.

For example, if you do this in a ERB view:

```html
<body class="<%= browser.classes %>">
...
```

The view will get compiled to this:

```html
<body class="chrome version-1 version-1_2 version-1_2_3 platform-osx">
...
```

And thus scoping your CSS will be trivial.

### Querying the browser

Brauser supports querying about name (method `is`), version (method `v`), platform (method `on`) and language (method `accepts`).

The `is` method queries about a browser name (or a list of names) and optionally by version and platform:

```ruby
# We talk about the ending ? later.
browser.is?(:chrome)
# => true
browser.is?([:msie, :firefox])
# => false
browser.is?(:chrome, {:lt => "2"}, :osx)
# => true
browser.is?(:chrome, ">= 3", :windows)
# => false
```

The method `is` is the only which supports direct internal propagation to version and platform.

The `v` method queries about the browser version. You can specify the comparison with an hash or a little expression.

In the case of hash, the syntax is `{:operator => value}`, where `:operator` is one of `[:lt, :lte, :eq, :gte, :gt]` and value can be a Float or a String.

In the case of expression, the syntax is `OPERATOR VALUE && ..`, where `OPERATOR` is one of `["<", "<=", "=", "==", ">=", ">"]` and value specifies the version.

Examples:

```ruby
# Those two methods are equivalent.
browser.v?({:lt => "2", :gt => 1})
# => true
browser.is?("< 2 && > 1")
# => true
```

The method `on` check is the current browser in one of the specifed platform. The platform should be passed as `Symbol`.

```ruby
browser.on?(:osx)
# => true
browser.on?([:windows, :ios])
# => false
```

At the end, the method `accepts` checks if the browser accepts one of the specified languages. Languages should be passed as language codes in `String`.

```ruby
browser.accepts?("en")
# => true
browser.accepts?(["de", "es"])
# => false
```

Every query method exists in two forms: the concatenation one (the method name doesn't end with a `?`.

The former return a `Query` object, which supports the same query method of the browser and thus enables concatenation.

The latter return a boolean object, and it's equivalent to calling `result` on the query after concatenation.

Ideally, you should use the `?` version to end the query and fetch the result.

```ruby
# These expressions are equivalent.
browser.is?(:chrome, {:lt => "2"}, :osx)
browser.is(:chrome, {:lt => "2"}, :osx).result
browser.is(:chrome).v({:lt => "2"}).on?(:osx)
browser.is(:chrome).v({:lt => "2"}).on(:osx).result
```

Finally, Brauser support dynamic query operator to write simple queries without using concatenation.

You construct the method just using operator specified above, separating method name and method arguments with a `_` and different methods with a `__`.

For the version, use the expression form but use symbol operators and replace `.` with `_` and `&&` with `and`.

Example:

```ruby
# These expressions are equivalent.
browser.is(:chrome).v("< 2 && > 1.2").on(:osx).result
browser.is_chrome__v_lt_2_and_gt_1_2__on_osx.result

# These expressions are equivalent.
browser.is(:chrome).v("< 2 && > 1.2").on?(:osx)
browser.is_chrome__v_lt_2_and_gt_1_2__on_osx?
```

### Adding new browsers

To add new browsers, simply call `register_browser`.

This methods accepts a single entry or an array of entries in the following format: `[name, name_match, version_match, label]`:

* `name` is the name of the browser. Should be a `Symbol`.
* `name_match` is a `Regexp` to match against the user agent to detect the current browser.
* `version_match` is a `Regexp` which last capture group holds the version of the browser.
* `label` is the human readable name of the browser.

For example, for Google Chrome the call should be:

```ruby
browser.register_browser(:chrome, /((chrome)|(chromium))/i, /(.+Chrom[a-z]+\/)([a-z0-9.]+)/i, "Google Chrome")
```

### Adding new platforms

To add new platforms, simply call `register_platform`.

This method accepts a single entry or an array of entries in the following format: `[name, matcher, label]`:

* `name` is the name of the platform. Should be a `Symbol`.
* `matcher` is a `Regexp` to match against the user agent to detect the current platform.
* `label` is the human readable name of the platform.

For example, for Mac OS X the call should be:

```ruby
browser.register_platform(:osx, /mac|macintosh|mac os x/i, "Apple MacOS X")
```

### Adding new languages

To add new languages, simply call `register_language`.

This method accepts a single pair of code and label or an hash where keys are language code and values are labels.

For example, for Italian the call should be:

```ruby
browser.register_language("it", "Italian")
```

## Contributing to brauser
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (C) 2013 and above Shogun (shogun_panda@me.com).

Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
