//
//  AnswerViewController.swift
//  iOSFact
//
//  Created by James Daniell on 29/12/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData
var answered: Bool = false

class AnswerViewController: UIViewController
{
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var crossImage: UIImageView!
    @IBOutlet weak var answerText: UILabel!
    var questionData: [Question]?
    
    @IBOutlet weak var backView: UIView!
    func fetchAnswer()
    {
        let coreData = CoreData()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        // Need to add AND subject
        request.predicate = NSPredicate(format: "questionContent = %@", currentQuestion)
        do
        {
            if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
            {
                questionData = results as! [Question]
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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // add festure recognisers for tick and cross
        var correctTap = UITapGestureRecognizer(target: self, action: #selector(AnswerViewController.correct))
        tickImage.addGestureRecognizer(correctTap)
        tickImage.isUserInteractionEnabled = true
        
        var incorrectTap = UITapGestureRecognizer(target: self, action: #selector(AnswerViewController.incorrect))
        crossImage.addGestureRecognizer(incorrectTap)
        crossImage.isUserInteractionEnabled = true
        // get data for display
        fetchAnswer()
        answerText.text = questionData?[0].answerContent
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        self.backView.layer.borderWidth = 2.0
        self.backView.layer.borderColor = UIColor.lightGray.cgColor
        self.backView.layer.cornerRadius = 10
    }
    
    func correct()
    {
        let coreData = CoreData()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        // Need to add AND subject
        request.predicate = NSPredicate(format: "questionContent = %@", currentQuestion)
        do
        {
            if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
            {
                questionData = results as? [Question]
                let question = questionData?[0]
                if question?.correctNeeded != 5
                {
                    question?.correctNeeded = (question?.correctNeeded)! + 1
                }
                print("--------- Saved ------------")
                coreData.saveContext()
                if titlePageActive != true
                {
                    self.dismiss(animated: true, completion: { () -> Void in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideCard"), object: nil)
                    })

                }
                else
                {
                    self.dismiss(animated: true, completion: { () -> Void in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backButton"), object: nil)
                    })
                }
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
    func incorrect()
    {
        let coreData = CoreData()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        // Need to add AND subject
        request.predicate = NSPredicate(format: "questionContent = %@", currentQuestion)
        do
        {
            if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
            {
                questionData = results as? [Question]
                let question = questionData?[0]
                if (question?.correctNeeded)! != 0
                {
                    question?.correctNeeded = (question?.correctNeeded)! - 1
                }
                coreData.saveContext()
                if titlePageActive != true
                {
                    //let questionTablePageView = self.storyboard?.instantiateViewController(withIdentifier: "QuestionTable") as! QuestionTableViewController
                    //self.navigationController?.pushViewController(questionTablePageView, animated: true)
                    self.dismiss(animated: true, completion: { () -> Void in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideCard"), object: nil)
                    })
                    
                    
                }
                else
                {
                    self.dismiss(animated: true, completion: { () -> Void in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backButton"), object: nil)
                    })
                }
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
    override func didReceiveMemoryWarning()
    {
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
