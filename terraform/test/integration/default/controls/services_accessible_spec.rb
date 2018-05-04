# frozen_string_literal: true

loadgen_ip = attribute("loadgen_ip", default: "", desciption: "loadgen IP")

sockshop_ip = attribute("sockshop_ip", default: "", description: "sockshop IP")
sockshop_url = 'http://' + sockshop_ip

elastic_ip = attribute("elastic_ip", default: "", description: "elastic IP")
elastic_url = 'http://' + elastic_ip

control 'services_accessible' do
  describe host(loadgen_ip, port: 22, protocol: "tcp") do
    it { should be_reachable }
  end

  describe host(elastic_ip, port: 22, protocol: "tcp") do
    it { should be_reachable }
  end

  describe host(elastic_ip, port: 80, protocol: "tcp") do
    it { should be_reachable }
  end

  describe host(elastic_ip, port: 9200, protocol: "tcp") do
    it { should be_reachable }
  end

  describe host(sockshop_ip, port: 22, protocol: "tcp") do
    it { should be_reachable }
  end

  describe host(sockshop_ip, port: 80, protocol: "tcp") do
    it { should be_reachable }
  end

  describe http(sockshop_url) do
    its('status') { should cmp 200 }
  end

  describe http(elastic_url) do
    its('status') { should cmp 200 }
  end
end
