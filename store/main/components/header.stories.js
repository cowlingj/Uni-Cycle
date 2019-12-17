import { storiesOf } from '@storybook/vue'
import Header from '@/components/header'

storiesOf('Header', module).add('Default', () => ({
  components: { Header },
  template: `<Header/>`
}))
