module TrafficSpy
  class Customer
    attr_reader :identifier, :rootUrl
    # extend TheDatabase

    def initialize(input)
      @identifier = input[:identifier]
      @rootUrl = input[:rootUrl]
    end

    def save
      Customer.data.insert(:identifier => identifier,
                           :rootUrl => rootUrl)
    end

    def self.data
      TheDatabase.database[:customers]
    end


    def self.find_root_url(identifier)
      row = data.select.where(:identifier => identifier)
      if row.to_a[-1] != nil
        row.to_a[-1][:rootUrl]
      end
    end

    def self.find_id(identifier)
      row = data.select.where(:identifier => identifier)
      if row.to_a[0] != nil
        row.to_a[0][:id]
      end
    end

    def self.identifier_exists?(customer_identifier)
      customer_identifiers = TheDatabase.database[:customers].select(:identifier)
      customer_identifiers.to_a.any? { |identifier| identifier[:identifier] == customer_identifier}
    end

    def self.destroy_all
      data.delete
    end
  end
end
