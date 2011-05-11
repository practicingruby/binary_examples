class PNG
  SIGNATURE    = "\x89PNG\r\n\x1A\n"
  IHDR_LENGTH  = 13

  def initialize(filename)
    File.open(filename, "rb") do |stream|
      unless stream.read(8) == SIGNATURE
        raise ArgumentError, "Input file is not a PNG"
      end

      chunk_length = read_int32(stream)
      chunk_name   = stream.read(4)

      unless chunk_name == "IHDR" && chunk_length == IHDR_LENGTH
        raise ArgumentError, "PNG is corrupted, invalid IHDR chunk"
      end
      
      read_ihdr(stream)
    end
  end

  attr_reader :idhr

  def width
    idhr[:width]
  end

  def height
    idhr[:height]
  end

  private

  def read_ihdr(stream)
    @idhr = {}

    @idhr[:width]              = read_int32(stream)
    @idhr[:height]             = read_int32(stream)
    @idhr[:colour_type]        = read_int8(stream)
    @idhr[:compression_method] = read_int8(stream)
    @idhr[:filter_method]      = read_int8(stream)
    @idhr[:interlace_method]   = read_int8(stream)
  end

  def read_int32(stream)
    stream.read(4).unpack("N").first
  end

  def read_int8(stream)
    stream.readbyte
  end
end

png = PNG.new("sample.png")
p [png.width, png.height]
p png.idhr

