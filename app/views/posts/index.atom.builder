atom_feed do |feed|
  feed.title("Blog")
  feed.updated((@posts.first.updated_at))

  for post in @posts
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.body_formatted, :type => 'html')
      entry.author do |author|
        author.name(post.user.name)
      end
    end
  end
end