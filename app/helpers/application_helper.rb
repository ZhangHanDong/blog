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
    trunc = trunc+'</p>' if trunc.starts_with?('<p>')
    trunc
  end
  
end
