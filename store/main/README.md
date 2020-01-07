# nuxt-ecommerce

> An ecommerce frontend

## Build Setup

``` bash
# install dependencies
$ npm run install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```

For detailed explanation on how things work, check out [Nuxt.js docs](https://nuxtjs.org).

## Environment

| Key | Description |
|---|---|
| CMS_EXTERNAL_ENDPOINT | url (without path parts) for the cms (client side) |
| CMS_INTERNAL_ENDPOINT | url (without path parts) for the cms (server side) |
| CMS_EXTERNAL_PATH | base path of the cms (client side) |
| CMS_INTERNAL_PATH | base path of the cms (server side) |
| PRODUCTS_EXTERNAL_ENDPOINT | url (without path parts) for the products service (client side) |
| PRODUCTS_INTERNAL_ENDPOINT | url (without path parts) for the products service (server side) |
| PRODUCTS_EXTERNAL_PATH | base path of the products service (client side) |
| PRODUCTS_INTERNAL_PATH | base path of the products service (server side) |
| DEFAULT_LOCALE | locale to use if no other is found |
| HOST | ip address to bind to |
| PORT | port to listen on |
