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
    
    var delegate: SearchPageControllerDelegate? = nil
    
    init() {
        searchController = UISearchController(searchResultsController: nil)
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            let realm = try Realm()
            self.previousResults = realm.objects(SearchResult.self)
            self.models = self.filterResults(searchTerm: (searchController.searchBar.text ?? ""))
            self.updateModels()
        } catch {
            print(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let frame = keyboardFrame.cgRectValue
        let keyboardHeight = frame.height
        collectionNode.frame.size.height = UIScreen.main.bounds.height - keyboardHeight
    }
    
    func keyboardWillDisappear(notification: Notification) {
        collectionNode.frame.size.height = UIScreen.main.bounds.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        searchController.searchBar.setBorder(color: UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0))
        
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.node.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        self.definesPresentationContext = true
        self.updateModels()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        self.models = filterResults(searchTerm: searchTerm)
        self.updateModels()
    }
    
    func filterResults(searchTerm: String) -> [SearchItemViewModel] {
        let previousTerms = self.previousResults.map({ (result) -> String in
            return result.term.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        })
        var uniques = Array(Set(Array(previousTerms)))
        if !searchTerm.isEmpty {
            uniques = uniques.filter({ (term) -> Bool in
                return term.starts(with: searchTerm.lowercased())
            })
        }
        return uniques.map({ (term) -> SearchItemViewModel in
            let model = SearchItemViewModel(text: term)
            model.delegate = self
            return model
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchBar.resignFirstResponder()
            let controller = SearchPageController(term: searchText)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension SearchController: SearchItemViewModelDelegate {
    func didSelectSearchItem(searchItem: SearchItemViewModel) {
        self.searchController.searchBar.resignFirstResponder()
        let controller = SearchPageController(term: searchItem.text)
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
