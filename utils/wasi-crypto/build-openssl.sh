#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# SPDX-FileCopyrightText: 2019-2024 Second State INC

echo "Building OpenSSL for wasi-crypto..."
# Get OpenSSL source
curl -s -L -O --remote-name-all https://www.openssl.org/source/openssl-3.5.7.tar.gz
echo "a8c0d28a529ca480f9f36cf5792e2cd21984552a3c8e4aa11a24aa31aeac98e8 openssl-3.5.7.tar.gz" | sha256sum -c
tar -xf openssl-3.5.7.tar.gz
cd ./openssl-3.5.7
# Configuring OpenSSL requires newer Perl.
curl -s -L -O --remote-name-all https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz
tar -xf perl-5.34.0.tar.gz
cd perl-5.34.0
mkdir localperl
./Configure -des -Dprefix=$(pwd)/localperl/
make -j
# too long!
# make test
make install
export PATH="$(pwd)/localperl/bin/:$PATH"
cd ..
# Configure by previous perl
mkdir openssl
./perl-5.34.0/localperl/bin/perl ./config --prefix=$(pwd)/openssl --openssldir=$(pwd)/openssl
make -j
make test
make install
cd ..
