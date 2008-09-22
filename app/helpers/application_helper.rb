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
  def blog_tag_name_path(blog, tag)
    "#{blog_path(blog)}/#{tag.name.gsub(' ', '_')}"
  end
  
end
