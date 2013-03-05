module TrafficSpy

  class Campaign
    extend TheDatabase

    attr_reader :campaignName, :eventNames, :customer_id

    def initialize(customer_id, name, events)
      @customer_id = customer_id
      @campaignName = name
      @eventNames= events
    end

    def save
      Campaign.data.insert(:customer_id => customer_id,
                           :campaignName => campaignName,
                           :eventNames => eventNames)
    end

    def self.data
      verify_table_exists
      TheDatabase.database[:campaigns]
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def self.create_table
      TheDatabase.database.create_table? :campaigns do
        primary_key :id
        foreign_key :customer_id
        String :campaignName
        String :eventNames
      end
    end

    # def self.create_event_array(eventNames)
    #   eventNames
    # end


  end
end
