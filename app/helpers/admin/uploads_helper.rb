module Admin::UploadsHelper
  
  # shorten a file name string but still maintain file extension at the end
  def truncate_filename(filename, count = 6, mid_str='...')  
    trunc = filename
    last_dot = filename.rindex('.')
    if filename.length >= (count+9)   
      trunc = filename[0, count]+mid_str+filename[last_dot-2, last_dot-1]
    end    
    trunc
  end
  
end
