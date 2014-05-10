# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # A query to a browser. This class enables concatenation, like:
  #
  # ```ruby
  # Brauser::Browser.new.is(:msie).version(">= 7").on?(:windows)
  # ```
  #
  # To end concatenation, use the `?` form of the queries or call `.result`.
  #
  # @attribute target
  #   @return [Browser] The current browser.
  # @attribute result
  #   @return [Boolean] The current result.
  class Query
    attr_accessor :target
    attr_accessor :result

    include Brauser::Queryable::Chainers
    include Brauser::Queryable::Queries

    # Creates a new query.
    #
    # @param target [Browser] The current browser.
    # @param result [Boolean] The current result.
    def initialize(target, result = true)
      @target = target
      @result = result
    end
  end
end
