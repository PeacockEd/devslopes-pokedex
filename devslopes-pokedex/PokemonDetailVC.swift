//
//  PokemonDetailVC.swift
//  devslopes-pokedex
//
//  Created by Edward P. Kelly on 3/26/16.
//  Copyright © 2016 Edward P. Kelly, LLC. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    var pokeItem:Pokemon!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateDetailsUI()
        
        nameLbl.text = pokeItem.name.capitalizedString
        let img = UIImage(named: "\(pokeItem.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokeItem.downloadPokemonDetails { self.updateDetailsUI() }
    }
    
    private func updateDetailsUI()
    {
        descriptionLbl.text = pokeItem.descriptionText
        typeLbl.text = pokeItem.type
        defenseLbl.text = pokeItem.defense
        heightLbl.text = pokeItem.height
        weightLbl.text = pokeItem.weight
        idLbl.text = "\(pokeItem.pokedexId)"
        attackLbl.text = pokeItem.attack
        if pokeItem.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: "\(pokeItem.nextEvolutionId)")
            var str = "Next Evolution: \(pokeItem.nextEvolutionText)"
            if pokeItem.nextEvolutionLevel != "" {
                str += " - LVL \(pokeItem.nextEvolutionLevel)"
            }
            evoLbl.text = str
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackButtonTapped(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
