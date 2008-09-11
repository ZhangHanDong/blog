atom_feed do |feed|
  feed.title("Recent comments #{ "on #{h(@post.title)}" if @post }#{ "by #{h(@user.name)}" if @user } in #{h(@blog.title)}")           
  feed.updated((@comments.empty? ? Time.now : @comments.first.updated_at))
  
  for comment in @comments
    feed.entry(comment, :url => blog_post_url(comment.post.blog, comment.post, :anchor => "comment-#{comment.id}")) do |entry|
      entry.title(h(comment.name))
      entry.content(h(comment.body), :type => 'html')
      entry.author do |author|
        author.name(h(comment.name))
      end
    end
  end   
end                                        