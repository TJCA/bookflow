json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :user, :item, :status
  json.url appointment_url(appointment, format: :json)
end
