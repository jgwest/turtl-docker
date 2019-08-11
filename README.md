
Turtl-docker allows you to run a standalone [Turtl](https://turtlapp.com/) server on your own IaaS infrastructure (for example, [DigitalOcean](https://www.digitalocean.com/)). Turtl is similar to services like Evernote, Google Keep, and OneNote, but unlike those services Turtl is an open source project which allows you to host and manage your own server (and thus your own personal data). Turtl has feature-rich desktop and Android clients, which match the essential features available from those commercially supported services.

Turtl-docker, *this* project, is a *"Turtl server in a box"*. While the Turtl project itself includes the source code for the Turtl server, and a simple docker-compose configuration file, it does not provide any containerized support for data persistence (you lose your data on container restart), support for TLS/SSL endpoints, automated backup, nginx update, security hardened containers, and more. 


## Turtl-docker features:
- **Containerized through Docker**: Each component of Turtl-docker runs inside an independently managed container. No local dependencies are required to be installed on your machine except Docker and Git.
- **Security-hardened**
  - *Run as non-root*: All containers run as non-root, to mitigate Linux kernel exploits that seek to escape the container through Linux kernel bugs.
  - *Read-only filesystem*: Nginx and the Turtl server are mounted as read-only file systems to prevent and mitigate container compromise.
  - *Drop container capabilities, except those that are necessary*: Nginx and the Turtl server drop all but three Linux kernel capabilities, which closes another door for malicious attemps to escaping the container through potential compromise of the Linux kernel.
  - *Bulkanized*: A compromise of one container cannot be used to compromise additional containers.
- **Free, automated HTTPS domain registration through Let's Encrypt**: Turtl-docker uses the Let's Encrypt service to create a signed TLS/SSL certificate for your Turtl-server instance (this requires that you have a domain name associated with your server through DNS). Certificate acquisition and renewal are automatic.
- **Automated Backup**: Using the [tarsnap](https://www.tarsnap.com/) backup service, all Turtl-docker data is backed up nightly, at a cost of pennies per month. Automatically uses the 'grandfather-father-son' backup strategy to keep costs down, while preserving old copies of data.
- **Fully self-contained**:  All user and program data is stored within the installation directory using Docker bind-mounts.
- **Integrated job-reporting failure through SMTP**: Automatically receive emails to your email account if the nightly backup or update jobs fail.
- **Self-updating**: Nginx, the container which is directly exposed to the internet, is automatically updated via a cronjob to ensure it is kept up to date with security updates.
- **Easy to setup**: Follow the simple instructions to get up and running: create a new settings file from the template, edit it, then run `init.sh`, `build-containers.sh`, then `run.sh`. Once up and running, run `add-cron-jobs.sh`. That's it!

## Why host my own Turtl server, rather than using a public Note service like Google Keep et al?

If you are not paying for a product or service, ask yourself, who is, and why? Are you the customer, or are you the product (eg are your data/usage statistics being packaged for sale to advertisers/data brokers)?

Hosting your own server allows you to:
- **Avoid having your notes hosted by an advertising company**: Are Google, Microsoft, and Evernote using your personal notes to tailor the advertising that they serve you? Can you trust them not to? Hosting your own server keeps monetization algorithms away from your data and privacy.
- **Avoid breach of contents**: Even the big companies aren't immune from compromise: Evernote had its passwords compromised in 2013, and in late 2018 Google+ exposed the user data of 52.5 million Google+ users. 
- **You control your own data**: You decide where your data is stored, by who, and how long they keep it for. Of course, control is a double-edged sword: don’t forget your password or your backups!
- **[Trust no one design philosophy](https://en.wikipedia.org/wiki/Trust_no_one_(Internet_security))**: Fully embraces the "trust no one" approach to internet security. The keys to your digital kingdom remain in your hands at all times, and at no point do you need to trust another party (commerial or otherwise) to maintain your security and privacy.


## Installation:

Before installation, see caveats section below.

1. `git clone https://github.com/jgwest/turtl-docker`
2. `cd turtl-docker`
3. Run `./init.sh` to setup the local directory.
4. `cd settings/`, then:
  - `cp trtl-env-var.sh.template trtl-env-var.sh` 
  - Edit the `trtl-env-var.sh` file with the required paths specified in the settings file. This includes:
    - `export TEV_SCRIPT_LOCT=(absolute path of settings dir)`
    - `export TRTL_EMAIL_ADDRESS=(your email address)`
    - `export TRTL_DOMAIN_NAME=(domain to register using let's encryption, example: mydomain.com)`
    - `export TRTL_DOMAIN_NAME_WWW=(domain to register using let's encryption, with www. prefic. example: www.mydomain.com)        `
  - *Optional, but recommended*: Place your `tarsnap.key` in the `settings/` directory, to allow turtl-docker to automatically backup to Tarsnap.
  - *Optional, but recommended* - job failure email reporting using an email account:
    - Under `settings/`, `cd mail`
    - `cp msmtprc.template msmtprc`
    - Fill in your Gmail account details in `msmtprc`.

5. If you want to run without HTTPS security (not recommended, but good for testing purposes):
	- In the `turtl-docker/nginx` directory, edit `run.sh`:
	- replace `-p 443:8443 \`  with `-p 443:8443 -p 8080:8080 \` to listen on port 8080
5. In the `turtl-docker` directory, run `./build-containers.sh`
6. Next, run `./run.sh`
7. You should now be able to access the turtl server:
	- If you are using Let's Encrypt: `https://(your domain name)`
	- If you are using non-HTTPS URL: `http://(your ip):8080`
8. Once you have confirmed the server is up and running as expected, run `./add-cron-jobs.sh` to add the nightly Turtl cron jobs to your crontab.

## Some Assembly Required

Configuring and administering a Turtl server can be a complex process, requiring some familiarity with Linux system adminstration and the details of this repository. It is much easier to use the central server hosted by the Turtl development team (and consider donating and/or subscribing to their premium service!) You might be required to get into the nitty gritty details of the `turtl-docker`  implementation if things go wrong. Hopefully it goes without saying, but I am not responsible for the ongoing maintenance of any self-hosted server you create, but I aim to help on a best-effort basis.

I am not affiliated with the Turtl developers; I created this as a personal project to host Turtl on a standalone DigitalOcean server. More information on the Turtl project is available from the links above.

## Security hardening

The following describes how each Turtl-docker container is hardened against compromise: 

| Container | Run as non-root | Drop unnecessary capabilities | Read-only file system |
| --- | --- | --- | --- |
| turtl-nginx | true | true | true |
| turtl-server | true | true | true |
| turtl-postgres | true | false | false |


*turtl-nginx* and the *turtl-server*, which are the containers which are directly (or indirectly) exposed to the internet, are fully hardened using compromise using all three hardening measures. *turtl-postgress* does not run as root (the most important of the three mitigations), but it does not drop capabilities, nor does it use a read-only file system: the Postgres server needs to create locally owned lock files which do not work well in a read-only environment. Fortunately, Postgres is never exposed to the public internet, and is only accessible through the turtl-server container.
