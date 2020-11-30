//
//  ImageViewController.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 12/11/20.
//

import UIKit

import BSImagePicker

import Photos

protocol ImageControllerDelegate {
    func getPath()->String
}


class ImageViewController : UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var barItem : UIBarItem!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var indicatorView : UIView!
    @IBOutlet weak var sampleView: UIView!
    @IBOutlet var addImageButton , saveButton , homeButton , favouriteButton : UIButton!
    @IBOutlet var nameTextField : UITextField!
    var selectedImage = UIImage()
    var myDocArray = NSMutableArray()
    var selectedFolderName = String()
    var favArray = [ImageDB]()
    var imageArray = [ImageDB]()
    var delegate : ImageControllerDelegate!
    var indexForCell : Int!
    var editTag = 0
    var indexPath = IndexPath()
   @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    @IBOutlet weak var sampleIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showActivityIndicatory()
        
        sampleView.isHidden = true
        selectedFolderName = self.delegate.getPath()
        
        imageArray = ImageDBManager.fetchFolderImage(folder_name: selectedFolderName)
        self.setupBarButton()
        self.setupTableView()
        //let fileManager = FileManager.default
        //let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(selectedFolderName)
        
        navigationItem.title =   "Folder Name: \(selectedFolderName)"
        
        let fileManager = FileManager.default
        let pathOne = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("main")
        if !fileManager.fileExists(atPath: pathOne){
            do {
                try fileManager.createDirectory(atPath: pathOne, withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print(error.localizedDescription)
            }
        }
        else{

        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedFolderName = self.delegate.getPath()
        sampleView.isHidden = true
        if editTag == 1
        {
            navigationItem.hidesBackButton = true
        }
        tableView.reloadData()
        
    }
    
    
    
    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CELL")
        tableView.tableFooterView = UIView.init()
    }
    
    
    
    func setupBarButton()
    {
        let addButton = UIBarButtonItem(title: "Add",  style: .plain, target: self, action: #selector(didTapAddButton(sender:)))
        let editButton   = UIBarButtonItem(title: "Edit",  style: .plain, target: self, action: #selector(didTapEditButton(sender:)))
        navigationItem.rightBarButtonItems = [editButton , addButton]
    }
    
    
    
    
    
    @IBAction func favouriteButtonTapped()
    {
        print("got")
        if editTag == 1
        {
            return
        }
        let favouriteVC = self.storyboard?.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
        favouriteVC.modalPresentationStyle = .fullScreen
        favouriteVC.delegate = self
        self.present(favouriteVC, animated: true, completion: nil)
        
    }
    
    
    @objc func didTapHomeButton(sender: AnyObject)
    {
        if editTag == 1
        {
            return
        }
        print("tapped home")
    }
    
    
    @objc func didTapAddButton(sender: AnyObject){
        
        //print("add")
        
        if editTag == 1
        {
            return
        }
      
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 50
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true
    
            let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
                print("Selected: \(asset)")
            }, deselect: { (asset) in
                print("Deselected: \(asset)")
            }, cancel: { (assets) in
                print("Canceled with selections: \(assets)")
            }, finish: { (assets) in
                
                print("--------------")
                if Thread.isMainThread {
                                print("Thread is main")
                            }
                print("--------------")
                
                DispatchQueue.main.async {
                    self.sampleView.isHidden = false
                    self.sampleIndicator.startAnimating()

                }
                
                
               
                DispatchQueue.global(qos: .background).async {
                for temp in assets{

                    let img = self.getUIImage(asset: temp)
                    self.selectedImage = img!
                    //DispatchQueue.global(qos: .background).async {
                    self.saveImageintoDocumentDirectory()
                   // }
                    print("Hello")

                }
                    DispatchQueue.main.async {
                        self.sampleIndicator.stopAnimating()
                        self.sampleView.isHidden = true
                    }
                }
                print("count")
                
                DispatchQueue.main.async {
                    //self.sampleIndicator.stopAnimating()
                    //self.sampleView.isHidden = true
                }

                
                print("Finished with selections: \(assets)")
            }, completion: {
                //self.tableView.reloadData()
                print("After Completion imagePicker")
                let finish = Date()
                print(finish.timeIntervalSince(start))
            })


        
        
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    func saveImageintoDocumentDirectory(){
        
        //let obj = Helper()
        let fileName = Helper.getUniqueName()
        
        let fileManager = FileManager.default
        let pathOne = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("main/\(fileName)")
        
        //let pathTwo = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("thumb/\(fileName)")
        
        ///let pathsMain = pathOne.appendingPathComponent(fileName)
        print("paths is \(pathOne)")
//        if !fileManager.fileExists(atPath: pathsMain!.path){
//            try! fileManager.createDirectory(atPath: pathsMain!.path, withIntermediateDirectories: true, attributes: nil)
//            print("Again path \(pathsMain!.path)")
//            print("directory created")
//        }else{
//            print(" Already directory created.")
//        }
        
    
      
            if let data = self.selectedImage.jpegData(compressionQuality:  1.0){
                fileManager.createFile(atPath: pathOne, contents: data, attributes: nil)
//                do {
//                    try data.write(to: URL(fileURLWithPath: pathOne))
//                    //fileManager.createFile(atPath: pathOne, contents: data, attributes: nil)
//                    print("file saved")
//                    print(pathOne)
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
        else
            {
                print("already exist")
            }
        
        
        
        
        
//        let image = self.selectedImage.jpegData(compressionQuality: 1.0)
//
//        fileManager.createFile(atPath: pathsMain.path, contents: image, attributes: nil)
        
//        if let imageData = self.selectedImage.pngData(){
//            let options = [
//                kCGImageSourceCreateThumbnailWithTransform: true,
//                kCGImageSourceCreateThumbnailFromImageAlways: true,
//                kCGImageSourceThumbnailMaxPixelSize: 100] as CFDictionary // Specify your desired size at kCGImageSourceThumbnailMaxPixelSize. I've specified 100 as per your question
//
//            imageData.withUnsafeBytes { ptr in
//               guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
//                  return              }
//               if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count){
//                  let source = CGImageSourceCreateWithData(cfData, nil)!
//                  let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
//                  let thumbnail = UIImage(cgImage: imageReference) // You get your thumbail here
//                let data = thumbnail.jpegData(compressionQuality: 1.0)
//                  fileManager.createFile(atPath: pathsThumb!.path, contents: data , attributes: nil)
//               }
//            }
//
//                }
//
//        print("passed")
        
        //fileManager.createFile(atPath: pathsMain!.path, contents: image, attributes: nil)
        
        
        
        
        
        ImageDBManager.insertData(folder_name: selectedFolderName, image_name: fileName,icon_name: "star_icon")
        
        imageArray = ImageDBManager.fetchFolderImage(folder_name: self.selectedFolderName)
        DispatchQueue.main.async {
            self.sampleIndicator.startAnimating()
            self.tableView.reloadData()
        }
       
        
    }
    
    
    @objc func didTapEditButton(sender: AnyObject){
        if editTag == 0
        {
            editTag = 1
            navigationItem.rightBarButtonItems?[0].title = "Done"
            navigationItem.hidesBackButton = true
            //UITabBarController.tabBar.userInteractionEnabled = NO;
            if let items =  self.tabBarController?.tabBar.items {
                
                for i in 0 ..< items.count {
                    
                    let itemToDisable = items[i]
                    itemToDisable.isEnabled = false
                    
                }
            }
            
        }
        else{
            editTag = 0
            navigationItem.rightBarButtonItems?[0].title = "Edit"
            navigationItem.hidesBackButton = false
            if let items =  self.tabBarController?.tabBar.items {
                
                for i in 0 ..< items.count {
                    
                    let itemToDisable = items[i]
                    itemToDisable.isEnabled = true
                    
                }
            }
            
        }
    }
    
}





extension ImageViewController : UITableViewDelegate , UITableViewDataSource , MyCellDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELL",for: indexPath) as! TableViewCell
        cell.delegate = self
        
        
        
      
        
        let imageName = imageArray[indexPath.row].image_name
        let iconName = imageArray[indexPath.row].icon_name
        let fileName = imageName!
        
        print("file name : \(fileName)")
        
        
        
        let fileManager = FileManager.default
        let pathOne = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent("main")
       let pathsMain = URL(string: pathOne)?.appendingPathComponent(fileName)
        
        print(pathsMain?.path)
    
        //print("image name \(imageName) and path  \(pathsMain!.path)")
        let image =  UIImage(contentsOfFile: pathsMain!.path)
        cell.coverImageView.image = image
        cell.starButton.setBackgroundImage(UIImage(named: iconName!), for: UIControl.State.normal)
        cell.dateLabel.text = fileName
        
        //tableView.reloadData()
        return cell
    }
    
    
    func favouriteButtonTapped(cell: TableViewCell)  {
        
        if editTag == 1
        {
            return
        }
        
        
        
        self.indexPath = self.tableView.indexPath(for: cell)!
        
        
        
        let imageName = imageArray[indexPath.row].image_name!
        if(isKeyPresentInUserDefaults(key: imageName)) {
            
            if UserDefaults.standard.string(forKey: imageName) == "mark"
            {
                UserDefaults.standard.set("unmark", forKey: imageName)
                print("unmarked")
                cell.starButton.setBackgroundImage(UIImage(named: "start_icon"), for: UIControl.State.normal)
                
            }
            else{
                UserDefaults.standard.set("mark", forKey: imageName)
                print("marked")
                cell.starButton.setBackgroundImage(UIImage(named: "startMark"), for: UIControl.State.normal)
                
            }
            
        }else {
            UserDefaults.standard.set("mark", forKey: imageName)
            print("marked")
            cell.starButton.setBackgroundImage(UIImage(named: "startMark"), for: UIControl.State.normal)
        }
        ImageDBManager.updateIcon(image_name: imageName)
        imageArray = ImageDBManager.fetchFolderImage(folder_name: selectedFolderName)
        let indexPathRow: Int = indexPath.row
        let indexPosition = IndexPath(row: indexPathRow, section: 0)
//        self.tableView.beginUpdates()
//        self.tableView.reloadRows(at: [indexPosition], with: UITableView.RowAnimation.fade)
//        self.tableView.endUpdates()
        
        self.tableView.reloadData()
        
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editTag == 1
        {
            
            if editingStyle == .delete
            {
                //tableView.deleteRows(at: [indexPath], with: .bottom)
                let imageName = imageArray[indexPath.row].image_name!
                imageArray.remove(at: indexPath.row)
                ImageDBManager.deleteData(withIndex: indexPath.row)
                removeImageLocalPath(localPathName: imageName)
                if UserDefaults.standard.string(forKey: imageName) == "marked"
                {
                    UserDefaults.standard.set("unMarked", forKey: imageName)
                }
                
                tableView.reloadData()
                
                
            }
            
        }
        
    }
    
    func removeImageLocalPath(localPathName : String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = localPathName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            do{
                try fileManager.removeItem(atPath: fileURL.path)
            }
            catch
            {
                print("Could not clear temp folder: \(error)")
            }
        }
    }
    
}

extension ImageViewController : takeFromImageViewController
{
    func getFolderName() -> String
    {
        return selectedFolderName
    }
}





