Sequel.migration do
  change do
    add_column :urls, :vanity_url, String, :unique => true
  end
end