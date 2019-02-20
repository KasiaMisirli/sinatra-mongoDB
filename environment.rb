
require "mongoid"
require_relative 'models/rating_question'
Mongoid.load!("./config/mongoid.yml",:development)

Mongoid.raise_not_found_error = false