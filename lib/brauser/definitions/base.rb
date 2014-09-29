#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # Definitions used by brauser.
  module Definitions
    # Registers a new definition.
    #
    # @param type [Symbol] The type of the definition. Can be `:browser`, `:language`, `:platform`.
    # @param args [Array] The arguments of the definition.
    # @param kwargs [Hash] The keyword arguments of the definition.
    # @param block [Proc] The block of the definition.
    def self.register(type, *args, **kwargs, &block)
      klass =
        case type
        when :browser then Brauser::Definitions::Browser
        when :language then Brauser::Definitions::Language
        when :platform then Brauser::Definitions::Platform
        else raise(ArgumentError, "Invalid definition type \"#{type}\".")
        end

      @definitions ||= {browsers: {}, languages: {}, platforms: {}}
      definition = klass.new(*args, **kwargs, &block)
      @definitions["#{type}s".to_sym][definition.id] = definition
    end

    # Returns the list of browser that can be recognized.
    #
    # The keys are the ids, the values are the definitions.
    #
    # @return [Hash] The list of browser that can be recognized.
    def self.browsers
      @definitions[:browsers]
    end

    # Returns the list of platforms that can be recognized.
    #
    # The keys are the ids, the values are the definitions.
    #
    # @return [Hash] The list of platform that can be recognized.
    def self.platforms
      @definitions[:platforms]
    end

    # Returns the list of languages that can be recognized.
    #
    # The keys are the ids, the values are the definitions.
    #
    # @return [Hash] The list of languages that can be recognized.
    def self.languages
      @definitions[:languages]
    end

    # A class which hold a definition of a browser, a platform or a language.
    #
    # @attribute [r] id
    #   @return The id of the definition.
    class Base
      attr_reader :id

      # Performs a match of this definition.
      #
      # @return [Object|NilClass] A non falsy value if match succeeded, `false` or `nil` otherwise.
      def match(_, *_, **_)
        raise "Must be overridden by a subclass."
      end
    end
  end
end
