//
//  MoviesViewController.swift
//  PopcornTime
//
//  Created by Andrew  K. on 3/19/15.
//  Copyright (c) 2015 PopcornTime. All rights reserved.
//

import UIKit

class MoviesViewController: PagedViewController {
    
    override var showType: PTItemType {
        get {
            return .Movie
        }
    }

    func unify(newItems: [BasicInfo]) -> [BasicInfo] {
        var ids = newItems.map( { $0.identifier } )
        
        var existingUniqueIds: [String] = self.items.map( { $0.identifier } )
        var uniqueIds = NSSet(array: ids).allObjects as! [String]
        
        var filteredUniqueIds = [String]()
        for uniqueId in uniqueIds {
            if !contains(existingUniqueIds, uniqueId) {
                filteredUniqueIds.append(uniqueId)
            }
        }
        
        uniqueIds = filteredUniqueIds
        var uniqueItems = [BasicInfo]()
        for uniqueId in uniqueIds {
            var item = newItems.filter( {$0.identifier == uniqueId} ).first
            uniqueItems.append(item!)
        }
        return uniqueItems
    }

    override func map(response: [AnyObject]) -> [BasicInfo] {
        var items = response.map({ Movie(dictionary: $0 as! NSDictionary) }) as [BasicInfo]
        return unify(items)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath){
            //Check if cell is MoreShowsCell
            if let moreCell = cell as? MoreShowsCollectionViewCell{
                loadMore()
            } else {
                performSegueWithIdentifier("showDetails", sender: cell)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "showDetails"{
            if let episodesVC = segue.destinationViewController as? MovieDetailsViewController{
                if let senderCell = sender as? UICollectionViewCell{
                    if let indexPath = collectionView!.indexPathForCell(senderCell) {
                        var item: BasicInfo!
                        if (searchController!.active) {
                            item = searchResults[indexPath.row]
                        } else {
                            item = items[indexPath.row]
                        }
                        episodesVC.item = item as! Movie
                    }
                }
            }
        }
    }
}
