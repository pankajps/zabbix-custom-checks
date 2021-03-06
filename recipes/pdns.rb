#
# Cookbook Name:: zabbix_custom_checks
# Recipe:: pdns
#
# Copyright 2014, TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "zabbix-custom-checks::default"

template "#{node['zabbix']['agent']['include_dir']}/pdns.conf" do
  source "pdns/zabbix.conf.erb"
  mode "644"
  notifies :restart, "service[zabbix_agentd]" if File.exist?("#{node['zabbix']['install_dir']}/zabbix_agentd")
end

# custom monitoring scripts
# these are taken from https://github.com/Rikbruggink/Zabbix-templates
files = ["errors", "latency", "qsize", "queries"]
files.each do |filename|
  template "#{node['zabbix']['external_dir']}/pdns_#{filename}" do
    source "pdns/pdns_#{filename}"
    mode "755"
  end
end

template "/etc/sudoers.d/zabbix-pdns" do
  source "pdns/sudoers.erb"
  mode "440"
end
