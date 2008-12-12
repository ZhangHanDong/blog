require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  
  include ApplicationHelper


  describe "truncate words method" do
    it "should truncate words to certain length (chars), to the word" do
      truncate_words('believe it or not, I\'m walking').should eql('believe it or not, I\'m ...')
      truncate_words('believe it or not, I\'m walking on air, never thought', 50).should 
          eql('believe it or not, I\'m walking on air, never ...')
          
      truncate_words('believe it or not, I\'m walking', 10, '[end transmission]').should 
          eql('believe[end transmission]')
    end

    it "should truncate words to certain length and put a closing p tag" do
      truncate_words('<p>believe it or not, I\'m walking</p>').should
          eql('<p>believe it or not, I\'m ...</p>')
    end
  end


  describe "blog_tag_name_url generation" do

    before(:each) do
      @blog = mock_model(Blog)
    end

    it "should generate relative path to tag name via blog/id" do
      tag = mock_model(Tag, :name => 'mr bo jangles')
      blog_tag_name_url(@blog, tag).should eql("http://test.host/blogs/#{@blog.id}/mr_bo_jangles")
    end

    it "should generate relative path to tag name atom feed" do
      tag = mock_model(Tag, :name => 'mr bo jangles')
      blog_tag_name_url(@blog, tag, {:format => :atom}).should 
                        eql("http://test.host/blogs/#{@blog.id}/mr_bo_jangles.atom")
    end

    it "should play nice converting crazy tag names" do
      tag = mock_model(Tag, :name => 'mr     \nâ Â, ê Ê, î Î, ô Ô, û Û, ŵ jangles')
      blog_tag_name_url(@blog, tag).should
      eql("http://test.host/blogs/#{@blog.id}/mr_____%5Cn%C3%A2_%C3%82,_%C3%AA_%C3%8A,_%C3%AE_%C3%8E,_%C3%B4_%C3%94,_%C3%BB_%C3%9B,_%C5%B5_jangles")
    end
  end


  describe "javascript including" do

    it "should accept string and/or array of files for including" do
      self.should_receive(:content_for).with(:javascript).exactly(3).times
      javascript("<script>TimeInWordsHelper.convertBySelector('.updated');</script>")
      javascript("", ['file_1.js', 'file_2.js'])
      javascript("<script>TimeInWordsHelper.convertBySelector('.updated');</script>",
                 ['file_1.js', 'file_2.js'])
    end
  end

end
