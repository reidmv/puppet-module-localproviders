Puppet::Type.type(:user).provide(
  :localuseradd,
  :parent => Puppet::Type.type(:user).provider(:useradd)
) do
 
  # This pseudo-provider does not actually provide any new or more specific
  # functionality. Rather, its sole purpose is to modify the behavior of the
  # :useradd provider. As such it is confined such that it will never be
  # directly invoked or used.
  confine :operatingsystem => :false

  # Create an instances method that will consider ONLY entries from the local
  # /etc/passwd file. Bind the new instances method to the :useradd provider's
  # instances method, overriding it.
  #
  # WARNING: this means that on ANY system where the :localuseradd
  #          pseudo-provider is installed, the behavior of the default :useradd
  #          provider will be modified.
  useradd_singleton = class << Puppet::Type::User.provider(:useradd); self; end
  useradd_singleton.send(:define_method, :instances) do
    objects = []
    passwd_file = "/etc/passwd"
    File.open(passwd_file) do |f|
      f.each_line do |line|
        if line.match(/^[\w-]+:/)
          objects << new(:name => line.split(':').first, :ensure => :present)
        end
      end
    end
    objects
  end
 
end
