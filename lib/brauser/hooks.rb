# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module Brauser
  # A set of Hooks for adding brauser to web frameworks.
  module Hooks
    # Hook for integration with Ruby on Rails.
    module RubyOnRails
      # Includes brauser in ActionController.
      #
      # @param base [Class] The base controller class.
      def self.included(base)
        base.send(:helper_method, :browser)
      end

      # Detects the current browser.
      #
      # @param force [Boolean] If to force detection.
      # @return [Browser] The detected browser.
      def browser(force = false)
        @browser = nil if force
        @browser ||= Browser.new(request.headers["User-Agent"], request.headers["Accept-Language"])
      end
    end
  end
end

ActionController::Base.send(:include, Brauser::Hooks::RubyOnRails) if defined?(Rails)
