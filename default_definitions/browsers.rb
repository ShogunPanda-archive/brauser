#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

# Mobile
Brauser::Definitions.register(:browser, :coremedia, "Apple CoreMedia", /coremedia/i, /.+CoreMedia v([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :opera_mobile, "Opera Mobile", /opera mobi/i, /.+Opera Mobi.+((.+Opera )|(Version\/))([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :opera, "Opera", /(opera)|(opr)/i, ->(header) {
  pattern = header !~ /wii/i ? /((.+Opera )|(OPR\/)|(Version\/))(?<version>[a-z0-9.]+)/i : /(.+Nintendo Wii; U; ; )(?<version>[a-z0-9.]+)/i
  mo = pattern.match(header)
  mo ? mo["version"] : nil
})
Brauser::Definitions.register(:browser, :android, "Android", /android/i, /(.+Android )([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :blackberry, "RIM BlackBerry", /blackberry/i, /(.+Version\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :kindle, "Amazon Kindle", /(kindle)/i, /(.+(Kindle|Silk)\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :psp, "Sony Playstation Portable", /psp/i, /(.+PlayStation Portable\); )([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :ps3, "Sony Playstation 3", /playstation 3/i, /(.+PLAYSTATION 3; )([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :windows_phone, "Microsoft Windows Phone", /windows phone/i, /(.+IEMobile\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :wii, "Nintendo Wii", /nintendo wii/, /(.+Nintendo Wii; U; ; )([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :chrome_ios, "Chrome iOS", /crios/i, /(.+CriOS\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :ipod, "Apple iPod", /ipod/i, /(.+Version\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :iphone, "Apple iPhone", /iphone/i, /(.+Version\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :ipad, "Apple iPad", /ipad/i, /(.+Version\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :mobile, "Other Mobile Browser", /(mobile|symbian|midp|windows ce)/i, /.+\/([a-z0-9.]+)/i)

# Major desktop
Brauser::Definitions.register(:browser, :chrome, "Google Chrome", ->(header) {
  ::Brauser::Parser.disambiguate(header, /((chrome)|(chromium))/i, /opr\//i)
}, /(.+Chrom[a-z]+\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :netscape, "Netscape Navigator", /(netscape|navigator)\//i, /((Netscape|Navigator)\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :firefox, "Mozilla Firefox", /firefox/i, /(.+Firefox\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :safari, "Apple Safari", ->(header) {
  ::Brauser::Parser.disambiguate(header, /safari/i, /((chrome)|(chromium)|(crios)|(opr))/i)
}, /(.+Version\/)([a-z0-9.]+)/i)

# Microsoft Internet Explorer
Brauser::Definitions.register(:browser, :msie_compatibility, "Microsoft Internet Explorer (Compatibility View)", /(msie 7\.0).+(trident)/i, ->(header) {
  version = /(.+trident\/)(?<version>[a-z0-9.]+)/i.match(header)["version"].split(".")
  version[0] = version[0].to_integer + 4
  version.join(".")
})
Brauser::Definitions.register(:browser, :msie, "Microsoft Internet Explorer", ->(header) {
  ::Brauser::Parser.disambiguate(header, /trident|msie/i, /opera/i)
}, /(.+MSIE |trident.+rv:)([a-z0-9.]+)/i)

# Minor desktop
Brauser::Definitions.register(:browser, :quicktime, "Apple QuickTime", /quicktime/i, /(.+((QuickTime\/)|(qtver=)))([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :webkit, "WebKit Browser", /webkit/i, /(.+WebKit\/)([a-z0-9.]+)/i)
Brauser::Definitions.register(:browser, :gecko, "Gecko Browser", /gecko/i, /(.+rv:|Gecko\/)([a-z0-9.]+)/i)