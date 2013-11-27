Custom Facts
============

Shell commands
--------------

    Facter.add(:who) do
      resolve_command '/usr/bin/who -u'
    end

Returns:

    adrien   tty7         2013-11-12 12:22 (:0)
    adrien   pts/0        2013-11-25 09:35 (:0)
    adrien   pts/1        2013-11-26 14:14 (:0)
    adrien   pts/3        2013-11-25 14:45 (:0)

Basic ruby resolutions
----------------------

    Facter.add(:rubyversion) do
      resolve do
        RUBY_VERSION
      end
    end

Returns:

    '1.9.3'

Returning structured data
-------------------------

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

Extending resolutions
---------------------

    # Define a hash that contains the network interface names
    Facter.fact(:network).resolution(:linux, :type => :ordered) do
      use_ordering

      resolve(:names) do
        net = {}

        names = Dir.glob('/sys/class/net/*').each do |path|
          name = File.basename(path)
          net[name] = {}
        end

        net
      end
    end

    # Add in the macaddress for each interface
    Facter.fact(:network).resolution(:linux) do

      resolve(:macaddress, :using => [:names]) do |net|
        net.each_pair do |name, properties|
          properties[:macaddress] = File.read("/sys/class/net/#{name}/address").chomp
        end

        net
      end
    end

