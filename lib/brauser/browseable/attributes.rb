# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # Methods to handle attributes.
    module Attributes
      # Gets a human-readable browser name.
      #
      # @return [String] A human-readable browser name.
      def readable_name
        parse_agent(@agent) unless @name
        ::Brauser::Browser.browsers.fetch(@name).label
      rescue KeyError
        "Unknown Browser"
      end

      # Gets a human-readable platform name.
      #
      # @return [String] A readable platform name.
      def platform_name
        parse_agent(@agent) unless @platform
        ::Brauser::Browser.platforms[@platform].try(:label) || "Unknown Platform"
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
      # @param block [Proc] A block to translate browser name.
      # @return [String|Array] CSS ready information of the current browser.
      def classes(join = " ", name = "", version = "version-", platform = "platform-", &block)
        platform = "platform-" if platform.is_a?(TrueClass)
        rv = [stringify_name(name, &block), stringify_version(version), !platform ? nil : (platform + @platform.to_s)].compact.flatten
        join ? rv.join(join) : rv
      end
      alias_method :meta, :classes
      alias_method :to_s, :classes

      private

      # Stringifies a browser name(s).
      #
      # @param name [Boolean] If non falsy, the string to prepend to the name. If falsy, the name information will not be included.
      # @param block [Proc] A block to translate browser name.
      # @return [String|Array|nil] The browser name(s) or `nil`, if it was set to be skipped.
      def stringify_name(name, &block)
        if name
          name, block = prepare_name_stringification(name, block)
          names = block.call(@name, @version, @platform).ensure_array { |n| "#{name}#{n}" }
          names.length > 1 ? names : names.first
        else
          nil
        end
      end

      # Prepare a name stringification
      #
      # @param name [Boolean] If non falsy, the string to prepend to the name. If falsy, the name information will not be included.
      # @param block [Proc] A block to translate browser name.
      # @return [Array] A name and a translator ready to use.
      def prepare_name_stringification(name, block)
        parse_agent(@agent) unless @name
        [(name.is_a?(TrueClass) ? "" : name), block || proc { |n, *| n == :msie_compatibility ? [:msie_compatibility, :msie] : n }]
      end

      # Stringifies a browser version.
      #
      # @param version [String|NilClass] If non falsy, the string to prepend to the version. If falsy, the version information will not be included.
      # @return [Array] The version strings or `nil`, if it was set to be skipped.
      def stringify_version(version)
        version = "version-" if version.is_a?(TrueClass)
        tokens = @version.split(".")

        !version ? nil : tokens.reduce([version + tokens.shift]) {|prev, current|
          prev + [prev.last + "_" + current]
        }.flatten
      end
    end
  end
end
