import { Image, StyleSheet, Platform, Button } from 'react-native';

import { HelloWave } from '@/components/HelloWave';
import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import MicModule from "@/modules/mic/src/MicModule"
import { useEffect } from 'react';

export default function HomeScreen() {
  useEffect(() => {
    MicModule.addListener('onAudioData', (event) => {
      console.log( event.timestamp + " " + event.mic);
    }
    );
    console.log(MicModule.PI);
  }, []);
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#A1CEDC', dark: '#1D3D47' }}
      headerImage={
        <Image
          source={require('@/assets/images/partial-react-logo.png')}
          style={styles.reactLogo}
        />
      }>
      <ThemedView style={styles.stepContainer}>
        <ThemedText style={{ fontWeight: 'bold' }}>Step 1: Install the Mic module</ThemedText>
        <ThemedText>
          To get started, you'll need to install the Mic module. This module allows you to interact
          with the device's microphone.
        </ThemedText>
        <Button title="Install Mic module" onPress={() => MicModule.setValueAsync("Test")} />
        <Button title="Start Recording" onPress={() => console.log(MicModule.startRecoding())} />
        <Button title="Stop Recording" onPress={() => console.log(MicModule.stopRecording())} />
      </ThemedView>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  stepContainer: {
    gap: 8,
    marginBottom: 8,
  },
  reactLogo: {
    height: 178,
    width: 290,
    bottom: 0,
    left: 0,
    position: 'absolute',
  },
});
