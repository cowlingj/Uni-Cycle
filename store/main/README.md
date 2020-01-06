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

- name: CMS_INTERNAL_ENDPOINT
              value: {{ printf "\"%s://%s.%s:%s\"" .Values.cms.api.protocol .Values.cms.api.hostname ( default ( printf "%s.svc.cluster.local" .Release.Namespace ) .Values.cms.api.domain ) ( toString .Values.cms.api.port ) }}
            - name: CMS_BASE_PATH
              value: {{ .Values.cms.api.basePath | quote }}
            - name: PORT
              value: "80"
            - name: HOST
              value: "0.0.0.0"

| Key | Description |
|---|---|
| CMS_INTERNAL_ENDPOINT | url (without path parts) for the cms |
| CMS_BASE_PATH | base path of the cms |
| PRODUCTS_INTERNAL_ENDPOINT | url (without path parts) for the products service |
| PRODUCTS_BASE_PATH | base path of the products service |
| DEFAULT_LOCALE | locale to use if no other is found |
| HOST | ip address to bind to |
| PORT | port to listen on |
