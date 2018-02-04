#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at https://choosealicense.com/licenses/mit.
#

require "spec_helper"

describe ::Brauser::Definitions do
  describe ".register" do
    it "should register a new definition" do
      dummy = ::OpenStruct.new(id: :definition)
      expect(::Brauser::Definitions::Browser).to receive(:new).with("A", "B", "C", a: 1, b: 2, c:3).and_return(dummy)
      ::Brauser::Definitions.register(:browser, "A", "B", "C", a: 1, b: 2, c:3)
      expect(::Brauser::Definitions.browsers[:definition]).to be(dummy)
      ::Brauser::Definitions.browsers.delete(:definition)
    end

    it "should raise an error for invalid types" do
      expect { ::Brauser::Definitions.register(:none, "A", "B", "C", a: 1, b: 2, c:3) }.to raise_error(::ArgumentError)
    end
  end

  describe ".browsers" do
    it "should return the list of browsers" do
      expect(::Brauser::Definitions.browsers).to include(:chrome)
    end
  end

  describe ".platforms" do
    it "should return the list of platforms" do
      expect(::Brauser::Definitions.platforms).to include(:osx)
    end
  end

  describe ".languages" do
    it "should return the list of languages" do
      expect(::Brauser::Definitions.languages).to include(:it)
    end
  end
end

describe ::Brauser::Definitions::Base do
  describe "#match" do
    it "should raise an error" do
      expect { ::Brauser::Definitions::Base.new.match(:unused) }.to raise_error(::RuntimeError)
    end
  end
end