require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do           
  
  
  describe 'named scopes' do

    it "should have a recent scope that returns tags created by a user" do
      Tag.should have_named_scope(:by_user, {:include=>:taggings, :conditions=>["taggings.user_id = ?", []]})
    end
    
  end
  
end