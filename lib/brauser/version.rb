#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

# A framework agnostic browser detection and querying helper.
module Brauser
  # The current version of brauser, according to semantic versioning.
  #
  # @see http://semver.org
  module Version
    # The major version.
    MAJOR = 4

    # The minor version.
    MINOR = 1

    # The patch version.
    PATCH = 2

    # The current version of brauser.
    STRING = [MAJOR, MINOR, PATCH].compact.join(".")
  end
end
