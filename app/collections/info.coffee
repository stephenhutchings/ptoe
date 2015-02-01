info = require("models/info")

class InfoCollection extends Backbone.Collection
  url: ->
    "data/wikiInfo.json"

  model: info

  phases: ["Gas", "Liquid", "Solid"]

  other: ["Primordial_nuclide", "Decay_product", "Synthetic_element"]

  keys: ["Hydrogen","Gas","Grey","Helium","Noble gas","Lithium","Solid","Alkali metal","Beryllium","Boron","Other nonmetal","Carbon","Nitrogen","Oxygen","Fluorine","Neon","Sodium","Magnesium","Aluminum","Poor metal","Silicon","Phosphorus","Sulfur","Chlorine","Argon","Potassium","Calcium","Scandium","Transition metal","Titanium","Vanadium","Chromium","Manganese","Iron","Cobalt","Nickel","Copper","Zinc","Gallium","Germanium","Arsenic","Selenium","Bromine","Liquid","Krypton","Rubidium","Strontium","Yttrium","Zirconium","Niobium","Molybdenum","Technetium","Ruthenium","Rhodium","Palladium","Silver","Cadmium","Indium","Tin","Antimony","Tellurium","Iodine","Xenon","Cesium","Barium","Lanthanum","Lanthanide metal","Cerium","Praseodymium","Neodymium","Promethium","Samarium","Europium","Gadolinium","Terbium","Dysprosium","Holmium","Erbium","Thulium","Ytterbium","Lutetium","Hafnium","Tantalum","Tungsten","Rhenium","Osmium","Iridium","Platinum","Gold","Mercury","Thallium","Lead","Bismuth","Polonium","Astatine","Radon","Francium","Radium","Actinium","Actinide metal","Thorium","Protactinium","Uranium","Neptunium","Plutonium","Americium","Curium","Berkelium","Californium","Einsteinium","Fermium","Mendelevium","Nobelium","Lawrencium","Rutherfordium","Unknown","Dubnium","Seaborgium","Bohrium","Hassium","Meitnerium","Ununnilium","Unununium","Ununbium"]

  elinks: ["Hydrogen","Helium","Lithium","Beryllium","Boron","Carbon","Nitrogen","Oxygen","Fluorine","Neon","Sodium","Magnesium","Aluminium","Silicon","Phosphorus","Sulfur","Chlorine","Argon","Potassium","Calcium","Scandium","Titanium","Vanadium","Chromium","Manganese","Iron","Cobalt","Nickel","Copper","Zinc","Gallium","Germanium","Arsenic","Selenium","Bromine","Krypton","Rubidium","Strontium","Yttrium","Zirconium","Niobium","Molybdenum","Technetium","Ruthenium","Rhodium","Palladium","Silver","Cadmium","Indium","Tin","Antimony","Tellurium","Iodine","Xenon","Caesium","Barium","Lanthanum","Cerium","Praseodymium","Neodymium","Promethium","Samarium","Europium","Gadolinium","Terbium","Dysprosium","Holmium","Erbium","Thulium","Ytterbium","Lutetium","Hafnium","Tantalum","Tungsten","Rhenium","Osmium","Iridium","Platinum","Gold","Mercury (element)","Thallium","Lead","Bismuth","Polonium","Astatine","Radon","Francium","Radium","Actinium","Thorium","Protactinium","Uranium","Neptunium","Plutonium","Americium","Curium","Berkelium","Californium","Einsteinium","Fermium","Mendelevium","Nobelium","Lawrencium","Rutherfordium","Dubnium","Seaborgium","Bohrium","Hassium","Meitnerium","Darmstadtium","Roentgenium","Copernicium","Ununtrium","Flerovium","Ununpentium","Livermorium","Ununseptium","Ununoctium"]

  glinks: ["Alkali metal","Alkaline earth metal","Pnictogen","Chalcogen","Halogen","Noble gas","Lanthanide","Actinide","Rare earth element","Transition metal","Post-transition metal","Metalloid", "Nonmetal", "Metal", "Radioactive decay", "Synthetic element", "Primordial nuclide"]

  occurance: ["primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","from decay","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","from decay","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","primordial","from decay","from decay","from decay","from decay","from decay","from decay","primordial","from decay","primordial","from decay","primordial","from decay","from decay","from decay","from decay","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic","synthetic"]

  initialize: () ->

module.exports = InfoCollection

