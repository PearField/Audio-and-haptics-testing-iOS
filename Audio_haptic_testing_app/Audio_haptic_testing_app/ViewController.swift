//
//  ViewController.swift
//  Audio_haptic_testing_app
//
//  Created by Benjamin Kallestein on 05/02/2024.
//

import UIKit
import AVFoundation
import CoreHaptics

class ViewController: UIViewController {
    
    var engine: CHHapticEngine?
    
    var sound = AVAudioPlayer()
    let testSounds = ["Zoom_Click_3rdVersion", "Zoom_Click_2ndVersion", "clicktest", "RenameGroup01", "RenameGroup02", "NextButton_Compressed", "SelectButton_simple", "SelectButton_simple02", "Sound_SendMessage01_Compressed", "Sound_SendMessage03_Compressed", "Sound_RecieveMessage01", "Sound_RecieveMessage02", "Sound_RecieveMessage03", "AddToChat_Check", "AddToChat_UnCheck", "PeerNotificationSound02", "PeerNotificationSound02_Mix01", "PeerNotificationSound02_Mix02", "PeerNotificationSound02_Mix04", "PeerNotificationSound03", "ChatOptions_TrayMenu", "moji_send"]
    var soundInList = ""
    
    let hapticType = ["light impact", "medium impact", "heavy impact", "soft", "rigid", "success notification", "error notification", "warning notification",
    "selected changed"]
    var chosenHaptic = ""
    
    @IBOutlet weak var volumeSliderValue: UISlider!
    @IBOutlet var soundLevel: UILabel!
    
    @IBOutlet weak var hapticsTextField: UITextField!
    @IBOutlet weak var soundTextField: UITextField!
    
    let hapticsPickerView = UIPickerView()
    let soundPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hapticsTextField.inputView = hapticsPickerView
        soundTextField.inputView = soundPickerView
        
        hapticsPickerView.delegate = self
        hapticsPickerView.dataSource = self
        soundPickerView.delegate = self
        soundPickerView.dataSource = self
        
        hapticsTextField.placeholder = "Select haptic type"
        soundTextField.placeholder = "Select sound"
        
        hapticsTextField.textAlignment = .center
        soundTextField.textAlignment = .center
        
        hapticsPickerView.tag = 1
        soundPickerView.tag = 2
        
        createEngine()
    }
    
    
    
    /// - Tag: CreateEngine
    func createEngine() {
        
        
        // Create and configure a haptic engine.
        do {
            // Associate the haptic engine with the default audio session
            // to ensure the correct behavior when playing audio-based haptics.
            let audioSession = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
        
        guard let engine = engine else {
            print("Failed to create engine!")
            return
        }
        
        // The stopped handler alerts you of engine stoppage due to external causes.
        engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }
 
        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    
    
    @IBAction func testButton(_ sender: UIButton) {
        playSound()
        playHaptic()
    }
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        let value: Float = sender.value
        soundLevel.text = "\(value)"
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "\(soundInList)", withExtension: "mp3")
        sound = try! AVAudioPlayer(contentsOf: url!)
        sound.volume = volumeSliderValue.value
        sound.play()
    }
    
    func playHaptic() {
        if (chosenHaptic == "light impact") {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred(intensity: 1.0)
        }
        else if (chosenHaptic == "medium impact"){
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred(intensity: 1.0)
        }
        else if (chosenHaptic == "heavy impact"){
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred(intensity: 1.0)
        }
        else if (chosenHaptic == "soft"){
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred(intensity: 1.0)
        }
        else if (chosenHaptic == "rigid"){
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred(intensity: 1.0)
        }
        else if (chosenHaptic == "success notification"){
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        else if (chosenHaptic == "error notification"){
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        else if (chosenHaptic == "warning notification"){
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
        else if (chosenHaptic == "selected changed"){
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
        
    }
    
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return hapticType.count
        case 2:
            return testSounds.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return hapticType[row]
        case 2:
            return testSounds[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            hapticsTextField.text = hapticType[row]
            hapticsTextField.resignFirstResponder()
            chosenHaptic = hapticType[row]
        case 2:
            soundTextField.text = testSounds[row]
            soundTextField.resignFirstResponder()
            soundInList = testSounds[row]
        default:
            return
        }
    }
}
