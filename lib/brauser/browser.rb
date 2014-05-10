# encoding: utf-8
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
  # @attribute languages
  #   @return [Array] The accepted languages.
  # @attribute name
  #   @return [String] The current browser name.
  # @attribute version
  #   @return [String] The current browser version.
  # @attribute platform
  #   @return [String] The current browser platform.
  class Browser
    attr_accessor :agent
    attr_accessor :accept_language
    attr_accessor :languages
    attr_accessor :name
    attr_accessor :version
    attr_accessor :platform

    # Aliases
    alias_attribute :ua, :agent

    include ::Brauser::Browseable::General
    include ::Brauser::Browseable::Attributes
    include ::Brauser::Browseable::DefaultDefinitions
    include ::Brauser::Browseable::Register
    include ::Brauser::Browseable::Parsing
    include ::Brauser::Browseable::PartialQuerying
    include ::Brauser::Browseable::Querying

    # Creates a new browser.
    #
    # @param agent [String] The User-Agent HTTP header.
    # @param accept_language [String] The Accept-Language HTTP header.
    def initialize(agent = "", accept_language = "")
      ::Brauser::Browser.add_default_browsers
      ::Brauser::Browser.add_default_platforms
      ::Brauser::Browser.add_default_languages

      @agent = agent
      @accept_language = accept_language

      @languages = parse_accept_language(@accept_language) if @accept_language
      parse_agent(@agent) if @agent
    end

    # Get the current browser version (if called without arguments) or checks if the browser is a specific version.
    #
    # @see #is_version
    # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against,
    #   in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
    # @return [String|Query] The browser version or a query which can evaluated for concatenation or result.
    def version(versions = nil)
      !versions ? @version : version_equals_to(versions)
    end

    # This method enables the use of dynamic queries in just one method.
    #
    # For example:
    #
    # ```ruby
    # browser.is_msie_v_gt_4_1_on_windows?
    # #=> true
    # ```
    #
    # If you don't provide a trailing `?`, you will get a Brauser::Query.
    #
    # If the syntax is invalid, a `NoMethodError` exception will be raised.
    #
    # @param query [String] The query to issue. Use `_` in place of `.` in the version.
    # @param arguments [Array] The arguments to pass the method. Unused from the query.
    # @param block [Proc] A block to pass to the method. Unused from the query.
    # @return [Boolean|Query|nil] A query or a boolean value (if `method` ends with `?`). If the query is not valid, `NoMethodError` will be raised.
    def method_missing(query, *arguments, &block)
      query_s = query.ensure_string
      rv = execute_query(parse_query(query_s)) || Brauser::Query.new(self, false)
      query_s =~ /\?$/ ? rv.result : rv
    rescue NoMethodError
      super(query, *arguments, &block)
    end

    private

    # Executes a parsed query
    #
    # @param query [Array] And array of `[method, arguments]` entries.
    # @return [Brauser::Query] The result of the query.
    def execute_query(query)
      query.reduce(Brauser::Query.new(self, true)) { |rv, call|
        break unless rv.result
        rv.send(call[0], *call[1])
      }
    end
  end
end
