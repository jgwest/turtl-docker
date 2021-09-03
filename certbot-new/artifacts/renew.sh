#!/bin/bash

if [ -z "$1" ]; then
        echo "Your email address needs to be specified as the first parameter."
        exit
#else
#        echo "Using $1 as your email address."
fi

if [ -z "$2" ]; then
	echo "The second parameter needs to be a domain name without a subdomain (example: domain.com)"
        exit
#else
#        echo "Using $2 as the first domain to add to the certificate."
fi


if [ -z "$3" ]; then
	echo "The second parameter needs to be a domain name beginning with www (example: www.domain.com)"
        exit
#else
#        echo "Using $3 as the second domain to add to the certificate."
fi

# --force-renewal
certbot  --preferred-chain="ISRG Root X1" renew

