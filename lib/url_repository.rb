class UrlRepository
  attr_reader :db

  def initialize(db)
    @db = db
    @urls_table = db[:urls]
  end

  def insert(url)
    @urls_table.insert(:original_url => url)
  end

  def display_all
    @urls_table.all
  end

  def display_row(id)
    @urls_table[:id => id]
  end

  def add_visit(id)
    @urls_table.where(:id => id).update(:total_visits => get_visits(id)+ 1)
  end

  def get_visits(id)
    @urls_table[:id => id][:total_visits]
  end

end