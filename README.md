# localproviders module #

Warning: when installed, this module overrides the behavior of the `useradd`
and `groupadd` Puppet user and group providers.

The providers included in this module override the `instances` method of the
default providers in order to prevent Puppet from iterating over directory
service accounts when using the resources type, a la

````puppet
resources { 'user':
  purge => true,
}
````

When installed, for purposes of `ensure=absent` this module causes Puppet to
care ONLY about users defined in the `/etc/passwd` file, and ONLY groups
defined in the `/etc/group` file, regardless of which name services are
installed for those databases.

It is necessary to override existing functionality because the resources type
calls the `instances` method not on a default provider, but on the type. When
called on the type, the `instances` method will iterate over ALL suitable
providers to generate instances; thus if we do not modify the existing
providers not to iterate over directory service accounts, we cannot disable
that behavior.
