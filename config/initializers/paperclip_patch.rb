module Paperclip

  class Attachment
    
    # PATCH check thumbnailable, ie. is an image or PDF content type
    def self.thumbnailable?(content_type)
      [ 'image/jpeg', 'image/pjpeg',
        'image/gif', 'image/png',
        'image/x-png', 'image/jpg',
      'application/pdf' ].include?(content_type)
    end

    private

    def post_process #:nodoc:
      return if @queued_for_write[:original].nil?
      @styles.each do |name, args|
        begin
          dimensions, format = args
          dimensions = dimensions.call(instance) if dimensions.respond_to? :call
          # PATCH check to see if thumbnailable, and if PDF, then send pdf page number
          Paperclip::Attachment.thumbnailable?(@instance[:"#{@name}_content_type"]) || raise(PaperclipError.new("Can not create thumbnails \
                                                                                                                 if the content type is not an image."))
          @instance[:"#{@name}_content_type"] == 'application/pdf' ? pdf_page = '[0]' : pdf_page = nil
          @queued_for_write[name] = Thumbnail.make(@queued_for_write[:original],
          dimensions,
          format,
          @whiny_thumnails,
          pdf_page)
        rescue PaperclipError => e
          @errors << e.message if @whiny_thumbnails
        end
      end
    end

  end


  class Thumbnail
    
    def self.make file, dimensions, format = nil, whiny_thumbnails = true, pdf_page = nil
      # PATCH make call to include pdf_paging to include pdf_page e.g. [0]
      new(file, dimensions, format, whiny_thumbnails).make(pdf_page)
    end
    
    def make pdf_page = nil
      src = @file
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

      # PATCH command to include pdf_page e.g. [0]
      command = <<-end_command
        #{ Paperclip.path_for_command('convert') }
        "#{ File.expand_path(src.path) }#{pdf_page}" 
        #{ transformation_command }
        "#{ File.expand_path(dst.path) }"
      end_command
      success = system(command.gsub(/\s+/, " "))

      if success && $?.exitstatus != 0 && @whiny_thumbnails
        raise PaperclipError, "There was an error processing this thumbnail"
      end

      dst
    end

  end
  
  
end
