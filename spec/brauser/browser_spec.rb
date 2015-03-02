#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Browser do
  subject {
    Brauser::Browser.new(
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1",
      "IT;q=0.7, EN;q=0.3"
    )
  }

  describe "#initialize" do
    it "should save agent and language, then call #parse" do
      expect_any_instance_of(::Brauser::Browser).to receive(:parse)
      subject = ::Brauser::Browser.new("AGENT", "LANGUAGE")
      expect(subject.agent).to eq("AGENT")
      expect(subject.accept_language).to eq("LANGUAGE")
    end
  end

  describe "#classes" do
    it "should return CSS compatible version of the classes" do
      expect(subject.classes).to eq("chrome version-21 version-21_0 version-21_0_1180 version-21_0_1180_82 version-21_0_1180_82_final version-21_0_1180_82_final_0 version-21_0_1180_82_final_0_0 platform-osx")
    end

    it "should return results as an array" do
      expect(subject.classes(nil)).to eq(["chrome", "version-21", "version-21_0", "version-21_0_1180", "version-21_0_1180_82", "version-21_0_1180_82_final", "version-21_0_1180_82_final_0", "version-21_0_1180_82_final_0_0", "platform-osx"])
    end

    it "should use prefixes" do
      expect(subject.classes(name: "NAME-")).to eq("NAME-chrome version-21 version-21_0 version-21_0_1180 version-21_0_1180_82 version-21_0_1180_82_final version-21_0_1180_82_final_0 version-21_0_1180_82_final_0_0 platform-osx")
      expect(subject.classes(version: "VERSION-")).to eq("chrome VERSION-21 VERSION-21_0 VERSION-21_0_1180 VERSION-21_0_1180_82 VERSION-21_0_1180_82_final VERSION-21_0_1180_82_final_0 VERSION-21_0_1180_82_final_0_0 platform-osx")
      expect(subject.classes(platform: "PLATFORM-")).to eq("chrome version-21 version-21_0 version-21_0_1180 version-21_0_1180_82 version-21_0_1180_82_final version-21_0_1180_82_final_0 version-21_0_1180_82_final_0_0 PLATFORM-osx")
    end

    it "should skip unwanted parts" do
      expect(subject.classes(version: nil)).to eq("chrome platform-osx")
      expect(subject.classes(platform: nil)).to eq("chrome version-21 version-21_0 version-21_0_1180 version-21_0_1180_82 version-21_0_1180_82_final version-21_0_1180_82_final_0 version-21_0_1180_82_final_0_0")
    end
  end

  describe "#accepts?" do
    it "should return whether the browser accept at least one of the languages" do
      expect(subject.accepts?("IT")).to be_truthy
      expect(subject.accepts?("IT", :en)).to be_truthy
      expect(subject.accepts?("ES", :de)).to be_falsey
      expect(subject.accepts?).to be_falsey
    end
  end

  describe "#is?" do
    describe "should check if the browser matches several criteria" do
      it "- name" do
        expect(subject.is?(name: :chrome)).to be_truthy
        expect(subject.is?(name: [:firefox, :chrome])).to be_truthy
        expect(subject.is?(name: :opera)).to be_falsey
      end

      it "- engine" do
        expect(subject.is?(engine: :chrome)).to be_truthy
        expect(subject.is?(engine: [:firefox, :chrome])).to be_truthy
        expect(subject.is?(engine: :opera)).to be_falsey
        expect(subject.is?(name: :chrome, engine: :opera)).to be_truthy
      end

      it "- version" do
        expect(subject.is?(version: "> 21")).to be_truthy
        expect(subject.is?(version: "> 21 && < 22")).to be_truthy
        expect(subject.is?(version: "> 23")).to be_falsey
        expect(subject.is?(version: "> 21 && > 21.0.2000")).to be_falsey
        expect(subject.is?(version: "capable")).to be_truthy

        subject = Brauser::Browser.new("Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/32.0")
        expect(subject.is?(version: "capable")).to be_truthy

        subject = Brauser::Browser.new("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET CLR 1.1.4322; .NET4.0C; Tablet PC 2.0")
        expect(subject.is?(version: "capable")).to be_falsey
      end

      it "- platform" do
        expect(subject.is?(platform: :osx)).to be_truthy
        expect(subject.is?(platform: [:windows, :osx])).to be_truthy
        expect(subject.is?(engine: :linux)).to be_falsey
      end

      it "- languages" do
        expect(subject.is?(languages: :it)).to be_truthy
        expect(subject.is?(languages: [:es, :en])).to be_truthy
        expect(subject.is?(languages: :de)).to be_falsey
      end

      it "- combination" do
        expect(subject.is?(name: :chrome, version: "> 21")).to be_truthy
        expect(subject.is?(name: :chrome, version: "> 21 && < 22")).to be_truthy
        expect(subject.is?(version: "> 21", platform: :osx)).to be_truthy
      end
    end
  end

  describe "#supported?" do
    it "should check whether the browser is supported" do
      expect(subject.supported?({chrome: 21})).to be_truthy
      expect(subject.supported?({chrome: 20})).to be_truthy
      expect(subject.supported?({chrome: 22})).to be_falsey
      expect(subject.supported?({})).to be_falsey
    end

    it "should load from a file" do
      expect(YAML).to receive(:load_file).with("/dev/null").and_return({chrome: 21})
      expect(subject.supported?("/dev/null")).to be_truthy
    end
  end

  describe "#method_missing" do
    it "should attempt to run #is? with the method as name if it ends with a ?" do
      expect(subject.chrome?).to be_truthy
      expect(subject.firefox?).to be_falsey
    end

    it "should fallback to the original for the rest" do
      expect { subject.not_supported }.to raise_error(NoMethodError)
    end
  end
end