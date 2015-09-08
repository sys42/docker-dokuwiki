# docker-dokuwiki

Dokuwiki in a Container.

### About

[Dokuwiki](https://www.dokuwiki.org/dokuwiki#) is a simple to use Wiki distribution. It requires no database which makes git and especially github a perfect target to be used as backend.

### Get Dokuwiki up and running

Actually I'm still experimenting how to streamline/automate the configuration. For now you have to take same manual steps to get configurate it and commit the container to a new image.

#### Step 1: Start the container and run the install script

Since we have to perform some manual steps we start the container in interactive mode.

```
docker run -ti --rm -w /usr/share/nginx/html -p 30000:80 sys42/docker-dokuwiki bash
```

Now open http://127.0.0.1:3000/install.php in your browser and configurate the access pattern and the admin account.

#### Step 2: Install plugin gitbacked

Log into the your wiki installation and open the following page:

http://localhost:30000/doku.php?id=start&do=admin&page=extension&tab=search&q=

Search for extension __gitbacked__ and click install


#### Step 3: Generate directory structure and modify config

Run the following commands in the terminal of the container:

```shell
cd /usr/share/nginx/html
mkdir -p data/gitrepo
chown -R www-data:www-data data/gitrepo
mv data/pages data/gitrepo/
mv data/media data/gitrepo/
```

... and add the following lines to /usr/share/nginx/html/conf/local.php:

```
    $conf['datadir'] = './data/gitrepo/pages';
    $conf['mediadir'] = './data/gitrepo/media';
```

#### Step 4: Configurate Plugin

Navigate with your browser to the Admin Section Configuration at:

http://localhost:30000/doku.php?id=start&do=admin&page=config

1. Change "Path of the git repo" to ./data/gitrepo
2. Change "Path of the git working tree" ./data/gitrepo

#### Step 5: Configurate Git

Modify and run the following commands

```shell
mkdir /var/www
chown www-data:www-data /var/wwww
setuser www-data git config --global user.email "you@example.com"
setuser www-data git config --global user.name "Your Name"
```

#### Step 6: Commit container to new Image

Run `docker ps` in another terminal to find the name of your dokuwiki-container.

Then execute (also in another terminal):

```
docker commit name-of-container mydoku-wiki:latest
```

#### Conclusion and work TODO

After all these steps we have configurated dokuwiki to use git internal as backend. What we still haven't done is to connect the container internal git directory with a remote origin.

I'm still not sure how to do this correctly. IMHO I don't want to embedded github credentials within the container and there are other points to think about:

  1. how to handle and where to store customizations?
  2. should the container perform a checkout during start?
  3. ... or should it use a external data volume managed separately?
  4. how to automate all the above config steps? Especially step 1 and step 5 with custom settings?



