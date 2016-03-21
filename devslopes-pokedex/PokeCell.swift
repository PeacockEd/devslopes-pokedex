//
//  PokeCell.swift
//  devslopes-pokedex
//
//  Created by Edward P. Kelly on 3/21/16.
//  Copyright © 2016 Edward P. Kelly, LLC. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    
    
    private var _pokemon:Pokemon!
    
    func configureCell(pokemon: Pokemon)
    {
        self._pokemon = pokemon
        nameLbl.text = self._pokemon.name.capitalizedString
        thumbImage.image = UIImage(named: "\(self._pokemon.pokedexId)")
    }
}
