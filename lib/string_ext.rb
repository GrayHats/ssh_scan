require 'ipaddr'

# Extend string to include some helpful stuff
class String
  def unhexify
    [self].pack("H*")
  end

  def hexify
    self.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
  end

  def ip_addr?
    begin
      IPAddr.new(self)

    # Using ArgumentError instead of IPAddr::InvalidAddressError for 1.9.3 backward compatability
    rescue ArgumentError
      return false
    end

    return true
  end

  def resolve_fqdn
    @fqdn ||= TCPSocket.gethostbyname(self)[3]
  end

  def fqdn?
    begin
      resolve_fqdn
    rescue SocketError
      return false
    end

    if ip_addr?
      return false
    else
      return true
    end
  end

end
