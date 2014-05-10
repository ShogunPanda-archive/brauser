# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # Methods to end querying.
    module Querying
      # Checks if the browser is a specific name and optionally of a specific version and platform.
      #
      # @see #v?
      # @see #on?
      #
      # @param names [Symbol|Array] A list of specific names to match. Also, this meta-names are supported: `:capable` and `:tablet`.
      # @param versions [Hash] An hash with specific version to match against. Need to be in form `{:operator => version}`, where operator
      #   is one of `:lt, :lte, :eq, :gt, :gte`.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def is?(names = [], versions = {}, platforms = [])
        is(names, versions, platforms).result
      end

      # Checks if the browser is a specific version.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against,
      #   in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def version?(versions = {})
        version(versions).result
      end
      alias_method :v?, :version?

      # Check if the browser is on a specific platform.
      #
      # @param platforms [Symbol|Array] A list of specific platform to match.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def on?(platforms = [])
        on(platforms).result
      end

      # Check if the browser accepts the specified languages.
      #
      # @param langs [String|Array] A list of languages to match against.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def accepts?(langs = [])
        accepts(langs).result
      end

      # Check if the browser is supported.
      #
      # @param supported [Hash|String] A map of engines and minimum supported major version, or a path to YAML file containing the map.
      # @return [Boolean] `true` if current browser is supported, `false` otherwise.
      def supported?(supported)
        supported = YAML.load_file(supported).symbolize_keys if supported.is_a?(String)
        minimum = supported[name]
        (minimum && v?(gte: minimum)).to_boolean
      end
    end
  end
end
