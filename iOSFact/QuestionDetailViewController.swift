//
//  QuestionDetailViewController.swift
//  iOSFact
//
//  Created by James Daniell on 28/12/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    
    @IBOutlet weak var questionContent: UILabel!
    var content: String?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        questionContent.text = currentQuestion

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
