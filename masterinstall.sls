#Create etcd directory
/opt/etcd:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
#Download etcd and docker-
/opt/etcd/etcdctl
    file:
    - managed
    - source: salt://kube_binaries/etcdctl
    - user: root
    - group: root
    - mode: 755
 
#  archive.extracted:
#    - name: /opt/
#    - source: https://github.com/coreos/etcd/releases/download/v2.0.5/etcd-v2.0.5-linux-amd64.tar.gz
#    - source_hash: md5=4d8ccff28c383980b52397a7664b3342
#    - archive_format: tar
#    - user: root
#    - group: root
#    - if_missing: /opt/etcd-v2.0.5-linux-amd64/

#Make symlink for etcdctl
/usr/local/bin/etcdctl:
  file.symlink:
    - target: /opt/etcd/etcdctl

/usr/lib/systemd/system/etcd.service:
  file:
    - managed
    - source: salt://service/etcd.service
    - user: root
    - group: root
    - mode: 755

etcd:
  service:
    - running
    - enable: true

#Make the kubernetes binary directory
/opt/kubernetes:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

#Pull down Kubernetes Binaries
/opt/kubernetes/kubectl:
  file:
    - managed
    - source: salt://kube_binaries/kubectl
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kube-apiserver:
  file:
    - managed
    - source: salt://kube_binaries/kube-apiserver
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kube-controller-manager:
  file:
    - managed
    - source: salt://kube_binaries/kube-controller-manager
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kube-scheduler:
  file:
    - managed
    - source: salt://kube_binaries/kube-scheduler
    - user: root
    - group: root
    - mode: 755


#Pull down Systemd Service definitions
/usr/lib/systemd/system/kube-apiserver.service:
  file:
    - managed
    - source: salt://systemd/kube-apiserver.service
    - user: root
    - group: root
    - mode: 755

/usr/lib/systemd/system/kube-controller.service:
  file:
    - managed
    - source: salt://systemd/kube-controller.service
    - user: root
    - group: root
    - mode: 755

/usr/lib/systemd/system/kube-scheduler.service:
  file:
    - managed
    - source: salt://systemd/kube-scheduler.service
    - user: root
    - group: root
    - mode: 755

#Start Kubernetes services
kube-apiserver:
  service:
    - running
    - enable: true
    - watch:
      - file: /usr/lib/systemd/system/kube-apiserver.service

kube-controller:
  service:
    - running
    - enable: true

kube-scheduler:
  service:
    - running
    - enable: true

#Make symlink for kubectl
/usr/local/bin/kubectl:
  file.symlink:
    - target: /opt/kubernetes/kubectl
[root@k8s-master saltstack-master]# more top.sls 
base:
  '*':
    - baseinstall
  '*masta*':
    - masterinstall
    - pods
  'host:kubminion1':
    - match: grain
    - minion1
  'host:kubminion2':
    - match: grain
    - minion2
  'host:kubminion3':
    - match: grain
    - minion3
  'host:kubminion4':
    - match: grain
    - minion4    
