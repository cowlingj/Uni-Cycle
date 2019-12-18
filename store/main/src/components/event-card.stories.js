import { storiesOf } from '@storybook/vue'
import { text, date } from '@storybook/addon-knobs'
import { LoremIpsum } from 'lorem-ipsum'
import Card from './event-card'

const ipsum = new LoremIpsum()

function _date(name, defaultValue) {
  const stringTimestamp = date(name, defaultValue)
  return new Date(stringTimestamp)
}

storiesOf('Event', module).add('Default', () => ({
  components: { Card },
  props: {
    title: { default: text('Title', ipsum.generateWords(3)) },
    description: { default: text('Description', ipsum.generateParagraphs(1)) },
    location: { default: text('Location', ipsum.generateWords(1)) },
    start: { default: _date('Start Date', new Date('1/1/2020')) },
    end: { default: _date('End Date', new Date('2/1/2020')) },
    ical: { default: text('Ical', '#') }
  },
  template: `<Card
        :title="title"
        :location="location"
        :start="start"
        :end="end"
        :description="description"
        :ical="ical"
      />`
}))
