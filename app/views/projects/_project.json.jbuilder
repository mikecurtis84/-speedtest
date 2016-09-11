json.extract! project, :id, :name, :urls, :schedule, :location, :startdate, :created_at, :updated_at
json.url project_url(project, format: :json)