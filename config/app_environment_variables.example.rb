ENV['ELASTICSEARCH_URL'] = 'http://localhost:9200' # elasticsearch client uses the ENV variable

if Rails.env.test?
  ENV['ELASTICSEARCH_URL'] = 'http://localhost:9250'
end