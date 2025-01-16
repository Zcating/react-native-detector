import { NativeModules, NativeEventEmitter, Platform } from 'react-native';

const { Detector } = NativeModules;

enum EventsName {
  UserDidCapturedScreen = "UIScreenCapturedDidChangeNotification"
}

const detectorEventEmitter = new NativeEventEmitter(Detector);

type Unsubscribe = () => void;

const commonAddScreenCapturedListener = (listener: () => void): Unsubscribe => {
  const eventSubscription = detectorEventEmitter.addListener(
    EventsName.UserDidCapturedScreen,
    () => listener(),
    {}
  );

  return () => {
    eventSubscription.remove();
  };
};

// const getListenersCount = (): number => {
//   return (
//     // React Native 0.64+
//     // @ts-ignore
//     detectorEventEmitter.listenerCount?.(EventsName.UserDidCapturedScreen) ??
//     // React Native < 0.64
//     // @ts-ignore
//     detectorEventEmitter.listeners?.(EventsName.UserDidCapturedScreen).length ??
//     0
//   );
// };

export const addScreenCapturedListener = Platform.select<
  (listener: () => void) => Unsubscribe
>({
  default: (): Unsubscribe => () => {},
  ios: commonAddScreenCapturedListener,
  android: (listener: () => void): Unsubscribe => {
    // TODO: add Android screen capture support
    return () => {};
  },
});
