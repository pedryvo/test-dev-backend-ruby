Order of the Pixel
==================

### General

Order of the Pixel is a small Sinatra API running on Puma using DataMapper &amp; Minitest and it's open for people to
play with it.

### API Description

We enjoy role playing games here at Pixel Perfect Tree so we’ve developed a small API to list the heroes from the Order of Pixel.
A Hero is composed of 3 basic entities, a Weapon, A Race and a Job.

* The **Weapon** is what the hero will wear on his quests (ie Bastard Sword or Mighty Bow).
* The **Race** is a classification used to categorize heroes into distinct populations or groups by anatomical, 
cultural and geographical (ie Elf, Dwarf or Orc).
* The **Job** aggregates several abilities and aptitudes depending what role the hero has chosen to follow 
(ie Warrior, Warlock, Priest or Archer)


### API usage
Here are the url's supported by the API:

- :base =>  http://api.root (soon to be determined)

- :heroes => http://api.root/api/heroes

  Supported Actions: GET, PUT, POST, DELETE

- :weapons =>  http://api.root/api/weapons

  Supported Actions: GET, PUT, POST, DELETE
  
- :races =>  http://api.root/api/races

  Supported Actions: GET, PUT, POST, DELETE
  
- :jobs =>  http://api.root/api/jobs

  Supported Actions: GET, PUT, POST, DELETE

Note: This API only supports JSON.

## Example Requests ##
Below is an example request that will create a **Weapon**.
<pre><code>
{
    "name": "Mjolnir",
    "desc": "Thor's Hammer, he might smite as hard as he desires, whatsoever might be before him, and the hammer would not fail."
}
</pre></code>


Here is an example request that will create a **Race**.
<pre><code>
{
    "name": "God"
}
</pre></code>


Here is an example request that will create a **Job**.
<pre><code>
{
    "name": "Paladin"
}
</pre></code>


Here is an example request that will create a **Hero**.
<pre><code>
{
    "name": "Thor",
    "weapon_id": 1,
    "job_id": 1,
    "race_id": 1
}
</pre></code>

#### Notes

* At the moment, you can't delete a Weapon, Race or Job if it's currently assigned to a hero 
(But you can delete a hero without destroying it's attached entities).

* Tests can be run using the Rake task `rake test`.

* To run the Sinatra app simply install the dependencias via bundler and run the server from the root using `ruby app.rb`. 
