//
//  InstrumentsPageController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/26/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

protocol PanelViewDelegate {
    func shouldTogglePanelView()
    func shouldShowPanelView()
    func shouldHidePanelView()
}

class InstrumentsPageController: UIPageViewController, ReportRenderable {
    var internalInstruments: InternalInstrumentsViewController?
    var externalInstruments: ExternalInstrumentsViewController?
    var restricted: UIViewController?
    
    var panelViewDelegate: PanelViewDelegate?
    var orderedPages = [UIViewController]()        
    
    func setReport(_ report: Report) {
        self.internalInstruments?.setReport(report)
        self.externalInstruments?.setReport(report)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        internalInstruments = UIStoryboard(name: "Instruments", bundle: nil).instantiateViewController(withIdentifier: "InternalInstruments") as? InternalInstrumentsViewController
        
        externalInstruments = UIStoryboard(name: "Instruments", bundle: nil).instantiateViewController(withIdentifier: "ExternalInstruments") as? ExternalInstrumentsViewController
        
        self.orderedPages.append(internalInstruments!)
        self.orderedPages.append(externalInstruments!)
        
        self.setViewControllers([self.orderedPages.first!], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}




extension InstrumentsPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedPages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedPages.count > previousIndex else {
            return nil
        }
        
         return orderedPages[previousIndex]
    }
    
    func allowRestrictedArea() {
        
        if restricted != nil { return }
        
        restricted = UIStoryboard(name: "Instruments", bundle: nil).instantiateViewController(withIdentifier: "CommandPanel")

        self.orderedPages.append(restricted!)
        
        self.setViewControllers([self.orderedPages.last!], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        guard let viewControllerIndex = orderedPages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let pagesCount = orderedPages.count
        
        guard pagesCount != nextIndex else {
            return nil
        }
        
        guard pagesCount > nextIndex else {
            return nil
        }
        
        return orderedPages[nextIndex]
    }
    
}

