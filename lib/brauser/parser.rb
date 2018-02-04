#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

module Brauser
  # A parser for the HTTP headers.
  class Parser
    # Makes sure a subject matches a pattern AND NOT another pattern.
    #
    # @param subject [String] The subject to match.
    # @param positive_matcher [Regexp] The expression to match.
    # @param negative_matcher [Regexp] The expression NOT to match.
    # @return [Boolean] `true` if matching succeeded, `false otherwise`.
    def self.disambiguate(subject, positive_matcher, negative_matcher)
      subject =~ positive_matcher && subject !~ negative_matcher
    end

    # Parses the User-Agent header.
    #
    # @param header [String] The User-Agent header.
    # @return [Array|NilClass] An array of engine, version and platform if the match succeeded, `nil` otherwise.
    def parse_agent(header)
      # First of all match the agent and the version
      catch(:result) do
        Brauser::Definitions.browsers.each do |_, definition|
          result = definition.match(header)
          throw(:result, result) if result
        end

        nil
      end
    end

    # Parses a Accept-Language header.
    #
    # @param header [String] The Accept-Language header.
    # @return [Hash] The list of accepted languages with their priorities.
    def parse_accept_language(header)
      header.ensure_string.tokenize.reduce({}) do |rv, token|
        code, priority = token.split(";q=")
        rv[code.downcase.gsub("_", "-").to_sym] = priority.to_float if code && priority
        rv
      end
    end
  end
end
