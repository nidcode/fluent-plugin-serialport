require 'fluent/test'

class SerialPortInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    require 'fluent/plugin/in_serialport'
  end

  CONFIG = %[
    type serial_input
    com_port serialport
    baud_rate 9600
    tag serialport
    format /\d+,\d+,\d+(.\d+)/
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::SerialPortInput).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal 'serialport', d.instance.com_port
    assert_equal 9600, d.instance.baud_rate
    assert_equal 'serialport', d.instance.tag
  end
end
