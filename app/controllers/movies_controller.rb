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
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort] = params[:sort] if params[:sort]

    # redirect to RESTful path if session contains more info than provided in params
    if (!params[:ratings] && session[:ratings]) || (!params[:sort] && session[:sort])
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
    end

    query_base = Movie

    if session[:ratings]
      query_base = query_base.scoped(:conditions => { :rating => session[:ratings].keys })
    end

    if session[:sort]
      query_base = query_base.scoped(:order => session[:sort])
    end

    @movies = query_base.all

    @all_ratings = Movie.all_ratings

    if session[:ratings]
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = {}
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
