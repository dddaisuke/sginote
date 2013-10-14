json.array!(@notes) do |note|
  json.extract! note, :title, :body, :user_id, :published_at
  json.url note_url(note, format: :json)
end
