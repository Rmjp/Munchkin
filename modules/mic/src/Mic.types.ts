import type { StyleProp, ViewStyle } from 'react-native';

export type OnLoadEventPayload = {
  url: string;
};

export type MicModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
  onAudioData: (params: AudioDataEventPayload) => void;
};

export type ChangeEventPayload = {
  value: string;
};

export type AudioDataEventPayload = {
  mic: string;
  timestamp: number;
  audio: string;
};

export type MicViewProps = {
  url: string;
  onLoad: (event: { nativeEvent: OnLoadEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
};
