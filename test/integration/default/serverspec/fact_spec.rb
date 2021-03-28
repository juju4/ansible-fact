require 'serverspec'

# Required by serverspec
set :backend, :exec

fact_rootdir = '/var/_fact/FACT_core'
curl_args='-sSvLk'
fact_url = 'https://localhost'


describe command("pip freeze") do
  its(:stdout) { should match /distro/ }
end

describe file("#{fact_rootdir}/src/config/main.cfg") do
  it { should be_file }
  its(:size) { should > 0 }
  its(:content) { should_not match /Error:/ }
  its(:content) { should_not match /Warning:/ }
end

describe file("/var/run/clamav/clamd.ctl") do
  it { should be_socket }
end

describe process('python3') do
  it { should be_running }
  its(:user) { should eq "_fact" }
end

describe process('uwsgi') do
  it { should be_running }
  its(:user) { should eq "_fact" }
end

describe port(5000) do
  it { should be_listening }
end

describe port(9191) do
  it { should be_listening }
end


describe command("curl #{curl_args} #{fact_url}") do
  its(:stdout) { should match /<title>FACT<\/title>/ }
  its(:stdout) { should match /Browse Firmware/ }
  its(:stdout) { should match /Browse Compares/ }
  its(:stdout) { should match /Basic Search/ }
  its(:stdout) { should_not match /Internal Server Error/ }
end

describe command("curl #{curl_args} #{fact_url}/system_health") do
  its(:stdout) { should match /<h5 class="card-title">frontend status<\/h5>/ }
  its(:stdout) { should match /<h5 class="card-title">backend status<\/h5>/ }
  its(:stdout) { should_not match /Internal Server Error/ }
end

describe file("/var/log/fact/fact_main.log") do
  its(:size) { should > 0 }
  # FIXME: [cwe_checker][ERROR]: Could not get module versions from Bap plugin: 1 (error: Found argument '/bin/true' which wasn't expected, or isn't valid in this context
  # its(:content) { should_not match /ERROR/ }
  its(:content) { should_not match /Exception/i }
  # its(:content) { should_not match /Permission Error:/ }
  its(:content) { should_not match /WARNING/ }
end

describe file("/var/log/fact/fact_mongo.log") do
  its(:size) { should > 0 }
  its(:content) { should_not match /authentication failed/ }
  its(:content) { should_not match /ERROR/ }
  its(:content) { should_not match /WARNING/ }
end

describe file("/tmp") do
  it { should be_directory }
  it { should be_mode 1777 }
end
