#!/bin/bash
kubectl taint node -l 'node-role.kubernetes.io/control-plane=' node-role.kubernetes.io/control-plane:PreferNoSchedule || echo done
kubectl taint node -l 'node-role.kubernetes.io/control-plane=' node-role.kubernetes.io/control-plane:NoSchedule- || echo done
