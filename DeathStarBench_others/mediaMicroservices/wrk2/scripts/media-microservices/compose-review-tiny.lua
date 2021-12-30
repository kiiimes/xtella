require "socket"
time = socket.gettime()*1000
math.randomseed(time)
math.random(); math.random(); math.random()

local charset = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's',
  'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'Q',
  'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H',
  'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '1', '2', '3', '4', '5',
  '6', '7', '8', '9', '0'}

local movie_titles = {
  "Avengers: Endgame",
  "Kamen Rider Heisei Generations FOREVER",
  "Captain Marvel",
  "Pokémon Detective Pikachu",
  "Hellboy",
  "After",
  "Avengers: Infinity War",
  "Doraemon the Movie: Nobita's Treasure Island",
  "Cold Pursuit",
  "Shazam!",
  "What Men Want",
  "Glass",
  "The Avengers",
  "Black Panther",
  "How to Train Your Dragon: The Hidden World",
  "Tolkien",
  "Fighting with My Family",
  "Guardians of the Galaxy Vol. 2",
  "Avengers: Age of Ultron",
  "The Prodigy",
  "Cars",
  "Thor: Ragnarok",
  "The Wandering Earth",
  "Extremely Wicked, Shockingly Evil and Vile",
  "Pet Sematary",
  "Logan",
  "Guardians of the Galaxy",
  "Fall in Love at First Kiss",
  "Spider-Man: Into the Spider-Verse",
  "Bumblebee",
  "Thor",
  "Aquaman",
  "Ant-Man and the Wasp",
  "The Lego Movie 2: The Second Part",
  "Edge of Tomorrow",
  "The Hustle",
  "Dumbo",
  "Redcon-1",
  "Instant Family",
  "Spider-Man: Homecoming",
  "The Hobbit: The Battle of the Five Armies",
  "Little",
  "The Curse of La Llorona",
  "Escape Room",
  "Miss Bala",
  "High Life",
  "The Highwaymen",
  "The Fate of the Furious",
  "Iron Man",
  "Captain America: The First Avenger",
  "Captain America: Civil War",
  "Us",
  "Detective Conan: The Fist of Blue Sapphire",
  "Fate/stay night: Heaven’s Feel II. lost butterfly",
  "Robin Hood",
  "Fantastic Beasts: The Crimes of Grindelwald",
  "Thor: The Dark World",
  "Alita: Battle Angel",
  "Happy Death Day 2U",
  "John Wick",
  "Mile 22",
  "Iron Man 2",
  "Maggie",
  "Venom",
  "Harry Potter and the Philosopher's Stone",
  "The Kid Who Would Be King",
  "Pirates of the Caribbean: The Curse of the Black Pearl",
  "Bohemian Rhapsody",
  "The Mule",
  "Ralph Breaks the Internet",
  "The Lord of the Rings: The Fellowship of the Ring",
  "Death Wish",
  "John Wick: Chapter 3 – Parabellum",
  "The Sisters Brothers",
  "We Are Your Friends",
  "Vaarikkuzhiyile Kolapathakam",
  "The First Purge",
  "Left Behind",
  "Deadpool 2",
  "BlacKkKlansman",
  "Jigsaw",
  "The Kissing Booth",
  "Shaun the Sheep Movie",
  "Under Siege 2: Dark Territory",
  "Truth or Dare",
  "Doctor Strange",
  "The Lord of the Rings: The Return of the King",
  "It's a Wonderful Life",
  "Interstellar",
  "Bad Times at the El Royale",
  "A Madea Family Funeral",
  "Long Shot",
  "Suspiria",
  "The Dark Knight",
  "Trainspotting",
  "Star Wars",
  "Mortal Engines",
  "Loving Vincent",
  "Jurassic World: Fallen Kingdom",
  "Velvet Buzzsaw",
  "A Wrinkle in Time",
  "The Lion King 1½",
  "Spider-Man: Far from Home",
  "Harry Potter and the Chamber of Secrets",
  "Solo: A Star Wars Story",
  "The Last Summer",
  "Iron Man 3",
  "Eighth Grade",
  "Mandy",
  "Die Hard",
  "Home Alone 4",
  "Adrift",
  "The Predator",
  "The Favourite",
  "Overlord",
  "Camp X-Ray",
  "Mary Poppins Returns",
  "Master Z: Ip Man Legacy",
  "Re: Zero kara Hajimeru Isekai Seikatsu - Memory Snow",
  "Scooby-Doo 2: Monsters Unleashed",
  "The Transporter Refueled",
  "Personal Shopper",
  "Endless Love",
  "Ant-Man",
  "Polar",
  "The Silence",
  "The Professor and the Madman",
  "12 Strong",
  "Anon",
  "Brightburn",
  "Outlaw King",
  "Texas Chainsaw 3D",
  "The Upside",
  "Breakthrough",
  "The Emoji Movie",
  "Green Book",
  "A Bad Moms Christmas",
  "Deadpool",
  "Herbie Fully Loaded",
  "Batman v Superman: Dawn of Justice",
  "Bel Ami",
  "A Hologram for the King",
  "The Hunger Games: Mockingjay - Part 1",
  "Planes",
  "Wrong Turn 2: Dead End",
  "Zodiac",
  "The Curious Case of Benjamin Button",
  "Wonder Woman",
  "A Goofy Movie",
  "The Incredible Hulk",
  "San Andreas",
  "Creed II",
  "X-Men: Days of Future Past",
  "Executive Decision",
  "The Man Who Knew Too Much",
  "Footloose",
  "Justice League",
  "47 Meters Down",
  "A Star Is Born",
  "Incredibles 2",
  "The Square",
  "Raw",
  "Regression",
  "Red Cliff",
  "Star Wars: The Last Jedi",
  "Hunter Killer",
  "Chain Reaction",
  "The Wind That Shakes the Barley",
  "Last Knights",
  "Avatar",
  "The Matrix",
  "I Spit on Your Grave 2",
  "The 100 Year-Old Man Who Climbed Out the Window and Disappeared",
  "2046",
  "The Smurfs 2",
  "Victoria",
  "The Gunman",
  "Batman Begins",
  "I, Daniel Blake",
  "Secret in Their Eyes",
  "The Man Who Knew Infinity",
  "The Past",
  "The Belko Experiment",
  "The Last Legion",
  "Free State of Jones",
  "Deadfall",
  "The Shawshank Redemption",
  "Anthropoid",
  "Pitch Perfect 3",
  "The Cold Light of Day",
  "March of the Penguins",
  "Popstar: Never Stop Never Stopping",
  "The Cat Returns",
  "The Zookeeper's Wife",
  "Aladdin",
  "Suburbicon",
  "The Water Horse",
  "Inception",
  "The Return of the Living Dead",
  "Odd Thomas",
  "Jungle",
  "Pulp Fiction",
  "Hard Target",
  "Iron Sky: The Coming Race",
  "Terminator 2: Judgment Day",
  "Legend",
  "Twilight",
  "Stealth",
  "Battle of the Sexes",
  "Split",
  "Adore",
  "Don't Say a Word",
  "A Royal Affair",
  "Salò, or the 120 Days of Sodom",
  "Triple Frontier",
  "The Rescuers",
  "Blade Runner 2049",
  "Tale of Tales",
  "Taken 3",
  "The Tale of Despereaux",
  "It's Only the End of the World",
  "Dark Places",
  "Poms",
  "Dragged Across Concrete",
  "Unsane",
  "15 Minutes",
  "Batman: The Dark Knight Returns, Part 1",
  "Ironclad",
  "Taxi",
  "Basic Instinct 2",
  "Florence Foster Jenkins",
  "Gone Girl",
  "Rough Night",
  "Schindler's List",
  "Alexander and the Terrible, Horrible, No Good, Very Bad Day",
  "The Great Mouse Detective",
  "The Ring Two",
  "Toni Erdmann",
  "Forbidden Planet",
  "The Lazarus Effect",
  "The Triplets of Belleville",
  "Heartbreaker",
  "Someone Great",
  "Veronica Mars",
  "Byzantium",
  "13 Sins",
  "Mission: Impossible - Fallout",
  "Far from the Madding Crowd",
  "Charlie Says",
  "'71",
  "The Proposition",
  "The Railway Man",
  "A Ghost Story",
  "The Choice",
  "A Nightmare on Elm Street 4: The Dream Master",
  "Bitter Moon",
  "Arrival",
  "Alvin and the Chipmunks: Chipwrecked",
  "The Salesman",
  "Soldier",
  "The Lord of the Rings: The Two Towers",
  "Sicario: Day of the Soldado",
  "Mia and the White Lion",
  "Vice",
  "Harry Potter and the Deathly Hallows: Part 1",
  "Zootopia",
  "Whiteout",
  "The Amazing Spider-Man",
  "The Santa Clause 2",
  "Five Feet Apart",
  "Star Wars: The Force Awakens",
  "No Man's Land",
  "Whiplash",
  "Hot Tub Time Machine 2",
  "The Babysitter",
  "The Paperboy",
  "The Maze Runner",
  "Jason X",
  "Harry Potter and the Order of the Phoenix",
  "Terms of Endearment",
  "Frozen",
  "Invasion of the Body Snatchers",
  "The Divide",
  "Brawl in Cell Block 99",
  "Killing Season",
  "Harry Potter and the Prisoner of Azkaban",
  "Man Up",
  "Missing Link",
  "Friday the 13th Part 2",
  "Force Majeure",
  "Léon: The Professional",
  "Suck Me Shakespeer",
  "Teenage Mutant Ninja Turtles II: The Secret of the Ooze",
  "Blood Father",
  "Ivan's Childhood",
  "The Garden of Words",
  "All Dogs Go to Heaven",
  "The Hobbit: An Unexpected Journey",
  "Step Up All In",
  "New Nightmare",
  "Slow West",


  "Edtv",
  "Something Something... Unakkum Enakkum",
  "Aliens",
  "The Last Temptation of Christ",
  "Tangerines",
  "Pacific Rim: Uprising",
  "Sunrise: A Song of Two Humans",
  "Fair Game",
  "Red Dawn",
  "Laws of Attraction",
  "Honey I Blew Up the Kid",
  "The Rocker",
  "Sleuth",
  "Stuck on You",
  "Flight of the Navigator",
  "Dangerous Minds",
  "Behind the Candelabra",
  "A Clockwork Orange",
  "The Messengers",
  "Straw Dogs",
  "City Slickers",
  "Fantastic Beasts and Where to Find Them",
  "Leaving Afghanistan",
  "The Lady Vanishes",
  "Kuch Kuch Hota Hai",
  "American Splendor",
  "A Hard Day's Night",
  "Pixels",
  "Days of Heaven",
  "The Big Blue",
  "Piranha 3DD",
  "Men in Black II",
  "Kalifornia",
  "Bull Durham",
  "Waitress",
  "Madagascar",
  "Grease",
  "Teen Wolf",
  "The Mighty Ducks",
  "Insurgent",
  "Gridiron Gang",
  "Rab Ne Bana Di Jodi",
  "Rabbit Hole",
  "Stalag 17",
  "Hatsukoi: Otosan, Chibi ga Inaku Narimashita",
  "Your Name.",
  "Sex Tape",
  "Sodemacom Killer",
  "Kong: Skull Island",
  "Jab Tak Hai Jaan",
  "My Sassy Girl",
  "Hereditary",
  "Sleeping Beauty",
  "Food, Inc.",
  "The Head Hunter",
  "The Killer Inside Me",
  "Spirited Away",
  "Maze Runner: The Death Cure",
  "The Hateful Eight",
  "Down with Love",
  "Cube Zero",
  "The Adventures of Baron Munchausen",
  "The Hitcher",
  "Alien",
  "Aladdin",
  "Red Sparrow",
  "Weekend at Bernie's",
  "Solo cose belle",
  "How High",
  "Skyscraper",
  "Den of Thieves",
  "Michael",
  "Last Man Standing",
  "National Security",
  "Saving Private Ryan",
  "The Duelist",
  "Forever Young",


  
  "The Mission",
  "Hellboy II: The Golden Army",
  "3 Men and a Baby",
  "Bad Words",
  "Chariots of Fire",
  "Spectre",
  "People Like Us",
  "Animal Kingdom",
  "The Ledge",
  "Copycat",
  "Double Jeopardy",
  "Super Mario Bros.",
  "Bad Company",
  "Striptease",
  "Dolores Claiborne",
  "Flyboys",
  "Time Bandits",
  "The Fan",
  "Little Women"
}

function string.random(length)
  if length > 0 then
    return string.random(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

request = function()
  local movie_index = math.random(397)
  local user_index = math.random(1000)
  local username = "username_" .. tostring(user_index)
  local password = "password_" .. tostring(user_index)
  local title = movie_titles[movie_index]
  local rating = math.random(0, 10)
  local text = string.random(256)

  local path = "http://media-nginx.test.com/wrk2-api/review/compose"
  local method = "POST"
  local headers = {}
  local body = "username=" .. username .. "&password=" .. password .. "&title=" ..
                  title .. "&rating=" .. rating .. "&text=" .. text
  headers["Content-Type"] = "application/x-www-form-urlencoded"

  return wrk.format(method, path, headers, body)
end