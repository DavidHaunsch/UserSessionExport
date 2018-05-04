# frozen_string_literal: true

control 'sockshop_running' do
  describe docker.containers do
    its('images') { should include 'weaveworksdemos/orders:0.4.7' }
    its('images') { should include 'weaveworksdemos/user-db:0.4.0' }
    its('images') { should include 'weaveworksdemos/queue-master:0.3.1' }
    its('images') { should include 'weaveworksdemos/edge-router:0.1.1' }
    its('images') { should include 'weaveworksdemos/shipping:0.4.8' }
    its('images') { should include 'weaveworksdemos/user:0.4.4' }
    its('images') { should include 'weaveworksdemos/carts:0.4.8' }
    its('images') { should include 'weaveworksdemos/payment:0.4.3' }
    its('images') { should include 'weaveworksdemos/catalogue-db:0.3.0' }
    its('images') { should include 'weaveworksdemos/catalogue:0.3.5' }
    its('images') { should include 'weaveworksdemos/front-end:0.3.12' }
    its('images') { should include 'mongo:3.4' }
    its('images') { should include 'rabbitmq:3.6.8' }
  end

  describe port(22) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  describe port(80) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end
