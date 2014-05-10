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
      # Default platforms.
      PLATFORMS = [
        [:symbian, "Symbian", /s60|symb/i],
        [:windows_phone, "Microsoft Windows Phone", /windows phone/i],
        [:kindle, "Nokia Symbian", /kindle|silk/i],
        [:ios, "Apple iOS", proc { |_, agent| [:iphone, :ipad, :ipod, :chrome_ios].include?(name) || agent =~ /ipad|iphone|ipod|crios/i }],
        [:android, "Android", /android/i],
        [:blackberry, "RIM BlackBerry", /blackberry/i],
        [:psp, "Sony Playstation Portable", /psp/i],
        [:ps3, "Sony Playstation 3", /playstation 3/i],
        [:wii, "Nintendo Wii", /wii/i],

        [:linux, "Linux", /linux/i],
        [:osx, "Apple MacOS X", /mac|macintosh|mac os x/i],
        [:windows, "Microsoft Windows", /windows/i]
      ]
    end
  end
end
