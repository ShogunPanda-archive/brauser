# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # Methods for register recognized browsers, versions and platforms.
    module Register
      extend ActiveSupport::Concern

      # Class methods.
      module ClassMethods
        # Adds a definitions for recognition.
        #
        # @param type [Symbol] The type of the definition. Can be `:browsers`, `:platforms` or `:languages`.
        # @param definition [Definition|Array] The definition to add. Can be also an array of definitions.
        # @return [Boolean] `true` if at least one definition has been added, `false` otherwise.
        def add(type, definition)
          rv = false

          if [:browsers, :platforms, :languages].include?(type)
            prepare_definitions_for(type)

            definition.ensure_array.each do |d|
              next unless d.is_a?(::Brauser::Definition)
              @definitions[type][d.tag] = d
              rv = true
            end
          end

          rv
        end

        # Adds definitions for a default list of browsers that can be recognized.
        #
        # @return [Boolean] `true` if at least one browser has been added, `false` otherwise.
        def add_default_browsers
          add(:browsers, (
            ::Brauser::Browseable::DefaultDefinitions::MOBILE_BROWSERS + ::Brauser::Browseable::DefaultDefinitions::MAJOR_DESKTOP_BROWSERS +
            ::Brauser::Browseable::DefaultDefinitions::MSIE_BROWSERS + ::Brauser::Browseable::DefaultDefinitions::MINOR_DESKTOP_BROWSERS
          ).map { |browser| ::Brauser::Definition.send(:new, *browser) })
        end

        # Adds a default list of platforms that can be recognized.
        #
        # @return [Boolean] `true` if at least one platform has been added, `false` otherwise.
        def add_default_platforms
          add(:platforms, ::Brauser::Browseable::DefaultDefinitions::PLATFORMS.map { |platform| ::Brauser::Definition.send(:new, *platform) })
        end

        # Adds a default list of languages that can be recognized.
        #
        # @return [Boolean] `true` if at least one language has been added, `false` otherwise.
        def add_default_languages
          add(:languages, ::Brauser::Browseable::DefaultDefinitions::LANGUAGES.map { |code, name| ::Brauser::Definition.new(code, name, code) })
        end

        private

        # Prepares definition for a specific type.
        #
        # @param type [Symbol] The type to prepare.
        def prepare_definitions_for(type)
          @definitions ||= {}
          @definitions[type] ||= {}
        end
      end
    end
  end
end
