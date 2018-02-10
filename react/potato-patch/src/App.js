import React, { Component } from 'react';
import './App.css';
import { initialPotatoPatch, isTileBuyable, plantPotatoAt, buyTileAt } from "./PotatoPatch";
import { ResourcesView } from "./ResourcesView";


class PatchTile extends Component {
  getTileText()  {
    return this.props.seedPotatoes > 0 ? this.props.seedPotatoes : "Plant!";
  }

  render() {
    return <div className="patch-tile" onClick={this.props.tileClicked}>{this.getTileText()}</div>
  }
}

class BuyablePatchTile extends Component {
  render() {
    return <div className="patch-tile buyable-tile" onClick={this.props.tileClicked}>Buy!</div>
  }
}

class PotatoPatchGrid extends Component {
  render() {
    let patchTiles = this.props.patch.map((row, i) => {
      let rowTiles = row.map((tileData, j) => {
        return isTileBuyable(tileData)
                ? <BuyablePatchTile tileClicked={() => this.props.buyableTileClicked(i, j)}/>
                : <PatchTile seedPotatoes={tileData} tileClicked={() =>this.props.patchTileClicked(i,j)}/>;
      });
      return <div className="patch-row">{rowTiles}</div>
    });

    return (
      <div className="patch-grid-container">
        {patchTiles}
      </div>
    );

  }
}

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      money: 20,
      seedPotatoes: 5,
      potatoes: 0,
      patch: initialPotatoPatch,
      maxSeedsInTile: 1,
      tilePrice: 5
    };
  }

  plantPotatoAt = (x, y) => {
    let newSeeds = this.state.seedPotatoes - 1;
    this.setState({patch: plantPotatoAt(this.state.patch, x, y), seedPotatoes: newSeeds});
  };

  buyNewTileAt = (x, y) => {
    if (this.state.money < this.state.tilePrice) {
      return;
    }
    let newMoney = this.state.money - this.state.tilePrice;
    this.setState({patch: buyTileAt(this.state.patch, x, y), money: newMoney});
  }

  render() {
    return (
      <div className="App">
        <ResourcesView money={this.state.money} seeds={this.state.seedPotatoes}/>
        <PotatoPatchGrid patch={this.state.patch} patchTileClicked={this.plantPotatoAt} buyableTileClicked={this.buyNewTileAt}/>
      </div>
    );
  }
}

export default App;
