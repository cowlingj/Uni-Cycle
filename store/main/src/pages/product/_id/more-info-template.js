const subjectTemplate = ({ id }) => `information for product ${id}`
const bodyTemplate = ({ name }) =>
  `Hi,

Could you tell me more about your product "${name}".

Thanks
`
export default ({ email: { address }, product }) =>
  `mailto:${address}?subject=${encodeURIComponent(
    subjectTemplate(product)
  )}&body=${encodeURIComponent(bodyTemplate(product))}`
