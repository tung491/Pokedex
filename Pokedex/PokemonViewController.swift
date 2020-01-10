import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var catched: Bool = true
    var species_url: String = ""
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var state: UIButton!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var descri: UITextView!

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        loadPokemon()
    }
    
    func load_description(pokemon_id: Int) {
        let url = "https://pokeapi.co/api/v2/pokemon-species/\(pokemon_id)/"
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do  {
                let result = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                DispatchQueue.main.async {
                    for entry in result.flavor_text_entries {
                        if entry.language.name == "en" {
                            self.descri.text = entry.flavor_text.replacingOccurrences(of: "\n", with: " ")
                    }
                    }
                    
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let n = UserDefaults.standard.object(forKey: "catches") as! [String: Bool]
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.species_url = result.species.url
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.catched = n[result.name]!

                    if self.catched == false {
                        self.state.setTitle("Catch", for: .normal)
                    }

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    self.load_description(pokemon_id: result.id)
                    if let img_url = URL(string: result.sprites.front_default) {
                        do {
                        let img_data = try Data(contentsOf: img_url)
                        self.avatar.image = UIImage(data: img_data)
                        }
                        catch let error {
                            print(error)
                        }
                    }
                    }
            }
            catch let error {
                print(error)
            }
        }.resume()

    }

    @IBAction func toggleCatch() {
        if catched == false {
            state.setTitle("Catch", for: .normal)
            catched = true
        }
        else {
            state.setTitle("Release",for: .normal)
            catched = false

        }
    }
    
    

}

