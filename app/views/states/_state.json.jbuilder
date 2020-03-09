json.extract! state, :id, :name, :tested, :positive, :deaths, :tested_crawl_date, :positive_crawl_date, :deaths_crawl_date, :tested_source, :positive_source, :deaths_source, :created_at, :updated_at
json.url state_url(state, format: :json)
