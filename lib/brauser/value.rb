#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # A defined entity, which supports comparison against a single or multiple values.
  #
  # @attribute [r] value
  #   @return [Object] The wrapped value.
  class Value
    attr_reader :value
    delegate :to_s, :inspect, to: :value

    # Creates a new value
    #
    # @param value [Object] The wrapped value.
    def initialize(value)
      @value = value
    end

    # Check if an object is equal to another object or if it is contained in a list of objects.
    #
    # @param other [Array|Object] The other object to match.
    # @return [Boolean] `true` if the current object is either equal or contained in the other object, `false` otherwise.
    def ==(other)
      other.is_a?(Array) ? other.include?(@value) : (@value == other)
    end

    # Delegates all the other values to the wrapped value.
    #
    # @param method [Symbol] The method to call.
    # @param args [Array] The arguments to pass to the method.
    # @param block [Proc] The block to pass to the method.
    def method_missing(method, *args, &block)
      @value.send(method, *args, &block)
    end
  end
end
