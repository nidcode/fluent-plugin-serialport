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
    @serial = SerialPort.new(@com_port, @baud_rate, 8, 1, SerialPort::NONE)
  end

  def configure(conf)
    super
  end

  def start
    @thread = Thread.new(&method(run))
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
          @data.split(",").each do |x|
            dd = d.shift
            if dd =~ /^(0x)|(\d+)/
              if dd =~ /\./
                dd = dd.strip.to_f
              else
                dd = dd.strip.to_i
              end
            end
            data[x.strip.to_sym] = dd
          end
        end
        Engine.emit("#{@tag}.#{device}", time, data)
      rescue => e
        STDERR.puts caller(), e
        break
      end
    end
  end

  private
  def device
    File.basename(@com_port).gsub(/\./,"_")
  end

end
end
