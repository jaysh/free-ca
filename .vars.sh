#!/bin/bash
output_directory="keypairs"

openssl_config="openssl.cnf"

ca_base="$output_directory/ca"
ca_key="$ca_base/ca.key"
ca_cert="$ca_base/ca.crt"
ca_serial="$ca_base/ca.srl"

mkdir -p $ca_base
