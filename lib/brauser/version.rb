# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # The current version of brauser, according to semantic versioning.
  #
  # @see http://semver.org
  module Version
    # The major version.
    MAJOR = 3

    # The minor version.
    MINOR = 2

    # The patch version.
    PATCH = 6

    # The current version of brauser.
    STRING = [MAJOR, MINOR, PATCH].compact.join(".")
  end
end
