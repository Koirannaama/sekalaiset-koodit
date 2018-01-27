import React, { Component } from 'react';
//import logo from './logo.svg';
import './App.css';


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

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      money: 20,
      seedPotatoes: 5,
      potatoes: 0,
      patch: [[0, 0], [0, 0]],
      maxSeedsInTile: 1,
      tilePrice: 5
    };
  }

  plantPotatoAt = (x, y) => {
    let patch = this.state.patch.slice();
    if (patch[x][y] >= this.state.maxSeedsInTile) {
      return;
    }
    patch[x][y] = 1;
    this.setState({patch: patch});
  };

  buyNewTileAt = (x, y) => {
    if (this.state.money < this.state.tilePrice) {
      return;
    }

    let newMoney = this.state.money - this.state.tilePrice;
    let patch = this.state.patch.slice();
    if (x >= this.state.patch.length) {
      let newPatch = this.state.patch.concat([[0]])
      this.setState({patch: newPatch, money: newMoney});
    }
    else {
      patch[x].push(0)
      this.setState({patch: patch, money: newMoney});
    }
  }

  render() {
    let patchTiles = this.state.patch.map((row, i) => {
      let rowTiles = row.map((seedAmount, j) => <PatchTile seedPotatoes={seedAmount} tileClicked={() => this.plantPotatoAt(i, j)}/>);
      let buyableTile = <BuyablePatchTile tileClicked={() => this.buyNewTileAt(i, rowTiles.length)}/>;
      return <div className="patch-row">{rowTiles.concat(buyableTile)}</div>
    });
    let lastRow = this.state.patch[this.state.patch.length-1];
    let buyableRow = <div className="patch-row">{lastRow.map((tile, i) => <BuyablePatchTile tileClicked={() => this.buyNewTileAt(lastRow.length, i)}/>)}</div>;

    return (
      <div className="App">
        <div>
          {patchTiles.concat(buyableRow)}
        </div>
      </div>
    );
  }
}

export default App;
