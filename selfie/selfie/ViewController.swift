//
//  ViewController.swift
//  selfie
//
//  Created by mahmoud6 on 3/28/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, MCSessionDelegate ,MCBrowserViewControllerDelegate{

    var session : MCSession!
    
    var peerID : MCPeerID!
    var advertiser : MCAdvertiserAssistant!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "selfie share "
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera
            , target: self, action: #selector(addPhoto))
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(showConnectionPrompt))
        
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
    
    }
    
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    func startHosting(action : UIAlertAction){
        advertiser = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: session)
        advertiser.start()
    }
    
    func joinSession(action : UIAlertAction){
        
        let browser = MCBrowserViewController(serviceType: "hws-project25", session: session)
        browser.delegate = self
        present(browser, animated: true)
        
    }
    
    @objc func addPhoto(){
        
       let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard  let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        
        dismiss(animated: true)
        
        
        images.insert(image, at: 0)
        collectionView?.reloadData()
        
        
        
        if session.connectedPeers.count > 0{
            
            if let imageData = UIImageJPEGRepresentation(image, 1){
                
                do {  try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
                }catch {
                    
                   
                }
            }
            
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
        
        
        switch state {
        case .connected : print("connected")
        case .connecting : print("connecting")
        case .notConnected : print("notconnected")
            
        }
        
    }
    
    
   
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        
        let image = UIImage(data: data)
        
        DispatchQueue.main.async {[unowned self] in
            
            self.images.insert(image!, at: 0)
            self.collectionView?.reloadData()
        }
        
        
        
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?){
        
    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController){
         dismiss(animated: true)
    }
    
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController){
         dismiss(animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

