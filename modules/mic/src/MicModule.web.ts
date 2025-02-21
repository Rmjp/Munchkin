import { registerWebModule, NativeModule } from 'expo';

import { ChangeEventPayload } from './Mic.types';

type MicModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
}

class MicModule extends NativeModule<MicModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
};

export default registerWebModule(MicModule);
