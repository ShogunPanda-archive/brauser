# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun_panda@me.com>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

# A framework agnostic browser detection and querying helper.
module Brauser
  # Methods of the {Browser Browser} class.
  module BrowserMethods
    # Methods for register recognized browsers, versions and platforms.
    module Register
      extend ActiveSupport::Concern

      # Class methods.
      module ClassMethods
        # Registers the default list of browsers that can be recognized.
        #
        # @return [Boolean] `true` if at least one browser has been added, `false` otherwise.
        def register_default_browsers
          @browsers = nil

          register_mobile_browsers
          register_desktop_browsers

          @browsers.present? ? true : false
        end

        # Registers the default list of platforms that can be recognized.
        #
        # @return [Boolean] `true` if at least one platform has been added, `false` otherwise.
        def register_default_platforms
          @platforms = nil

          self.register_platform([
            [:symbian, /s60|symb/i, "Symbian"],
            [:windows_phone, /windows phone/i, "Microsoft Windows Phone"],
            [:kindle, Proc.new { |name, _| name == :kindle }, "Nokia Symbian"],
            [:ios, Proc.new { |name, agent| [:iphone, :ipad, :ipod].include?(name) || agent =~ /ipad|iphone|ipod/i }, "Apple iOS"],
            [:android, /android/i, "Android"],
            [:blackberry, /blackberry/i, "RIM BlackBerry"],
            [:psp, /psp/i, "Sony Playstation Portable"],
            [:ps3, /playstation 3/i, "Sony Playstation 3"],
            [:wii, /wii/i, "Nintendo Wii"],

            [:linux, /linux/i, "Linux"],
            [:osx, /mac|macintosh|mac os x/i, "Apple MacOS X"],
            [:windows, /windows/i, "Microsoft Windows"]
          ])

          @platforms.present? ? true : false
        end

        # Registers the default list of languages that can be recognized.
        #
        # @return [Boolean] `true` if at least one language has been added, `false` otherwise.
        def register_default_languages
          @languages = nil

          self.register_language({
            "af" => "Afrikaans",
            "sq" => "Albanian",
            "eu" => "Basque",
            "bg" => "Bulgarian",
            "be" => "Byelorussian",
            "ca" => "Catalan",
            "zh" => "Chinese",
            "zh-cn" => "Chinese/China",
            "zh-tw" => "Chinese/Taiwan",
            "zh-hk" => "Chinese/Hong Kong",
            "zh-sg" => "Chinese/singapore",
            "hr" => "Croatian",
            "cs" => "Czech",
            "da" => "Danish",
            "nl" => "Dutch",
            "nl-nl" => "Dutch/Netherlands",
            "nl-be" => "Dutch/Belgium",
            "en" => "English",
            "en-gb" => "English/United Kingdom",
            "en-us" => "English/United States",
            "en-au" => "English/Australian",
            "en-ca" => "English/Canada",
            "en-nz" => "English/New Zealand",
            "en-ie" => "English/Ireland",
            "en-za" => "English/South Africa",
            "en-jm" => "English/Jamaica",
            "en-bz" => "English/Belize",
            "en-tt" => "English/Trinidad",
            "et" => "Estonian",
            "fo" => "Faeroese",
            "fa" => "Farsi",
            "fi" => "Finnish",
            "fr" => "French",
            "fr-be" => "French/Belgium",
            "fr-fr" => "French/France",
            "fr-ch" => "French/Switzerland",
            "fr-ca" => "French/Canada",
            "fr-lu" => "French/Luxembourg",
            "gd" => "Gaelic",
            "gl" => "Galician",
            "de" => "German",
            "de-at" => "German/Austria",
            "de-de" => "German/Germany",
            "de-ch" => "German/Switzerland",
            "de-lu" => "German/Luxembourg",
            "de-li" => "German/Liechtenstein",
            "el" => "Greek",
            "he" => "Hebrew",
            "he-il" => "Hebrew/Israel",
            "hi" => "Hindi",
            "hu" => "Hungarian",
            "ie-ee" => "Internet Explorer/Easter Egg",
            "is" => "Icelandic",
            "id" => "Indonesian",
            "in" => "Indonesian",
            "ga" => "Irish",
            "it" => "Italian",
            "it-ch" => "Italian/ Switzerland",
            "ja" => "Japanese",
            "km" => "Khmer",
            "km-kh" => "Khmer/Cambodia",
            "ko" => "Korean",
            "lv" => "Latvian",
            "lt" => "Lithuanian",
            "mk" => "Macedonian",
            "ms" => "Malaysian",
            "mt" => "Maltese",
            "no" => "Norwegian",
            "pl" => "Polish",
            "pt" => "Portuguese",
            "pt-br" => "Portuguese/Brazil",
            "rm" => "Rhaeto-Romanic",
            "ro" => "Romanian",
            "ro-mo" => "Romanian/Moldavia",
            "ru" => "Russian",
            "ru-mo" => "Russian /Moldavia",
            "sr" => "Serbian",
            "sk" => "Slovack",
            "sl" => "Slovenian",
            "sb" => "Sorbian",
            "es" => "Spanish",
            "es-do" => "Spanish",
            "es-ar" => "Spanish/Argentina",
            "es-co" => "Spanish/Colombia",
            "es-mx" => "Spanish/Mexico",
            "es-es" => "Spanish/Spain",
            "es-gt" => "Spanish/Guatemala",
            "es-cr" => "Spanish/Costa Rica",
            "es-pa" => "Spanish/Panama",
            "es-ve" => "Spanish/Venezuela",
            "es-pe" => "Spanish/Peru",
            "es-ec" => "Spanish/Ecuador",
            "es-cl" => "Spanish/Chile",
            "es-uy" => "Spanish/Uruguay",
            "es-py" => "Spanish/Paraguay",
            "es-bo" => "Spanish/Bolivia",
            "es-sv" => "Spanish/El salvador",
            "es-hn" => "Spanish/Honduras",
            "es-ni" => "Spanish/Nicaragua",
            "es-pr" => "Spanish/Puerto Rico",
            "sx" => "Sutu",
            "sv" => "Swedish",
            "sv-se" => "Swedish/Sweden",
            "sv-fi" => "Swedish/Finland",
            "ts" => "Thai",
            "tn" => "Tswana",
            "tr" => "Turkish",
            "uk" => "Ukrainian",
            "ur" => "Urdu",
            "vi" => "Vietnamese",
            "xh" => "Xshosa",
            "ji" => "Yiddish",
            "zu" => "Zulu"
          })

          @languages.present? ? true : false
        end

        # Registers a new browser that can be recognized.
        #
        # @param name [Symbol|Array] The browser name or a list of browser (a list of array with `[name, name_match, version_match, label]` entries).
        # @param name_match [String|Regexp|Block] The matcher for the name. If a block, it will be yield with the user agent and must return `true` if the name was recognized.
        # @param version_match [String|Regexp|Block] The match for the version. If a block, it will be yield with the browser name and the user agent and must return the browser version.
        # @param label [String] A human readable name of the browser.
        # @return [Boolean] `true` if at least one browser has been added, `false` otherwise.
        def register_browser(name, name_match = nil, version_match = nil, label = nil)
          @browsers ||= []
          register_entries(@browsers, (name.is_a?(Array) ? name : [[name.ensure_string, name_match, version_match, label]]))
        end

        # Registers a new platform that can be recognized.
        #
        # @param name [Symbol|Array] The platform name or a list of platforms (a list of array with `[name, matcher, label]` entries).
        # @param matcher [StringRegexp|Block] The matcher for the platform. If a block, it will be yielded with the browser name and the user agent and must return `true` if the platform was recognized.
        # @param label [String] A human readable name of the platform.
        # @return [Boolean] `true` if at least one platform has been added, `false` otherwise.
        def register_platform(name, matcher = nil, label = nil)
          @platforms ||= []
          register_entries(@platforms, (name.is_a?(Array) ? name : [[name.ensure_string, matcher, label]]))
        end

        # Registers a new language that can be recognized.
        #
        # @param code [String|Hash] The language code or an hash with codes as keys and label as values.
        # @param label [String] The language name. Ignored if code is an Hash.
        # @return [Boolean] `true` if at least one language has been added, `false` otherwise.
        def register_language(code, label = nil)
          @languages ||= {}
          rv = false
          code = {code.ensure_string => label.ensure_string} if !code.is_a?(Hash)

          code.each_pair do |c, l|
            if c.present? && l.present? then
              @languages[c] = l
              rv = true
            end
          end

          rv
        end

        private
          # Register the most common desktop browsers.
          # @return [Boolean] `true` if at least one browser has been added, `false` otherwise.
          def register_desktop_browsers
            self.register_browser([
              [:chrome, /((chrome)|(chromium))/i, /(.+Chrom[a-z]+\/)([a-z0-9.]+)/i, "Google Chrome"],
              [:netscape, /(netscape|navigator)\//i, /((Netscape|Navigator)\/)([a-z0-9.]+)/i, "Netscape Navigator"],
              [:firefox, /firefox/i, /(.+Firefox\/)([a-z0-9.]+)/i, "Mozilla Firefox"],
              [:safari, Proc.new{ |agent| agent =~ /safari/i && agent !~ /((chrome)|(chromium))/i }, /(.+Version\/)([a-z0-9.]+)/i, "Apple Safari"],

              [:msie_compatibility, /(msie 7\.0).+(trident)/i, Proc.new { |_, agent|
                version = /(.+Trident\/)([a-z0-9.]+)/i.match(agent)

                if version.is_a?(::MatchData) then
                  v = version.to_a.last.split(".")
                  v[0] = v[0].to_integer + 4
                  version = v.join(".")
                end

                version
              }, "Microsoft Internet Explorer (Compatibility View)"],
              [:msie, Proc.new{ |agent| agent =~ /msie/i && agent !~ /opera/i }, /(.+MSIE )([a-z0-9.]+)/i, "Microsoft Internet Explorer"],

              [:quicktime, /quicktime/i, /(.+((QuickTime\/)|(qtver=)))([a-z0-9.]+)/i, "Apple QuickTime"],

              [:webkit, /webkit/i, /(.+WebKit\/)([a-z0-9.]+)/i, "WebKit Browser"],
              [:gecko, /gecko/i, /(.+rv:|Gecko\/)([a-z0-9.]+)/i, "Gecko Browser"],
            ])
          end

          # Register the most common mobile and console browsers.
          # @return [Boolean] `true` if at least one browser has been added, `false` otherwise.
          def register_mobile_browsers
            self.register_browser([
              [:coremedia, /coremedia/i, /.+CoreMedia v([a-z0-9.]+)/i, "Apple CoreMedia"],

              [:opera_mobile, /opera mobi/i, /.+Opera Mobi.+((.+Opera )|(Version\/))([a-z0-9.]+)/i, "Opera Mobile"],
              [:opera, /opera/i, Proc.new{ |_, agent|
                regexp = (agent !~ /wii/i) ? /((.+Opera )|(Version\/))([a-z0-9.]+)/i : /(.+Nintendo Wii; U; ; )([a-z0-9.]+)/i

                version = regexp.match(agent)
                version = version.to_a.last if version.is_a?(MatchData)
                version
              }, "Opera"],

              [:android, /android/i, /(.+Android )([a-z0-9.]+)/i, "Android"],
              [:blackberry, /blackberry/i, /(.+Version\/)([a-z0-9.]+)/i, "RIM BlackBerry"],
              [:kindle, /(kindle)/i, /(.+(Kindle|Silk)\/)([a-z0-9.]+)/i, "Amazon Kindle"],
              [:psp, /psp/i, /(.+PlayStation Portable\); )([a-z0-9.]+)/i, "Sony Playstation Portable"],
              [:ps3, /playstation 3/i, /(.+PLAYSTATION 3; )([a-z0-9.]+)/i, "Sony Playstation 3"],
              [:windows_phone, /windows phone/i, /(.+IEMobile\/)([a-z0-9.]+)/i, "Microsoft Windows Phone"],
              [:wii, /nintendo wii/, /(.+Nintendo Wii; U; ; )([a-z0-9.]+)/i, "Nintendo Wii"],

              [:ipod, /ipod/i, /(.+Version\/)([a-z0-9.]+)/i, "Apple iPod"],
              [:iphone, /iphone/i, /(.+Version\/)([a-z0-9.]+)/i, "Apple iPhone"],
              [:ipad, /ipad/i, /(.+Version\/)([a-z0-9.]+)/i, "Apple iPad"],

              [:mobile, /(mobile|symbian|midp|windows ce)/i, /.+\/([a-z0-9.]+)/i, "Other Mobile Browser"],
            ])
          end

          # Registers a new set of entries to a collection.
          #
          # @param collection [Array] The collection which add entries to.
          # @param entries [Array] The entries to add.
          def register_entries(collection, entries)
            rv = false

            entries.each do |entry|
              entry[0] = entry[0].to_sym
              index = collection.find_index { |item| item[0] == entry[0] }

              # Replace a previous entry
              if index then
                collection[index] = entry
              else
                collection << entry
                rv = true
              end
            end

            rv
          end
      end
    end

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
          registered_to_hash(@browsers)
        end

        # Returns the list of platforms that can be recognized.
        #
        # The keys are the platform name, values are arrays of the matcher and the label.
        #
        # @return [Hash] The list of platform that can be recognized.
        def platforms
          registered_to_hash(@platforms)
        end

        # Returns the list of languages that can be recognized.
        #
        # The keys are the languages code, the values the labels.
        #
        # @return [Hash] The list of languages that can be recognized.
        def languages
          @languages
        end

        # Compares two versions.
        #
        # @param v1 [String] The first versions to compare.
        # @param operator [Symbol] The operator to use for comparison, can be one of `[:lt, :lte, :eq, :gte, :gt]`.
        # @param v2 [Symbol] The second version to compare.
        # @return [Boolean] true if comparison is valid, `false` otherwise.
        def compare_versions(v1 = "", operator = :eq, v2 = "")
          valid_results = {lt: [-1], lte: [-1, 0], eq: [0], gte: [0, 1], gt: [1]}.fetch(operator, [])

          if valid_results.present? && v1.ensure_string.present? then
            p1, p2 = find_relevant_tokens(v1.ensure_string.strip, v2.ensure_string.strip)
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
            v1 = v1.split(".")
            v2 = v2.split(".")

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
            if !p1.is_integer? then
              ll = p1.length
              p1 = p2 + p1
              p2 = p2 + ("z" * ll)
            end

            [p1, p2]
          end

          # Converts a list of register entries to an ordered hash.
          #
          # @param entries [Array] The array to convert.
          # @return [OrderedHash] An ordered hash.
          def registered_to_hash(entries)
            entries.inject(ActiveSupport::OrderedHash.new) do |rv, entry|
              rv[entry[0]] = entry[1, entry.length]
              rv
            end
          end
      end
    end

    # Methods to handle attributes
    module Attributes
      # Gets a human-readable browser name.
      #
      # @return [String] A human-readable browser name.
      def readable_name
        self.parse_agent(@agent) if !@name
        ::Brauser::Browser.browsers.fetch(@name, ["Unknown Browser"]).last.ensure_string
      end

      # Gets a human-readable platform name.
      #
      # @return [String] A readable platform name.
      def platform_name
        self.parse_agent(@agent) if !@platform
        ::Brauser::Browser.platforms.fetch(@platform, ["Unknown Platform"]).last.ensure_string
      end

      # Returns an array of information about the browser. Information are strings which are suitable to use as CSS classes.
      #
      # For version, it will be included a class for every token of the version. For example, version `7.0.1.2` will return this:
      #
      # ```ruby
      # ["version-7", "version-7_0", "version-7_0_1", "version-7_0_1_2"]
      # ```
      #
      # If you provide a block (with accepts name, version and platform as arguments), it will be used for translating the name.
      #
      # @param join [String|NilClass] If non falsy, the separator to use to join information. If falsy, informations will be returned as array.
      # @param name [Boolean] If non falsy, the string to prepend to the name. If falsy, the name information will not be included.
      # @param version [String|NilClass] If non falsy, the string to prepend to the version. If falsy, the version information will not be included.
      # @param platform [String|NilClass] If non falsy, the string to prepend to the platform. If falsy, the platform information will not be included.
      # @param block [Proc] A block to translate browser name.
      # @return [String|Array] CSS ready information of the current browser.
      def classes(join = " ", name = "", version = "version-", platform = "platform-", &block)
        platform = "platform-" if platform.is_a?(TrueClass)
        rv = [stringify_name(name, &block), stringify_version(version), !platform ? nil : (platform + @platform.to_s)].compact.flatten
        join ? rv.join(join) : rv
      end
      alias :meta :classes

      private
        # Stringifies a browser name(s).
        #
        # @param name [Boolean] If non falsy, the string to prepend to the name. If falsy, the name information will not be included.
        # @param block [Proc] A block to translate browser name.
        # @return [String|Array|nil] The browser name(s) or `nil`, if it was set to be skipped
        def stringify_name(name, &block)
          if !name then
            nil
          else
            name = "" if name.is_a?(TrueClass)
            self.parse_agent(@agent) if !@name
            block ||= Proc.new {|n, *| n == :msie_compatibility ? [:msie_compatibility, :msie] : n }

            names = block.call(@name, @version, @platform).ensure_array.collect {|n| "#{name}#{n}" }
            names.length > 1 ? names : names.first
          end
        end

        # Stringifies a browser version.
        #
        # @param version [String|NilClass] If non falsy, the string to prepend to the version. If falsy, the version information will not be included.
        # @return [Array] The version strings or `nil`, if it was set to be skipped
        def stringify_version(version)
          version = "version-" if version.is_a?(TrueClass)
          others = @version.split(".")
          major = others.shift
          !version ? nil : others.inject([version + major]) {|prev, current| prev + [prev.last + "_" + current] }.flatten
        end
    end

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
        accept_language.ensure_string.gsub(/;q=[\d.]+/, "").split(",").collect {|l| l.downcase.strip }.select{|l| l.present? }
      end

      private
        # Matches a browser name and version.
        #
        # @param agent [String] The User-Agent header.
        # @return [String|Symbol] The browser name or `:unknown`, if no match was found.
        def match_name_and_version(agent)
          catch(:name) do
            ::Brauser::Browser.browsers.each do |name, definitions|
              matched = match_definition(definitions[0], agent)

              if matched then
                @version = match_definition(definitions[1], name, agent)
                throw(:name, name)
              end
            end

            :unknown
          end
        end

        # Adjusts a browser version.
        def adjust_version(version)
          # Adjust version
          if version.blank? then
            "0.0"
          elsif version.is_a?(::MatchData) then
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
            ::Brauser::Browser.platforms.each do |platform, definitions|
              matched = match_definition(definitions[0], @name, agent)
              throw(:platform, platform) if matched
            end

            :unknown
          end
        end

        # Matches a subject against a definition
        #
        # @param subject [Array] The subject to match.
        # @param definition [StringRegexp|Block] The definition. If a block, it will be yielded with the subject must return `true` if the subject was recognized.
        def match_definition(definition, *subject)
          if definition.is_a?(::Regexp) then
            definition.match(subject.last)
          elsif definition.respond_to?(:call) then
            definition.call(*subject)
          else
            subject.last == definition.ensure_string ? subject.last : nil
          end
        end
    end

    # Methods to query with chaining.
    module PartialQuerying
      # Checks if the browser is a specific name and optionally of a specific version and platform.
      #
      # @see #v?
      # @see #on?
      #
      # @param names [Symbol|Array] A list of specific names to match. Also, this meta-names are supported: `:capable` and `:tablet`.
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against, in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Query] A query which can evaluated for concatenation or result.
      def is(names = [], versions = {}, platforms = [])
        self.parse_agent(@agent) if !@name

        names = adjust_names(names)
        versions = parse_versions_query(versions)
        platforms = platforms.ensure_array

        ::Brauser::Query.new(self,
          (names.blank? || (names.include?(@name) && check_capable(names))) &&
          (versions.blank? || self.v?(versions)) &&
          (platforms.blank? || self.on?(platforms))
        )
      end

      # Checks if the browser is a specific version.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against, in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Query] A query which can evaluated for concatenation or result.
      def v(versions = {})
        self.parse_agent(@agent) if !@version

        versions = if versions.is_a?(String) then
          parse_versions_query(versions)
        elsif !versions.is_a?(::Hash) then
          {}
        else
          versions
        end

        ::Brauser::Query.new(self, versions.all? { |operator, value| Brauser::Browser.compare_versions(@version, operator, value) })
      end

      # Check if the browser is on a specific platform.
      #
      # @param platforms [Symbol|Array] A list of specific platform to match.
      # @return [Query] A query which can evaluated for concatenation or result.
      def on(platforms = [])
        self.parse_agent(@agent) if !@platform
        ::Brauser::Query.new(self, platforms.blank? || platforms.ensure_array.uniq.compact.collect {|p| p.ensure_string.to_sym }.include?(@platform))
      end

      # Check if the browser accepts the specified languages.
      #
      # @param langs [String|Array] A list of languages to match against.
      # @return [Query] A query which can evaluated for concatenation or result.
      def accepts(langs = [])
        self.parse_accept_language(@accept_language) if !@languages
        ::Brauser::Query.new(self, (@languages & langs.ensure_array.uniq.compact.collect {|l| l.to_s }).present?)
      end

      private
        # Adjusts names for correct matching.
        #
        # @param names [Array] A list of names.
        # @return [Array] The adjusted list of names.
        def adjust_names(names)
          # Adjust names
          names = names.ensure_array.compact.collect {|n| n.ensure_string.to_sym }
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
        # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against, in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
        # @return [Hash] The hash representation of the query.
        def parse_versions_query(versions)
          versions.is_a?(::Hash) ? versions : versions.ensure_string.split(/\s*&&\s*/).inject({}) do |prev, token|
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
          operator, version = token.strip.split(/\s+/, 2).collect(&:strip)
          [{"<" => :lt, "<=" => :lte, "=" => :eq, "==" => :eq, ">" => :gt, ">=" => :gte}.fetch(operator, nil), version]
        end
    end

    # Methods to end querying.
    module Querying
      # Checks if the browser is a specific name and optionally of a specific version and platform.
      #
      # @see #v?
      # @see #on?
      #
      # @param names [Symbol|Array] A list of specific names to match. Also, this meta-names are supported: `:capable` and `:tablet`.
      # @param versions [Hash] An hash with specific version to match against. Need to be in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def is?(names = [], versions = {}, platforms = [])
        self.is(names, versions, platforms).result
      end

      # Checks if the browser is a specific version.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against, in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def v?(versions = {})
        self.v(versions).result
      end

      # Check if the browser is on a specific platform.
      #
      # @param platforms [Symbol|Array] A list of specific platform to match.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def on?(platforms = [])
        self.on(platforms).result
      end

      # Check if the browser accepts the specified languages.
      #
      # @param langs [String|Array] A list of languages to match against.
      # @return [Boolean] `true` if current browser matches, `false` otherwise.
      def accepts?(langs = [])
        self.accepts(langs).result
      end
    end
  end

  # This class represents a detection of the current user browser.
  #
  # @attribute agent
  #   @return [String] The raw User-Agent HTTP header.
  # @attribute accept_language
  #   @return [String] The raw Accept-Language HTTP header.
  # @attribute languages
  #   @return [Array] The accepted languages.
  # @attribute name
  #   @return [String] The current browser name.
  # @attribute version
  #   @return [String] The current browser version.
  # @attribute platform
  #   @return [String] The current browser platform.
  class Browser
    attr_accessor :agent
    attr_accessor :accept_language
    attr_accessor :languages
    attr_accessor :name
    attr_accessor :version
    attr_accessor :platform

    # Aliases
    alias :ua :agent
    alias :ua= :agent=

    include ::Brauser::BrowserMethods::General
    include ::Brauser::BrowserMethods::Attributes
    include ::Brauser::BrowserMethods::Register
    include ::Brauser::BrowserMethods::Parsing
    include ::Brauser::BrowserMethods::PartialQuerying
    include ::Brauser::BrowserMethods::Querying

    # Creates a new browser.
    #
    # @param agent [String] The User-Agent HTTP header.
    # @param accept_language [String] The Accept-Language HTTP header.
    def initialize(agent = "", accept_language = "")
      ::Brauser::Browser.register_default_browsers
      ::Brauser::Browser.register_default_platforms
      ::Brauser::Browser.register_default_languages

      @agent = agent
      @accept_language = accept_language

      @languages = self.parse_accept_language(@accept_language) if @accept_language
      self.parse_agent(@agent) if @agent
    end

    # This method enables the use of dynamic queries in just one method.
    #
    # For example:
    #
    # ```ruby
    # browser.is_msie_gt_4_1__on_windows?
    # #=> true
    # ```
    #
    # If you don't provide a trailing `?`, you will get a Brauser::Query.
    #
    # If the syntax is invalid, a `NoMethodError` exception will be raised.
    #
    # @param query [String] The query to issue. Use `__` to separate query and `_` in place of `.` in the version.
    # @param arguments [Array] The arguments to pass the method. Unused from the query.
    # @param block [Proc] A block to pass to the method. Unused from the query.
    # @return [Boolean|Query|nil] A query or a boolean value (if `method` ends with `?`). If the query is not valid, `NoMethodError` will be raised.
    def method_missing(query, *arguments, &block)
      begin
        parsed_query = parse_query(query.ensure_string)
        rv = execute_query(parsed_query) || Brauser::Query.new(self, false)
        query.ensure_string =~ /\?$/ ? rv.result : rv
      rescue NoMethodError
        super(query, *arguments, &block)
      end
    end

    # Returns the current browser as a string.
    #
    # @see #classes
    #
    # @return [String] A string representation of the current browser.
    def to_s
      self.classes
    end

    private
      # Parse query, getting all arguments.
      # @param query [String] The query to issue. Use `__` to separate query and `_` in place of `.` in the version.
      # @return [Array] And array of `[method, arguments]` entries.
      def parse_query(query)
        query.gsub(/\?$/, "").split("__").collect do |part|
          parse_query_part(part)
        end
      end

      # Handles a part of a query.
      #
      # @param part [String] A part of a query.
      # @return [Boolean|Query|nil] A query or a boolean value (if `method` ends with `?`). If the query is not valid, `NoMethodError` will be raised.
      def parse_query_part(part)
        method, arguments = part.split("_", 2)

        if method == "v" then
          arguments = parse_query_version(arguments)
        elsif !["is", "on"].include?(method)
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
        ].inject(version) { |current, parse| current.gsub(parse[0], parse[1])}.strip
      end

      # Executes a parsed query
      #
      # @param query [Array] And array of `[method, arguments]` entries.
      # @return [Brauser::Query] The result of the query.
      def execute_query(query)
        query.inject(Brauser::Query.new(self, true)) { |rv, call|
          break if !rv.result
          rv.send(call[0], *call[1])
        }
      end
  end
end