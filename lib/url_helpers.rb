module UrlHelpers

  def link_path(id, stats)
    "/#{id}?stats=#{stats}"
  end

  def root_path
    '/'
  end

end
