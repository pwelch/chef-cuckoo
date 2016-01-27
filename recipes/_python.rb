#
# Cookbook Name:: cuckoo
# Recipe:: _python
#

# Install python
include_recipe 'poise-python'
python_runtime '2'

# Install additional python packages
%w{ python-dev libffi-dev libssl-dev }.each do |pkg|
  package pkg
end

