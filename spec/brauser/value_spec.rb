#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

require "spec_helper"

describe Brauser::Value do
  subject { ::Brauser::Value.new(1) }

  describe "#initialize" do
    it "should save the value" do
      expect(subject.value).to eq(1)
    end
  end

  describe "#==" do
    it "should compare against a value or an array of value" do
      expect(subject).to eq(1)
      expect(subject).not_to eq(2)
      expect(subject).to eq([1, 2])
    end
  end

  describe "it should delegate the rest to the value" do
    it "- #to_s" do
      expect(subject.to_s).to eq("1")
    end

    it "- #method_missing" do
      expect(subject.odd?).to be_truthy
    end
  end
end