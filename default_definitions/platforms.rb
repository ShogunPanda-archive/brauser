#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

# Mobile
Brauser::Definitions.register(:platform, :symbian, "Symbian", /s60|symb/i)
Brauser::Definitions.register(:platform, :windows_phone, "Microsoft Windows Phone", /windows phone/i)
Brauser::Definitions.register(:platform, :kindle, "Nokia Symbian", /kindle|silk/i)
Brauser::Definitions.register(:platform, :ios, "Apple iOS", ->(header, engine) {
  [:iphone, :ipad, :ipod, :chrome_ios].include?(engine) || header =~ /ipad|iphone|ipod|crios/i
})
Brauser::Definitions.register(:platform, :android, "Android", /android/i)
Brauser::Definitions.register(:platform, :blackberry, "RIM BlackBerry", /blackberry/i)

# Console
Brauser::Definitions.register(:platform, :psp, "Sony Playstation Portable", /psp/i)
Brauser::Definitions.register(:platform, :ps3, "Sony Playstation 3", /playstation 3/i)
Brauser::Definitions.register(:platform, :wii, "Nintendo Wii", /wii/i)

# Desktop
Brauser::Definitions.register(:platform, :linux, "Linux", /linux/i)
Brauser::Definitions.register(:platform, :osx, "Apple MacOS X", /mac|macintosh|mac os x/i)
Brauser::Definitions.register(:platform, :windows, "Microsoft Windows", /windows/i)
