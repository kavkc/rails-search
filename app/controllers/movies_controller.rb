class MoviesController < ApplicationController
  def index
    # if need to fileter by a word present in title or synopsis
    # if params[:query].present?
    #   sql_query = "title ILIKE :query OR synopsis ILIKE :query"
    #   @movies = Movie.where(sql_query, query: "%#{params[:query]}%")

    if params[:query].present?
      # sql_query = <<~SQL
      #   movies.title @@ :query
      #   OR movies.synopsis @@ :query
      #   OR directors.first_name @@ :query
      #   OR directors.last_name @@ :query
      # SQL
      # @movies = Movie.joins(:director).where(sql_query, query: "%#{params[:query]}%")
      # @movies = Movie.search_by_title_and_synopsis(params[:query])
      results = PgSearch.multisearch(params[:query])
      @movies = []
      results.each do |result|
        @movies << Movie.find(result.searchable_id)
      end
    else
      @movies = Movie.all
    end
  end
end
