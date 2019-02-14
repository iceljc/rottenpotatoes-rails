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
    # @sort = params[:sort]
    # @rating_filter = params[:ratings]
    
    if params[:sort] == nil
      if session[:sort] == nil
        @hilite = nil
        redirect = false
      else
        @hlite = session[:sort]
      end
    else
      @hilite = params[:sort]
    end
    
    if params[:ratings] == nil
      if session[:ratings] == nil
        @selected_ratings = @all_ratings
        redirect = false
      else
        @selected_ratings = session[:ratings]
      end
    else
      @selected_ratings = (params[:ratings].is_a?(Hash)) ? params[:ratings].keys : params[:ratings]
    end
    
    session[:sort] = @hilite
    session[:ratings] = @selected_ratings
    
    if redirect
      flash.keep
      redirect_to movies_path(:sort => @hilite, :ratings => @selected_ratings)
    else
      @movies = (@hilite == nil) ? Movie.where(:rating => @selected_ratings) : Movie.order(@hilite.to_sym).where(:rating => @selected_ratings)
    end
    

    # if params[:sort]
    #   @sorted = params[:sort]
    # else
    #   @sorted = session[:sort]
    # end

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
