atom_feed do |feed|
  feed.title("Recent posts#{ " by #{h(@user.name)}" if @user }#{ " tagged with #{h(@tag.name)}" if @tag } in #{h(@blog.title)}")   
  feed.updated((@posts.empty? ? Time.now : @posts.first.updated_at))

  for post in @posts
    feed.entry(post, :url => blog_post_url(post.blog, post)) do |entry|
      entry.title(h(post.title))
      entry.content(post.body_formatted, :type => 'html')
      entry.author do |author|
        author.name(h(post.user.name))
      end
    end
  end
end