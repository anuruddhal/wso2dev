* Create a truststore
```bash
   keytool -import -alias cluster-dockerForMac -file apiserver.crt -keystore trustore.jks
   keytool -importkeystore -srckeystore trustore.jks -srcstoretype JKS -deststoretype PKCS12 -destkeystore trustore.p12
``` 
* Create a keystore
```bash
openssl pkcs12 -export -in client.crt -inkey client.key -certfile client.crt -out keystore.p12
```