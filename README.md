# Terraform scripts to create AWS EKS cluster

## Подготовка

##### Установка terraform с помощью [tgenv](https://github.com/tfutils/tfenv)

Устанавливаем версию terraform из файла ([.terraform-version](.terraform-version)).

```shell
$ tfenv install
```

##### Установка terragrunt с помощью [tgswitch](https://github.com/warrensbox/tgswitch)

Устанавливаем версию terraform из файла [.terragrunt-version](.terragrunt-version).

```shell
$ tgswith
```

## Запуск кластера

```shell
$ cd dev/kubernetes
$ echo 'do_token = "<DigitalOcean Token>"' | tee vars.auto.tfvars > /dev/null

$ terragrunt plan --out main.tfplan

$ terragrunt apply main.tfplan

$ doctl kubernetes cluster kubeconfig save k8s-cluster 

$ kubectl get nodes
```

Получить DigitalOcean Access Token: [Control Panel](https://cloud.digitalocean.com/) -> `API` -> `Generate New Token`.

## Обновление описания модуля

Конфигурация [terraform-docs](https://terraform-docs.io/) находится в [.terraform-docs.yml](.terraform-docs.yml).

```shell
$ terraform-docs table document modules/kubernetes/
```