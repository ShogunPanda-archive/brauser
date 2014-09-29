#
# This file is part of the brauser gem. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

require "spec_helper"

describe Brauser::Definitions::Language do
  subject { ::Brauser::Definitions::Language.new("it_CH", "Italian/ Switzerland") }

  describe "#initialize" do
    it "should save the code as id and code, and also save the name" do
      expect(subject.id).to eq(:"it-ch")
      expect(subject.code).to eq("it-ch")
      expect(subject.name).to eq("Italian/ Switzerland")
    end
  end
end