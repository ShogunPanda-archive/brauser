#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Parser do
  subject { ::Brauser::Parser.new }

  describe ".disambiguate" do
    it "should check if a string matches a pattern and NOT another one" do
      expect(::Brauser::Parser.disambiguate("test", /es/, /az/)).to be_truthy
      expect(::Brauser::Parser.disambiguate("test", /es/, /st/)).to be_falsey
    end
  end

  describe "#parse_agent" do
    it "should parse Agent header and return a id, version and platform" do
      expect(subject.parse_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1")).to eq([:chrome, Versionomy.parse("21.0.1180.82"), :osx])
      expect(subject.parse_agent("Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/15.0a2")).to eq([:firefox, Versionomy.parse("15.0a2"), :windows])
      expect(subject.parse_agent("UNKNOWN")).to be_nil
    end
  end

  describe "#parse_accept_language" do
    it "should parse Accept-Language and return an hash of languages with their priorities" do
      expect(subject.parse_accept_language("IT;q=0.7, EN;q=0.3")).to eq({it: 0.7, en: 0.3})
    end
  end
end