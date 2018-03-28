//
//  RecordWhistleViewController.swift
//  pro33
//
//  Created by mahmoud6 on 3/13/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import AVFoundation


class RecordWhistleViewController: UIViewController , AVAudioRecorderDelegate {

    var recordingSession : AVAudioSession!
    var whistleRecorder : AVAudioRecorder!
    var stackView : UIStackView!
    var recordButton : UIButton!
    
    override func loadView() {
    
    super.loadView()

        view.backgroundColor = UIColor.gray
        
        stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "record your whistle"
        
        recordingSession = AVAudioSession.sharedInstance()
        
        
        do
        {
             try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission({ [unowned self](allowed) in
                
                DispatchQueue.main.async {
                    if allowed {
                        self.loadrecordingUI()
                    }else {
                        self.loadFailUI()
                    }
                }
                
            })
        }
        catch
        {
            
        }
        
    }
    
    func loadrecordingUI(){
        
        recordButton = UIButton()
        recordButton.setTitle("tap to record", for: .normal)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.addTarget(self, action: #selector(Tapped), for: .touchUpInside)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        stackView.addArrangedSubview(recordButton)
        
        
    }
    
    func loadFailUI(){
        
        let failLabel = UILabel()
        
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        failLabel.text = "jbdljvbn"
        failLabel.numberOfLines = 0
        stackView.addArrangedSubview(failLabel)
        
    }
    @objc func Tapped(){
        
        if whistleRecorder == nil {
            startRecording()
        }else {
            finishRecording(success: true)
        }
    
    }
    
    class func getDocumentryPath()-> URL{
    
        let fm = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         let path = fm[0]
        return path
    
    }
    
    class func getURLForWhistle() -> URL {
        
        return getDocumentryPath().appendingPathComponent("whistle.m4a")
    }
    
    func startRecording(){
        
        
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        
        recordButton.setTitle("Tap to stop", for: .normal)
        
        let settingDic = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC), AVSampleRateKey : 1200 , AVNumberOfChannelsKey : 1 , AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue ]
        let path = RecordWhistleViewController.getURLForWhistle()
        
        do {
        whistleRecorder = try AVAudioRecorder(url: path, settings: settingDic)
            
           whistleRecorder.delegate = self
            whistleRecorder.record()
        }catch{
            
            finishRecording(success: false)
            
        }
        
        
        
    }
    
    func finishRecording(success : Bool){
        
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if success {
            
            recordButton.setTitle("Tap to Re-record", for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    
        
    }
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    @objc func nextTapped() {
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
