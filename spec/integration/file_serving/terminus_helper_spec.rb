#!/usr/bin/env rspec
require 'spec_helper'

require 'puppet/file_serving/terminus_helper'

class TerminusHelperIntegrationTester
  include Puppet::FileServing::TerminusHelper
  def model
    Puppet::FileServing::Metadata
  end
end

describe Puppet::FileServing::TerminusHelper, :fails_on_windows => true do
  it "should be able to recurse on a single file" do
    @path = Tempfile.new("fileset_integration")
    request = Puppet::Indirector::Request.new(:metadata, :find, @path.path, :recurse => true)

    tester = TerminusHelperIntegrationTester.new
    lambda { tester.path2instances(request, @path.path) }.should_not raise_error
  end
end
