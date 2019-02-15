class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
    
    
    # @movies = Movie.all
    # @all_ratings = Movie.all_ratings
    
    # if params[:sort]
    #   @sorted = params[:sort]
    # else
    #   @sorted = session[:sort]
    # end

    # if params[:commit] == 'Refresh'
    #   if params[:ratings]
    #     @rating_filter = params[:ratings].keys
    #   else  # press 'Refresh' while selecting nothing
    #     @rating_filter = @all_ratings
    #     @sorted = nil
    #   end
    # else
    #   if params[:ratings]
    #     @ratings_filter = (params[:ratings].is_a?(Hash)) ? params[:ratings].keys : params[:ratings]
    #   else
    #     if session[:ratings]
    #       @rating_filter = session[:ratings]
    #     else
    #       @rating_filter = @all_ratings
    #     end
    #   end
    # end
    
    # if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
    #   session[:sort] = @sorted
    #   session[:ratings] = @rating_filter
    #   redirect_to :sort => @sorted, :ratings => @rating_filter and return
    # end
    
    # @movies = @movies.sorting(@sorted)
    # @movies = @movies.with_ratings(@rating_filter)

  end




  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
