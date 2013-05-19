# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun_panda@me.com>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Definition do
  let(:definition) { ::Brauser::Definition.new(:tag, "Label", "ABC", /(abc)+/) }

  describe "#initialize" do
    it "should assign attributes" do
      other = ::Brauser::Definition.new("A", "B", "C", "D")
      expect(other.tag).to eq("A")
      expect(other.label).to eq("B")
      expect(other.primary).to eq("C")
      expect(other.secondary).to eq("D")
    end
  end

  describe "#match" do
    it "should apply the correct matcher and return the correct value" do
      expect(definition.match(:primary, "ABC")).to eq("ABC")
      expect(definition.match(:primary, "CDE")).to be_nil
      expect(definition.match(:secondary, "abcabc")).to be_a(MatchData)
      expect(definition.match(:secondary, "abx")).to be_nil
    end

    it "should support a block matcher" do
      definition.primary = Proc.new { |a, b, c| a + b + c }
      expect(definition.match(:primary, 1, 2, 3)).to eq(6)
    end

    it "should return nil when the matcher is not valid" do
      expect(definition.match(:tertiary)).to be_nil
    end
  end
end