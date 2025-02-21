import * as React from 'react';

import { MicViewProps } from './Mic.types';

export default function MicView(props: MicViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
