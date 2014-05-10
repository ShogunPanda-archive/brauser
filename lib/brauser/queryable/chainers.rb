# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser queries.
  module Queryable
    # Methods to chain queries.
    module Chainers
      # Checks if the browser is a specific name and optionally of a specific version and platform.
      #
      # @see #version?
      # @see #on?
      #
      # @param names [Symbol|Array] A list of specific names to match. Also, this meta-names are supported: `:capable` and `:tablet`.
      # @param versions [Hash] An hash with specific version to match against. Need to be in any form that {#v} understands.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Query] The query itself.
      def is(names = [], versions = {}, platforms = [])
        @result = is?(names, versions, platforms)
        self
      end

      # Checks if the browser is a specific version.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against,
      #   in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Query] The query itself.
      def version(versions = {})
        @result = version?(versions)
        self
      end
      alias_method :v, :version

      # Check if the browser is on a specific platform.
      #
      # @param platforms [Symbol|Array] A list of specific platform to match.
      # @return [Query] The query itself.
      def on(platforms = [])
        @result = on?(platforms)
        self
      end

      # Check if the browser accepts the specified languages.
      #
      # @param langs [String|Array] A list of languages to match against.
      # @return [Query] The query itself.
      def accepts(langs = [])
        @result = accepts?(langs)
        self
      end
    end
  end
end
