module Services
  module Station
    class Autocomplete
      extend Services::Base

      attr_reader :query_string

      def initialize(query_string)
        @query_string = query_string
      end

      def call!
        StationMaster::Station.find_by_city(query_string).inject([]) do |array, (key, value)|
          array << { value: key, key: value }
        end
      end
    end
  end
end