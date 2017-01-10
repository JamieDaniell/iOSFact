//
//  QuestionDetailViewController.swift
//  iOSFact
//
//  Created by James Daniell on 28/12/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData
var passBack: [Question]? = []

class QuestionDetailViewController: UIViewController
{

    
    @IBOutlet weak var questionContent: UILabel!
    @IBOutlet weak var flipButton: UIImageView!
    @IBOutlet weak var cardView: UIView!
    var content: String?

    let coreData = CoreData()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionDetailViewController.hideCard), name: NSNotification.Name(rawValue: "hideCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionDetailViewController.backButton), name: NSNotification.Name(rawValue: "backButton"), object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(QuestionDetailViewController.filpTapped))
        flipButton.addGestureRecognizer(tap)
        flipButton.isUserInteractionEnabled = true
        print(content)
        questionContent.text = content
        view.backgroundColor = UIColor.clear
        self.cardView.layer.borderWidth = 2.0
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        self.cardView.layer.cornerRadius = 10
    }
    @IBAction func backButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func filpTapped()
    {
        performSegue(withIdentifier: "toAnswer", sender: self)
    }
    func hideCard()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.predicate = NSPredicate(format: "subject.name = %@", questionSubject)
        do
        {
            if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
            {
                currentQs = results as! [Question]
                self.dismiss(animated: true, completion: { () -> Void in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshContentList"), object: nil)
                })
            }
            else
            {
                print("no values")
            }
            
        }
        catch
        {
            fatalError("Error fetching questions")
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toAnswer"
        {
            //Note that, originally, destinationViewController is of Type UIViewController and has to be casted as myViewController instead since that's the ViewController we trying to go to.
            let destinationVC = segue.destination as! AnswerViewController
            self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {

    }

}
