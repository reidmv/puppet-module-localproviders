Puppet::Type.type(:group).provide(
  :localgroupadd,
  :parent => Puppet::Type.type(:group).provider(:groupadd)
) do
 
  # This pseudo-provider does not actually provide any new or more specific
  # functionality. Rather, its sole purpose is to modify the behavior of the
  # :groupadd provider. As such it is confined such that it will never be
  # directly invoked or used.
  confine :operatingsystem => :false

  # Create an instances method that will consider ONLY entries from the local
  # /etc/group file. Bind the new instances method to the :groupadd provider's
  # instances method, overriding it.
  #
  # WARNING: this means that on ANY system where the :localgroupadd
  #          pseudo-provider is installed, the behavior of the default :groupadd
  #          provider will be modified.
  groupadd_singleton = class << Puppet::Type::Group.provider(:groupadd); self; end
  groupadd_singleton.send(:define_method, :instances) do
    objects = []
    group_file = "/etc/group"
    File.open(group_file) do |f|
      f.each_line do |line|
        if line.match(/^[\w-]+:/)
          objects << new(:name => line.split(':').first, :ensure => :present)
        end
      end
    end
    objects
  end
 
end
