#Pull down docker config file 
/etc/sysconfig/docker:
  file.managed:
    - source: salt://minion1/docker
    - user: root
    - group: root
    - mode: 755

#Install docker, enable it, and run it
docker:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/sysconfig/docker
    - enable: true

#Make the kubernetes binary directory
/opt/kubernetes:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

#Setup and copy down the manifests
/etc/kubernetes:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

/etc/kubernetes/manifests:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

/etc/kubernetes/manifests/fluentd.yaml:
  file.managed:
    - source: salt://manifests/fluentd.yaml
    - user: root
    - group: root
    - mode: 755

#Pull down kubernetes binaries
/opt/kubernetes/kube-proxy:
  file:
    - managed
    - source: salt://kube_binaries/kube-proxy
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kubelet:
  file:
    - managed
    - source: salt://kube_binaries/kubelet
    - user: root
    - group: root
    - mode: 755

#Pull down systemd service definitions
/usr/lib/systemd/system/kube-proxy.service:
  file:
    - managed
    - source: salt://systemd/kube-proxy.service
    - user: root
    - group: root
    - mode: 755

/usr/lib/systemd/system/kube-kubelet.service:
  file:
    - managed
    - source: salt://minion1/kube-kubelet.service
    - user: root
    - group: root
    - mode: 755

#Start Kubernetes services
kube-proxy:
  service:
    - running
    - enable: true

kube-kubelet:
  service:
    - running
    - enable: true
    - watch:
      - file: /etc/kubernetes/manifests/*
