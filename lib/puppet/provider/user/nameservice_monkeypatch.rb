class Puppet::Provider::NameService < Puppet::Provider

  def passwdinfo
    @passwdinfo ||= File.open('/etc/passwd') do |f|
      records = {}
      f.each_line do |line|
        if line.match(/^[\w-]+:/)
          fields = line.split(':')
          records[fields[0]] = {
            #:password => fields[1],
            :uid      => fields[2].to_i,
            :gid      => fields[3].to_i,
            :comment  => fields[4],
            :home     => fields[5],
            :shell    => fields[6].chomp
          }
        end
      end
      records
    end
  end

  def getinfo(refresh)
    passwdinfo[@resource[:name]]
  end

end
