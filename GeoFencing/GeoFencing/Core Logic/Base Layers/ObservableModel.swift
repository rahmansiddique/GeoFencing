//
//  ObservableModel.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 20/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation

class ObservableModel<T>{
    
    typealias CompletionHandler = ((T)->Void)
    private var observerList = [String:CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    
    //MARK: - Generic store for storing value
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    //MARK: - Datasource observer
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observerList[observer.description] = completionHandler
    }
    
    //MARK: - Add and notify method to add an observer and notify the changes
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    
    //MARK: - Notify the ViewModel that change has occured so its time to update the views
    
    private func notify() {
        observerList.forEach({ $0.value(value) })
    }
    
    //MARK: - Remove all observers
    
    deinit {
        observerList.removeAll()
    }
}
