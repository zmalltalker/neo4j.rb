require 'common'

puts "Starting Broker"
broker = org.apache.activemq.broker.BrokerService.new

broker.add_connector "tcp://localhost:61616"
broker.start

