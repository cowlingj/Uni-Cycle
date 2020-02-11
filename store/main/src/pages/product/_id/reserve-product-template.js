const subjectTemplate = ({ id }) => `reservation of product ${id}`
const bodyTemplate = ({ name }) =>
  `Hi,

I am interested in "${name}", and would like to reserve it so I can buy it in store.

Thanks
`
export default ({ email: { address }, product }) =>
  `mailto:${address}?subject=${encodeURIComponent(
    subjectTemplate(product)
  )}&body=${encodeURIComponent(bodyTemplate(product))}`
