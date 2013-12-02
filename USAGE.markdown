Custom Facts
============

Basic usage
-----------

### Shell commands


When all you need to do is capture the output of a command, you can use the
`resolve_command` method to set up a simple fact that just runs the command and
returns stdout.

    Facter.add(:who) do
      resolve_command '/usr/bin/who -u'
    end

Returns:

    adrien   tty7         2013-11-12 12:22 (:0)
    adrien   pts/0        2013-11-25 09:35 (:0)
    adrien   pts/1        2013-11-26 14:14 (:0)
    adrien   pts/3        2013-11-25 14:45 (:0)

### Basic ruby resolutions

You can run ruby statements inside of a `resolve` block to do some computation
and return the output.

    Facter.add(:rubyversion) do
      resolve do
        RUBY_VERSION
      end
    end

Returns:

    '1.9.3'

### Returning structured data

Structured data such as hashes and arrays can be returned by the `resolve`
statement. The returned data can be deeply nested, but should only be a basic
type, like an Array, Hash, Integer, Float, or String.

    Facter.add(:rubyversion) do
      resolve do
        info = {}

        info['engine']     = RUBY_ENGINE
        info['patchlevel'] = RUBY_PATCHLEVEL
        info['version']    = RUBY_VERSION

        info
      end
    end

Returns:

    {
      'engine'     => 'ruby',
      'version'    => '1.9.3',
      'patchlevel' => '484',
    }

Advanced usage
--------------

### Extending resolutions 
If you need to define a data structure that may be extended later, you can use
an ordered resolution like so.

    # Define a hash that contains the network interface names. The actual values
    # will be populated later.
    Facter.fact(:network).resolution(:linux) do

      confine :kernel => :linux

      resolve(:names) do
        net = {}
        Dir.glob('/sys/class/net/*').map { |d| File.basename(d) }.each do |name|
          net[name] = {}
        end

        net
      end
    end

    # Look up the mac address for each interface
    Facter.fact(:network).resolution(:linux) do

      # This depends on the earlier :names block to run first
      resolve(:macaddress, :using => [:names]) do |net|
        net.each_pair do |name, properties|
          properties[:macaddress] = File.read("/sys/class/net/#{name}/address").chomp
        end

        net
      end
    end

    # Look up the MTU for each interface
    Facter.fact(:network).resolution(:linux) do

      # This depends on the earlier :names block to run first. If any other
      # names are listed here, they will all be run before this one.
      resolve(:mtu, :using => [:names]) do |net|

        net.each_pair do |name, properties|
          properties[:mtu] = File.read("/sys/class/net/#{name}/mtu").chomp.to_i
        end

        net
      end
    end


Returns:

    {
      "network": {
        "vboxnet0": {
          "macaddress": "0a:00:27:00:00:00",
          "mtu": 1500,
          "jumbo": false
        },
        "eth0": {
          "macaddress": "3c:97:0e:81:cb:4f",
          "mtu": 1500,
          "jumbo": false
        },
        "lo": {
          "macaddress": "00:00:00:00:00:00",
          "mtu": 65536,
          "jumbo": true
        },
        "wlan0": {
          "macaddress": "6c:88:14:0b:79:70",
          "mtu": 1500,
          "jumbo": false
        }
      }
    }

