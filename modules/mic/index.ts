// Reexport the native module. On web, it will be resolved to MicModule.web.ts
// and on native platforms to MicModule.ts
export { default } from './src/MicModule';
export { default as MicView } from './src/MicView';
export * from  './src/Mic.types';
