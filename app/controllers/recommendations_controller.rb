require 'dotenv/load'
require 'net/http'
require 'json'
require 'openai'

class RecommendationsController < ApplicationController
  before_action :load_user_data, only: [:index, :show]
  def index
    if params[:query].present?
      gpt_query = GptQuery.create(query: params[:query], user: current_user)
      redirect_to recommendation_path(gpt_query)
    else
      load_user_data
    end
  end

  def show
    @gpt_query = GptQuery.find(params[:id])
    @movies = @gpt_query.movies
  end

  private

  def load_user_data
    @queries = GptQuery.where(user: current_user).to_a
    @movies = current_user.query_movies.to_a.map { |query| Movie.find(query.movie_id) }.uniq
    @favorites = Favorite.where(user: current_user).to_a.map(&:movie)
    @lists = List.where(user: current_user).order(updated_at: :asc)
  end
end
