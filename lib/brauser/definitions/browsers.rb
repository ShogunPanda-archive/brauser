# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The interface of brauser browsers.
  module Browseable
    # The default browsers definitions.
    module DefaultDefinitions
      # Default mobile browsers.
      MOBILE_BROWSERS = [
        [:coremedia, "Apple CoreMedia", /coremedia/i, /.+CoreMedia v([a-z0-9.]+)/i],

        [:opera_mobile, "Opera Mobile", /opera mobi/i, /.+Opera Mobi.+((.+Opera )|(Version\/))([a-z0-9.]+)/i],
        [:opera, "Opera", /opera/i, proc { |_, agent|
          version = ((agent !~ /wii/i) ? /((.+Opera )|(Version\/))(?<version>[a-z0-9.]+)/i : /(.+Nintendo Wii; U; ; )(?<version>[a-z0-9.]+)/i).match(agent)
          version ? version["version"] : nil
        }],

        [:android, "Android", /android/i, /(.+Android )([a-z0-9.]+)/i],
        [:blackberry, "RIM BlackBerry", /blackberry/i, /(.+Version\/)([a-z0-9.]+)/i],
        [:kindle, "Amazon Kindle", /(kindle)/i, /(.+(Kindle|Silk)\/)([a-z0-9.]+)/i],
        [:psp, "Sony Playstation Portable", /psp/i, /(.+PlayStation Portable\); )([a-z0-9.]+)/i],
        [:ps3, "Sony Playstation 3", /playstation 3/i, /(.+PLAYSTATION 3; )([a-z0-9.]+)/i],
        [:windows_phone, "Microsoft Windows Phone", /windows phone/i, /(.+IEMobile\/)([a-z0-9.]+)/i],
        [:wii, "Nintendo Wii", /nintendo wii/, /(.+Nintendo Wii; U; ; )([a-z0-9.]+)/i],

        [:chrome_ios, "Chrome iOS", /crios/i, /(.+CriOS\/)([a-z0-9.]+)/i],
        [:ipod, "Apple iPod", /ipod/i, /(.+Version\/)([a-z0-9.]+)/i],
        [:iphone, "Apple iPhone", /iphone/i, /(.+Version\/)([a-z0-9.]+)/i],
        [:ipad, "Apple iPad", /ipad/i, /(.+Version\/)([a-z0-9.]+)/i],

        [:mobile, "Other Mobile Browser", /(mobile|symbian|midp|windows ce)/i, /.+\/([a-z0-9.]+)/i]
      ]

      # Default major desktop browsers.
      MAJOR_DESKTOP_BROWSERS = [
        [:chrome, "Google Chrome", /((chrome)|(chromium))/i, /(.+Chrom[a-z]+\/)([a-z0-9.]+)/i],
        [:netscape, "Netscape Navigator", /(netscape|navigator)\//i, /((Netscape|Navigator)\/)([a-z0-9.]+)/i],
        [:firefox, "Mozilla Firefox", /firefox/i, /(.+Firefox\/)([a-z0-9.]+)/i],
        [:safari, "Apple Safari", proc { |_, agent|
          Brauser::Definition.disambiguate_browser(agent, /safari/i, /((chrome)|(chromium)|(crios))/i)
        }, /(.+Version\/)([a-z0-9.]+)/i]
      ]

      # Default Microsoft Internet Explorer browsers.
      MSIE_BROWSERS = [
        [:msie_compatibility, "Microsoft Internet Explorer (Compatibility View)", /(msie 7\.0).+(trident)/i, proc { |_, agent|
          version = /(.+trident\/)(?<version>[a-z0-9.]+)/i.match(agent)["version"].split(".")
          version[0] = version[0].to_integer + 4
          version.join(".")
        }],
        [:msie, "Microsoft Internet Explorer", proc {
          |_, agent| Brauser::Definition.disambiguate_browser(agent, /trident|msie/i, /opera/i)
        }, /(.+MSIE |trident.+rv:)([a-z0-9.]+)/i]
      ]

      # Default minor desktop browsers.
      MINOR_DESKTOP_BROWSERS = [
        [:quicktime, "Apple QuickTime", /quicktime/i, /(.+((QuickTime\/)|(qtver=)))([a-z0-9.]+)/i],
        [:webkit, "WebKit Browser", /webkit/i, /(.+WebKit\/)([a-z0-9.]+)/i],
        [:gecko, "Gecko Browser", /gecko/i, /(.+rv:|Gecko\/)([a-z0-9.]+)/i]
      ]
    end
  end
end
