# brauser

[![Gem Version](https://badge.fury.io/rb/brauser.png)](http://badge.fury.io/rb/brauser)
[![Dependency Status](https://gemnasium.com/ShogunPanda/brauser.png?travis)](https://gemnasium.com/ShogunPanda/brauser)
[![Build Status](https://secure.travis-ci.org/ShogunPanda/brauser.png?branch=master)](http://travis-ci.org/ShogunPanda/brauser)
[![Code Climate](https://codeclimate.com/github/ShogunPanda/brauser.png)](https://codeclimate.com/github/ShogunPanda/brauser)
[![Coverage Status](https://coveralls.io/repos/github/ShogunPanda/brauser/badge.svg?branch=master)](https://coveralls.io/github/ShogunPanda/brauser?branch=master)

A framework agnostic browser detection and querying helper.

https://sw.cowtech.it/brauser

## Description

Brauser is a framework agnostic helper that helps you in targeting your applications against most diffused browsers.

### Installation

Brauser comes with a Ruby on Rails hooks (more frameworks to follow), so for Rails you have just to add this to your Gemfile:

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

Once you instantiate the browser, you can query the browser about `name`, `version`, `platform`, `languages`.

You can also get readable name and platforms via `human_name`, `human_platform`, `human_languages`.

The version is handle via the [versionomy](http://dazuma.github.io/versionomy/) gem.

The name and the platform are returned as `Symbol` and can be in the range of names and engines registered via `Brauser::Definitions.register`.

The languages are returned as an hash where values are the priorities.

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

Brauser supports querying about name, version, platform, language.

Name and platform support querying via the `==` operator, which supports a single value or a list of values.

```ruby
# We'll talk about the ending "?" later.
browser.name == :chrome
# => true
browser.name == [:msie, :firefox]
# => false
```

The version is delegated to the versionomy gem. You can use comparison operator. The right hand part must be either a `String` or a `Versionomy::Value`.

```ruby
browser.version == "3"
# => false
browser.version >= "2"
# => true
```

The language support querying via the `accepts?` method, which supports a single value or a list of values.

```ruby
browser.accepts?(:it)
# => true
browser.accepts?(:it, :en)
# => true
```

All the querying can be combined in the single method `is?`:

```ruby
browser.is?(name: :chrome, version: ">= 4", platform: [:osx, :windows], languages: :it)
# => false
```

Name, platform and languages can be either symbols or array of symbols. Version must be a query in the form is `OPERATOR VALUE && ..`,
where `OPERATOR` is one of `["<", "<=", "=", "==", ">=", ">"]` and value specifies the version.

### Prevent old browsers to access the Rails application.

If you want to easily prevent a legacy browser to open your application, create a file `supported-browsers.yml` in the `config` folder with a similar content:

```yaml
---
chrome: 29
firefox: 28
safari: 6.1
msie: 11
```

then create a filter in the `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  # ...

  before_filter do
    redirect_to(URL) unless browser.supported?(Rails.root + "config/supported-browsers.yml")
  end

  # ...
end
```

and you are set.

### Adding new browsers, platform and languages.

To add new browsers, simply call `::Brauser::Definitions.register(:browser, :id, ...)`.

The first argument can be `:browser`, `:platform` or `:language`.
The second argument is the id of the definition.
The remaining argument will be passed to the definition constructor.

For example, for Google Chrome the call should be:

```ruby
Brauser::Definitions.register(:browsers, :chrome, "Chrome", /((chrome)|(chromium))/i, /(.+Chrom[a-z]+\/)([a-z0-9.]+)/i)
```

## API Documentation

The API documentation can be found [here](https://sw.cowtech.it/brauser/docs).

## Contributing to brauser

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (C) 2013 and above Shogun (shogun@cowtech.it).

Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/ShogunPanda/brauser/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

