# aws-ecr-update-credentials

[Amazon ECR User Guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html)


## Create script and log files
```sudo touch /var/log/aws-ecr-update-credentials.log
sudo chown $USER /var/log/aws-ecr-update-credentials.log
sudo touch /usr/local/bin/aws-ecr-update-credentials.sh
sudo chown $USER /usr/local/bin/aws-ecr-update-credentials.sh
sudo chmod +x /usr/local/bin/aws-ecr-update-credentials.sh```
```

## Content of /usr/local/bin/aws-ecr-update-credentials.sh
```
#!/usr/bin/env bash

kube_namespaces=($(kubectl get secret --all-namespaces | grep regcred | awk '{print $1}'))
for i in "${kube_namespaces[@]}"
do
  :
  echo "$(date): Updating secret for namespace - $i"
  kubectl delete secret regcred --namespace $i
  kubectl create secret docker-registry regcred \
    --docker-server="$aws_account".dkr.ecr."$aws_region".amazonaws.com \
    --docker-username=AWS \
    --docker-password=$(/usr/bin/aws ecr get-login-password) \
    --namespace=$i
done
```

## Add cronjob
```
crontab -e

0 */10 * * * /usr/local/bin/aws-ecr-update-credentials.sh >> /var/log/aws-ecr-update-credentials.log 2>&1
```

