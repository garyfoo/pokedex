//
//  PokeCell.swift
//  pokedex-garie
//
//  Created by Gary Foo on 25/11/2015.
//  Copyright © 2015 Eden. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeNameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        pokeNameLbl.text = self.pokemon.name.capitalizedString
        pokeImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }

}
