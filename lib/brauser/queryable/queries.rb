# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser queries.
  module Queryable
    # Methods to make queries.
    module Queries
      # Checks if the browser is a specific name and optionally of a specific version and platform.
      #
      # This version returns a boolean and it is equal to append a call to `#result` to the method `#is`.
      #
      # @see #v?
      # @see #on?
      #
      # @param names [Symbol|Array] A list of specific names to match. Also, this meta-names are supported: `:capable` and `:tablet`.
      # @param versions [Hash] An hash with specific version to match against. Need to be in any form that `#v` understands.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def is?(names = [], versions = {}, platforms = [])
        @result ? @target.is?(names, versions, platforms) : @result
      end

      # Checks if the browser is a specific version.
      #
      # This version returns a boolean and it is equal to append a call to `#result` to the method `#v`.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against,
      #   in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def version?(versions = {})
        @result ? @target.version?(versions) : @result
      end
      alias_method :v?, :version?

      # Check if the browser is on a specific platform.
      #
      # This version returns a boolean and it is equal to append a call to `#result` to the method `#on.
      #
      # @param platforms [Symbol|Array] A list of specific platform to match.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def on?(platforms = [])
        @result ? @target.on?(platforms) : @result
      end

      # Check if the browser accepts the specified languages.
      #
      # This version returns a boolean and it is equal to append a call to `#result` to the method `#accepts.
      #
      # @param langs [String|Array] A list of languages to match against.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def accepts?(langs = [])
        @result ? @target.accepts?(langs) : @result
      end
    end
  end
end
