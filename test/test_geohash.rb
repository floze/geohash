#!/usr/bin/env ruby
$LOAD_PATH << "#{File.dirname(__FILE__)}/.."
require "#{File.dirname(__FILE__)}/../lib/geohash"
require 'test/unit'

class GeoHashTest < Test::Unit::TestCase
  include GeoHash
  
  def test_decoding
    assert_equal [39.02474, -76.51100], decode("dqcw4bnrs6s7")
    assert_equal [37.791562, -122.398541], decode("9q8yyz8pg3bb", 6)
    assert_equal [37.791562, -122.398541], decode("9Q8YYZ8PG3BB", 6)
    assert_equal [42.60498046875, -5.60302734375], decode("ezs42", 11)
    assert_equal [-25.382708, -49.265506], decode("6gkzwgjzn820",6)
    assert_equal [-25.383, -49.266], decode("6gkzwgjz", 3)
    assert_equal [37.8565, -122.2554], decode("9q9p658642g7", 4)
  end

  def test_encoding
    assert_equal "dqcw4bnrs6s7", encode(39.0247389581054, -76.5110040642321, 12)
    assert_equal "dqcw4bnrs6", encode(39.0247389581054, -76.5110040642321, 10)
    assert_equal "6gkzmg1u", encode(-25.427, -49.315, 8)
    assert_equal "ezs42", encode(42.60498046875, -5.60302734375, 5)
  end

  def check_decoding(gh)
    exact = decode(gh, 20)
    bbox = decode_bbox(gh)

    # check that the bbox is centered on the decoded point
    bbox_center = [(bbox[0][0] + bbox[1][0]) / 2, (bbox[0][1] + bbox[1][1]) / 2]
    assert_equal exact, bbox_center

    # check that the bounding box is the expected size
    bits = gh.size * 5
    lon_bits = (bits.to_f/2).ceil
    lat_bits = (bits.to_f/2).floor
    correct_size = [180.0/2**lat_bits, 360.0/2**lon_bits]
    bbox_size = [bbox[1][0] - bbox[0][0], bbox[1][1] - bbox[0][1]]
    assert_equal bbox_size, correct_size
  end

  def test_decoding_bbox
    s = "dqcw4bnrs6s7"
    (s.length-1).downto(0) do |l|
      check_decoding(s[0..l])
    end
  end
  
  def test_specific_bbox
    assert_equal [[39.0234375, -76.552734375], [39.0673828125, -76.5087890625]], decode_bbox('dqcw4')
  end
  
  # require 'benchmark'
  # def test_multiple
  #   Benchmark.bmbm(30) do |bm|
  #     bm.report("encoding") {30000.times { test_encoding }}
  #     bm.report("decoding") {30000.times { test_encoding }}
  #   end
  # end
end

