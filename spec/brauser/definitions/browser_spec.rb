#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

require "spec_helper"

describe Brauser::Definitions::Browser do
  subject { ::Brauser::Definitions.browsers[:opera] }

  describe "#initialize" do
    it "should save the id, the name and the pattern" do
      subject = ::Brauser::Definitions::Browser.new(:browser, "BROWSER", /engine/, /version/)
      expect(subject.id).to eq(:browser)
      expect(subject.name).to eq("BROWSER")
      expect(subject.engine_matcher).to eq(/engine/)
      expect(subject.version_matcher).to eq(/version/)
    end
  end

  describe "#match" do
    it "should run against the engine pattern and the version pattern" do
      result = subject.match("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; de) Opera 11.51")
      expect(result.first).to eq(:opera)
    end

    it "should also fetch the version" do
      result = subject.match("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; de) Opera 11.51")
      expect(result[1]).to eq(::Versionomy.parse("11.51"))

      result = subject.match("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; de) Opera")
      expect(result[1]).to eq(::Versionomy.parse("0.0"))

      subject.instance_variable_set(:@version_matcher, ->(_) { "123" })
      result = subject.match("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; de) Opera")
      expect(result[1]).to eq("123")
    end

    it "should also fetch the platform" do
      result = subject.match("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; de) Opera 11.51")
      expect(result[2]).to eq(:windows)

      result = subject.match("Mozilla/5.0 (compatible; MSIE 9.0; FOO 6.1; de) Opera 11.51")
      expect(result[2]).to eq(nil)
    end
  end
end