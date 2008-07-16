require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
   
   include ApplicationHelper                            

   describe "truncate words method" do
     it "should truncate words to certain length (chars), to the word" do
       truncate_words('believe it or not, I\'m walking on air, never thought I would be so free').should eql('believe it or not, I\'m ...')
       truncate_words('believe it or not, I\'m walking on air, never thought I would be so free', 50).should eql('believe it or not, I\'m walking on air, never ...')
       truncate_words('believe it or not, I\'m walking on air, never thought I would be so free', 10, '[end transmission]').should eql('believe[end transmission]')     
     end

     it "should truncate words to certain length and put a closing p tag" do
       truncate_words('<p>believe it or not, I\'m walking on air, never thought I would be so free</p>').should eql('<p>believe it or not, I\'m ...</p>')
     end
   end

end
