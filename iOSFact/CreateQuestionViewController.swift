//
//  CreateQuestionViewController.swift
//  iOSFact
//
//  Created by James Daniell on 29/11/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData


class CreateQuestionViewController: UIViewController {

    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answerText: UITextView!
    @IBOutlet weak var datePick: UIDatePicker!
    
    @IBAction func backButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: {})
    }
    @IBAction func submitQuestion(_ sender: Any)
    {
        if questionText.text != nil
        {
            if answerText.text != nil
            {
                if datePick.date != nil
                {
                    let coreData = CoreData()
                    let question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: coreData.managedObjectContext) as! Question
                    
                    question.questionContent = questionText.text
                    question.answerContent = answerText.text
                    question.examDate = datePick.date as NSDate?
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
                    request.predicate = NSPredicate(format: "name = %@", questionSubject)
                    do
                    {
                        if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
                        {
                            let subjects = results as! [Subject]
                            question.subject = subjects[0]
                            coreData.saveContext()
                            print("saved")
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
            }
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(questionSubject)
        // Do any additional setup after loading the view.
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
