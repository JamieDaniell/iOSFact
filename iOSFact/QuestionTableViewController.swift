//
//  QuestionTableViewController.swift
//  iOSFact
//
//  Created by James Daniell on 29/11/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData

var currentQuestion: String = ""
var questionSubject: String = "Happy"

class QuestionTableViewController: UITableViewController
{

    
    let coreData = CoreData()
    var managedObjectContext: NSManagedObjectContext!
    var questions: [Question]? = []
    var results: [NSManagedObject]? 
    //let questions = ["When did contantinople fall?" , "How many wives did Henry VIII have?" , "Who is the most great?" , "Is this app great or what?"]


    @IBAction func dismissView(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadQuestions()
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionTableViewController.refreshQuestionList), name: NSNotification.Name(rawValue: "refreshQuestionList"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        print(questionSubject)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath as IndexPath)
        
        
        
        cell.textLabel?.text = questions?[indexPath.row].questionContent
        var rowImage = UIImage(named: "ProgressCircleFour")
        if questions?[indexPath.row].correctNeeded == 0
        {
            rowImage = UIImage(named: "ProgressCircleZero")
        }
        if questions?[indexPath.row].correctNeeded == 1
        {
            rowImage = UIImage(named: "ProgressCircleOne")
        }
        else if questions?[indexPath.row].correctNeeded == 3
        {
            rowImage = UIImage(named: "ProgressCircleThree")
        }
        else if questions?[indexPath.row].correctNeeded == 2
        {
            rowImage = UIImage(named: "ProgressCircleTwo")
        }

        
        cell.imageView?.image = rowImage
        let itemSize = CGSize(width: 50 , height: 50)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedQuestion = questions?[indexPath.row]
        currentQuestion = (selectedQuestion?.questionContent!)!
    }
    
    func loadQuestions()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.predicate = NSPredicate(format: "subject.name = %@", questionSubject)
        do
        {
            if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
            {
                questions = results as! [Question]
                self.tableView.reloadData()
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
    func refreshQuestionList()
    {
        loadQuestions()
        print("questions loaded")
        self.tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("Delete Row")
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        var cell = tableView.cellForRow(at: indexPath)
        /*
        let edit = UITableViewRowAction(style: .normal, title: "  Edit    ") { action, index in
            // Go To Form to edit the the
            print("edit the question")
        }
        edit.backgroundColor = UIColor.orange
         */
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            let cellKey = cell?.textLabel?.text
            let alert = UIAlertController(title: "Delete Question", message: "Are you sure you want to delete question?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                self.deleteQuestion(key: cellKey!)
                //self.collectionView?.deleteItems(at: [activeIndexPath!])
                self.refreshQuestionList()
                //print(self.subjects)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        delete.backgroundColor = UIColor.red
        
        return [delete]

    }
    
    func deleteQuestion(key: String)
    {
        do
        {
            let questionRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
            questionRequest.predicate = NSPredicate(format: "subject.name = %@", questionSubject)
            let questionResults = try coreData.managedObjectContext.fetch(questionRequest) as! [Question]
            for question in questionResults
            {
                if question.questionContent == key
                {
                    print("Question Name: \(question.questionContent)")
                    coreData.managedObjectContext.delete(question)
                    coreData.saveContext()
                    
                }
            }
            
        }
        catch
        {
            print("error fetching subjects")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
