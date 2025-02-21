import { NativeModule, requireNativeModule } from 'expo';

import { MicModuleEvents } from './Mic.types';

declare class MicModule extends NativeModule<MicModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<MicModule>('Mic');
