# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper    
                     
  # shorten a string to a set number of characters to the word # append a </p> tag if needed
  # this method counts tags or formatting symbols as characters for shortening
  def truncate_words(string, count = 30, end_str=' ...')  
    trunc = string
    if string.length >= count   
      shortened = string[0, count]  
      splitted = shortened.split(/\s/)  
      words = splitted.length  
      trunc = splitted[0, words-1].join(" ") + end_str 
    end  
    trunc = trunc+'</p>' if trunc.starts_with?('<p>') # be smarter (close open tags)
    trunc
  end
  
  # create path for blogs/:blog_id/:tag_name (mapped in routes)
  def blog_tag_name_url(blog, tag, options = {})
    url_for({:only_path => false, :controller => "posts", :action => "tagged", :blog_id => "#{blog.id}", :tag => tag.name.gsub(' ', '_')}.merge(options))
  end 
  
  # create path for http://host:protocol .. etc .. /blogs/:blog_id/:year/:month/:day/:permalink (mapped in routes)
  def blog_post_permalink_url(post, options = {})
    url_for({:only_path => false, 
             :controller => "/posts", 
             :action => "permalink",  
             :blog_id => "#{post.blog.id}",
             :year => "#{post.publish_date.year}", 
             :month => "#{post.publish_date.month}", 
             :day => "#{post.publish_date.day}",
             :permalink => post.permalink}.merge(options))                          
  end
  
end
