require 'spec_helper'

describe 'cuckoo::default' do
  it 'creates cuckoo user' do
    expect(user('cuckoo')).to exist
  end

  %w{libcap2-bin tcpdump git}.each do |pkg|
    it "installs #{pkg} package" do
      expect(package(pkg)).to be_installed
    end
  end

  it 'installs python' do
    expect(package('python')).to be_installed
  end

  it 'clones a copy of cuckoo git repo' do
    expect(file('/home/cuckoo/cuckoo/.git')).to be_directory
  end
end
