module Hancock::Mappable
  extend ActiveSupport::Concern

  included do

    if Hancock.mongoid?
      include ::Geocoder::Model::Mongoid
      field :coordinates, type: Array
      field :address, type: String, localize: Hancock.configuration.localize

      field :map_address, type: String
      field :map_hint, type: String

      field :lat, type: Float
      field :lon, type: Float
    end

    geocoded_by :geo_address
    after_validation :do_geocode
  end

  if Hancock.active_record?
    def coordinates
      if latitude.nil? || longitude.nil?
        nil
      else
        [longitude, latitude]
      end
    end
  end

  def do_geocode
    if geo_address.blank?
      if Hancock.mongoid?
        self.coordinates = nil
      else
        self.latitude = nil
        self.longitude = nil
      end
    else
      if (lat.nil? || lon.nil?) && (new_record? || address_changed? || coordinates.nil? || map_address_changed?)
        geocode
      end
    end
  end

  def get_lat
    if lat.blank?
      if coordinates.nil?
        nil
      else
        coordinates[1]
      end
    else
      lat
    end
  end
  def get_lon
    if lon.blank?
      if coordinates.nil?
        nil
      else
        coordinates[0]
      end
    else
      lon
    end
  end

  def has_map?
    (!lat.blank? && !lon.blank?) || !coordinates.nil?
  end

  def to_map
    {
      id: id.to_s,
      hint: map_hint,
      addr: address,
      lat: get_lat,
      lon: get_lon,
    }
  end

  def geo_address
    if map_address.blank?
      address
    else
      map_address
    end
  end
end
