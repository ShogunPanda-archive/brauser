# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Browser do
  let(:browser){::Brauser::Browser.new}

  describe ".add" do
    it "should return false and not add any value when the type is invalid" do
      definitions = ::Brauser::Browser.instance_variable_get("@definitions")
      
      expect(::Brauser::Browser.add(:none, nil)).to be_false
      expect(definitions).to be_nil
    end

    it "add the definition to the right hash" do
      ::Brauser::Browser.instance_variable_set("@definitions", nil)
      definition = ::Brauser::Definition.new(:tag)

      expect(::Brauser::Browser.add(:platforms, definition)).to be_true
      definitions = ::Brauser::Browser.instance_variable_get("@definitions")
      expect(definitions[:platforms][:tag]).to be(definition)
    end

    it "support adding more definitions in one call" do
      ::Brauser::Browser.instance_variable_set("@definitions", nil)
      expect(::Brauser::Browser.add(:platforms, [::Brauser::Definition.new(:tag1), ::Brauser::Definition.new(:tag2)])).to be_true
      definitions = ::Brauser::Browser.instance_variable_get("@definitions")
      expect(definitions[:platforms].length).to eq(2)
    end
  end

  describe ".add_default_browsers" do
    it "should call .add" do
      expect(::Brauser::Browser).to receive(:add).with(:browsers, an_instance_of(Array)).and_call_original
      ::Brauser::Browser.add_default_browsers
    end

    it "should return a good return code" do
      expect(::Brauser::Browser.add_default_browsers).to be_true

      allow(::Brauser::Browser).to receive(:add).and_return(false)
      expect(::Brauser::Browser.add_default_browsers).to be_false
    end
  end

  describe ".add_default_platforms" do
    it "should call .add" do
      expect(::Brauser::Browser).to receive(:add).with(:platforms, an_instance_of(Array))
      ::Brauser::Browser.add_default_platforms
    end

    it "should return a good return code" do
      expect(::Brauser::Browser.add_default_platforms).to be_true

      allow(::Brauser::Browser).to receive(:add).and_return(false)
      expect(::Brauser::Browser.add_default_platforms).to be_false
    end
  end

  describe ".add_default_languages" do
    it "should call .add" do
      expect(::Brauser::Browser).to receive(:add).with(:languages, an_instance_of(Array))
      ::Brauser::Browser.add_default_languages
    end

    it "should return a good return code" do
      expect(::Brauser::Browser.add_default_languages).to be_true

      allow(::Brauser::Browser).to receive(:add).and_return(false)
      expect(::Brauser::Browser.add_default_languages).to be_false
    end
  end

  describe ".browsers" do
    it "should return the list of browsers" do
      ::Brauser::Browser.add_default_browsers

      expect(::Brauser::Browser.browsers).to be_a(Hash)
      expect(::Brauser::Browser.browsers[:chrome]).to be_a(::Brauser::Definition)
      expect(::Brauser::Browser.browsers[:chrome].label).to eq("Google Chrome")
    end
  end

  describe ".platforms" do
    it "should return the list of platforms" do
      ::Brauser::Browser.add_default_platforms

      expect(::Brauser::Browser.platforms).to be_a(Hash)
      expect(::Brauser::Browser.platforms[:osx]).to be_a(::Brauser::Definition)
      expect(::Brauser::Browser.platforms[:osx].label).to eq("Apple MacOS X")
    end
  end

  describe ".languages" do
    it "should return the list of languages" do
      ::Brauser::Browser.add_default_languages

      expect(::Brauser::Browser.languages).to be_a(Hash)
      expect(::Brauser::Browser.languages["it"]).to be_a(::Brauser::Definition)
      expect(::Brauser::Browser.languages["it"].label).to eq("Italian")
    end
  end

  describe ".compare_versions" do
    it "should correctly compare versions" do
      expect(::Brauser::Browser.compare_versions(nil, :eq, nil)).to be_false

      expect(::Brauser::Browser.compare_versions("3", :eq, nil)).to be_false
      expect(::Brauser::Browser.compare_versions("3", :eq, "7")).to be_false
      expect(::Brauser::Browser.compare_versions("7.1", :eq, "7")).to be_false
      expect(::Brauser::Browser.compare_versions("7.1.2", :eq, "7.1.2")).to be_true

      expect(::Brauser::Browser.compare_versions("3", :lt, "3")).to be_false
      expect(::Brauser::Browser.compare_versions("3", :lt, "3.4")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.5", :lt, "3.4.5")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.5", :lt, "3.2")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.5", :lt, "3.4.6")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.beta", :lt, "3.4")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.alpha", :lt, "3.4beta")).to be_true

      expect(::Brauser::Browser.compare_versions("3", :lte, "3")).to be_true
      expect(::Brauser::Browser.compare_versions("3", :lte, "3.4")).to be_true
      expect(::Brauser::Browser.compare_versions("4", :lte, "3.4")).to be_false
      expect(::Brauser::Browser.compare_versions("4.1", :lte, "3.4")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.5", :lte, "3.4.5")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.5", :lte, "3.4.4")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.5", :lt, "3.2")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.beta", :lte, "3.4")).to be_true

      expect(::Brauser::Browser.compare_versions("3", :gt, "3")).to be_false
      expect(::Brauser::Browser.compare_versions("3", :gt, "3.4")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.5", :gt, "3.4.3")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.5", :gt, "3.4.5")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.5", :gt, "3.4.6")).to be_false
      expect(::Brauser::Browser.compare_versions("3.5", :gt, "3")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.beta", :gt, "3.4")).to be_false
      expect(::Brauser::Browser.compare_versions("3.4.alpha", :gt, "3.4beta")).to be_false

      expect(::Brauser::Browser.compare_versions("3", :gte, "3")).to be_true
      expect(::Brauser::Browser.compare_versions("3", :gte, "3.4")).to be_false
      expect(::Brauser::Browser.compare_versions("4", :gte, "3.4")).to be_true
      expect(::Brauser::Browser.compare_versions("4.1", :gte, "3.4")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.5", :gte, "3.4.5")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.5", :gte, "3.4.4")).to be_true
      expect(::Brauser::Browser.compare_versions("3.4.beta", :gte, "3.4")).to be_false
      expect(::Brauser::Browser.compare_versions("3.5", :gt, "3")).to be_true
    end
  end

  describe "#readable_name" do
    before(:each) do
      ::Brauser::Browser.add_default_browsers
    end

    it "should return the correct name" do
      browser.name = :msie
      expect(browser.readable_name).to eq("Microsoft Internet Explorer")

      browser.name = :chrome
      expect(browser.readable_name).to eq("Google Chrome")
    end

    it "should return a default name" do
      browser.name = :none
      expect(browser.readable_name).to eq("Unknown Browser")
    end
  end

  describe "#platform_name" do
    before(:each) do
      ::Brauser::Browser.add_default_platforms
    end

    it "should return the correct name" do
      browser.platform = :windows
      expect(browser.platform_name).to eq("Microsoft Windows")

      browser.platform = :ios
      expect(browser.platform_name).to eq("Apple iOS")
    end

    it "should return a default name" do
      browser.platform = :none
      expect(browser.platform_name).to eq("Unknown Platform")
    end
  end

  describe "#classes" do
    before(:each) do
      browser.name = :chrome
      browser.version = "1.2.A.4"
      browser.platform = :osx
    end

    it "should return requested classes" do
      expect(browser.classes(false)).to eq(["chrome", "version-1", "version-1_2", "version-1_2_A", "version-1_2_A_4", "platform-osx"])
      expect(browser.classes(false, "name-")).to eq(["name-chrome", "version-1", "version-1_2", "version-1_2_A", "version-1_2_A_4", "platform-osx"])
      expect(browser.classes(false, true, "v-")).to eq(["chrome", "v-1", "v-1_2", "v-1_2_A", "v-1_2_A_4", "platform-osx"])
      expect(browser.classes(false, true, true, "p-")).to eq(["chrome", "version-1", "version-1_2", "version-1_2_A", "version-1_2_A_4", "p-osx"])
      expect(browser.classes(false, false)).to eq(["version-1", "version-1_2", "version-1_2_A", "version-1_2_A_4", "platform-osx"])
      expect(browser.classes(false, true, false)).to eq(["chrome", "platform-osx"])
      expect(browser.classes(false, true, true, false)).to eq(["chrome", "version-1", "version-1_2", "version-1_2_A", "version-1_2_A_4"])
    end

    it "should return as a string" do
      expect(browser.classes).to eq("chrome version-1 version-1_2 version-1_2_A version-1_2_A_4 platform-osx")
      expect(browser.classes("@")).to eq("chrome@version-1@version-1_2@version-1_2_A@version-1_2_A_4@platform-osx")
    end

    it "should handle msie compatibility" do
      browser.name = :msie_compatibility
      expect(browser.classes(false, true, false, false)).to eq(["msie_compatibility", "msie"])
    end

    it "should transform name" do
      expect(browser.classes(" ", true, false, false) { |name, *| name.to_s.upcase }).to eq("CHROME")
    end
  end

  describe "#parse_agent" do
    def recognize(agent = nil, only_rv = false)
      if agent.present? then
        rv = browser.parse_agent(agent)
        !only_rv ? [browser.name, browser.version, browser.platform] : rv
      else
        only_rv ? true : []
      end
    end

    it "should return true for known names" do
      expect(recognize("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1", true)).to be_true
      expect(recognize("Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/15.0a2", true)).to be_true
    end

    it "should return false for unknown names" do
      expect(recognize("UNKNOWN", true)).to be_false
    end

    it "should detect the correct name, version and platform" do
      # Google Chrome
      expect(recognize("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1")).to eq([:chrome, "21.0.1180.82", :osx])
      expect(recognize("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.9 Safari/536.5")).to eq([:chrome, "19.0.1084.9", :linux])
      expect(recognize("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.215 Safari/535.1")).to eq([:chrome, "13.0.782.215", :windows])

      # Mozilla Firefox
      expect(recognize("Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/15.0a2")).to eq([:firefox, "15.0a2", :windows])
      expect(recognize("Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:14.0) Gecko/20100101 Firefox/14.0.1")).to eq([:firefox, "14.0.1", :linux])
      expect(recognize("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0b8) Gecko/20100101 Firefox/4.0b8")).to eq([:firefox, "4.0b8", :osx])

      # Apple Safari
      expect(recognize("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.55.3 (KHTML, like Gecko) Version/5.1.3 Safari/534.53.10")).to eq([:safari, "5.1.3", :osx])
      expect(recognize("Mozilla/5.0 (Windows; U; Windows NT 5.0; en-en) AppleWebKit/533.16 (KHTML, like Gecko) Version/4.1 Safari/533.16")).to eq([:safari, "4.1", :windows])

      # Opera Mobile
      expect(recognize("Opera/9.80 (Android 2.3.3; Linux; Opera Mobi/ADR-1111101157; U; es-ES) Presto/2.9.201 Version/11.50")).to eq([:opera_mobile, "11.50", :android])
      expect(recognize("Mozilla/5.0 (S60; SymbOS; Opera Mobi/SYB-1103211396; U; es-LA; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6 Opera 11.00")).to eq([:opera_mobile, "11.00", :symbian])

      # Opera
      expect(recognize("Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00")).to eq([:opera, "12.00", :windows])
      expect(recognize("Mozilla/5.0 (Windows NT 5.1; U; en; rv:1.8.1) Gecko/20061208 Firefox/5.0 Opera 11.11")).to eq([:opera, "11.11", :windows])
      expect(recognize("Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; fr) Presto/2.9.168 Version/11.52")).to eq([:opera, "11.52", :osx])
      expect(recognize("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; de) Opera 11.51")).to eq([:opera, "11.51", :windows])

      # Microsoft Internet Explorer in compatibility view
      expect(recognize("Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/6.0)")).to eq([:msie_compatibility, "10.0", :windows])
      expect(recognize("Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET CLR 1.1.4322; .NET4.0C; Tablet PC 2.0)")).to eq([:msie_compatibility, "9.0", :windows])
      expect(recognize("Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; Zune 3.0)")).to eq([:msie_compatibility, "8.0", :windows])

      # Microsoft Internet Explorer
      expect(recognize("Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko")).to eq([:msie, "11.0", :windows])
      expect(recognize("Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64;0)")).to eq([:msie, "10.0", :windows])
      expect(recognize("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET CLR 1.1.4322; .NET4.0C; Tablet PC 2.0)")).to eq([:msie, "9.0", :windows])
      expect(recognize("Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; Zune 3.0)")).to eq([:msie, "8.0", :windows])
      expect(recognize("Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.0; fr-FR)")).to eq([:msie, "7.0", :windows])
      expect(recognize("Mozilla/4.01 (compatible; MSIE 6.0; Windows NT 5.1)")).to eq([:msie, "6.0", :windows])

      # Netscape
      expect(recognize("Mozilla/5.0 (Windows; U; Win 9x 4.90; SG; rv:1.9.2.4) Gecko/20101104 Netscape/9.1.0285")).to eq([:netscape, "9.1.0285", :windows])
      expect(recognize("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.8pre) Gecko/20071001 Firefox/2.0.0.7 Navigator/9.0RC1")).to eq([:netscape, "9.0RC1", :osx])

      # Chrome IOS
      expect(recognize("Mozilla/5.0 (iPhone; U; CPU iPhone OS 5_1_1 like Mac OS X; en-gb) AppleWebKit/534.46.0 (KHTML, like Gecko) CriOS/19.0.1084.60 Mobile/9B206 Safari/7534.48.3")).to eq([:chrome_ios, "19.0.1084.60", :ios])
      expect(recognize("Mozilla/5.0 (iPad; U; CPU iPhone OS 5_1_1 like Mac OS X; en-gb) AppleWebKit/534.46.0 (KHTML, like Gecko) CriOS/21.0.1180.82 Safari/536.5")).to eq([:chrome_ios, "21.0.1180.82", :ios])

      # Apple iPhone
      expect(recognize("Mozilla/5.0 (iPhone; U; fr; CPU iPhone OS 4_2_1 like Mac OS X; fr) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148a Safari/6533.18.5")).to eq([:iphone, "5.0.2", :ios])
      expect(recognize("Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8B5097d Safari/6531.22.7")).to eq([:iphone, "4.0.5", :ios])

      # Apple iPad
      expect(recognize("Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko ) Version/5.1 Mobile/9B176 Safari/7534.48.3")).to eq([:ipad, "5.1", :ios])
      expect(recognize("Mozilla/5.0 (iPad; U; CPU OS 4_3 like Mac OS X; nl-nl) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F190 Safari/6533.18.5")).to eq([:ipad, "5.0.2", :ios])

      # Apple iPod Touch
      expect(recognize("Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5")).to eq([:ipod, "5.0.2", :ios])
      expect(recognize("Mozilla/5.0 (iPod; U; CPU iPhone OS 3_0 like Mac OS X; ja-jp) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16")).to eq([:ipod, "4.0", :ios])

      # Android
      expect(recognize("Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30")).to eq([:android, "4.0.3", :android])
      expect(recognize("Mozilla/5.0 (Linux; U; Android 2.3.3; en-us; HTC_DesireS_S510e Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1")).to eq([:android, "2.3.3", :android])

      # RIM Blackberry
      expect(recognize("Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.1.0.346 Mobile Safari/534.11+")).to eq([:blackberry, "7.1.0.346", :blackberry])
      expect(recognize("Mozilla/5.0 (BlackBerry; U; BlackBerry 9700; pt) AppleWebKit/534.8+ (KHTML, like Gecko) Version/6.0.0.546 Mobile Safari/534.8+")).to eq([:blackberry, "6.0.0.546", :blackberry])

      # Windows Phone
      expect(recognize("Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; SAMSUNG; SGH-i917)")).to eq([:windows_phone, "9.0", :windows_phone])
      expect(recognize("Mozilla/4.0 (compatible; MSIE 7.0; Windows Phone OS 7.0; Trident/3.1; IEMobile/7.0; DELL; Venue Pro")).to eq([:windows_phone, "7.0", :windows_phone])

      # Symbian
      expect(recognize("Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaC6-00/20.0.042; Profile/MIDP-2.1 Configuration/CLDC-1.1; zh-hk) AppleWebKit/525 (KHTML, like Gecko) BrowserNG/7.2.6.9 3gpp-gba")).to eq([:mobile, "7.2.6.9", :symbian])

      # Amazon Kindle
      expect(recognize("Mozilla/4.0 (compatible; Linux 2.6.22) NetFront/3.4 Kindle/2.0 (screen 600x800)")).to eq([:kindle, "2.0", :kindle])
      expect(recognize("Mozilla/4.0 (compatible; Linux 2.6.10) NetFront/3.3 Kindle/1.0 (screen 600x800)")).to eq([:kindle, "1.0", :kindle])

      # Sony Playstation Portable
      expect(recognize("PSP (PlayStation Portable); 2.00")).to eq([:psp, "2.00", :psp])
      expect(recognize("Mozilla/4.0 (PSP (PlayStation Portable); 2.00)")).to eq([:psp, "2.00", :psp])

      # Sony Playstation 3
      expect(recognize("Mozilla/5.0 (PLAYSTATION 3; 3.55)")).to eq([:ps3, "3.55", :ps3])
      expect(recognize("Mozilla/5.0 (PLAYSTATION 3; 1.70)")).to eq([:ps3, "1.70", :ps3])

      # Nintendo Wii
      expect(recognize("Opera/9.30 (Nintendo Wii; U; ; 2071; Wii Shop Channel/1.0; en)")).to eq([:opera, "2071", :wii])
      expect(recognize("Opera/9.30 (Nintendo Wii; U; ; 2047-7;pt-br)")).to eq([:opera, "2047", :wii])

      # Mobile browsers
      expect(recognize("Mozilla/4.0 (compatible; MSIE 4.01; Windows CE; Sprint;PPC-i830; PPC; 240x320)")).to eq([:mobile, "4.0", :windows])

      # Generic Webkit
      expect(recognize("Midori/0.2.0 (X11; Linux i686; U; de-de) WebKit/531.2+")).to eq([:webkit, "531.2", :linux])
      expect(recognize("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-de) AppleWebKit/531.21.8 (KHTML, like Gecko) NetNewsWire/3.2.3")).to eq([:webkit, "531.21.8", :osx])

      # Generic Gecko
      expect(recognize("Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a3pre) Gecko/20070330")).to eq([:gecko, "1.9a3pre", :linux])
      expect(recognize("Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.2a1pre) Gecko")).to eq([:gecko, "1.9.2a1pre", :windows])

      # QuickTime
      expect(recognize("QuickTime/7.6.2 (qtver=7.6.2;os=Windows NT 5.1Service Pack 3)")).to eq([:quicktime, "7.6.2", :windows])
      expect(recognize("QuickTime/7.6 (qtver=7.6;cpu=IA32;os=Mac 10,5,7)")).to eq([:quicktime, "7.6", :osx])

      # CoreMedia
      expect(recognize("Apple iPhone v1.1.1 CoreMedia v1.0.0.3A110a")).to eq([:coremedia, "1.0.0.3A110a", :ios])
      expect(recognize("Apple Mac OS X v10.6.6 CoreMedia v1.0.0.10J567")).to eq([:coremedia, "1.0.0.10J567", :osx])

      # Generic
      browser.class.add(:browsers, ::Brauser::Definition.new(:generic, "NAME", "NAME", "NAME"))
      browser.class.add(:platforms, ::Brauser::Definition.new(:generic, "NAME", "NAME"))
      expect(recognize("NAME")).to eq([:generic, "NAME", :generic])
    end
  end

  describe "#parse_accept_language" do
    it "should parse languages" do
      expect(browser.parse_accept_language).to eq([])
      expect(browser.parse_accept_language(nil)).to eq([])
      expect(browser.parse_accept_language("IT")).to eq(["it"])
      expect(browser.parse_accept_language("IT;q=0.7, EN;q=0.3")).to eq(["it", "en"])
      expect(browser.parse_accept_language("It;q=0.7, eN;q=0.3")).to eq(["it", "en"])
      expect(browser.parse_accept_language("IT;q=0.7, ")).to eq(["it"])
    end
  end

  describe "#is" do
    it "should at first call #parse_agent" do
      browser.name = nil
      expect(browser).to receive(:parse_agent)
      browser.is
    end

    it "should recognized names" do
      browser.name = :chrome
      expect(browser.is.result).to be_true
      expect(browser.is(:chrome).result).to be_true
      expect(browser.is(:capable).result).to be_true

      browser.name = :ipad
      expect(browser.is([:tablet, :blackberry]).result).to be_true

      browser.name = :msie
      browser.version = "7.0"
      expect(browser.is(:capable).result).to be_false
      browser.version = "9.0"
      expect(browser.is(:capable).result).to be_true

      expect(browser).to receive(:version?).exactly(2).and_call_original
      expect(browser).to receive(:on?).and_call_original
      expect(browser.is(:capable, {gte: 8}).result).to be_true
      browser.platform = :windows

      expect(browser.is(:capable, {gt: 7}, [:windows]).result).to be_true
    end
  end

  describe "#is?" do
    it "should call the query and then fetch the result" do
      browser.name = :msie

      expect(browser).to receive("is").exactly(2).and_call_original

      expect(browser.is?(:chrome)).to be_false
      expect(browser.is?(:msie)).to be_true
    end
  end

  describe "#version" do
    it "should at first call #parse_agent" do
      browser.version = nil
      expect(browser).to receive(:parse_agent)
      browser.v
    end

    it "should return the version if called without arguments" do
      browser.version = "3.4.5"
      expect(browser.version).to eq("3.4.5")
    end

    it "should compare browser versions" do
      browser.version = "3.4.5"

      expect(browser.version(lt: 7).result).to be_true
      expect(browser.version(lte: 3).result).to be_false
      expect(browser.version(eq: 3).result).to be_false
      expect(browser.version(gte: 3).result).to be_true
      expect(browser.version(gt: 4).result).to be_false
      expect(browser.version(gt: 3.5).result).to be_false
      expect(browser.version(foo: "3").result).to be_false
      expect(browser.v(">= 3.5").result).to be_false
      expect(browser.v("< 7 && > 3").result).to be_true
      expect(browser.v("< 7 && > 3 && FOO NO").result).to be_true
      expect(browser.v("<= 7 && >= 3 && FOO NO").result).to be_true
      expect(browser.v("= 7 && == 3 && FOO NO").result).to be_false
    end
  end

  describe "#version?" do
    it "should call the query and then fetch the result" do
      browser.version = "7.0"
      expect(browser.version?(">= 8")).to be_false
      expect(browser.v?(">= 7")).to be_true
    end
  end

  describe "#on" do
    it "should at first call #parse_agent" do
      browser.platform = nil
      expect(browser).to receive(:parse_agent)
      browser.on
    end

    it "should detect platforms" do
      browser.platform = :windows
      expect(browser.on.result).to be_true
      expect(browser.on(:windows).result).to be_true
      expect(browser.on([:osx, :linux]).result).to be_false
    end
  end

  describe "#on?" do
    it "should call the query and then fetch the result" do
      browser.platform = :windows

      expect(browser).to receive("on").exactly(2).and_call_original

      expect(browser.on?(:osx)).to be_false
      expect(browser.on?(:windows)).to be_true
    end
  end

  describe "#accepts" do
    it "should at first call #parse_accept_language" do
      browser.languages = nil
      expect(browser).to receive(:parse_accept_language)
      browser.accepts
    end

    it "should detect languages" do
      browser.languages = []
      expect(browser.accepts.result).to be_false
      expect(browser.accepts("it").result).to be_false
      expect(browser.accepts(["it", "en"]).result).to be_false

      browser.languages = ["it", "en"]
      expect(browser.accepts(nil).result).to be_false
      expect(browser.accepts([]).result).to be_false
      expect(browser.accepts("it").result).to be_true
      expect(browser.accepts(["it", "en"]).result).to be_true
      expect(browser.accepts(["it", "es"]).result).to be_true
      expect(browser.accepts(["es", "en"]).result).to be_true
      expect(browser.accepts("es").result).to be_false
      expect(browser.accepts(["es", "de"]).result).to be_false
    end
  end

  describe "#accepts?" do
    it "should call the query and then fetch the result" do
      browser.languages = ["it"]

      expect(browser).to receive("accepts").exactly(2).and_call_original

      expect(browser.accepts?("it")).to be_true
      expect(browser.accepts?("en")).to be_false
    end
  end

  describe "#supported?" do
    it "should check if the browser is supported starting from a definition map" do
      browser.parse_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1")
      expect(browser.supported?(chrome: 21)).to be_true
      expect(browser.supported?(chrome: 31)).to be_false
      expect(browser.supported?(chrome: "21.2")).to be_false
      expect(browser.supported?(firefox: 11)).to be_false
    end

    it "should load definition files from a YAML file" do
      path = File.dirname(__FILE__) + "/../supported.yml"
      browser.parse_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1")
      expect(browser.supported?(path)).to be_true
    end
  end

  describe "#initalize" do
    it "initialized definitions" do
      expect(::Brauser::Browser).to receive(:add_default_browsers)
      expect(::Brauser::Browser).to receive(:add_default_platforms)
      expect(::Brauser::Browser).to receive(:add_default_languages)
      ::Brauser::Browser.new
    end

    it "should initialize attributes and parse them" do
      expect_any_instance_of(::Brauser::Browser).to receive(:parse_agent).with("A")
      expect_any_instance_of(::Brauser::Browser).to receive(:parse_accept_language).with("B")

      other = ::Brauser::Browser.new("A", "B")
      expect(other.agent).to eq("A")
      expect(other.accept_language).to eq("B")
    end
  end

  describe "accepts dynamic finders by" do
    before(:each) do
      browser.name = :opera_mobile
      browser.version = "2.0.0"
      browser.platform = :windows
    end

    it "calling the right method" do
      expect(browser).to receive(:is?).with("opera_mobile", {}, []).and_call_original
      expect(browser).to receive(:version?).with("< 3").and_call_original
      expect(browser).to receive(:on?).with("windows").and_call_original

      expect(browser.is_opera_mobile_v_lt_3_on_windows?).to be_true
    end

    it "returning as query" do
      expect(browser.is_opera_mobile_version_lt_3_on_windows).to be_a(::Brauser::Query)
    end

    it "returning as boolean" do
      expect(browser.is_opera_mobile_v_gt_3_on_windows?).to be_false
    end

    it "correctly analyzing version" do
      expect(browser).to receive(:is?).with("opera_mobile", {}, []).at_least(1).and_call_original

      expect(browser).to receive(:version?).with("<= 3").and_call_original
      expect(browser.is_opera_mobile_v_lte_3).to be_true

      expect(browser).to receive(:version?).with("< 3 && >= 3").and_call_original
      expect(browser.is_opera_mobile_v_lt_3_and_gte_3?).to be_false

      expect(browser).to receive(:version?).with("&& >= 3").and_call_original
      expect(browser.is_opera_mobile_v_and_gte_3?).to be_false

      expect(browser).to receive(:version?).with("< 3 &&").and_call_original
      expect(browser.is_opera_mobile_v_lt_3_and?).to be_true

      expect(browser).to receive(:version?).with("> 2").and_return(true)
      expect(browser.is_opera_mobile_v_gt_2?).to be_true

      expect(browser).to receive(:version?).with("== 3.4.5alpha").and_return(false)
      expect(browser.is_opera_mobile_v_eq_3_4_5alpha_is_3?).to be_false
    end

    it "immediately invalidate a query if one of the methods is invalid" do
      expect(browser).not_to receive(:is)
      expect(browser).not_to receive(:v)
      expect(browser).not_to receive(:on)

      expect{ browser.is_opera_mobile_vv_lt_3_on_windows? }.to raise_error(NoMethodError)
    end

    it "raising an exception for invalid finder" do
      expect{ browser.aa? }.to raise_error(NoMethodError)
      expect{ browser.isa_opera_mobile_vv_lt_3_on_windows? }.to raise_error(NoMethodError)
      expect{ browser.is_opera_mobile_v_lt_3_ona_windows? }.to raise_error(NoMethodError)
    end
  end
end