import { storiesOf } from '@storybook/vue'
import Card from './event-card'
import { text } from '@storybook/addon-knobs'
import { LoremIpsum } from 'lorem-ipsum'

const ipsum = new LoremIpsum()

storiesOf('Event', module).add('Default', () => ({
  components: { Card },
  props: {
    title: { default: text('Title', ipsum.generateWords(3)) },
    description: { default: text('Description', ipsum.generateParagraphs(1)) },
    location: { default: text('Location', ipsum.generateWords(1)) }
  },
  template: `<Card
        :title="title"
        :location="location"
        start="some date or string"
        end="tomorrow"
        :description="description"
        ical="url"
      />`
}))
