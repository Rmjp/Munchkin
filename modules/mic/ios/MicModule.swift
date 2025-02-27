import ExpoModulesCore
import AVFAudio

public class MicModule: Module {
  let audioEngine = AVAudioEngine()
  var mixerNode = AVAudioMixerNode()

  var hwFormat: AVAudioFormat? = nil

  private func setupAudioSession() {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth])
      try session.setPreferredSampleRate(44100.0)
      try session.setActive(true)

      let actualSampleRate = session.sampleRate
      let inputChannels = session.inputNumberOfChannels

      hwFormat = nil

      // Check available microphones
      if let inputs = session.availableInputs {
        for input in inputs {
          if let dataSources = input.dataSources {
            for source in dataSources {
              print("Mic: \(source)")
            }
          }
        }
      }
    } catch {
      print("Audio Session error: \(error)")
    }
  }

  private func setupAudioEngine() {
    audioEngine.attach(mixerNode)
    audioEngine.connect(mixerNode, to: audioEngine.mainMixerNode, format: nil)

    let session = AVAudioSession.sharedInstance()

    // If you want to pick the first input port & data source automatically:
    if let inputPort = session.availableInputs?.first,
       let dataSources = inputPort.dataSources, 
       let firstDataSource = dataSources.first {
      configureInput(port: inputPort, source: firstDataSource)
    }

    do {
      try audioEngine.start()
    } catch {
      print("Error starting AudioEngine: \(error)")
    }
  }

  /// Configure the audio session's port and data source, then install a tap on the input node.
  private func configureInput(port: AVAudioSessionPortDescription,
                              source: AVAudioSessionDataSourceDescription) {
    let session = AVAudioSession.sharedInstance()
    do {
      // Set the preferred data source on the AVAudioSession port
      try port.setPreferredDataSource(source)
      // Then set that port as the preferred input
      try session.setPreferredInput(port)

      // Now install the tap on the audioEngine input node
      let inputNode = audioEngine.inputNode
      let format = inputNode.outputFormat(forBus: 0)
      inputNode.removeTap(onBus: 0)
      inputNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { [weak self] buffer, time in
        guard let self = self else { return }
        self.processAudioBuffer(buffer, timestamp: time, micName: source.description)
      }
    } catch {
      print("Error setting data source: \(error)")
    }
  }

  private func processAudioBuffer(_ buffer: AVAudioPCMBuffer,
                                  timestamp: AVAudioTime,
                                  micName: String) {
    let audioData = bufferToData(buffer)
    // Convert sampleTime (AVAudioFramePosition) to Double before dividing
    let timeStamp = Double(timestamp.sampleTime) / timestamp.sampleRate

    let event: [String: Any] = [
      "mic": micName,
      "timestamp": timeStamp,
      "audio": audioData.base64EncodedString()
    ]

    // New Expo Modules API usage: no argument labels
    sendEvent("onAudioData", event)
  }

  private func bufferToData(_ buffer: AVAudioPCMBuffer) -> Data {
    let frameLength = Int(buffer.frameLength)
    let channels = buffer.format.channelCount
    // We'll assume channel data is non-nil on first channel
    let floatData = buffer.floatChannelData?[0]
    let audioBuffer = UnsafeBufferPointer(start: floatData,
                                          count: frameLength * Int(channels))
    return Data(buffer: audioBuffer)
  }

  // MARK: - Module definition

  public func definition() -> ModuleDefinition {
    Name("Mic")

    OnCreate {
      self.setupAudioSession()
    }

    Constants([
      "PI": Double.pi
    ])

    Events("onChange", "onAudioData")

    Function("hello") {
      return "Hello world! 👋"
    }

    Function("getDataSources") {
      let audioSession = AVAudioSession.sharedInstance()

      guard let availableInputs = audioSession.availableInputs else {
        return []
      }

      var dataSourceDescriptions: [String] = []
      for input in availableInputs {
        if let dataSources = input.dataSources {
          for dataSource in dataSources {
            dataSourceDescriptions.append("\(dataSource)")
          }
        }
      }
      return dataSourceDescriptions
    }

    Function("startRecoding") {
      self.setupAudioEngine()
    }

    Function("stopRecording") {
      self.audioEngine.stop()
    }

    AsyncFunction("setValueAsync") { (value: String) in
      // Send an event to JavaScript.
      self.sendEvent("onChange", ["value": value])
    }

    // Optional: If you need to export a native view
    View(MicView.self) {
      Prop("url") { (view: MicView, url: URL) in
        if view.webView.url != url {
          view.webView.load(URLRequest(url: url))
        }
      }
      Events("onLoad")
    }
  }
}
