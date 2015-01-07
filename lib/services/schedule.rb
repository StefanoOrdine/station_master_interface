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
        time_now = Time.now.in_time_zone(StationMaster::TIME_ZONE)
        StationMaster::Schedule.find_station_departures(station_code, time_now)
          .select { |schedule| schedule.time >= time_now }
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
        time_now = Time.now.in_time_zone(StationMaster::TIME_ZONE)
        StationMaster::Schedule.find_station_arrivals(station_code, time_now)
          .select { |schedule| schedule.time >= time_now }
          .sort!{ |a, b| a.time <=> b.time }
          .first(entries_count)
      end
    end
  end
end