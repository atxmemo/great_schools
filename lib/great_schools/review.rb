module GreatSchools #:nodoc:
  class Review < Model
    attr_accessor :school_name, :school_address
    attr_accessor :review_link, :rating, :submitter, :posted_date, :comments

    class << self # Class methods
      # = School Reviews
      #
      # Returns a list of the most recent reviews for a school or for any schools in a city.
      # * state       - Two letter state abbreviation
      # * city        - Name of city, with spaces replaced with hyphens. If the city name has hyphens, replace those with underscores.
      # * cutoff_age  - Reviews must have been published after this many days ago to be returned. Only valid for the recent reviews in a city call.
      # * limit       - Maximum number of reviews to return. This defaults to 5.
      def for_city(state, city, limit = 5, cutoff_age = nil) # TODO options hash instead of limit and cutoff_age?
        options = { limit: limit, cutoffAge: cutoff_age }.keep_if { |_,v| v.present? }

        response = GreatSchools::API.get("reviews/city/#{state.upcase}/#{parameterize(city)}", options)

        Array.wrap(response).map {|review| new(review) }
      end

      # = School Reviews
      #
      # Returns a list of the most recent reviews for a school or for any schools in a city.
      # * state - Two letter state abbreviation
      # * id    - Numeric id of school. This gsID is included in other listing requests like Browse Schools and Nearby Schools
      # * limit - Maximum number of reviews to return. This defaults to 5.
      def for_school(state, id, limit = 5) # TODO options hash instead of limit for consistency?
        response = GreatSchools::API.get("reviews/school/#{state.upcase}/#{id}", limit: limit)

        Array.wrap(response).map {|review| new(review) }
      end
    end
  end
end
