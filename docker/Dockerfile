FROM java:7-jre-alpine

ADD http://central.maven.org/maven2/org/jgroups/jgroups/3.6.4.Final/jgroups-3.6.4.Final.jar / 

EXPOSE 12001

CMD ["java", "-cp", "jgroups-3.6.4.Final.jar", "org.jgroups.stack.GossipRouter"]
