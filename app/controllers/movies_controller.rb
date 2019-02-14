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
    redirect = false
    
    if params[:sort]
      @sorted = params[:sort]
    else
      @sorted = session[:sort]
      redirect = true
    end

    if params[:commit] == 'Refresh'
      if params[:ratings]
        @rating_filter = params[:ratings].keys
      else  # press 'Refresh' while selecting nothing
        @rating_filter = @all_ratings
      end
    else
      if params[:ratings]
        @ratings_filter = (params[:ratings].is_a?(Hash)) ? params[:ratings].keys : params[:ratings]
      else
        if session[:ratings]
          @rating_filter = session[:ratings]
          redirect = true
        else
          @rating_filter = @all_ratings
          redirect = false
        end
      end
    end
    
    if session[:sort] != @sorted
      session[:sort] = @sorted
    end
    if session[:ratings] != @rating_filter
      session[:ratings] = @rating_filter
    end
    
    if redirect
      flash[:notice] = "redirecting..."
      flash.keep
      redirect_to movies_path(:sort => @sorted, :ratings => @rating_filter)
    else
      @movies = @movies.sorting(@sorted)
      @movies = @movies.with_ratings(@rating_filter)
    end

    
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
