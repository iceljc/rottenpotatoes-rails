class Movie < ActiveRecord::Base
    
    def self.sorting(input)
        if input
            self.order(input)
        else
            self
        end
    end
    
    
end
