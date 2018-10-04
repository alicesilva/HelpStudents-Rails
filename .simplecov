SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place
  add_filter "/app/jobs/"
  add_filter "/app/channels/"
  add_filter "/app/mailers/"

  puts 'SimpleCov started successfully!'
end
