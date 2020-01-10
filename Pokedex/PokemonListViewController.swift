import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    var pokemon: [PokemonListResult] = []
    var current_list: [PokemonListResult] = []
    let defaults = UserDefaults.standard
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        current_list = []
        if searchText == "" {
            current_list = pokemon
        }
        else {
            for i in 0..<pokemon.count
            {
                if pokemon[i].name.localizedStandardContains(searchText) == true {
                    current_list.append(pokemon[i])
                }
            }
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let entries = try JSONDecoder().decode(PokemonListResults.self, from: data)
                self.pokemon = entries.results
                self.current_list = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return current_list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: current_list[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var catches: [String: Bool] = [:]
        for poke in pokemon {
            catches.updateValue(false, forKey: poke.name)
        }
        
        if defaults.bool(forKey: "on") == false {
            defaults.set(catches, forKey: "catches")
            defaults.set(true, forKey: "on")
        }
        
        if segue.identifier == "ShowPokemonSegue",
                let destination = segue.destination as? PokemonViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.url = current_list[index].url
        }
    }
    
}

