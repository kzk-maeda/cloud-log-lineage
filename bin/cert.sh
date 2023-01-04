#!/bin/bash

WORKDIR="./.cert"

# create dirs
mkdir ${WORKDIR}
for i in bolt https
do
    mkdir -p neo4j/ssl/${i}/revoked/
    mkdir -p neo4j/ssl/${i}/trusted/
done

# generate private key
openssl genrsa 2048 > ${WORKDIR}/private.key

# generate csr file interactively
openssl req -new -key ${WORKDIR}/private.key > ${WORKDIR}/server.csr

# ----- sample
# Country Name (2 letter code) [XX]:JP
# State or Province Name (full name) []:Tokyo
# Locality Name (eg, city) [Default City]:Minato-ku
# Organization Name (eg, company) [Default Company Ltd]:kzk_maeda
# Organizational Unit Name (eg, section) []:
# Common Name (eg, your name or your server's hostname) []:localhost
# Email Address []:admin@localhost

# Please enter the following 'extra' attributes
# to be sent with your certificate request
# A challenge password []:
# An optional company name []:

# generate server cert
openssl x509 -req -days 3650 -signkey ${WORKDIR}/private.key < ${WORKDIR}/server.csr > ${WORKDIR}/public.crt

# copy certs
for i in bolt https
do
    cp ${WORKDIR}/private.key neo4j/ssl/${i}/private.key
    cp ${WORKDIR}/public.crt neo4j/ssl/${i}/public.crt
    cp ${WORKDIR}/public.crt neo4j/ssl/${i}/trusted/public.crt
done
