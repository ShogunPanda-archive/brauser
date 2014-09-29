#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Definitions::Platform do
  subject { ::Brauser::Definitions::Platform.new(:platform, "PLATFORM", /platform/) }

  describe "#initialize" do
    it "should save the id, the name and the pattern" do
      expect(subject.id).to eq(:platform)
      expect(subject.name).to eq("PLATFORM")
      expect(subject.matcher).to eq(/platform/)
    end
  end

  describe "#match" do
    it "should run against the pattern and return its result" do
      result = subject.match("This is the platform", "ENGINE")
      expect(result).to be_a(::MatchData)

      result = subject.match("This is invalid", "ENGINE")
      expect(result).to be_nil
    end

    it "should run against the given block" do
      result = ::Brauser::Definitions::Platform.new(:platform, "PLATFORM", ->(header, engine) { "#{header}-#{engine}" }).match("HEADER", "ENGINE")
      expect(result).to eq("HEADER-ENGINE")

      result = (::Brauser::Definitions::Platform.new(:platform, "PLATFORM"){ |header| header.reverse }).match("HEADER", "ENGINE")
      expect(result).to eq("REDAEH")
    end
  end
end