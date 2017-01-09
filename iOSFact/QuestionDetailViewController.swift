//
//  QuestionDetailViewController.swift
//  iOSFact
//
//  Created by James Daniell on 28/12/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController
{

    
    @IBOutlet weak var questionContent: UILabel!
    @IBOutlet weak var flipButton: UIImageView!
    
    var content: String?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var tap = UITapGestureRecognizer(target: self, action: #selector(QuestionDetailViewController.filpTapped))
        flipButton.addGestureRecognizer(tap)
        flipButton.isUserInteractionEnabled = true
        questionContent.text = currentQuestion

    }
    func filpTapped()
    {
        let answerPageView = self.storyboard?.instantiateViewController(withIdentifier: "AnswerSection") as! AnswerViewController
        self.navigationController?.pushViewController(answerPageView, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        

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
