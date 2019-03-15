//
//  ViewController.swift
//  pitch perfect
//
//  Created by khalid alhazmi on 11/03/2019.
//  Copyright © 2019 khalid alhazmi. All rights reserved.
//

import UIKit
import AVFoundation 

class ViewController: UIViewController , AVAudioRecorderDelegate  {
    //first_page
    //audio
    var audioRecorder : AVAudioRecorder!
    
    //stopWatch
    var counter = 0.0
    var timer = Timer()
    var isStopClicked : Bool = false
    
    //labels
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var stpwchLabel: UILabel!
    
    //buttons
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var stopRecord: UIButton!
    
    
    
    //start+++++++++++++++++++++++++++++++++
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stpwchLabel.isHidden=true
        stopRecord.isHidden = true
        cancelButton.isHidden = true
        
        

 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isStopClicked = false
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    
    @IBAction func recordAudio(_ sender: Any) {
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        recordingLable.text = "recording..."
        recordAudio.isHidden = true
        stopRecord.isHidden = false
        cancelButton.isHidden = false
        stpwchLabel.isHidden=false
        
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
        
        isStopClicked = false



        
    }
    
    
    @IBAction func stopRecord(_ sender: Any) {
        recordingLable.text = "Tap to record"
        recordAudio.isHidden = false
        stopRecord.isHidden = true
        cancelButton.isHidden = true
        stpwchLabel.isHidden = true
        
        counter = 0.0
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        isStopClicked = true

        
    }
    
    @IBAction func cancelRecord(_ sender: Any) {
        recordAudio.isHidden = false
        
        stopRecord.isHidden = true
        
        cancelButton.isHidden = true
        
        recordingLable.text = "Tap to record"
        
        stpwchLabel.isHidden=true
        
        
        audioRecorder.stop()
        
        
        audioRecorder.deleteRecording()


        counter = 0.0
        
        isStopClicked = false
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag && isStopClicked){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"   {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
           
        }
    }
    
    
    @objc func updateTimer() {
        counter = audioRecorder.currentTime
        stpwchLabel.text = String(format: "%.1f", counter)
    }
    
    
    
    
    
    
    
}

