export default (context) => {
  if (process.server) {
    // TODO: extract path
    context.app.$env.CMS_EXTERNAL_URL = `${context.req.protocol || 'http'}://${
      context.req.headers.host
    }/cms/graphql`
  }
}
