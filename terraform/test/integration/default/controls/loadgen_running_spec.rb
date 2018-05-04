# frozen_string_literal: true

sockshop_ip = attribute("sockshop_ip", default: "", description: "sockshop IP")
sockshop_url = 'http://' + sockshop_ip

control 'loadgen_running' do
  describe port(22) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  describe crontab('ubuntu') do
    its('commands') { should include '/home/ubuntu/loadgen.sh' }
  end

  describe file('/usr/bin/phantomjs') do
    it { should exist }
  end

  describe file('/usr/local/bin/casperjs') do
    it { should exist }
  end

  describe host(sockshop_ip, port: 80, protocol: "tcp") do
    it { should be_reachable }
  end

  describe http(sockshop_url) do
    its('status') { should cmp 200 }
  end
end
