//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Luciano Schillagi on 11/7/16.
//  Copyright © 2016 Luko. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!


    @IBAction func recordAudio(_ sender: AnyObject) {
			
			recordingLabel.text = "Grabación en progreso"
			stopRecordingButton.isEnabled = true
			recordingButton.isEnabled = false
			
			stopRecordingButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
			
			
			let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
			let recordingName = "recordedVoice.wav"
			let pathArray = [dirPath, recordingName]
			let filePath = NSURL.fileURL(withPathComponents: pathArray)
			print(filePath ?? "")
			
			let session = AVAudioSession.sharedInstance()
			try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
			
			try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
			audioRecorder.delegate = self
			audioRecorder.isMeteringEnabled = true
			audioRecorder.prepareToRecord()
			audioRecorder.record()
			
    }
	
    @IBAction func stopRecording(_ sender: AnyObject) {
			
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Presiona para Grabar"
        audioRecorder.stop()
			
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print ("View Will Appear Called")
        
        stopRecordingButton.isEnabled = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    
        
        print ("AVAudioRecorder finished saving recording")
        if (flag) {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
        print ("Saving to recording failed")
    }
    
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "stopRecording") {
                let playSoundsVC = segue.destination as! PlaySoundsViewController
                let recordedAudioURL = sender as! URL
                playSoundsVC.recordedAudioURL = recordedAudioURL
            }
        }
    }




