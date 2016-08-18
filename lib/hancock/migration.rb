module Hancock
  module Migration
    extend self

    def map_fields(t)
      t.text :address
      t.text :map_address
      t.text :map_hint
      t.float :latitude
      t.float :longitude
      t.float :lat
      t.float :lon
    end
  end
end
