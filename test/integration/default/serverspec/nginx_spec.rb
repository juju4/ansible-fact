require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('nginx'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('nginx'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('nginx'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('nginx'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.nginx.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

describe port(443) do
  it { should be_listening }
end

describe command('openssl s_client -connect localhost:443 < /dev/null 2>/dev/null | openssl x509 -text -in /dev/stdin') do
  its(:stdout) { should match /sha256/ }
  its(:stdout) { should match /Public-Key: \(4096 bit\)/ }
end
