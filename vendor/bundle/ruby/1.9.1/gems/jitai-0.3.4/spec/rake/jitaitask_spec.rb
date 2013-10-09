require "spec_helper"

describe "Jitai rake utility" do
  context "refreshing a font directory" do
    before :each do 
      %x{rake jitai:refresh}
    end

    # Currently just using naiive file exists test
    # the rake task doesn't do much else :\
    it "should create a public/fonts directory if it doesn't already exist" do
      File.exists?("public/fonts").should == true
    end

    it "should create a public/stylesheets directory if it doesn't already exist" do
      File.exists?("public/stylesheets").should == true
    end

    it "should create both mozilla and ie compatible css stylesheet" do
      File.exists?("public/stylesheets/fonts_moz.css").should == true
      File.exists?("public/stylesheets/fonts_ie.css").should == true
    end

    it "should provide conversion for true-type fonts to .eot font types" do
      File.exists?("public/fonts/yardsale.eot").should == true
    end
  end
end
