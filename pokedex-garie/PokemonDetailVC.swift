//
//  PokemonDetailVC.swift
//  pokedex-garie
//
//  Created by Gary Foo on 26/11/2015.
//  Copyright © 2015 Eden. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    /*
    This value is either passed by `PokemonCollectionViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of checking out a new pokemon.
    */
    var pokemon: Pokemon!
    let attrs = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 24)!
    ]
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var pokedexId: UILabel!
    
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var attkLbl: UILabel!
    @IBOutlet weak var defLbl: UILabel!
    
    @IBOutlet weak var baseEvo: UIImageView!
    @IBOutlet weak var additionalEvo: UIImageView!
    
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var pokeDetailsStack: UIStackView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var nextEvoStack: UIStackView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeDetailsStack.hidden = true
        lineView.hidden = true
        nextEvoStack.hidden = true
        spinner.startAnimating()
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.pokemon.downloadPokemonDetails { () -> () in
                    // This class will be called after download is done
                    self.updateUI()
                    self.spinner.stopAnimating()
                    self.pokeDetailsStack.hidden = false
                    self.lineView.hidden = false
                    self.nextEvoStack.hidden = false
                }
            }
        }
        
        //navigationController?.navigationBar.titleTextAttributes = attrs
        
        if let pokemon = pokemon {
            navigationItem.title = pokemon.name.capitalizedString
            let img = UIImage(named: "\(pokemon.pokedexId)")
            mainImg.image = img
            baseEvo.image = img
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    func updateUI() {
        descLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        attkLbl.text = pokemon.attack
        defLbl.text = pokemon.defense
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        if pokemon.pokedexId < 10 {
            pokedexId.text = "#00\(pokemon.pokedexId)"
        } else if pokemon.pokedexId < 100 {
            pokedexId.text = "#0\(pokemon.pokedexId)"
        } else {
            pokedexId.text = "#\(pokemon.pokedexId)"
        }
        if pokemon.nextEvoId == "" {
            nextEvoLbl.text = "No Evolutions"
            additionalEvo.hidden = true
        } else {
            additionalEvo.hidden = false
            additionalEvo.image = UIImage(named: pokemon.nextEvoId)
            var str = "Next Evolution: \(pokemon.nextEvoTxt)"
            if pokemon.nextEvoLvl != "" {
                str += " - LVL \(pokemon.nextEvoLvl)"
            }
            nextEvoLbl.text = str
        }
        additionalEvo.image = UIImage(named: pokemon.nextEvoId)
    }

    @IBAction func nextEvoDetails(sender: UITapGestureRecognizer) {
        let poke = Pokemon(name: pokemon.nextEvoTxt, pokedexId: Int(pokemon.nextEvoId)!)
        //performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PokemonDetailVC") as! PokemonDetailVC
        vc.pokemon = poke
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentChange(sender: UISegmentedControl) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
