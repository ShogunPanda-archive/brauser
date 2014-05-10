# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # Methods to parse the user agent.
    module Parsing
      # Parses the User-Agent header.
      # @param agent [String] The User-Agent header.
      # @return [Boolean] `true` if the browser was detected, `false` otherwise.
      def parse_agent(agent = nil)
        agent = agent.ensure_string

        @name, _ = match_name_and_version(agent)
        @version = adjust_version(@version)
        @platform = match_platform(agent)

        (@name != :unknown) ? true : false
      end

      # Parses the Accept-Language header.
      #
      # @param accept_language [String] The Accept-Language header.
      # @return [Array] The list of accepted languages.
      def parse_accept_language(accept_language = nil)
        accept_language.ensure_string.gsub(/;q=[\d.]+/, "").split(",").map { |l| l.downcase.strip }.select { |l| l.present? }
      end

      private

      # Matches a browser name and version.
      #
      # @param agent [String] The User-Agent header.
      # @return [String|Symbol] The browser name or `:unknown`, if no match was found.
      def match_name_and_version(agent)
        catch(:name) do
          ::Brauser::Browser.browsers.each do |tag, definition|
            matched = definition.match(:primary, definition, agent)

            if matched
              @version = definition.match(:secondary, definition, agent)
              throw(:name, tag)
            end
          end

          :unknown
        end
      end

      # Adjusts a browser version.
      #
      # @param version [String] The version to adjust.
      # @return [String] The adjusted version.
      def adjust_version(version)
        # Adjust version
        if version.blank?
          "0.0"
        elsif version.is_a?(::MatchData)
          version.to_a.last
        else
          version
        end
      end

      # Matches a browser platform.
      #
      # @param agent [String] The User-Agent header.
      # @return [String|Symbol] The browser platform or `:unknown`, if no match was found.
      def match_platform(agent)
        catch(:platform) do
          ::Brauser::Browser.platforms.each do |tag, definition|
            throw(:platform, tag) if definition.match(:primary, definition, agent)
          end

          :unknown
        end
      end

      # Parse query, getting all arguments.
      #
      # @param query [String] The query to issue. Use `__` to separate query and `_` in place of `.` in the version.
      # @return [Array] And array of `[method, arguments]` entries.
      def parse_query(query)
        query.gsub(/\?$/, "").gsub(/(_(v|on|is))/, " \\2").split(" ").map do |part|
          parse_query_part(part)
        end
      end

      # Handles a part of a query.
      #
      # @param part [String] A part of a query.
      # @return [Boolean|Query|nil] A query or a boolean value (if `method` ends with `?`). If the query is not valid, `NoMethodError` will be raised.
      def parse_query_part(part)
        method, arguments = part.split("_", 2)

        if method == "v" || method == "version"
          arguments = parse_query_version(arguments)
        elsif !%w(is on).include?(method)
          raise NoMethodError
        end

        [method, arguments]
      end

      # Parses the version for a query.
      #
      # @param version [String] The version to parse.
      # @return [String] The parsed version.
      def parse_query_version(version)
        [
          [/_?eq_?/, " == "], # Parse ==
          [/_?lte_?/, " <= "], # Parse <=
          [/_?gte_?/, " >= "], # Parse >=
          [/_?lt_?/, " < "], # Parse <
          [/_?gt_?/, " > "], # Parse >
          [/_?and_?/, " && "], # Parse &&
          ["_", "."], # Dot notation
          [/\s+/, " "]
        ].reduce(version) { |a, e| a.gsub(e[0], e[1]) }.strip
      end
    end
  end
end
