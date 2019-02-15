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
    @all_ratings = Movie.all_ratings
    redirect = false
    
    if params[:sort]
      @sorted = params[:sort]
      session[:sort] = @sorted
    elsif session[:sort]
      redirect = true
      @sorted = session[:sort]
    else
      @sorted = nil
    end
    
    if params[:ratings]
      @rating_filter = params[:ratings]
      session[:ratings] = @rating_filter
    elsif session[:ratings]
      redirect = true
      @ratings_filter = session[:ratings]
    else
      @ratings_filter = nil
    end
    
    if redirect
      flash.keep
      redirect_to :sort => @sorted, :ratings => rating_filter
    end
    
    if !@rating_filter.nil?
      @rating_filter = Hash.new
      @all_ratings.each do |rating|
        @rating_filter[rating] = 1
      end
    end
    
    if @sorted && @rating_filter
      @movies = Movie.all
      @movies = @movies.sorting(@sorted)
      @movies.with_ratings(@rating_filter.keys)
    elsif @sorted
      @movies = Movie.all
      @movies = @movies.sorting(@sorted)
    elsif @rating_filter
      @movies = Movie.all
      @movies.with_ratings(@rating_filter.keys)
    else
      @movies = Movie.all
    end
    
    
      
        
    
    
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
    
    # if session[:sort] != @sorted
    #   session[:sort] = @sorted
    # end
    # if session[:ratings] != @rating_filter
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
