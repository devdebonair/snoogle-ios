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

class SearchController: CollectionController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    let searchController: UISearchController
    var previousResults: Results<SearchResult>!
    
    init() {
        searchController = UISearchController(searchResultsController: nil)
        super.init()
        do {
            let realm = try Realm()
            self.previousResults = realm.objects(SearchResult.self)
        } catch {
            print(error)
        }
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
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            print(searchText)
        } else {
            print("results are empty")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
