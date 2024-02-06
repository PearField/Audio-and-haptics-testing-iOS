//
//  ViewController.swift
//  Audio_haptic_testing_app
//
//  Created by Benjamin Kallestein on 05/02/2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var sound = AVAudioPlayer()
    let testSounds = ["Zoom_Click_3rdVersion", "Zoom_Click_2ndVersion"]
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
