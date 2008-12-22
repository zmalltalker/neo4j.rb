#require 'common'
#require 'readline'


# import some java classes
module Cluster


  class MessageProducer
    include javax.jms.Session
    include javax.jms.MessageListener

    def initialize
      factory = ActiveMQConnectionFactory.new("tcp://localhost:61616")
      connection = factory.create_connection();
      @session = connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
      queue = @session.create_queue("test1-queue");

      @producer = @session.create_producer(queue);
    end

    def send_message(line)
      #    puts "received input of #{line}"
      m = @session.createTextMessage()  ;
      m.set_text(line)
      @producer.send(m)
    end

    def close
      @session.close
    end

  end

end
#handler = MessageHandler.new
#loop do
#  line = Readline::readline('> ', true)
#  handler.send_message(line)
#end