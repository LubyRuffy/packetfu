if VERSION < "1.8.6"
	$stderr.puts "[*] WARNING: Ruby not at a minimum version of 1.8.6" 
end

require 'bindata'

# Happy day, unforking BinData.
if BinData::VERSION < "0.9.3"
	raise LoadError, "BinData not at version 0.9.3 or later."
end

require 'ipaddr'
require 'singleton'

#	require 'rubygems'
#	require 'ruby-prof'

module PacketFu

	# Sets the expected byte order for a pcap file. See PacketFu::Read.set_byte_order
	@byte_order = :little

	# Checks if pcaprub is loaded correctly.
	@@pcaprub_loaded = false
	
	# PacketFu works best with Pcaprub version 0.8-dev, now made available
	# with this distribution. Say, can Mac users give me some idea of how
	# to install on your hipster youth-oriented Bay Area grunge OS?
  def self.pcaprub_platform_require
    if File.directory?("C:\\")
			require 'pcaprub_win32/pcaprub'
      @@pcaprub_loaded = true 
    else
			require 'pcaprub' # Linux and Mac (Apple uses pcaprub.bundle, Linux uses pcaprub.so)
      @@pcaprub_loaded = true if($".grep(/pcaprub\./).size > 0)
    end
  end

	begin
		pcaprub_platform_require
		if Pcap.version !~ /[0-9]\.[7-9][0-9]?(-dev)?/ # Regex for 0.7-dev and beyond.
      @@pcaprub_loaded = false # Don't bother with broken versions
			raise LoadError, "PcapRub not at a minimum version of 0.8-dev"
		end
		require 'packetfu/capture' 
		require 'packetfu/inject'
	rescue LoadError
	end
end
# Doesn't require PcapRub
require 'packetfu/pcap'
require 'packetfu/write' 
require 'packetfu/read' 	

# Packet crafting/parsing goodness.
require 'packetfu/packet'
require 'packetfu/invalid'
require 'packetfu/eth'
require 'packetfu/ip'
require 'packetfu/arp'
require 'packetfu/icmp'
require 'packetfu/udp'
require 'packetfu/tcp'
require 'packetfu/ipv6'

# Various often-used utilities.
require 'packetfu/utils'

# A place to keep defaults.
require 'packetfu/config'

#:main:PacketFu
#
#:include:../README
#:include:../LICENSE

module PacketFu

	# Returns the version.
	def self.version
		"0.2.0" # June 13, 2009
	end

end
