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


class HomeCollectionViewController: UICollectionViewController
{
    
    private var activeCell : HomeCollectionViewCell!
    var deleteIsShowing: Bool = false
    var subjects = ["Maths": "Leopard", "German": "Starfish" , "French" : "Leopard" , "Geography" : "Sheep"]
    
    func fetchSubjects()
    {
        let coreData = CoreData()
        let subjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        do
        {
            
            let subjectResults = try coreData.managedObjectContext.fetch(subjectRequest) as! [Subject]
            for subject in subjectResults
            {
                subjects[subject.name!] = subject.icon
            }
        }
        catch
        {
            print("error fetching subjects")
        }
    }
    func refreshList()
    {
        print("X")
        fetchSubjects()
        self.collectionView?.reloadData()
        
    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
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
    }
    
    
    

    // MARK: UICollectionViewDataSource

    
    // need to find the number of Subjects
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of items
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
        if deleteIsShowing
        {
            
        }
        self.performSegue(withIdentifier: "ToQuestions", sender: collectionView.cellForItem(at: indexPath))
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
        print("HAPPY")
        //let cell = sender.view as! UICollectionViewCell

        /*if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            
            
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
        */
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
        if deleteIsShowing
        {
            let activeCell = getCellAtPoint(point: point) as! HomeCollectionViewCell
            let cellFrame = activeCell.frame
            let rect = CGRect( x: cellFrame.origin.x + cellFrame.width/2, y: cellFrame.origin.y, width: screenWidth/4, height: screenWidth/2)
            //print("cellFrame: \(cellFrame)")
            //print("rect: \(rect)")
            //print("point: \(point)")
            if rect.contains(point)
            {
                // If swipe point is in the cell delete it
                
                let indexPath = collectionView?.indexPath(for: activeCell)
                print("Removed")
                
            }
        }
        else
        {
            let activeCell = getCellAtPoint(point: point) as! HomeCollectionViewCell
            let indexPath = collectionView?.indexPath(for: activeCell)
            self.performSegue(withIdentifier: "ToQuestions", sender: collectionView?.cellForItem(at: indexPath!))
        }
        
    }
    func userDidSwipeLeft(sender: UISwipeGestureRecognizer)
    {
        let point = sender.location(in: collectionView)
        let duration = 0.5
        
        print("Left swipe: \(point)")
        //Bug here
        if(activeCell == nil)
        {
            print("nil clause")
            activeCell = getCellAtPoint(point: point) as! HomeCollectionViewCell!
            
            UIView.animate(withDuration: duration, animations:
                {
                    self.activeCell.titleCellView.transform = CGAffineTransform(translationX: -self.activeCell.frame.width/2, y: 0)
                });
            
            deleteIsShowing = true
            
        }
        else
        {
            // Getting the cell at the point
            let cell = getCellAtPoint(point: point) as! HomeCollectionViewCell
            print("else clause")
            
            // If the cell is the previously swiped cell, or nothing assume its the previously one.
            if (cell == nil || cell == activeCell)
            {
                // To target the cell after that animation I test if the point of the swiping exists inside the now twice as tall cell frame
                let cellFrame = activeCell.frame
                let rect = CGRect( x: cellFrame.origin.x - cellFrame.width, y: cellFrame.origin.y, width: screenWidth, height: screenWidth)
                if rect.contains(point)
                {
                    // If swipe point is in the cell delete it
                    
                    let indexPath = collectionView?.indexPath(for: activeCell)
                    print("Removed")
                    
                }
                // If another cell is swiped
            }
            else if activeCell != cell
            {
                // It's not the same cell that is swiped, so the previously selected cell will get unswiped and the new swiped.
                UIView.animate(withDuration: duration, animations:
                    {
                        self.activeCell.titleCellView.transform = CGAffineTransform.identity
                        cell.titleCellView.transform = CGAffineTransform(translationX: -cell.frame.width/2, y: 0)
                    }, completion:
                    {
                        (Void) in
                        
                        self.activeCell = cell as? HomeCollectionViewCell!
                    })
                
            }
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
                self.activeCell.titleCellView.transform = CGAffineTransform.identity
            }, completion:
            {
                (Void) in
                self.activeCell = nil
            })
        }
        deleteIsShowing = false
    }

    



}
