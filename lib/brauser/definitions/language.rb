#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  module Definitions
    # A definition of a language.
    #
    # @attribute [r] code
    #   @return [String] The language code.
    # @attribute [r] name
    #   @return [String] The language name.
    class Language < Base
      attr_reader :code, :name

      # Creates a new definition.
      #
      # @param code [String] The language code.
      # @param name [String] The language name.
      def initialize(code, name, **_)
        code = code.downcase.gsub("_", "-")
        @id = code.to_sym
        @code = code
        @name = name
      end
    end
  end
end
