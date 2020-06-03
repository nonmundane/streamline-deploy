#cloud-config
write_files:
  - encoding: b64
    path: /home/ubuntu/movienight.conf
    permissions: '0755'
    content: ${base64encode(file("${path}/nginx/movienight.conf"))}
  - encoding: b64
    path: /home/ubuntu/video-hls.js
    permissions: '0755'
    content: ${base64encode(file("${path}/movienight/video-hls.js"))}
  - encoding: b64
    path: /home/ubuntu/settings.json
    permissions: '0755'
    content: ${base64encode(file("${path}/movienight/settings.json"))}
  - encoding: b64
    path: /home/ubuntu/movienight.service
    permissions: '0755'
    content: ${base64encode(file("${path}/movienight/movienight.service"))}
  - encoding: b64
    path: /home/ubuntu/install.sh
    permissions: '0755'
    content: ${base64encode(file("${path}/scripts/install.sh"))}
  - encoding: b64
    path: /home/ubuntu/playout-mpd.sh
    permissions: '0755'
    content: ${base64encode(file("${path}/scripts/playout-mpd.sh"))}
  - encoding: b64
    path: /home/ubuntu/streamline-encode.sh
    permissions: '0755'
    content: ${base64encode(file("${path}/scripts/streamline-encode.sh"))}
  - encoding: b64
    path: /home/ubuntu/test-encode-1min.sh
    permissions: '0755'
    content: ${base64encode(file("${path}/scripts/test-encode-1min.sh"))}
  - encoding: b64
    path: /home/ubuntu/create-reference-mp4.sh
    permissions: '0755'
    content: ${base64encode(file("${path}/scripts/create-reference-mp4.sh"))}

runcmd:
  - /home/ubuntu/install.sh ${stream_key} ${hostname} ${domainname}
