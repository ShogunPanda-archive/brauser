#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  module Definitions
    # A definition of a platform.
    #
    # @attribute [r] name
    #   @return [String] The platform name.
    # @attribute [r] matcher
    #   @return [Regexp|Proc] The pattern or the block to recognize the platform.
    class Platform < Base
      attr_reader :name, :matcher

      # Creates a new definition.
      #
      # @param id [Symbol] The platform id.
      # @param name [String] The platform name.
      # @param matcher [Regexp|Proc] The pattern or the block to recognize the platform. **Ignore if a block is given**
      def initialize(id, name, matcher = /.*/, **_, &block)
        @id = id
        @name = name
        @matcher = block ? block : matcher
      end

      # Matches against an header.
      #
      # @param header [String] The header to match.
      # @param engine [Symbol] The engine to match.
      # @return [Boolean|NilClass] True if match succeeded, `false` or `nil` otherwise.
      def match(header, engine)
        if @matcher.is_a?(Regexp)
          @matcher.match(header)
        else
          @matcher.call(header, engine)
        end
      end
    end
  end
end
