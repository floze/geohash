require 'geohash_native'
  
class Float
  def decimals(places)
    n = (self * (10 ** places)).round
    n.to_f/(10**places)
  end
end

module GeoHash
  VERSION = '1.0.2'
  
  # Encode latitude and longitude to a geohash with precision digits
  def encode(lat, lon, precision=10)
    encode_base(lat, lon, precision)
  end

  # Decode a geohash to a latitude and longitude with decimals digits
  def decode(geohash, decimals=5)
    lat, lon = decode_base(geohash)
    [lat.decimals(decimals), lon.decimals(decimals)]
  end

  # Decode a geohash to a bounding box
  def decode_bbox(geohash)
    decode_bbox_base(geohash)
  end
  
  extend self
end
