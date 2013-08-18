# encoding: utf-8
#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Query do
  let(:browser){ ::Brauser::Browser.new("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1", "it;q=0.7, en;q=0.3") }
  let(:query) { ::Brauser::Query.new(browser, true) }

  describe "#is" do
    it "should call the final corresponding method and then return self" do
      expect(query).to receive(:is?).and_call_original
      expect(query.is(:msie)).to be(query)
    end
  end

  describe "#is?" do
    it "should call the browser's corresponding method and update the result" do
      expect(browser).to receive(:is?).with(:msie, {}, []).and_call_original
      expect(query.is?(:msie)).to be_false
    end
  end

  describe "#v" do
    it "should call the final corresponding method and then return self" do
      expect(query).to receive(:v?).and_call_original
      expect(query.v(">= 9")).to be(query)
    end
  end

  describe "#v?" do
    it "should call the browser's corresponding method and update the result" do
      expect(browser).to receive(:v?).with(">= 9").and_call_original
      expect(query.v?(">= 9")).to be_true
    end
  end

  describe "#on" do
    it "should call the final corresponding method and then return self" do
      expect(query).to receive(:on?).and_call_original
      expect(query.on(:osx)).to be(query)
    end
  end

  describe "#on?" do
    it "should call the browser's corresponding method and update the result" do
      expect(browser).to receive(:on?).with(:osx).and_call_original
      expect(query.on?(:osx)).to be_true
    end

  end

  describe "#accepts" do
    it "should call the final corresponding method and then return self" do
      expect(query).to receive(:accepts?).and_call_original
      expect(query.accepts("it")).to be(query)
    end
  end

  describe "#accepts?" do
    it "should call the browser's corresponding method and update the result" do
      expect(browser).to receive(:accepts?).with("es").and_call_original
      expect(query.accepts?("es")).to be_false
    end
  end

  describe "concatenation" do
    before(:each) do
      browser.name = :chrome
      browser.version = "7.1.2"
      browser.platform = :windows
    end

    it "should call requested methods on the browser and return a query" do
      expect(browser).to receive(:is).and_call_original
      expect(browser).to receive(:v?).and_call_original
      expect(browser).to receive(:on?).and_call_original

      expect(browser.is(:chrome).v(">= 7").on(:osx)).to be_a(::Brauser::Query)
    end

    it "should call methods while result is true" do
      expect(browser).to receive(:is).and_call_original
      expect(browser).to receive(:v?).and_call_original
      expect(browser).not_to receive(:on?)

      expect(browser.is(:chrome).v(">= 9").on(:osx)).to be_a(::Brauser::Query)
    end

    it "when the last method is the question mark, it should return the evaluation to boolean" do
      expect(browser).to receive(:is).and_call_original
      expect(browser).to receive(:v?).and_call_original
      expect(browser).to receive(:on?).and_call_original

      expect(browser.is(:chrome).v(">= 7").on?(:osx)).to be_false
    end

    it "should return the result when ending the query with #result" do
      expect(browser).to receive(:is).and_call_original
      expect(browser).to receive(:v?).and_call_original
      expect(browser).not_to receive(:on?)

      expect(browser.is(:chrome).v(">= 9").on(:osx).result).to be_false
    end
  end
end