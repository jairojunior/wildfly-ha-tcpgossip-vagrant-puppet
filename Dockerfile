FROM java:7-jre-alpine

COPY jgroups-3.2.13.Final.jar /

EXPOSE 12001

CMD ["java", "-cp", "jgroups-3.2.13.Final.jar", "org.jgroups.stack.GossipRouter"]
