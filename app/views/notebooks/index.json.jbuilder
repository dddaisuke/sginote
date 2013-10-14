json.array!(@notebooks) do |notebook|
  json.extract! notebook, :title, :user_id, :notes_count, :published_at
  json.url notebook_url(notebook, format: :json)
end
