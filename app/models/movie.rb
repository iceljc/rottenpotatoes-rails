class Movie < ActiveRecord::Base
    # @all_ratings = ['G','PG','PG-13','R']
    
    # sort movies based on one attribute
    # def self.sorting(input)
    #     if input
    #         self.order(input)
    #     else
    #         self
    #     end
    # end
    
    # list all the movie ratings
    def self.all_ratings
        self.select(:rating).map(&:rating).uniq
        # @all_ratings
    end
    
    # # select movies where rating = [...]
    # def self.with_ratings(ratings)
    #     self.where(rating: ratings)
    # end
    
    
end
