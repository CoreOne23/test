//
//  TelestrationViewController.swift
//  DigitalGameday
//
//  Created by Priyesh Pilapally on 17/02/17.
//  Copyright © 2017 Gist Digital. All rights reserved.
//

import UIKit
import AVFoundation
import NXDrawKit

class TelestrationViewController: UIViewController {

    @IBOutlet weak var VideoContainer: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    //For Drawing
    weak var canvasView: Canvas?
    weak var paletteView: Palette?
    weak var toolBar: ToolBar?
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var timeObserver: AnyObject!
    var gotResposne: Bool = false
    //Counts to know which subview should be added and dimiss
    var propertyIndexForAddView: Int = 0
    var propertyIndexToDismissView: Int = 0
    //Pan gesture recogniser
    var parentClass  = VideoParent()
    var videoSuorce: String?
    var telestrationObjects: [VideoProperty] = []
    //String : color  dictionary
    var colors : [String:UIColor] = ["white": UIColor.white,
                                     "black": UIColor.black,
                                     "gray": UIColor.gray,
                                     "turquoise": UIColor.cyan,
                                     "red": UIColor.red,
                                     "yellow": UIColor.yellow,
                                     "blue": UIColor.blue,
                                     "green": UIColor.green]
    //Array of views(telestrations to addSubview)
    var arrayOfViewToAdd = [AnyObject]()
    //Array of views to dismiss
    var arrayOfViewToDismiss = [AnyObject] ()
    //Strartingtime array and ending time array to trigger adsubview adn dismiss view method
    var telestrationPropertiesStartingTime: [Float] = []
    var telestrationPropertiesEndingTime: [Float] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 0.4
        pauseButton.layer.cornerRadius = 0.4
        for eachTelestration in parentClass.clip.properties {
            self.telestrationPropertiesStartingTime.append(eachTelestration.telestration_element_begin!)
            self.telestrationPropertiesEndingTime.append(eachTelestration.telestration_element_end!)
        }
        //* -------- Here Assuming first trasition will end first. In case if not, we should sort arrayOfViewToDismiss according to telestration-element-end time. ----------- *//
        self.populateArrayOfUiviews(parentClass: parentClass)
        self.playVideo()
    }
    
    override func viewDidLayoutSubviews() {
        avPlayerLayer.frame = VideoContainer.bounds
    }
    //MARK:- Palette Actions
    @IBAction func playerButtonTapped(_ sender: AnyObject) {
        avPlayer.play()
        startButton.isEnabled = false
        pauseButton.isEnabled = true
    }

    @IBAction func pauseButtonTapped(_ sender: AnyObject) {
        avPlayer.pause()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editedVideo(_ sender: AnyObject) {
        //The new video is played with the edited object
        TelestrationVideo().playVideo(sourceUrl: videoSuorce!, jsonObject: self.parentClass)
    }
    @IBAction func drawButtonTapped(_ sender: AnyObject) {
        self.initializeDrawing()

    }
    //MARK: - Canvas methods
    fileprivate func initializeDrawing() {
        self.setupCanvas()
        self.setupPalette()
        self.setupToolBar()
    }
    
    fileprivate func setupPalette() {
        let paletteView = Palette()
        paletteView.delegate = self
        paletteView.setup()
        self.view.addSubview(paletteView)
        self.paletteView = paletteView
        let paletteHeight = paletteView.paletteHeight()
        paletteView.frame = CGRect(x: 0, y: self.view.frame.height - paletteHeight, width: self.view.frame.width, height: paletteHeight)
    }
    
    fileprivate func setupToolBar() {
        let height = (self.paletteView?.frame)!.height * 0.25
        let startY = self.view.frame.height - (paletteView?.frame)!.height - height
        let toolBar = ToolBar()
        toolBar.frame = CGRect(x: 0, y: startY, width: self.view.frame.width, height: height)
        toolBar.undoButton?.addTarget(self, action: #selector(TelestrationViewController.onClickUndoButton), for: .touchUpInside)
        toolBar.redoButton?.addTarget(self, action: #selector(TelestrationViewController.onClickRedoButton), for: .touchUpInside)
        toolBar.saveButton?.addTarget(self, action: #selector(TelestrationViewController.onClickDoneButton), for: .touchUpInside)
        // default title is "Save"
        toolBar.saveButton?.setTitle("Done", for: UIControlState())
        toolBar.clearButton?.addTarget(self, action: #selector(TelestrationViewController.onClickClearButton), for: .touchUpInside)
        self.view.addSubview(toolBar)
        self.toolBar = toolBar
    }
    
    fileprivate func setupCanvas() {
        let canvasView = Canvas()
        canvasView.frame = CGRect.init(x: 0, y: 0, width: VideoContainer.frame.width, height: VideoContainer.frame.height)
        canvasView.delegate = self
       // canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).cgColor
        canvasView.layer.borderWidth = 0.0
        canvasView.layer.cornerRadius = 0.0
        canvasView.clipsToBounds = true
        canvasView.backgroundColor = UIColor.clear
        VideoContainer.addSubview(canvasView)
        self.canvasView = canvasView
    }
    
    fileprivate func updateToolBarButtonStatus(_ canvas: Canvas) {
        self.toolBar?.undoButton?.isEnabled = canvas.canUndo()
        self.toolBar?.redoButton?.isEnabled = canvas.canRedo()
        self.toolBar?.saveButton?.isEnabled = canvas.canSave()
        self.toolBar?.clearButton?.isEnabled = canvas.canClear()
    }

    func onClickUndoButton() {
        self.canvasView?.undo()
    }
    
    func onClickRedoButton() {
        self.canvasView?.redo()
    }
    
    func onClickDoneButton() {
        toolBar?.removeFromSuperview()
        paletteView?.removeFromSuperview()
        canvasView?.removeFromSuperview()
    }
    
    func onClickClearButton() {
        self.canvasView?.clear()
    }
    //MARK:- Play Video
    //Video Playing after respose
     private func playVideo() {
        //Video playback
        //Video source url --> change here
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: videoSuorce!))
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        VideoContainer.layer.insertSublayer(avPlayerLayer, at: 0)
        VideoContainer.layer.masksToBounds = false
        //Delegate trigger addSubview method for each properties starting time
        avPlayer.addBoundaryTimeObserver(forTimes: telestrationPropertiesStartingTime as [NSValue], queue: DispatchQueue.main){
            () -> Void in
            self.addSubviewsOnVideo(propertyIndex: self.propertyIndexForAddView )
            self.propertyIndexForAddView += 1
        }
        //Delegate trigger dismissSubViews method for each properties ending time
        avPlayer.addBoundaryTimeObserver(forTimes: telestrationPropertiesEndingTime as [NSValue], queue: DispatchQueue.main){
            () -> Void in
            self.dismissSubViews(propertyIndex: self.propertyIndexToDismissView)
            self.propertyIndexToDismissView += 1
        }
    }
    //Adding subviews
    private func addSubviewsOnVideo(propertyIndex: Int) {
            //SUBVIEW IS ADDED ALONG SIDE OBSERVER FOR DRAGGING
            let testView = self.arrayOfViewToAdd[propertyIndex] as! UIView
            let panRec = UIPanGestureRecognizer()
            panRec.addTarget(self, action:  #selector(TelestrationViewController.draggedView))
            testView.addGestureRecognizer(panRec)
            testView.isUserInteractionEnabled = true
            VideoContainer.clipsToBounds = true
            VideoContainer.addSubview(testView)
    }
    
    //Dismiss subviews
    private func dismissSubViews(propertyIndex: Int) {
            self.arrayOfViewToDismiss[propertyIndex].removeFromSuperview()
    }
    //View to dismiss and view to add are appended by same instance
    // Assuming all are text telestrations - for image separate uiview can be added
    private func populateArrayOfUiviews (parentClass: VideoParent) {
        var indexPath: Int = 0
        for eachTelestration in parentClass.clip.properties {
            let testView = UIView(frame: CGRect(x: CGFloat(eachTelestration.telestration_element_left!), y: CGFloat(eachTelestration.telestration_element_top!), width: CGFloat(eachTelestration.telestration_element_width!), height: CGFloat(eachTelestration.telestration_element_height!)) )
            if eachTelestration.telestration_element! == "text" {
                testView.backgroundColor = UIColor.white
                let textView = UILabel(frame: CGRect(x:0,y:0, width: CGFloat(eachTelestration.telestration_element_width!), height:CGFloat(eachTelestration.telestration_element_height!)))
                textView.text = eachTelestration.telestration_element_text
                textView.textColor = colors[eachTelestration.telestration_element_color!]
                textView.contentMode = UIViewContentMode.scaleAspectFill;
                textView.clipsToBounds = true
                testView.addSubview(textView)
                testView.tag = indexPath
                self.arrayOfViewToAdd.append(testView)
                self.arrayOfViewToDismiss.append(testView)
            }else {
                let imageView : UIImageView
                imageView  = UIImageView(frame: CGRect(x:0,y:0, width: CGFloat(eachTelestration.telestration_element_width!), height:CGFloat(eachTelestration.telestration_element_height!)))
                imageView.image = UIImage(named: eachTelestration.telestration_element_id!)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
                testView.addSubview(imageView)
                testView.tag = indexPath
                self.arrayOfViewToAdd.append(testView)
                self.arrayOfViewToDismiss.append(testView)
            }
            indexPath += 1
        }
    }
}
//MARK:- Canvas Delegates
extension TelestrationViewController: CanvasDelegate {
    //Update canvas
    func canvas(_ canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
        print("\(image?.size.width) -- height \(image?.size.height)")
        self.updateToolBarButtonStatus(canvas)
    }
    //MARK: - Delegate to get the rescent image
    //- same size as the canvas, need to crop acc. to rect
    func getRecentImage(temporary_image image: UIImage?, reactangleCoordinates coordinates: [Float]) {
        //Removing canvas therby removing recent drawing
        canvasView?.removeFromSuperview()
        //Setting up canvas for new drawing
        setupCanvas()
        //Added extra points to rect
        let rect = CGRect(x: CGFloat(coordinates[0] - 25), y: CGFloat(coordinates[1] - 25), width: CGFloat(coordinates[2] + 25 ), height: CGFloat(coordinates[3] + 25))
        //View to hold imagivew with drawn image
        let testView = UIView(frame: rect)
        testView.backgroundColor = UIColor.clear
        //Rect for imageView inside the testView having same wdith and height as tesView but origin (0,0)
        let rectImage = CGRect(x: 0, y: 0, width: CGFloat(coordinates[2] + 25 ), height: CGFloat(coordinates[3] + 25))
        //Creating imageView to put inside testView
        let imageView  = UIImageView(frame : rectImage)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        //Setting imageView's image to cropped image
        imageView.image =    image?.cropImage(rect)
        VideoContainer.clipsToBounds = true
        testView.addSubview(imageView)
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action:  #selector(TelestrationViewController.draggedView))
        testView.addGestureRecognizer(panRec)
        testView.isUserInteractionEnabled = true
        VideoContainer?.addSubview(testView)
    }
}
//MARK: - Palette Delagates
extension TelestrationViewController: PaletteDelegate {
    func colorWithTag(_ tag: NSInteger) -> UIColor? {
        if tag == 4 {
            // if you return clearColor, it will be eraser
            return UIColor.clear
        }
        return nil
    }
    func brush() -> Brush? {
        return self.paletteView?.currentBrush()
    }
}
extension TelestrationViewController {
    //MARK: - Handle draggedView
    func draggedView(sender:UIPanGestureRecognizer) {
        print("panning")
        let translation = sender.translation(in: self.view)
        print("the translation x:\(translation.x) & y:\(translation.y)")
        print(sender.view?.tag ?? 0)
        //sender.view.
        let tmp=sender.view?.center.x  //x translation
        let tmp1=sender.view?.center.y //y translation
        //frame has translated x y coordinates of the draged view
        let frame = sender.view?.convert(view.frame, from: VideoContainer)
        print("\(frame)")
        //Iterate to get the drageed view's indexpath
        var propertyIndex: Int = 0
        //set limitation for x and y origin
        if((sender.view?.frame.maxY)! <= VideoContainer.frame.height && (sender.view?.frame.maxX)! <= VideoContainer.frame.width && (sender.view?.frame.minY)! >= 0 && (sender.view?.frame.minX)! >= 0) {
            sender.view?.center = CGPoint.init(x:  tmp!+translation.x, y: tmp1!+translation.y)//CGPoint(x: tmp!+translation.x, tmp1!+translation.y)
            sender.setTranslation(CGPoint.zero , in: self.VideoContainer)
            for eachTelestration in parentClass.clip.properties {
                if propertyIndex == sender.view!.tag {
                    print("found")
                    //Setting the new x, y cordinates to the view
                    eachTelestration.telestration_element_left = Float((frame!.origin.x) * -1)
                    eachTelestration.telestration_element_top = Float((frame!.origin.y) * -1)
                }
                propertyIndex += 1
            }
        }else {
            var propertyIndex = 0
            for eachTelestration in parentClass.clip.properties {
                if propertyIndex == sender.view!.tag {
                    sender.view?.center = CGPoint.init( x: (CGFloat(eachTelestration.telestration_element_left!) + ( sender.view?.frame.width)! / 2 ), y: CGFloat(eachTelestration.telestration_element_top!) +  ( sender.view?.frame.height)! / 2 )//CGPoint(x: tmp!+translation.x, tmp1!+translation.y)
                    sender.setTranslation(CGPoint.zero , in: self.VideoContainer)
                }
                propertyIndex += 1
            }
        }
    }

}
