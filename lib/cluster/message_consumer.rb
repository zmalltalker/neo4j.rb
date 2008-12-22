module Cluster
  # import some java classes
  #ActiveMQConnectionFactory = org.apache.activemq.ActiveMQConnectionFactory
  #ByteSequence = org.apache.activemq.util.ByteSequence
  #ActiveMQBytesMessage = org.apache.activemq.command.ActiveMQBytesMessage
  #MessageListener = javax.jms.MessageListener
  #Session = javax.jms.Session

  class MessageConsumer
    include javax.jms.Session
    include javax.jms.MessageListener

    def onMessage(serialized_message)
      message_body = serialized_message.get_content.get_data.inject("") { |body, byte| body << byte }
# TODO ENCODING PROBLEM ...
#      eval):1: Invalid char `\0' ('') in expression
#cluster/message_consumer.rb:16:in `onMessage': (eval):1: Invalid char `\0' ('') in expression (SyntaxError)

      puts message_body
      eval(message_body)
    end

    def run
      factory = ActiveMQConnectionFactory.new("tcp://localhost:61616")
      connection = factory.create_connection();
      @session = connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
      queue = @session.create_queue("test1-queue");

      consumer = @session.create_consumer(queue);
      consumer.set_message_listener(self);

      connection.start();
      puts "Listening..."
    end

    def close
      @session.unsubscribe("test1-queue") # TODO, we will not get anything from broker after this call
      @session.close
    end
  end

end
#handler = MessageConsumer.new
#handler.run
