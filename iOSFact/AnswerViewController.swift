//
//  AnswerViewController.swift
//  iOSFact
//
//  Created by James Daniell on 29/12/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData

class AnswerViewController: UIViewController
{
    @IBOutlet weak var answerText: UILabel!
    var questions: [Question]?
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
                questions = results as! [Question]
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
        fetchAnswer()
        answerText.text = questions?[0].answerContent
        // Do any additional setup after loading the view.
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
