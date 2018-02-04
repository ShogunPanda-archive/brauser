#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

module Brauser
  module Definitions
    # A definition of a platform.
    #
    # @attribute [r] name
    #   @return [String] The platform name.
    # @attribute [r] engine_matcher
    #   @return [Regexp|Proc] The pattern or the block to recognize the engine.
    # @attribute [r] version_matcher
    #   @return [Regexp|Proc] The pattern or the block to recognize the version.
    class Browser < Base
      attr_reader :name, :engine_matcher, :version_matcher

      # Creates a new definition.
      #
      # @param id [Symbol] The platform id.
      # @param name [String] The platform name.
      # @param engine_matcher [Regexp|Proc] The pattern or the block to recognize the engine.
      # @param version_matcher [Regexp|Proc] The pattern or the block to recognize the version.
      def initialize(id, name, engine_matcher, version_matcher, **_)
        @id = id
        @name = name
        @engine_matcher = engine_matcher
        @version_matcher = version_matcher
      end

      # Matches against an header.
      #
      # @param header [String] The header to match
      # @return [Array|NilClass] An array with the engine and the version if match succeeded, `false` or `nil` otherwise.
      def match(header)
        # First of all, match the engine
        engine = perform_match(@engine_matcher, header) ? @id : nil

        if engine
          version = extract_version(perform_match(@version_matcher, header))
          platform = extract_platform(header, engine)
          [Brauser::Value.new(engine), Brauser::Value.new(version), Brauser::Value.new(platform)]
        end
      end

      private

      # :nodoc:
      def perform_match(pattern, subject)
        method = pattern.is_a?(Regexp) ? :match : :call
        pattern.send(method, subject)
      end

      # :nodoc:
      # @private
      def extract_version(version)
        # Adjust version
        version = "0.0" if version.blank?
        version = version.to_a.last if version.is_a?(::MatchData)
        Versionomy.parse(version)
      rescue
        version
      end

      # :nodoc:
      def extract_platform(header, engine)
        catch(:result) do
          Brauser::Definitions.platforms.each do |platform, definition|
            throw(:result, platform) if definition.match(header, engine)
          end

          nil
        end
      end
    end
  end
end
