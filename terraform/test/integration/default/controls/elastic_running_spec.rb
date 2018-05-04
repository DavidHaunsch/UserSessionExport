# frozen_string_literal: true

control 'elastic_running' do
  describe port(22) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  describe port(80) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  describe port(9200) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  describe processes(Regexp.new("nginx")) do
    it { should exist }
  end

  describe processes(Regexp.new("elasticsearch")) do
    it { should exist }
  end

  describe processes(Regexp.new("kibana")) do
    it { should exist }
  end
end
