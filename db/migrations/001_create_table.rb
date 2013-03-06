require 'sequel'

Sequel.migration do
  change do
    create_table :customers do
      primary_key :id
      String      :identifier
      String      :rootUrl
    end

    create_table :requests do
      primary_key :id
      foreign_key :customer_id
      foreign_key :event_id
      String      :url
      DateTime    :requestedAt
      Integer     :respondedIn
      String      :referredBy
      String      :requestType
      String      :parameters
      String      :eventName
      String      :userAgent
      Integer     :resolutionHeight
      Integer     :resolutionWidth
      String      :ip
    end
  end
end
