//
//  ViewController.swift
//  devslopes-pokedex
//
//  Created by Edward P. Kelly on 3/21/16.
//  Copyright © 2016 Edward P. Kelly, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    private var musicPlayer: AVAudioPlayer!
    private var pokemon = [Pokemon]()
    private var inSearchMode = false
    private var filteredItems = [Pokemon]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .Done
        initAudio()
        parsePokemonCSV()
    }
    
    private func initAudio()
    {
        if let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3"),
            let musicUrl = NSURL(string: path)
        {
            do {
                musicPlayer = try AVAudioPlayer(contentsOfURL: musicUrl)
                musicPlayer.prepareToPlay()
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    private func parsePokemonCSV()
    {
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                for row in rows {
                    if let pokeValue = row["id"], let pokeId = Int(pokeValue),
                        let pokeName = row["identifier"]
                    {
                        pokemon.append(Pokemon(name: pokeName, pokedexId: pokeId))
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let item:Pokemon
            if inSearchMode {
                item = filteredItems[indexPath.row]
            } else {
                item = pokemon[indexPath.row]
            }
            cell.configureCell(item)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let pokeItem:Pokemon
        
        if inSearchMode {
            pokeItem = filteredItems[indexPath.row]
        } else {
            pokeItem = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: pokeItem)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if inSearchMode { return filteredItems.count }
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(105, 105)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if let searchText = searchBar.text where searchText != "" {
            inSearchMode = true
            let lower = searchText.lowercaseString
            filteredItems = pokemon.filter({$0.name.rangeOfString(lower) != nil})
        } else {
            inSearchMode = false
            view.endEditing(true)
        }
        collection.reloadData()
    }
    
    @IBAction func onMusicButtonTapped(sender:AnyObject)
    {
        if musicPlayer.playing {
            (sender as? UIButton)?.alpha = 0.2
            musicPlayer.stop()
        } else {
            musicPlayer.play()
            (sender as? UIButton)?.alpha = 1.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokeItem = poke
                }
            }
        }
    }

}

