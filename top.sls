base:
  '*':
    - baseinstall
  'host:k8s-master':
    - match: grain
    - masterinstall
    - pods
  'host:k8s-node':
    - match: grain
    - minion1
  'host:k8s-node2':
    - match: grain
    - minion2   
