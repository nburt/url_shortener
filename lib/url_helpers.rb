module UrlHelpers

  def stats_path(id)
    "/#{id}?stats=true"
  end

  def root_path
    '/'
  end

end