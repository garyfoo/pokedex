//
//  Pokemon.swift
//  pokedex-garie
//
//  Created by Gary Foo on 25/11/2015.
//  Copyright © 2015 Eden. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId :Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _defense: String!
    private var _nextEvoTxt: String!
    private var _pokemonUrl: String!
    private var _nextEvoLvl: String!
    private var _nextEvoId: String!
    
    var name: String! {
        return _name
    }
    
    var pokedexId: Int! {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var nextEvoTxt: String {
        
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoLvl: String {
        get {
            if _nextEvoLvl == nil {
                _nextEvoLvl = ""
            }
            return _nextEvoLvl
        }
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    else if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += " / \(name)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let descResult = response.result
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                                
                            }
                            
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let evolutionTo = evolutions[0]["to"] as? String {
                        
                        // Unable to support mega evolutions yet
                        if evolutionTo.rangeOfString("mega") == nil {
                            
                            if let str = evolutions[0]["resource_uri"] as? String {
                                
                                // Get EvolutionID from link to next evolved pokemon
                                let newStr = str.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let evoId = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvoLvl = "\(lvl)"
                                }
                                
                                self._nextEvoTxt = evolutionTo
                                self._nextEvoId = evoId
                                
                                print(self._nextEvoLvl)
                                print(self._nextEvoTxt)
                                print(self._nextEvoId)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
}