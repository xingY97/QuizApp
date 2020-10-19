//
//  ResultViewController.swift
//  QuizApp
//
//  Created by XIN on 10/18/20.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}
class ResultViewController: UIViewController {

    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate:ResultViewControllerProtocol?
    
    //ViewDidLoad only appears once, when all the elements loaded into the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round the dialog box corners
        dialogView.layer.cornerRadius = 10
        
    }
    //happens every single time when the view is about to shown to the user
    override func viewWillAppear(_ animated: Bool) {
        
        //Now that the elements have loaded, set the text
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
    }
    

    @IBAction func dismissTapped(_ sender: Any) {
        //dismiss the popup
        dismiss(animated: true, completion: nil)
        
        //Notify delegate the popup was dismissed
        delegate?.dialogDismissed()
    }
    
}
