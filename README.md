# FreeCA

FreeCA is a simple wrapper around OpenSSL to make generating signed certificates, with a self-signed CA, less of a headache.

OpenSSL in incredibly time-consuming to use effectively for what I felt was a reasonably simply use case.
All I was trying to do is create a CA that I could use to sign SAN/UCC/Wildcard certificates. This turned out
not to be an easy task - I found that very few online tutorials make it absolutely clear how to sign such certificate without having to modify your global `openssl.cnf`.

## How to use it FreeCA

1. Modify the `req_distinguished_name` of [`openssl.cnf`](#) to your liking.
2. Create your own CA:

        $ ./generate_ca 
        Generating RSA private key, 4096 bit long modulus
        ...................................................++
        ......................................++
        e is 65537 (0x10001)

        Your CA is now ready to use (certificate: keypairs/ca/ca.crt, private key: keypairs/ca/ca.key)

   You should now proceed to install this certificate wherever you like (e.g. Firefox, Google Chrome). When prompted, trust it to identify websites.

3. Issue certificates that support SAN/UCC/Wildcard names:

        $ ./generate_certificate web-server "*.example.com" "*.example.net"
        Generating RSA private key, 4096 bit long modulus
        ...............................++
        ................++
        e is 65537 (0x10001)
        Signature ok
        subject=/C=US/ST=CA/L=Example/O=Example/OU=Example/CN=example.com
        Getting CA Private Key

        Your certificate is now ready to use (certificate: keypairs/web-server.crt, private key: keypairs/web-server.key)

    This will leave you with a directory called `keypairs`, which contain all of your certificates.

        keypairs/
        ├── ca
        │   ├── ca.crt
        │   ├── ca.key
        │   └── ca.srl
        ├── web-server.crt
        └── web-server.key

    Which contains both your CA certificate, and web server certificates.

4. (Optional) Verify that the SAN names are indeed in the certificate (output is snipped for brevity):

        $ openssl x509 -in keypairs/web-server.crt -noout -text
        ...
        X509v3 extensions:
            X509v3 Key Usage: 
                Key Encipherment, Data Encipherment
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Subject Alternative Name: 
                DNS:*.example.com, DNS:*.example.net
        ...

5. Install the certificate into your web server. In Nginx, you should append the `ca.crt` to `web-server.crt` before using it.

