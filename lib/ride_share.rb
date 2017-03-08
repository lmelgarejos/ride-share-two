require 'csv'
require 'time'


module RideShare
  class Driver
    attr_reader :id_d, :name_d, :vin

    def  initialize(id_d, name_d, vin)
      raise ArgumentError.new("no valid ID") if id_d.class != Integer
      raise ArgumentError.new("name must be a string") if name_d.class != String
      raise ArgumentError.new("vin must has 17 characters") if vin.length != 17
      @id_d = id_d
      @name_d = name_d
      @vin = vin
    end#end of initialize in driver class

    def self.all
      info = []
      # CSV.open("../support/drivers.csv", :headers => true).each do |line|
      CSV.open("support/drivers.csv", :headers => true).each do |line|
        info << self.new(line[0].to_i, line[1].to_s, line[2].to_s)
      end
      info
    end

    def self.find_driver(id_d)
      all.each do |line|
        # return line.name_d if line.id_d == id_d
        return line if line.id_d == id_d

      end
    end

    def find_drivers_trips
      RideShare::Trip.trips_made_by_driver(@id_d)
    end

    def drivers_rating(id_d)
      rates = []
      RideShare::Trip.all.each do |line|
        if line.id_d == id_d
          rates << line.rating
          @rate = rates.sum / rates.length
        end
      end
      @rate
    end
  end#end of Driver Class

  class Rider
    attr_reader :id_r, :name_r, :phone_number

    def  initialize(id_r, name_r, phone_number)
      raise ArgumentError.new("no valid ID") if id_r.class != Integer
      raise ArgumentError.new("name must be a string") if name_r.class != String
      raise ArgumentError.new("phone_number must be a string") if phone_number.class != String
      @id_r = id_r
      @name_r = name_r
      @phone_number = phone_number
    end#end of initialize in rider class

    def self.all
      info = []
      # CSV.open("../support/rider.csv", :headers => true).each do |line|
      CSV.open("support/riders.csv", :headers => true).each do |line|
        info << self.new(line[0].to_i, line[1].to_s, line[2].to_s)
      end
      info
    end

    def self.find_rider(id_r)
      all.each do |line|
        return line.name_r if line.id_r == id_r
      end
    end

    def find_riders_trips
      RideShare::Trip.trips_taken_by_rider(@id_r)
    end

    def rider_drivers
      @rider_drivers = []
      find_riders_trips.each do |trip|
        @rider_drivers << RideShare::Driver.find_driver(trip.id_d)
      end
      @rider_drivers
    end
  end#end of Rider class

  class Trip
    attr_reader :id_t, :id_d, :id_r, :date, :rating

    def initialize(id_t, id_d, id_r, date, rating)
      @id_t = id_t
      @id_d = id_d
      @id_r = id_r
      @date = date
      @rating = rating
    end

    def self.all
      info = []
      # CSV.open("../support/trips.csv", :headers => true).each do |line|
      CSV.open("support/trips.csv", :headers => true).each do |line|
        info << self.new(line[0].to_i, line[1].to_i, line[2].to_i, Time.parse(line[3]), line[4].to_f)
      end
      info
    end


    def self.trips_made_by_driver(id_d)
      trips = []
      all.each do |line|
        if line.id_d == id_d
          trips << line
        end
      end
      trips
    end

    def self.trips_taken_by_rider(id_r)
      trips = []
      all.each do |line|
        if line.id_r == id_r
          trips << line
        end
      end
      trips
    end


  end#end of Trip class
end#end of RideShare Module



# d = RideShare::Rider.new(159,'Celestine Blanda PhD','1-343-220-7104 x266')

# puts RideShare::Rider.find_riders_trips(111)


# print d.rider_drivers
# puts
# print d.find_riders_trips
# puts RideShare::Driver.find_drivers_trips(1)
