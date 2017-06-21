# Oracle Weblogic with empty domain

### Description

This docker image use Oracle Weblogic 12.2.1.2, Oracle Server JRE 1.8 and CentOS 7

**Note:** This image is the basic weblogic image, it's only the intermidiate weblogic images, for production docker image, use [playniuniu/weblogic-domain](https://hub.docker.com/r/playniuniu/weblogic-domain/)

### Run

If you just wonder to create an adminserver, you can run this image with

```bash
docker run -d -p 8001:8001 playniuniu/weblogic-base
```

And login with *weblogic:welcome1*
