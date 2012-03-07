module Fluent
class SerialPortInput < Input
  Plugin.register_input('serial_input', self)
  config_param :com_port, :string
  config_param :baud_rate, :integer
  config_param :data, :string
  config_param :tag, :string, :default => "serial"
  config_param :delimiter, :string, :default => ','
  config_param :eol, :string, :default => $/

  def initialize
    require 'serialport'
    super
  end

  def configure(conf)
    super
  end

  def start
    @serial = SerialPort.new(@com_port, @baud_rate, 8, 1, SerialPort::NONE)
    @data_tag = data_tag
    @thread = Thread.new(&method(:run))
  end

  def shutdown
    @serial.close
    @thread.join
  end

  def run
    loop do
      unless @serial.closed?
        begin
          d = @serial.readline(@eol)
          time = Engine.now
          d = d.split(@delimiter)
          data = {}
          @data_tag.each do |x|
            dd = d.shift
            if dd =~ /^(0x)|(\d+)/
              if dd =~ /\./
                dd = dd.strip.to_f
              else
                dd = dd.strip.to_i
              end
            end
            tag = x.strip
            data[tag.to_sym] = dd
          end
          Engine.emit("#{@tag}.#{device}", time, data)
        rescue
          STDERR.puts caller()
          break
        end
      end
    end
  end

  private
  def device
    File.basename(@com_port).gsub(/\./,"_")
  end

  def data_tag
    @data.split(",")
  end

end
end
