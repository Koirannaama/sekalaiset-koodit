import React, { Component } from 'react';
import "./PatchElements.css";

class PatchTile extends Component {
  getTileText()  {
    return this.props.seedPotatoes > 0 ? this.props.seedPotatoes + " potato planted!": "Plant!";
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

export class PotatoPatchGrid extends Component {
  render() {
    let patchTiles = this.props.patch.map((row, i) => {
      let rowTiles = row.map((tileData, j) => {
        return this.props.checkBuyability(tileData)
                ? <BuyablePatchTile tileClicked={() => this.props.buyableTileClicked(i, j)}/>
                : <PatchTile seedPotatoes={tileData} tileClicked={() =>this.props.patchTileClicked(i,j)}/>;
      });
      return <div className="patch-row">{rowTiles}</div>
    });

    return (
      <div className="darker-border-box ">
        {patchTiles}
      </div>
    );

  }
}