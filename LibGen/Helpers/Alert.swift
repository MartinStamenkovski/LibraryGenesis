//
//  Alert.swift
//  LibGen
//
//  Created by Martin Stamenkovski INS on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit

struct Alert {
    
    static func showMirrors(on vc: UIViewController, for md5: String, completion: @escaping((URL) -> Void)) {
        let actionSheetMirrors = UIAlertController(title: "Select download mirror", message: nil, preferredStyle: .actionSheet)
        
        let libTipsMirrorAction = UIAlertAction(title: "Mirror 1", style: .default) { _ in
            completion(URL(string: "http://libtips.org/main/\(md5)")!)
        }
        let libGenMirrorAction = UIAlertAction(title: "Mirror 2", style: .default) { _ in
            completion(URL(string: "http://libgen.lc/ads.php?md5=\(md5)")!)
        }
        let bookFiMirrorAction = UIAlertAction(title: "Mirror 3", style: .default) { _ in
            completion(URL(string: "http://bookfi.net/md5/\(md5)")!)
        }
        let bOKMirrorAction = UIAlertAction(title: "Mirror 4", style: .default) { _ in
            completion(URL(string: "http://b-ok.cc/md5/\(md5)")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        actionSheetMirrors.addAction(libTipsMirrorAction)
        actionSheetMirrors.addAction(libGenMirrorAction)
        actionSheetMirrors.addAction(bookFiMirrorAction)
        actionSheetMirrors.addAction(bOKMirrorAction)
        
        actionSheetMirrors.addAction(cancelAction)
        vc.present(actionSheetMirrors, animated: true, completion: nil)
    }
    
    static func errorLoadingBooks(on vc: UIViewController, with error: LibError, completion: @escaping((Bool) -> Void)) {
        switch error {
        case .error, .errorParsingHTML:
            Alert.retry(on: vc, with: error, completion)
        case .noResults:
            Alert.errorNoResults(on: vc, with: error, completion)
        }
    }
    
    static func retry(on vc: UIViewController, with error: LibError, _ completion: @escaping((Bool) -> Void)) {
        let alert = UIAlertController(title: "Error loading books, try again.", message: error.localizedDescription, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            completion(true)
        }
        alert.addAction(retryAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    private static func errorNoResults(on vc: UIViewController, with error: LibError,_ completion: @escaping((Bool) -> Void)) {
        let alert = UIAlertController(title: "Error loading books, try again.", message: error.localizedDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion(false)
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
