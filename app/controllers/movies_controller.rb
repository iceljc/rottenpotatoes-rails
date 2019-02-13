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
    # @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    @checked_ratings = params[:ratings] if params.has_key? 'ratings'
    @sorted = params[:sort] if params.has_key? 'sort'

    # session.clear where user submit empty rating filters
    if params.has_key? 'utf8'
      session.delete :checked_ratings
      session.delete :sorted
    end

    # update session from incoming params
    session[:checked_ratings] = @checked_ratings if @checked_ratings
    session[:sorted] = @sorted if @sorted

    if !@checked_ratings && !@sorted && session[:checked_ratings]
      @checked_ratings = session[:checked_ratings] unless @checked_ratings
      @sorted = session[:sorted] unless @sorted

      flash.keep
      redirect_to movies_path({sort: @sorted, ratings: @checked_ratings})
    end

    if @checked_ratings
      if @sorted      
        @movies = Movie.find_all_by_rating(@checked_ratings, :order => "#{@sorted} asc")
      else
        @movies = Movie.find_all_by_rating(@checked_ratings)
      end
    elsif @sorted
      @movies = Movie.all(:order => "#{@sorted} asc")
    else 
      @movies = Movie.all
    end
    
    
    
    
    
    # if params[:commit] == 'Refresh'
    #   if params[:ratings]
    #     @rating_filter = params[:ratings].keys
    #   else
    #     @rating_filter = @all_ratings
    #   end
    # else
    #   if session[:ratings]
    #     @rating_filter = session[:ratings]
    #   else
    #     @rating_filter = @all_ratings
    #   end
    # end
    
    # if params[:sort] != session[:sort]
    #   session[:sort] = @sorted
    # end
    # if params[:ratings] != session[:ratings]
    #   session[:ratings] = @rating_filter
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
