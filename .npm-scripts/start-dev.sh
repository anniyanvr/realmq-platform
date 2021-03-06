#!/usr/bin/env bash

# Stop services when user hits Ctrl+C
on_exit() {
  docker-compose stop
  exit 0
}

trap "on_exit" SIGINT

if [[ ! -f .env ]]; then
  echo -e "\033[1;34m☞\033[0m Setting up \033[1m.env\033[0m file. Here you can adjust dev setup configuration."
  echo -e "\033[1;34m☞\033[0m See \033[4msrc/config/README.md\033[0m for a complete list of configuration options."
  echo ""
  cp .env.template .env
fi

# install dev hosts
if [[ ! -n "$(grep "realmq.local" /etc/hosts)" ]]; then
    echo -e "\033[1;33m⚠\033[0m DNS entries in \033[4m/etc/hosts\033[0m need to be set up"
    read -p "Shall we do this for you now? (y/n)" answer

    if [[ "$answer" == "y" || "$answer" == "Y" || "${answer}Y" == "Y" ]]; then
        echo -e "\033[1;34m☞\033[0m Setting up \033[1mlocal DNS\033[0m.\nAdding \033[1m127.0.0.1 realmq.local api.realmq.local rtm.realmq.local\033[0m to \033[4m/etc/hosts\033[0m."
        printf "127.0.0.1 realmq.local api.realmq.local rtm.realmq.local\n" | sudo tee -a "/etc/hosts" > /dev/null;
        if [[ -n "$(grep "realmq.local" /etc/hosts)" ]]; then
            echo -e "\033[0;32m✓\033[0m Hosts have been added successfully"
        else
            echo -e "\033[1;33mFailed to setup hosts\033[0m";
        fi
    else
        echo -e "\033[1;33m⚠\033[0m Please set up your \033[1mlocal DNS\033[0m manually.\n\033[43mAdd \033[1m127.0.0.1 realmq.local api.realmq.local rtm.realmq.local\033[0m\033[43m to your \033[4m/etc/hosts\033[0m\033[43m file.\033[0m"
    fi
fi

# make sure the latest dependencies are installed
npm install

# launch docker setup
docker-compose up -d

# wait a little until mongo has started
sleep 2

# copy dev root ca certificate to user space
if [[ ! -f certs/dev-ca-root.crt.pem ]]; then
  echo -e "\033[1;34m☞\033[0m Setting up \033[1mTLS certificates\033[0m.\nCopy dev ROOT CA certificate to \033[4mcerts/dev-ca-root.crt.pem\033[0m."
  mkdir certs
  docker cp $(docker-compose ps -q certificates | head -1):/data/certificates/root.crt.pem certs/dev-ca-root.crt.pem
fi

# attach to the logs
docker-compose logs -f --tail 5 platform
