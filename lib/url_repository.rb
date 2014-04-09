class UrlRepository
  attr_reader :db

  def initialize(db)
    @db = db
    @urls_table = db[:urls]
  end

  def insert(url, vanity_url='')
    @urls_table.insert(:original_url => url, :vanity_url => vanity_url)
  end

  def get_original_url(identification)
    if identification.to_i.to_s == identification
      @urls_table[:id => identification.to_i][:original_url]
    else
      @urls_table[:vanity_url => identification][:original_url]
    end
  end

  def add_visit(identification)
    if identification.to_i.to_s == identification
      @urls_table.where(:id => identification.to_i).update(:total_visits => get_visits(identification) + 1)
    else
      @urls_table.where(:vanity_url => identification).update(:total_visits => get_visits(identification) + 1)
    end
  end

  def get_visits(identification)
    if identification.to_i.to_s == identification
      @urls_table[:id => identification.to_i][:total_visits]
    else
      @urls_table[:vanity_url => identification][:total_visits]
    end
  end

  def get_vanity_url(identification)
    if identification.to_i.to_s == identification
      @urls_table[:id => identification.to_i][:vanity_url]
    else
      identification
    end
  end
end