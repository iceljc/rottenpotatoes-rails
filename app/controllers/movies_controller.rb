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

    if params[:sort] != nil
      @sort_by = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort] != nil
      @sort_by = session[:sort]
    else
      @sort_by = 'id'
    end
    
    if params[:ratings] != nil
      @rating_filter = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != nil
      @rating_filter = session[:ratings]
    else
      @rating_filter = nil
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:ratings] = @rating_filter
      session[:sort] = @sort_by
      flash.keep
      redirect_to movies_path(:sort => @sort_by, :ratings => @rating_filter)
      return
    end


    if @rating_filter != nil
      selected_ratings = (@rating_filter.is_a?(Hash)) ? @rating_filter.keys : @rating_filter
      @movies = Movie.where(rating: selected_ratings).order(@sort_by)
    else
      @rating_filter = @all_ratings
      @movies = Movie.order(@sort_by)
      # if @sort_by != nil
      #   @movies = Movie.order(@sort_by)
      # else
      #   @movies = Movie.all
      # end
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