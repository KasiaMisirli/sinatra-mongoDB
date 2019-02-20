require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'mongo'
require 'json'

require_relative "environment"

before do
  response.headers["Access-Control-Allow-Methods"] = "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization", "Content-Type", "Accept", "X-User-Email", "X-Auth-Token"
  response.headers['Access-Control-Allow-Origin'] = "http://localhost:3000"
  content_type :json
  rating_questions = JSON.parse(File.read('db.json'))['ratingQuestions']
end

options "*" do 
  200
end


def serialize_question(question)
  {
    id: question.id.to_s,
    title: question.title,
    tag: question.tag
  }
end


get '/ratingQuestions' do
  RatingQuestion.all.map do |question|
    serialize_question(question)
  end.to_json
end

get '/ratingQuestions/:id' do
  this_id = params[:id]
  question = RatingQuestion.find(this_id)

  if !question
    response.status = 404
    response
  else
    single = serialize_question(question).to_json
  end

  if single 
    response.status = 200
  end

  single
end

post '/ratingQuestions' do
  error = {"errors"=>{"title"=>["can't be blank"]}}

  if request.body.size.zero?
    return 400
  end

  json_params = JSON.parse(request.body.read)
  question = RatingQuestion.create(json_params)

  if question.title == '' 
    response.body = error.to_json
    response.status = 422 
    return response
  else
    question.save
  end
  
  response.body = serialize_question(question).to_json
  response.status = 201
  response
end

delete '/ratingQuestions/:id' do
  this_id = params[:id]
  question = RatingQuestion.find(this_id)

  if question == nil
    response.status = 404
    return response
  else
    question.delete
  end
 
  response.status = 204 
  response
end

put '/ratingQuestions/:id' do

  json_params = JSON.parse(request.body.read)
  this_id = params[:id]
  question = RatingQuestion.find(this_id)

  if question == nil
    response.status = 404
    return response
  else
    question.update(json_params)
  end
 
  if question
    response.status = 200
    response.body = question.to_json
    response
  end

end

patch '/ratingQuestions/:id' do
  json_params = JSON.parse(request.body.read)
  this_id = params[:id]
  question = RatingQuestion.find(this_id)

  if question == nil
    response.status = 404
    return response
  else
    question.update(json_params)
  end

  if question
    response.status = 200
    response.body = question.to_json
    response
  end

end
