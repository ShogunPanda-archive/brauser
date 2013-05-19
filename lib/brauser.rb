# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun_panda@me.com>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "lazier"

Lazier.load!(:object)

require "brauser/version" if !defined?(Brauser::Version)
require "brauser/query"
require "brauser/definition"
require "brauser/browser"
require "brauser/hooks"