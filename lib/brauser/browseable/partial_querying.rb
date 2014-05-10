# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # Methods to query with chaining.
    module PartialQuerying
      # Checks if the browser is a specific name and optionally of a specific version and platform.
      #
      # @see #version?
      # @see #on?
      #
      # @param names [Symbol|Array] A list of specific names to match. Also, this meta-names are supported: `:capable` and `:tablet`.
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against,
      #   in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Query] A query which can evaluated for concatenation or result.
      def is(names = [], versions = {}, platforms = [])
        parse_agent(@agent) unless @name

        names = adjust_names(names)
        versions = parse_versions_query(versions)
        platforms = platforms.ensure_array

        ::Brauser::Query.new(self,
                             (names.blank? || (names.include?(@name) && check_capable(names))) &&
                               (versions.blank? || version?(versions)) &&
                               (platforms.blank? || on?(platforms))
        )
      end

      # Checks if the browser is a specific version.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against,
      #   in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Query] A query which can evaluated for concatenation or result.
      def version_equals_to(versions = {})
        parse_agent(@agent) unless @version
        versions = versions.is_a?(String) ? parse_versions_query(versions) : versions.ensure_hash

        ::Brauser::Query.new(self, versions.all? { |operator, value| Brauser::Browser.compare_versions(@version, operator, value) })
      end
      alias_method :v, :version_equals_to

      # Check if the browser is on a specific platform.
      #
      # @param platforms [Symbol|Array] A list of specific platform to match.
      # @return [Query] A query which can evaluated for concatenation or result.
      def on(platforms = [])
        parse_agent(@agent) unless @platform

        ::Brauser::Query.new(self, platforms.blank? || platforms.ensure_array(nil, true, true, true, :to_sym).include?(@platform))
      end

      # Check if the browser accepts the specified languages.
      #
      # @param langs [String|Array] A list of languages to match against.
      # @return [Query] A query which can evaluated for concatenation or result.
      def accepts(langs = [])
        parse_accept_language(@accept_language) unless @languages

        ::Brauser::Query.new(self, (@languages & langs.ensure_array(nil, true, true, true, :to_s)).present?)
      end

      private

      # Adjusts names for correct matching.
      #
      # @param names [Array] A list of names.
      # @return [Array] The adjusted list of names.
      def adjust_names(names)
        # Adjust names
        names = names.ensure_array(nil, true, true, true, :to_sym)
        names << [:msie, :msie_compatibility] if names.include?(:ie) || names.include?(:msie)
        names << [:chromium] if names.include?(:chrome)
        names << [:chrome, :firefox, :safari, :opera, :msie] if names.include?(:capable)
        names << [:ipad, :android, :kindle] if names.include?(:tablet)
        names.flatten.compact.uniq
      end

      # Checks if the browser is capable.
      #
      # @param names [Array] A list of names.
      # @return [Boolean] `true` if the browser is capable, `false` otherwise.
      def check_capable(names)
        !names.include?(:capable) || @name != :msie || Brauser::Browser.compare_versions(@version, :gte, 9)
      end

      # Parses a version query.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match
      #   against, in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Hash] The hash representation of the query.
      def parse_versions_query(versions)
        versions.is_a?(::Hash) ? versions : versions.ensure_string.split(/\s*&&\s*/).reduce({}) do |prev, token|
          operator, version = parse_versions_query_component(token)
          prev[operator] = version if operator.present? && version.present?
          prev
        end
      end

      # Parses a token of a version query.
      #
      # @param token [String] The token to parse.
      # @return [Array] An operator and an argument.
      def parse_versions_query_component(token)
        operator, version = token.strip.split(/\s+/, 2).map(&:strip)
        [{"<" => :lt, "<=" => :lte, "=" => :eq, "==" => :eq, ">" => :gt, ">=" => :gte}.fetch(operator, nil), version]
      end
    end
  end
end
