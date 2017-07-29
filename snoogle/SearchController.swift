//
//  SearchController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RealmSwift
import UIKit

class SearchController: CollectionController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    let searchController: UISearchController!
    var previousResults: Results<SearchResult>!
    
    init() {
        searchController = UISearchController(searchResultsController: nil)
        super.init()
        do {
            let realm = try Realm()
            self.previousResults = realm.objects(SearchResult.self)
            let viewModels = self.previousResults.map({ (result) -> SearchItemViewModel in
                return SearchItemViewModel(text: result.term)
            })
            self.models = Array(viewModels)
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let frame = keyboardFrame.cgRectValue
        let keyboardHeight = frame.height
        collectionNode.frame.size.height = collectionNode.frame.size.height - keyboardHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.setBorder(color: UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0))
        self.navigationItem.titleView = searchController.searchBar
        self.navigationController?.navigationBar.barTintColor = .white
        self.node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        self.searchController.searchBar.tintColor = UIColor(colorLiteralRed: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        self.updateModels()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let viewModels = self.previousResults.filter({ (result) -> Bool in
                return result.term.lowercased().starts(with: searchText.lowercased())
            }).map({ (result) -> SearchItemViewModel in
                return SearchItemViewModel(text: result.term)
            })
            self.models = Array(viewModels)
        } else {
            let viewModels = self.previousResults.map({ (result) -> SearchItemViewModel in
                return SearchItemViewModel(text: result.term)
            })
            self.models = Array(viewModels)
        }
        self.updateModels()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let controller = SearchPageController(term: searchText)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
