import { requireNativeView } from 'expo';
import * as React from 'react';

import { MicViewProps } from './Mic.types';

const NativeView: React.ComponentType<MicViewProps> =
  requireNativeView('Mic');

export default function MicView(props: MicViewProps) {
  return <NativeView {...props} />;
}
