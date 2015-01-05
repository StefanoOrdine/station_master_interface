module Services
  module Schedule 
    class Departure
      extend Services::Base

      attr_reader :station_code, :entries_count

      def initialize(station_code, entries_count)
        @station_code = station_code
        @entries_count = entries_count
      end

      def call!
        StationMaster::Schedule.find_station_departures(station_code, Time.now + 5 hours)
          .select { |schedule| schedule.time >= Time.now + 5 hours } # TODO fix me from station master
          .sort!{ |a, b| a.time <=> b.time }
          .first(entries_count)
      end
    end

    class Arrival
      extend Services::Base

      attr_reader :station_code, :entries_count

      def initialize(station_code, entries_count)
        @station_code = station_code
        @entries_count = entries_count
      end

      def call!
        StationMaster::Schedule.find_station_arrivals(station_code, Time.now + 5 hours)
          .select { |schedule| schedule.time >= Time.now + 5 hours } # TODO fix me from station master
          .sort!{ |a, b| a.time <=> b.time }
          .first(entries_count)
      end
    end
  end
end