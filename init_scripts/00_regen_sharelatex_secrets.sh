#!/bin/sh
# Create random secret keys (twice, once for http auth pass, once for cookie secret).
CRYPTO_RANDOM=$(dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev | tr -d '\n+/')
echo "export WEB_API_PASSWORD=$CRYPTO_RANDOM" > /etc/profile.d/crypto.sh

CRYPTO_RANDOM=$(dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev | tr -d '\n+/')
echo "export CRYPTO_RANDOM=$CRYPTO_RANDOM" >> /etc/profile.d/crypto.sh
