//
//  HomeCollectionViewController.swift
//  iOSFact
//
//  Created by James Daniell on 28/11/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "Cell"
private let deleteIdentifier = "DeleteCell"
let screenWidth = UIScreen.main.bounds.width
var titlePageActive: Bool = false


class HomeCollectionViewController: UICollectionViewController
{
    
    
    var activeCell : HomeCollectionViewCell? = nil
    var deleteIsShowing: Bool = false
    var subjects: [String: String] = [:]
    let coreData = CoreData()
    let subjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
    
    func fetchSubjects()
    {
        do
        {
            
            let subjectResults = try coreData.managedObjectContext.fetch(subjectRequest) as! [Subject]
            for subject in subjectResults
            {
                subjects.updateValue(subject.icon!, forKey: subject.name!)
            }
        }
        catch
        {
            print("error fetching subjects")
        }
    }
    func deleteSubject(key: String)
    {
        do
        {
            let subjectResults = try coreData.managedObjectContext.fetch(subjectRequest) as! [Subject]
            for subject in subjectResults
            {
                if subject.name! == key
                {
                    print("Subject Name: \(subject.name)")
                    coreData.managedObjectContext.delete(subject)
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
                    request.predicate = NSPredicate(format: "subject.name = %@" , key)
                    do
                    {
                        if let results = try coreData.managedObjectContext.fetch(request) as? [NSManagedObject]
                        {
                            for question in results
                            {
                                coreData.managedObjectContext.delete(question)
                                
                            }
                            subjects.removeValue(forKey: key)
                            coreData.saveContext()
                            refreshList()

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
        catch
        {
            print("error fetching subjects")
        }
    }
    func refreshList()
    {
        fetchSubjects()
        self.collectionView?.reloadData()
        print("Refreshed Subjects: \(subjects)")
        
    }
    // Related to the Ask in the main menu --> Asks all questons with outstanding answers
    /*@IBAction func askStack(_ sender: Any)
    {
        do
        {
            let questionRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
            let sortDescriptor = NSSortDescriptor(key: "correctNeeded" , ascending: false)
            let sortDescriptors = [sortDescriptor]
            questionRequest.sortDescriptors = sortDescriptors
            questionRequest.predicate = NSPredicate(format: "correctNeeded != %@", 0)
            let questionResults = try coreData.managedObjectContext.fetch(questionRequest) as! [Question]
            // ask the first question
            // show question
            currentQuestion = questionResults[0].questionContent!
            print("Page Active")
            titlePageActive = true
            let questionTablePageView = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
            self.navigationController?.pushViewController(questionTablePageView, animated: true)
            
        }
        catch
        {
            print("error fetching subjects")
        }
    }*/
    override func viewDidLoad()
    {
        fetchSubjects()
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCollectionViewController.refreshList), name: NSNotification.Name(rawValue: "refreshList"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToQuestions", let destination = segue.destination as? QuestionTableViewController
        {
            if let cell = sender , let indexPath = collectionView?.indexPath(for: cell as! UICollectionViewCell)
            {
                //let subject = subjects[indexPath.item]
                    //destination.subject = subject
            }
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }*/
    
    
    

    // MARK: UICollectionViewDataSource

    
    // need to find the number of Subjects
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

        return self.subjects.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // Top Cell
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.25
        cell.layer.cornerRadius = 5
        cell.frame.size.width = screenWidth / 2
        cell.frame.size.height = screenWidth / 2
  
        let key = Array(subjects.keys)[indexPath.row]
        let array = subjects[key]
        //print(array)
        cell.cellTitle.text = key 
        cell.cellTitle.textColor = UIColor.darkGray
        
        cell.cellImage.image = UIImage(named: (array! as String))
        
        cell.cellTitle.sizeToFit()
        cell.cellTitle.textAlignment = .center
        
        // Delete Cell
        // Configure the cell
            
        //cell.deleteView.backgroundColor = UIColor.red
        
        
        
        //deleteCell.cellTitle.text = "Delete"
        //deleteCell.cellTitle.textColor = UIColor.white
    
        //deleteCell.cellTitle.sizeToFit()
        //deleteCell.cellTitle.textAlignment = .center
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeCollectionViewController.userDidSwipeLeft))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        cell.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeCollectionViewController.userDidSwipeBackRight))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        cell.addGestureRecognizer(rightSwipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeCollectionViewController.userDidPressDelete))
        tap.numberOfTapsRequired = 1
        cell.addGestureRecognizer(tap)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //self.performSegue(withIdentifier: "ToQuestions", sender: collectionView.cellForItem(at: indexPath))
        
    }
    //func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    //{
        // If clicked on another cell than the swiped cell
        //let cell = collectionView.cellForItem(at: indexPath as IndexPath)
        //if activeCell != nil && activeCell != cell
        //{
        //    userDidSwipeBackRight()
        //}
    //}
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    /*
    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool 
    {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    //override func coll
    func respondToSwipeGesture(sender: UISwipeGestureRecognizer)
    {
    }
    func getCellAtPoint(point: CGPoint) -> UICollectionViewCell?
    {
        // Function for getting item at point. Note optionals as it could be nil
        let indexPath = collectionView?.indexPathForItem(at: point)
        var cell : UICollectionViewCell?
        
        if indexPath != nil
        {
            cell = collectionView?.cellForItem(at: indexPath!) as? HomeCollectionViewCell
        }
        else
        {
            cell = nil
        }
        
        return cell
    }
    func animationDuration() -> Double
    {
        return 0.5
    }
    func userDidPressDelete(sender: UISwipeGestureRecognizer)
    {
        
        let point = sender.location(in: collectionView)
        let cell = getCellAtPoint(point: point) as! HomeCollectionViewCell
        if deleteIsShowing
        {
            if (cell == nil || cell == activeCell)
            {
            
                let activeCell = getCellAtPoint(point: point) as! HomeCollectionViewCell
                let cellFrame = activeCell.frame
                let rect = CGRect( x: cellFrame.origin.x + cellFrame.width/2, y: cellFrame.origin.y, width: screenWidth/4, height: screenWidth/2)
                //print("cellFrame: \(cellFrame)")
                //print("rect: \(rect)")+
                //print("point: \(point)")
                if rect.contains(point)
                {
                    // If swipe point is in the cell delete it
                    let activeIndexPath = collectionView?.indexPath(for: activeCell)
                    let cellKey = activeCell.cellTitle.text
                    let alert = UIAlertController(title: "Delete Subject", message: "Are you sure you want to delete subject?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                        self.deleteSubject(key: cellKey!)
                        //self.collectionView?.deleteItems(at: [activeIndexPath!])
                        self.refreshList()
                        //print(self.subjects)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else if activeCell != cell // if you have clicked on another cell
            {
                // It's not the same cell that is swiped, so the previously selected cell will get unswiped and the new swiped.
                UIView.animate(withDuration: 0.5, animations:
                    {
                       self.activeCell?.titleCellView.transform = CGAffineTransform.identity
                       // cell.titleCellView.transform = CGAffineTransform(translationX: -cell.frame.width/2, y: 0)
                }, completion: nil )
                activeCell = nil
                deleteIsShowing = false
                
            }
            userDidSwipeBackRight()
            
        }
        else
        {
            let activeCell = getCellAtPoint(point: point) as! HomeCollectionViewCell
            let indexPath = collectionView?.indexPath(for: activeCell)
            //let destination = QuestionTableViewController()
            questionSubject = activeCell.cellTitle.text!
            // indicates if we wnat to go back to title or question table
            titlePageActive = false
            self.performSegue(withIdentifier: "ToQuestions", sender: self)

        }
        
    }
    func userDidSwipeLeft(sender: UISwipeGestureRecognizer)
    {
        let point = sender.location(in: collectionView)
        let duration = 0.5
        
        print("Left swipe: \(point)")
        //If the active cell is equal to nil
        if(activeCell == nil)
        {
            print("nil clause")
            // get the active cell
            activeCell = getCellAtPoint(point: point) as! HomeCollectionViewCell!
            // perform animation to show delete
            UIView.animate(withDuration: duration, animations:
                {
                    self.activeCell?.titleCellView.transform = CGAffineTransform(translationX: -(self.activeCell?.frame.width)! / 2, y: 0)
                });
            // delete is now showing
            deleteIsShowing = true
            
        }
    }
    func userDidSwipeBackRight()
    {
        // Revert back
        if(activeCell != nil)
        {
            let duration = animationDuration()
            
            UIView.animate(withDuration: duration, animations:
            {
                self.activeCell?.titleCellView.transform = CGAffineTransform.identity
            }, completion:
            {
                (Void) in
                self.activeCell = nil
            })
        }
        deleteIsShowing = false
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "homeToQuestion"
        {
            //Note that, originally, destinationViewController is of Type UIViewController and has to be casted as myViewController instead since that's the ViewController we trying to go to.
            let destinationVC = segue.destination as! QuestionDetailViewController
            do
            {
                // find all questions with a nextDate <= current date
                let questionRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
                let sortDescriptor = NSSortDescriptor(key: "nextDate" , ascending: true)
                let sortDescriptors = [sortDescriptor]
                questionRequest.sortDescriptors = sortDescriptors
                let currentDate = NSDate()
                questionRequest.predicate = NSPredicate(format: "nextDate <= %@", currentDate)
                
                let questionResults = try coreData.managedObjectContext.fetch(questionRequest) as! [Question]
                // ask the first question
                // show question
                if !questionResults.isEmpty
                {
                    currentQuestion = questionResults[0].questionContent!
                    destinationVC.content  = questionResults[0].questionContent
                    titlePageActive = true
                    let questionTablePageView = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
                //self.navigationController?.pushViewController(questionTablePageView, animated: true)
                }
                
            }
            catch
            {
                print("error fetching subjects")
            }
        }
    }
     */

    @IBAction func askStack(_ sender: Any)
    {
        
        let questionRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        let sortDescriptor = NSSortDescriptor(key: "nextDate" , ascending: true)
        let sortDescriptors = [sortDescriptor]
        questionRequest.sortDescriptors = sortDescriptors
        let currentDate = NSDate()
        questionRequest.predicate = NSPredicate(format: "nextDate <= %@", currentDate)
        do
        {
            let questionResults = try coreData.managedObjectContext.fetch(questionRequest) as! [Question]
            // ask the first question
            // show question
            if !questionResults.isEmpty
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let questionDetailViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
                currentQuestion = questionResults[0].questionContent!
                questionDetailViewController.content  = questionResults[0].questionContent
                titlePageActive = true
                
                self.present(questionDetailViewController, animated:true, completion:nil)
            }
            else
            {
                let alert = UIAlertController(title: "No Questions Due Today", message: "Come back tomorrow or select a subject!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        catch
        {
            
            print("Error in ask stack")
        }
    }



}
