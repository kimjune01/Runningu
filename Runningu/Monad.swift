//
//  Monad.swift
//  Runningu
//
//  Created by Camvy Films on 2015-03-09.
//  Copyright (c) 2015 June. All rights reserved.
//

import UIKit


class Monad: NSObject {
  func andThen (completionBlock:(Bool) -> ()) -> Monad {
    asynchronousCall("awer"){ (completed: Bool) -> () in
      completionBlock(completed)
    }
    return self
  }
  
  func asynchronousCall(someString:String, completion: (Bool) -> ()) {
    
  }
}
