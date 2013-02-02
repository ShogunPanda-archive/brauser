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

          self.register_browser([
            [:coremedia, /coremedia/i, /.+CoreMedia v([a-z0-9.]+)/i, "Apple CoreMedia"],

            [:opera_mobile, /opera mobi/i, /.+Opera Mobi.+((.+Opera )|(Version\/))([a-z0-9.]+)/i, "Opera Mobile"],
            [:opera, /opera/i, Proc.new{ |name, agent|
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

            [:chrome, /((chrome)|(chromium))/i, /(.+Chrom[a-z]+\/)([a-z0-9.]+)/i, "Google Chrome"],
            [:netscape, /(netscape|navigator)\//i, /((Netscape|Navigator)\/)([a-z0-9.]+)/i, "Netscape Navigator"],
            [:firefox, /firefox/i, /(.+Firefox\/)([a-z0-9.]+)/i, "Mozilla Firefox"],
            [:safari, Proc.new{ |agent| agent =~ /safari/i && agent !~ /((chrome)|(chromium))/i }, /(.+Version\/)([a-z0-9.]+)/i, "Apple Safari"],

            [:msie_compatibility, /trident/i, Proc.new { |name, agent|
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
            [:kindle, Proc.new { |name, agent| name == :kindle }, "Nokia Symbian"],
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
            "gd" => "Scots Gaelic",
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
          if !@browsers then
            @browsers = []
            @browsers_indexes = {}
          end

          rv = false
          name = [[name.ensure_string.to_sym, name_match, version_match, label]] if !name.is_a?(Array)

          name.each do |browser|
            browser[0] = browser[0].to_sym

            index = @browsers.index do |item|
              item[0] == browser[0]
            end

            # Replace a previous entry
            if index then
              @browsers[index] = browser
            else
              @browsers << browser
              @browsers_indexes[browser[0]] = @browsers.length - 1
            end

            rv = true
          end

          rv
        end

        # Registers a new platform that can be recognized.
        #
        # @param name [Symbol|Array] The platform name or a list of platforms (a list of array with `[name, matcher, label]` entries).
        # @param matcher [StringRegexp|Block] The matcher for the platform. If a block, it will be yielded with the browser name and the user agent and must return `true` if the platform was recognized.
        # @param label [String] A human readable name of the platform.
        # @return [Boolean] `true` if at least one platform has been added, `false` otherwise.
        def register_platform(name, matcher = nil, label = nil)
          if !@platforms then
            @platforms = []
            @platforms_indexes = {}
          end


          rv = false
          name = [[name.ensure_string.to_sym, matcher, label]] if !name.is_a?(Array)

          name.each do |platform|
            platform[0] = platform[0].to_sym

            index = @platforms.index do |item|
              item[0] == platform[0]
            end

            # Replace a previous entry
            if index then
              @platforms[index] = platform
            else
              @platforms << platform
              @platforms_indexes[platform[0]] = @platforms.length - 1
            end

            rv = true
          end

          rv
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
          rv = ActiveSupport::OrderedHash.new

          @browsers.each do |browser|
            rv[browser[0]] = browser[1, browser.length]
          end

          rv
        end

        # Returns the list of platforms that can be recognized.
        #
        # The keys are the platform name, values are arrays of the matcher and the label.
        #
        # @return [Hash] The list of platform that can be recognized.
        def platforms
          rv = ActiveSupport::OrderedHash.new

          @platforms.each do |platform|
            rv[platform[0]] = platform[1, platform.length]
          end

          rv
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
          rv = true

          if [:lt, :lte, :eq, :gte, :gt].include?(operator) && v1.ensure_string.present? then
            # At first, split versions
            vv1 = v1.ensure_string.split(".").reverse
            vv2 = v2.ensure_string.split(".").reverse

            left = vv1.pop
            right = vv2.pop

            # Start comparison, picking from length
            rv = catch(:result) do
              while true do
                left = (left || "0").ensure_string
                right = (right || "0").ensure_string

                # Adjust for alpha, beta, etc
                if !left.is_integer? then
                  ll = left.length
                  left = right + left
                  right = right + ("z" * ll)
                end

                # Pad arguments to make correct string comparisons
                len = [left.length, right.length].max
                left = left.rjust(len, "0")
                right = right.rjust(len, "0")

                if left == right then # If we have still an equal version
                                      # Goto next tokens
                  left = vv1.pop
                  right = vv2.pop

                  # We end the left version, so until now all tokens were equal. Check what to do.
                  if left.blank? then
                    case operator
                      when :lt then throw(:result, right.present? && right.to_integer > 0) # The comparison is true if there is at least another right version number greater than 0.
                      when :lte then throw(:result, right.blank? || right.is_integer?) # The comparison is true if there is no other right version or that is a integer (so it means no alpha, beta etc).
                      when :eq then throw(:result, right.blank? || ([right] + vv2).uniq.first == "0") # The comparison is true if also right version ends or only zero are left.
                      when :gte then throw(:result, right.blank? || !right.is_integer?) # The comparison is true if there is no other right version or that is not a integer (so it means alpha, beta etc).
                      when :gt then throw(:result, right.present? && !right.is_integer?) # The comparison is true if there is at least another right version not a integer (so it means alpha, beta etc).
                    end
                  end

                  throw(:result, [:lte, :eq, :gte].include?(operator)) if left.blank? # If we end the left version, it means that all tokens were equal. Return accordingly
                else # We can compare a different token
                  case operator
                    when :lt, :lte then throw(:result, left < right)
                    when :eq then throw(:result, false)
                    when :gt, :gte then throw(:result, left > right)
                  end
                end
              end
            end
          else
            rv = false
          end

          rv
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
      # @return [String|Array] CSS ready information of the current browser.
      def classes(join = " ", name = "", version = "version-", platform = "platform-")
        self.parse_agent(@agent) if !@name
        rv = []
        name = "" if name == true
        version = "version-" if version == true
        platform = "platform-" if platform == true

        # Manage name
        if name then
          final_name = block_given? ? yield(@name, @version, @platform) : @name
          rv << name + final_name.ensure_string
        end

        # Manage platform
        if version then
          vbuffer = []
          vtokens = @version.split(".")

          vtokens.each do |v|
            vbuffer << v
            rv << (version + vbuffer.join("_"))
          end
        end

        rv << (platform + @platform.to_s) if platform

        # Return
        join ? rv.join(join) : rv
      end
      alias :meta :classes
    end

    # Methods to parse the user agent.
    module Parsing
      # Parses the User-Agent header.
      # @param agent [String] The User-Agent header.
      # @return [Boolean] `true` if the browser was detected, `false` otherwise.
      def parse_agent(agent = nil)
        agent = agent.ensure_string

        # At first, detect name and version. Tries order is important to avoid false positives.
        @name = catch(:name) do
          ::Brauser::Browser.browsers.each do |name, definitions|
            matched = false

            if definitions[0].is_a?(::Regexp) then
              matched = definitions[0].match(agent) ? true : false
            elsif definitions[0].respond_to?(:call) then
              matched = (definitions[0].call(agent) ? true : false)
            else
              matched = (agent == definitions[0].ensure_string)
            end

            if matched then # Found a match, go through version
              if definitions[1].is_a?(::Regexp) then
                @version = definitions[1].match(agent)
                @version = @version.to_a.last if @version.is_a?(::MatchData)
              elsif @version = definitions[1].respond_to?(:call) then
                @version = definitions[1].call(name, agent).ensure_string
              else
                @version = definitions[1].ensure_string
              end
            end

            throw(:name, name) if matched
          end

          :unknown
        end

        # Adjust version
        @version = "0.0" if @version.blank?

        # At last, detect platform
        @platform = catch(:platform) do
          ::Brauser::Browser.platforms.each do |platform, definitions|
            if definitions[0].is_a?(::Regexp) then
              matched = definitions[0].match(agent) ? true : false
            elsif definitions[0].respond_to?(:call) then
              matched = (definitions[0].call(@name, agent) ? true : false)
            else
              matched = (agent == definitions[0].ensure_string)
            end

            throw(:platform, platform) if matched
          end

          :unknown
        end

        (@name != :unknown) ? true : false
      end

      # Parses the Accept-Language header.
      #
      # @param accept_language [String] The Accept-Language header.
      # @return [Array] The list of accepted languages.
      def parse_accept_language(accept_language = nil)
        accept_language.ensure_string.gsub(/;q=[\d.]+/, "").split(",").collect {|l| l.downcase.strip }.select{|l| l.present? }
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
      # @param versions [Hash] An hash with specific version to match against. Need to be in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @param platforms [Symbol|Array] A list of specific platform to match. Valid values are all those possible for the platform attribute.
      # @return [Query] A query which can evaluated for concatenation or result.
      def is(names = [], versions = {}, platforms = [])
        self.parse_agent(@agent) if !@name
        versions = {} if !versions.is_a?(::Hash)
        platforms = platforms.ensure_array

        # Adjust names
        names = names.ensure_array.uniq.compact.collect {|n| n.ensure_string.to_sym }
        names << [:msie] if names.include?(:ie)
        names << [:chromium] if names.include?(:chrome)

        if names.delete(:capable) then
          names += [:chrome, :firefox, :safari, :opera, :msie]

          # Add version 9 as minimum for IE if capable is specified
          versions[:gte] = 9 if @name == :msie
        end

        names << [:ipad, :android, :kindle] if names.delete(:tablet)
        names.compact!

        rv = names.blank? || names.include?(@name)

        # Look also for version
        rv = rv && self.v?(versions) if rv && versions.present?

        # Look also for platforms
        rv = rv && self.on?(platforms) if rv && platforms.present?

        ::Brauser::Query.new(self, rv)
      end

      # Checks if the brower is a specific version.
      #
      # @param versions [String|Hash] A string in the form `operator version && ...` (example: `>= 7 && < 4`) or an hash with specific version to match against, in form `{:operator => version}`, where operator is one of `:lt, :lte, :eq, :gt, :gte`.
      # @return [Query] A query which can evaluated for concatenation or result.
      def v(versions = {})
        self.parse_agent(@agent) if !@version
        rv = true

        if versions.is_a?(String) then
          versions_s = versions
          versions = {}

          versions_s.split(/\s*&&\s*/).each do |token|
            next if token.strip.empty?
            tokens = token.strip.split(/\s+/).collect {|t| t.strip}
            operator = case tokens[0]
              when "<" then :lt
              when "<=" then :lte
              when "=" then :eq
              when "==" then :eq
              when ">=" then :gte
              when ">" then :gt
              else tokens[0].downcase.to_sym
            end

            versions[operator] = tokens[1]
          end
        else
          versions = {} if !versions.is_a?(::Hash)
        end

        versions.each do |operator, value|
          value = value.ensure_string
          rv = rv && Brauser::Browser.compare_versions(@version, operator, value)
          break if !rv
        end

        ::Brauser::Query.new(self, rv)
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

      # Checks if the brower is a specific version.
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
        rv = parse_query(query.ensure_string).inject(Brauser::Query.new(self, true)) { |rv, call|
          break if !rv.result
          rv.send(call[0], *call[1])
        } || Brauser::Query.new(self, false)

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
  end
end