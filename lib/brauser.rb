# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "lazier"

Lazier.load!(:object, :boolean)

require "brauser/version" unless defined?(Brauser::Version)
require "brauser/queryable/chainers"
require "brauser/queryable/queries"
require "brauser/query"
require "brauser/definitions/browsers"
require "brauser/definitions/languages"
require "brauser/definitions/platforms"
require "brauser/definition"
require "brauser/browseable/attributes"
require "brauser/browseable/general"
require "brauser/browseable/parsing"
require "brauser/browseable/partial_querying"
require "brauser/browseable/querying"
require "brauser/browseable/register"
require "brauser/browser"
require "brauser/hooks"
