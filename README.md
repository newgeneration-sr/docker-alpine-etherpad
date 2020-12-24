![docker build automated](https://img.shields.io/docker/cloud/automated/dotriver/etherpad)
![docker build status](https://img.shields.io/docker/cloud/build/dotriver/etherpad)
![docker build status](https://img.shields.io/docker/pulls/dotriver/etherpad)

# Etherpad on Alpine Linux + S6 Overlay

# Auto configuration parameters :

- TITLE=Welcome to Etherpad (title of the browser window)
- DATABASE_HOST=mariadb
- DATABASE_PORT=3306
- DATABASE_NAME=etherpad
- DATABASE_USERNAME=etherpad
- DATABASE_PASSWORD=password
- USE_ADMIN=FALSE           (use a local admin user)
- ADMIN_USERNAME=admin
- ADMIN_PASSWORD=password
- USE_LDAP=TRUE             (use ldap to authenticate)
- LDAP_BASE_DN=dc=example,dc=com
- LDAP_HOST=fd
- LDAP_ADMIN_PASS=password
- LDAP_ADMIN_GROUP=admin    (the ldap group containing etherpad admins)
- PLUGINS=ep_adminpads ep_pad_tracker

You must use atleast 1 of admin or ldap, otherwise you won't have any admin.
You can use both, but we do not recommend using a local admin user since the
passwords are stored in plain-text in the config file.

The plugin ep_hash_auth enables to store hashes of the password instead,
but we couldn't make it work on this container. If you succeed in adding it,
please make a pull-request.

# Compose file example

```
version: '3.1'

services:

  etherpad:
    image: dotriver/etherpad
    environment:
        - TITLE=Welcome to Etherpad
        - DATABASE_HOST=mariadb
        - DATABASE_PORT=3306
        - DATABASE_NAME=etherpad
        - DATABASE_USERNAME=etherpad
        - DATABASE_PASSWORD=password
        - USE_ADMIN=TRUE
        - ADMIN_USERNAME=admin
        - ADMIN_PASSWORD=password
        - USE_LDAP=TRUE
        - LDAP_BASE_DN=dc=example,dc=com
        - LDAP_HOST=fd
        - LDAP_ADMIN_PASS=password
        - LDAP_ADMIN_GROUP=admin
        - PLUGINS=ep_adminpads ep_pad_tracker
    ports:
      - 9001:9001
    volumes:
      - /tmp/etherpad:/var/www/etherpad/
    networks:
      default:
    deploy:
      resources:
        limits:
          memory: 256M
      restart_policy:
        condition: on-failure
      mode: global

  mariadb:
    image: dotriver/mariadb
    environment:
      - ROOT_PASSWORD=password
      - DB_0_NAME=etherpad
      - DB_0_PASS=password
    ports:
      - 3306:3306
      - 8081:8081
    volumes:
      - mariadb-data:/var/lib/mysql/
      - mariadb-config:/etc/mysql/
    networks:
      default:
    deploy:
      resources:
        limits:
          memory: 256M
      restart_policy:
        condition: on-failure
      mode: global

  fd:
    image: dotriver/fusiondirectory
    ports:
      - "8080:80"
    environment:
      DOMAIN: example.com
      ADMIN_PASS: password
      CONFIG_PASS: password
    volumes:
      - openldap-data:/var/lib/openldap/
      - openldap-config:/etc/openldap/

volumes:
    mariadb-data:
    mariadb-config:
    openldap-data:
    openldap-config:

```