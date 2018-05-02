import React, { Component } from 'react';
import './App.css';
import { initialPotatoPatch, isTileBuyable, plantPotatoAt, buyTileAt, canPlantAt, harvestPotatoes } from "./PotatoPatch";
import { ResourcesView } from "./ResourcesView";
import { ShopView } from "./ShopView";
import * as Seasons from "./Seasons";
import { MessageBox } from "./MessageBox";
import { PotatoPatchGrid } from "./PatchElements"; 

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      money: 20,
      seedPotatoes: 5,
      potatoes: 0,
      patch: initialPotatoPatch,
      maxSeedsInTile: 1,
      tilePrice: 5,
      currentSeason: Seasons.spring,
      messageData: []
    };
  }

  plantPotatoAt = (x, y) => {
    if (canPlantAt(this.state.patch, x, y)) {
      let newSeeds = this.state.seedPotatoes - 1;
      this.setState({patch: plantPotatoAt(this.state.patch, x, y), seedPotatoes: newSeeds});
    }
  };

  buyNewTileAt = (x, y) => {
    if (this.state.money < this.state.tilePrice) {
      return;
    }
    let newMoney = this.state.money - this.state.tilePrice;
    this.setState({patch: buyTileAt(this.state.patch, x, y), money: newMoney});
  }

  isBuyItemsEnabled = (totalItemCost) => {
    return this.state.money >= totalItemCost;
  }

  buyItems = (transaction, cost) => {
    this.setState({
      money: this.state.money - cost,
      seedPotatoes: this.state.seedPotatoes + transaction.seedPotatoes,
      potatoes: this.state.potatoes - transaction.potatoes
    });
  }

  calculatePotatoesEatenOverWinter = () => {
    let minPotatoesEaten = 2;
    let maxAdditionalPotatoes = 2;
    // eat seeds if need to
    return minPotatoesEaten + Math.floor(Math.random() * maxAdditionalPotatoes);
  }

  clickNextSeason = () => {
    if (this.state.currentSeason === Seasons.spring) {
      // only place to plant potatoes
      // unexpected event: weasel attack
    }
    else if (this.state.currentSeason === Seasons.summer) {
      // fertilizer potatoes ?
      let [updatedPatch, potatoes, seedPotatoes] = harvestPotatoes(this.state.patch);
      this.setState({
        //currentSeason: Seasons.advance(this.state.currentSeason),
        seedPotatoes: this.state.seedPotatoes + seedPotatoes,
        potatoes: this.state.potatoes + potatoes,
        patch: updatedPatch,
        messageData: this.state.messageData.concat({ potatoesHarvested: potatoes, seedsHarvested: seedPotatoes })
      });
    }
    else if (this.state.currentSeason === Seasons.fall) {
      // unexpected events: thieves attack, disease
      // move harvest to here ?
    }
    else if (this.state.currentSeason === Seasons.winter) {
      // potatoes eaten
      let potatoesEaten = this.calculatePotatoesEatenOverWinter();
      this.setState({
        potatoes: this.state.potatoes - potatoesEaten,
        messageData: this.state.messageData.concat({ potatoesEaten: potatoesEaten })
      });
    }
    this.setState({
      currentSeason: Seasons.advance(this.state.currentSeason)
    });
  }

  gameElements = () => {
    return (
      <div className="App">
        <div className="top-container">
          <div className="left-side-container">
            <ResourcesView money={this.state.money} seeds={this.state.seedPotatoes} potatoes={this.state.potatoes}/>
            <ShopView isBuyEnabled={this.isBuyItemsEnabled} itemsBought={this.buyItems}/>
          </div>
          <PotatoPatchGrid patch={this.state.patch} checkBuyability={isTileBuyable} patchTileClicked={this.plantPotatoAt} buyableTileClicked={this.buyNewTileAt}/>
        </div>
        <div className="bottom-container">
          <MessageBox messageData={this.state.messageData}/>
          <span>It's {this.state.currentSeason} now, move on to</span>
          <button onClick={this.clickNextSeason}>the next season</button>
        </div>
      </div>
    );
  }

  death = () => {
    return <div>You died.</div>;
  }

  render() {
    if (this.state.potatoes >= 0) {
      return this.gameElements();
    }
    else {
      return this.death();
    }
  }
}

export default App;
