# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun_panda@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # A class which hold a definition of a browser, a platform or a language
  # This class represents a detection of the current user browser.
  #
  # @attribute tag
  #   @return [String|Symbol] An identifier for this definition.
  # @attribute label
  #   @return [String] A human readable label for this definition.
  # @attribute primary
  #   @return [String|Symbol|Proc] The primary matcher of this definition. Used to match browser engine, platform name and language.
  # @attribute secondary
  #   @return [String|Symbol|Proc] The secondary matcher of this definition. Used to match browser version.
  class Definition
    attr_accessor :tag, :label, :primary, :secondary

    # Creates a new definition.
    #
    # @param tag [String|Symbol] An identifier for this definition.
    # @param label [String] A human readable label for this definition.
    # @param primary [String|Symbol|Proc] The primary matcher of this definition.
    # @param secondary [String|Symbol|Proc] The secondary matcher of this definition.
    def initialize(tag = nil, label = nil, primary = nil, secondary = nil)
      self.tag = tag if tag
      self.label = label if label
      self.primary = primary if primary
      self.secondary = secondary if secondary
    end

    # Performs a match of this definition.
    #
    # @param type [Symbol] The matcher to perform. Can be `:primary` (default) or `:secondary`.
    # @param args [Array] Arguments to pass to the matcher. The first is the definition itself.
    # @return [Object|NilClass] A match if matcher succeeded, `nil` otherwise.
    def match(type, *args)
      matcher = self.send(type || :primary) rescue nil

      if matcher.is_a?(::Regexp) then
        matcher.match(args[1])
      elsif matcher.respond_to?(:call) then
        matcher.call(*args)
      elsif matcher
        args[1] == matcher ? args[1] : nil
      else
        nil
      end
    end
  end
end