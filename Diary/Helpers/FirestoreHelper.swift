//
//  FirestoreHelper.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import Firebase
import FirebaseFirestore

let db = { () -> Firestore in
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = true
    db.settings = settings
    return Firestore.firestore()
}()

//
//db.settings = settings

protocol FirestoreHelper {
    var collectionName: String { get }
}

extension FirestoreHelper {
    func getDocument( _ docId: String, completion: @escaping (String) -> () ) {
        db.collection(collectionName).document(docId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                completion(dataDescription)
            } else {
                print("Document does not exist")
                completion("nothing")
            }
        }
    }
}

