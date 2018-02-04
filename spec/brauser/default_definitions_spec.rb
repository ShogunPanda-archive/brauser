#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

require "spec_helper"

describe Brauser do
  describe "should recognize common browsers" do
    def recognize(agent = nil)
      browser = ::Brauser::Browser.new(agent)
      [browser.name, browser.version, browser.platform]
    end

    it "should return false for unknown names" do
      expect(recognize("UNKNOWN")).to eq([:unknown, "0.0", :unknown])
    end

    it "by detecting the correct name, version and platform" do
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
      expect(recognize("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73")).to eq([:opera, "16.0.1196.73", :windows])
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
      expect(recognize("Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a3.pre) Gecko/20070330")).to eq([:gecko, "1.9a3.pre", :linux])
      expect(recognize("Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.2a1pre) Gecko")).to eq([:gecko, "1.9.2a1pre", :windows])

      # QuickTime
      expect(recognize("QuickTime/7.6.2 (qtver=7.6.2;os=Windows NT 5.1Service Pack 3)")).to eq([:quicktime, "7.6.2", :windows])
      expect(recognize("QuickTime/7.6 (qtver=7.6;cpu=IA32;os=Mac 10,5,7)")).to eq([:quicktime, "7.6", :osx])

      # CoreMedia
      expect(recognize("Apple iPhone v1.1.1 CoreMedia v1.0.0.3A110a")).to eq([:coremedia, "1.0.0.3A110a", :ios])
      expect(recognize("Apple Mac OS X v10.6.6 CoreMedia v1.0.0.10J567")).to eq([:coremedia, "1.0.0.10J567", :osx])
    end
  end
end