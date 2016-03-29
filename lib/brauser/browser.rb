#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

# A framework agnostic browser detection and querying helper.
module Brauser
  # This class represents a detection of the current user browser.
  #
  # @attribute agent
  #   @return [String] The raw User-Agent HTTP header.
  # @attribute accept_language
  #   @return [String] The raw Accept-Language HTTP header.
  # @attribute [r] name
  #   @return [Symbol] The current browser name.
  # @attribute [r] human_name
  #   @return [String] The human-readable current browser name.
  # @attribute [r] version
  #   @return [Versionomy::Value] The current browser version.
  # @attribute [r] platform
  #   @return [Symbol] The current browser platform.
  # @attribute [r] human_platform
  #   @return [String] The human-readable current browser platform.
  # @attribute [r] languages
  #   @return [Hash] The accepted languages.
  # @attribute [r] human_languages
  #   @return [Hash] The human-readable list of accepted languages.
  class Browser
    attr_accessor :agent, :accept_language
    attr_reader :name, :human_name, :version, :platform, :human_platform, :languages, :human_languages
    alias_attribute :ua, :agent

    # Creates a new browser.
    #
    # @param agent [String] The User-Agent HTTP header.
    # @param accept_language [String] The Accept-Language HTTP header.
    def initialize(agent = "", accept_language = "")
      @agent = agent
      @accept_language = accept_language
      parse
    end

    # Returns an array of information about the browser. Information are strings which are suitable to use as CSS classes.
    #
    # For version, it will be included a class for every token of the version. For example, version `7.0.1.2` will return this:
    #
    # ```ruby
    # ["version-7", "version-7_0", "version-7_0_1", "version-7_0_1_2"]
    # ```
    #
    # If you provide a block (with accepts name, version and platform as arguments), it will be used for translating the name.
    #
    # @param join [String|NilClass] If non falsy, the separator to use to join information. If falsy, informations will be returned as array.
    # @param name [Boolean] If non falsy, the string to prepend to the name. If falsy, the name information will not be included.
    # @param version [String|NilClass] If non falsy, the string to prepend to the version. If falsy, the version information will not be included.
    # @param platform [String|NilClass] If non falsy, the string to prepend to the platform. If falsy, the platform information will not be included.
    # @return [String|Array] CSS ready information of the current browser.
    def classes(join = " ", name: true, version: true, platform: true)
      rv = [name_to_str(name), version_to_str(version), platform_to_str(platform)].compact.uniq.flatten
      join ? rv.join(join) : rv
    end
    alias_method :meta, :classes
    alias_method :to_s, :classes

    # Checks if the browser accepts a specific language or languages.
    #
    # @param languages [Array] The list of languages.
    # @return [Boolean] `true` if at least one of requested languages is accepted, `false` otherwise.
    def accepts?(*languages)
      languages = normalize_query_arguments(languages)
      (@languages.keys & languages).present?
    end

    # Checks if the browser matches a specific query.
    #
    # @param name [Symbol|Array|NilClass] The list of names to check. Also, this meta-name is supported: `:tablet`.
    # @param engine [Symbol|Array|NilClass] Alias for `name`, **which has precedence over this.**
    # @param version [String|NilClass] The query to match the version.
    #   It must be a query in the form is `OPERATOR VALUE && ..`, where `OPERATOR` is one of `["<", "<=", "=", "==", ">=", ">"]`.
    #   You can also pass the value "capable", which will return true for Webkit browsers, IE 10 or above, Firefox 28 and above and Opera 15 and above.
    # @param platform [Symbol|Array|NilClass] The list of platforms to check.
    # @param languages [Symbol|Array|NilClass] The list of languages to check.
    # @return [Boolean] `true` if browser match the query, `false` otherwise.
    def is?(name: nil, engine: nil, version: nil, platform: nil, languages: nil)
      name ||= engine
      rv = name ? (@name == apply_aliases(normalize_query_arguments(name))) : true
      rv &&= query_version(version) if version
      rv &&= @platform == normalize_query_arguments(platform) if platform
      rv &&= accepts?(normalize_query_arguments(languages)) if languages
      rv
    end

    # Check if the browser is supported.
    #
    # @param browsers [Hash|String] A map of name and minimum supported major version, or a path to YAML file containing the map.
    # @return [Boolean] `true` if current browser is supported, `false` otherwise. If the name is not found in the map, `false` is returned.
    def supported?(browsers = {})
      browsers = YAML.load_file(browsers.to_s).symbolize_keys unless browsers.is_a?(Hash)
      minimum_version = browsers.with_indifferent_access[name.value]
      minimum_version ? is?(version: ">= #{minimum_version}") : false
    end

    # Check if the browser is a specific one
    #
    # @param method The browser engine to check.
    # @param args [Array] **unused.**
    # @param block [Proc] **unused.**
    # @return [Boolean] `true` if browser match the engine, `false` otherwise.
    def method_missing(method, *args, &block)
      method.to_s =~ /(.+)\?$/ ? is?(name: Regexp.last_match[1]) : super(method, *args, &block)
    end

    private

    # :nodoc:
    VERSION_TOKEN = /(?<operator>>=|<=|<|>|!=|(={1,2}))\s*(?<version>.+)/

    # :nodoc:
    def parse
      parser = Brauser::Parser.new
      parse_agent(parser)
      parse_languages(parser)
    end

    # :nodoc:
    def parse_agent(parser)
      agent = parser.parse_agent(@agent)

      if agent
        @name, @version, @platform = *agent
        @human_name = Brauser::Definitions.browsers[@name].try(:name) || "Unknown Browser"
        @human_platform = Brauser::Definitions.platforms[@platform].try(:name) || "Unknown Platform"
      else
        sanitize_agent
      end
    end

    # :nodoc:
    def sanitize_agent
      @name = @platform = Brauser::Value.new(:unknown)
      @human_name = @human_platform = Brauser::Value.new("Unknown")
      @version = Brauser::Value.new(Versionomy.parse("0.0"))
    end

    # :nodoc:
    def parse_languages(parser)
      languages = parser.parse_accept_language(@accept_language)
      @languages = languages
      @human_languages = languages.reduce({}) do |rv, (code, priority)|
        rv[Brauser::Definitions.languages[code].name] = priority
        rv
      end
    end

    # :nodoc:
    def name_to_str(name)
      if name
        name = "" if name.is_a?(TrueClass)
        rv = @name
        rv = [:msie_compatibility, :msie] if rv == :msie_compatibility
        rv.ensure_array(no_duplicates: true) { |n| "#{name}#{n}" }
      end
    end

    # :nodoc:
    def version_to_str(version)
      if version
        version = "version-" if version.is_a?(TrueClass)
        version_str = @version.values_array.reduce([]) do |rv, current|
          rv << [rv.last, current].compact.join("_")
          rv
        end

        version_str.map { |v| "#{version}#{v}" }
      end
    end

    # :nodoc:
    def platform_to_str(platform)
      return nil unless platform
      platform = "platform-" if platform.is_a?(TrueClass)
      "#{platform}#{@platform}"
    end

    # :nodoc:
    def normalize_query_arguments(arguments)
      sanitizer = ->(a) { a.ensure_string.downcase.gsub("_", "-").to_sym }
      arguments ? arguments.ensure_array(no_duplicates: true, compact: true, flatten: true, &sanitizer) : nil
    end

    # :nodoc:
    def apply_aliases(names)
      names << [:msie, :msie_compatibility] if (names & [:ie, :msie]).present?
      names << [:chromium] if names.include?(:chrome)
      names << [:ipad, :android, :kindle] if names.include?(:tablet)
      names.flatten.compact.uniq
    end

    # :nodoc:
    def query_version(version)
      version.ensure_string.strip.parameterize.to_sym == :capable ? check_capable_browser : check_version(version)
    end

    # :nodoc:
    def check_version(version)
      parser = StringScanner.new(version)
      rv = true

      until parser.eos?
        token = parser.scan_until(/(?=&&)|\Z/)
        parser.skip_until(/&&|\Z/)
        operator, version = parse_version_token(token)

        rv &&= @version.send(operator, Versionomy.parse(version))
        break unless rv
      end

      rv
    end

    # :nodoc:
    def check_capable_browser
      check_capable_browser_engines || check_capable_browser_recents
    end

    # :nodoc:
    def check_capable_browser_engines
      chrome? || safari? || check_capable_browser_recents
    end

    # :nodoc:
    def check_capable_browser_recents
      (firefox? && @version >= "28") || (msie? && @version >= "10") || (opera? && @version >= "15")
    end

    # :nodoc:
    def parse_version_token(token)
      mo = VERSION_TOKEN.match(token)
      raise ArgumentError, "Invalid version check: #{token}." unless mo
      [mo["operator"], mo["version"]].map(&:strip)
    end
  end
end
