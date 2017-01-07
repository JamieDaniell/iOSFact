//
//  SubjectChoiceViewController.swift
//  iOSFact
//
//  Created by James Daniell on 28/11/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData

class SubjectChoiceViewController: UIViewController  ,  UIPickerViewDelegate , UIPickerViewDataSource
{

    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerContent: String = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SubjectChoiceViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        pickerView.dataSource = self
        pickerView.delegate = self

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 11
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        var myImageView = UIImageView(frame: CGRect(x: 0,y: 0, width: 50, height: 50))
        switch row
        {
        case 0:
            myImageView.image = UIImage(named:"Bear")
        case 1:
            myImageView.image = UIImage(named:"Bee")
        case 2:
            myImageView.image = UIImage(named:"Bird")
        case 3:
            myImageView.image = UIImage(named:"Dog")
        case 4:
            myImageView.image = UIImage(named:"Duck")
        case 5:
            myImageView.image = UIImage(named:"Hachiko")
        case 6:
            myImageView.image = UIImage(named:"Hummingbird")
        case 7:
            myImageView.image = UIImage(named: "Owl")
        case 8:
            myImageView.image = UIImage(named:"Sheep")
        case 9:
            myImageView.image = UIImage(named:"Sstarfish")
        case 10:
            myImageView.image = UIImage(named:"Leopard")
        default:
            myImageView.image = nil
        }
        myView.addSubview(myImageView)
        return myView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        // do something with selected row
        switch row
        {
        case 0:
            pickerContent = "Bear"
        case 1:
            pickerContent = "Bee"
        case 2:
            pickerContent = "Bird"
        case 3:
            pickerContent = "Dog"
        case 4:
            pickerContent = "Duck"
        case 5:
            pickerContent = "Hachiko"
        case 6:
            pickerContent = "Hummingbird"
        case 7:
            pickerContent = "Owl"
        case 8:
            pickerContent = "Sheep"
        case 9:
            pickerContent = "Sstarfish"
        case 10:
            pickerContent = "Leopard"
        default:
            pickerContent = ""
        }
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitSubject(_ sender: Any)
    {
        let coreData = CoreData()
        let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: coreData.managedObjectContext) as! Subject
        if subjectName.text != nil
        {
            subject.name = subjectName.text
            subject.icon = pickerContent
            coreData.saveContext()
            self.dismiss(animated: true, completion: { () -> Void in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshList"), object: nil)
            })
        }
        else
        {
            let alertController = UIAlertController(title: "Title Needed", message: "You need to enter a title for your subject ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
 
        
    }
    
    @IBAction func dismissScene(_ sender: Any)
    {
        self.dismiss(animated: true, completion: {})
    }
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}
