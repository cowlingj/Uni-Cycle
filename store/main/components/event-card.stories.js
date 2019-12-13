import Card from './event-card'
import { storiesOf } from '@storybook/vue';

// export default { title: 'Event' };

storiesOf('Event', module)
  .add('as a thing that works', () => ({
      components: { Card },
      template: `<Card
        title="title"
        location="Somewhere"
        locationLink="Somewhere"
        start="some date or string"
        end="tomorrow"
        description="desc\nmore desc"
        ical="url"
      />`
  }))

