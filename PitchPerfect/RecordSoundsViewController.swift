//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Kreta Desai on 9/26/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        stopRecordingButton.alpha = 0.5
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(recording: Bool) {
        if recording == true {
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            stopRecordingButton.alpha = 1.0
            recordButton.alpha = 0.5
            recordButton.isEnabled = false
        }
        else {
            recordButton.isEnabled = true
            recordButton.alpha = 1.0
            stopRecordingButton.alpha = 0.5
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
}

