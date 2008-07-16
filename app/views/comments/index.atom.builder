atom_feed do |feed|
  feed.title("#{h(@post.title)} Comments")
  feed.updated((@post.comments.first.updated_at))

  for comment in @post.comments
    feed.entry(comment, :url => post_url(@post, :anchor => "comment-#{comment.id}")) do |entry|
      entry.title(comment.name)
      entry.content(comment.body, :type => 'html')
      entry.author do |author|
        author.name(comment.name)
      end
    end
  end   
end                                        