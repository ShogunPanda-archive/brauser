# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # General methods.
    module General
      extend ActiveSupport::Concern

      # Class methods.
      module ClassMethods
        # Returns the list of browser that can be recognized.
        #
        # The keys are the browser name, the values are arrays of the name matcher, the version match and the label.
        #
        # @return [Hash] The list of browser that can be recognized.
        def browsers
          @definitions[:browsers]
        end

        # Returns the list of platforms that can be recognized.
        #
        # The keys are the platform name, values are arrays of the matcher and the label.
        #
        # @return [Hash] The list of platform that can be recognized.
        def platforms
          @definitions[:platforms]
        end

        # Returns the list of languages that can be recognized.
        #
        # The keys are the languages code, the values the labels.
        #
        # @return [Hash] The list of languages that can be recognized.
        def languages
          @definitions[:languages]
        end

        # Compares two versions.
        #
        # @param v1 [String] The first versions to compare.
        # @param operator [Symbol] The operator to use for comparison, can be one of `[:lt, :lte, :eq, :gte, :gt]`.
        # @param v2 [Symbol] The second version to compare.
        # @return [Boolean] true if comparison is valid, `false` otherwise.
        def compare_versions(v1 = "", operator = :eq, v2 = "")
          valid_results = {lt: [-1], lte: [-1, 0], eq: [0], gte: [0, 1], gt: [1]}.fetch(operator, [])

          if valid_results.present? && v1.ensure_string.present?
            p1, p2 = find_relevant_tokens(v1, v2)
            p1, p2 = normalize_tokens(p1, p2)
            valid_results.include?(p1 <=> p2)
          else
            false
          end
        end

        private

        # Find relevant tokens (that is, the first two which are not equals) in a string for comparison.
        #
        # @param v1 [String] The first versions to compare.
        # @param v2 [String] The second version to compare.
        # @return [Array] The tokens to compare.
        def find_relevant_tokens(v1, v2)
          v1 = v1.ensure_string.strip.split(".")
          v2 = v2.ensure_string.strip.split(".")

          p1 = nil
          p2 = nil
          [v1.length, v2.length].max.times do |i|
            p1 = v1[i]
            p2 = v2[i]
            break if !p1 && !p2 || p1 != p2
          end

          [p1 || "0", p2 || "0"]
        end

        # Normalizes token for comparison.
        #
        # @param p1 [String] The first token to normalize.
        # @param p2 [String] The second token to normalize.
        # @return [Array] The tokens to compare.
        def normalize_tokens(p1, p2)
          if !p1.is_integer?
            ll = p1.length
            p1 = p2 + p1
            p2 += ("z" * ll)
          else
            ll = [p1.length, p2.length].max
            p1 = p1.rjust(ll, "0")
            p2 = p2.rjust(ll, "0")
          end

          [p1, p2]
        end
      end
    end
  end
end
