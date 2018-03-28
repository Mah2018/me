
import UIKit
import CoreGraphics





class viewController : UIViewController {


    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotated()
        
        
        
    }


    

    func rotated() {
    
    
    
        let renderer = UIGraphicsImageRenderer(size : CGSize(width : 512, height : 512))
        

        
        let img = renderer.image { ctx in
            
           
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // 3
            let attrs = [NSAttributedString.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedString.paragraphStyle: paragraphStyle]
            
            // 4
            let string : NSString = "The best-laid schemes o'\nmice an' men gang aft agley"
            string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
            // 5
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        
        }
        
    imageView.image = img
    
    }

























}
