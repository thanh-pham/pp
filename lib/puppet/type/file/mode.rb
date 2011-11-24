# Manage file modes.  This state should support different formats
# for specification (e.g., u+rwx, or -0011), but for now only supports
# specifying the full mode.
module Puppet
  Puppet::Type.type(:file).newproperty(:mode) do
    desc "Mode the file should be.  Currently relatively limited:
      you must specify the exact mode the file should be.

      Note that when you set the mode of a directory, Puppet always
      sets the search/traverse (1) bit anywhere the read (4) bit is set.
      This is almost always what you want: read allows you to list the
      entries in a directory, and search/traverse allows you to access
      (read/write/execute) those entries.)  Because of this feature, you
      can recursively make a directory and all of the files in it
      world-readable by setting e.g.:

          file { '/some/dir':
            mode => 644,
            recurse => true,
          }

      In this case all of the files underneath `/some/dir` will have
      mode 644, and all of the directories will have mode 755."

    validate do |value|
      if value.is_a?(String) and value !~ /^[0-7]+$/
        raise Puppet::Error, "File modes can only be octal numbers, not #{should.inspect}"
      end
    end

    munge do |should|
      dirmask(should)
    end

    # If we're a directory, we need to be executable for all cases
    # that are readable.  This should probably be selectable, but eh.
    def dirmask(value)
      value = value.to_i(8) unless value.is_a? Integer
      if FileTest.directory?(resource[:path])
        value |= 0100 if value & 0400 != 0
        value |= 010 if value & 040 != 0
        value |= 01 if value & 04 != 0
      end

      value.to_s(8)
    end

    # If we're not following links and we're a link, then we just turn
    # off mode management entirely.
    def insync?(currentvalue)
      if stat = @resource.stat and stat.ftype == "link" and @resource[:links] != :follow
        self.debug "Not managing symlink mode"
        return true
      else
        return super(currentvalue)
      end
    end
  end
end

