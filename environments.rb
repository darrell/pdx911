configure do

  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgis',
    :host     => 'localhost',
    :database => 'pdxcrimes',
    :encoding => 'utf8'
  )
end
