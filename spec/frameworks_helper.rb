# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2012 and above Shogun <shogun_panda@me.com>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "ostruct"

if !defined?(Rails) then
  module Rails
  end

  module ActionController
    class Base
      def request
        OpenStruct.new(:headers => {})
      end

      def self.helper_method(method)

      end
    end
  end
end