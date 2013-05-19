# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun_panda@me.com>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Hooks::RubyOnRails do
  let(:controller){::ActionController::Base.new}

  it "should append to ActionController::Base" do
    expect(::ActionController::Base.new.respond_to?(:browser)).to be_true
  end

  it "should memoize browser" do
    browser = controller.browser
    expect(browser).to be_a(::Brauser::Browser)
    expect(controller.browser).to eq(browser)
  end

  it "should detect browser again" do
    browser = controller.browser
    expect(controller.browser(true)).not_to eq(browser)
  end
end