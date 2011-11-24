#!/usr/bin/env rspec
require 'spec_helper'

require 'puppet/indirector/file_metadata/file_server'
require 'shared_behaviours/file_server_terminus'

describe Puppet::Indirector::FileMetadata::FileServer, " when finding files", :fails_on_windows => true do
  it_should_behave_like "Puppet::Indirector::FileServerTerminus"

  before do
    @terminus = Puppet::Indirector::FileMetadata::FileServer.new
    @test_class = Puppet::FileServing::Metadata
  end
end
