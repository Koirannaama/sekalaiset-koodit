import React, { Component } from 'react';
import './ShopView.css';

export class ShopTransaction {
  constructor(potatoes, seedPotatoes) {
    this.potatoes = potatoes;
    this.seedPotatoes = seedPotatoes;
  }
}

export class ShopView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      seedPotatoBuyPrice: 3,
      potatoSellPrice: 3,
      potatoAmount: 0,
      seedPotatoAmount: 0
    }
  }

  calculateTotalCost = () => {
    return this.state.seedPotatoAmount * this.state.seedPotatoBuyPrice
          - this.state.potatoAmount * this.state.potatoSellPrice;
  }

  changePotatoAmount = (event) => {
    this.setState({potatoAmount: event.target.value});
  }

  changeSeedPotatoAmount = (event) => {
    this.setState({seedPotatoAmount: event.target.value});
  }

  changeAmount = (event, getStateUpdate) => {
    let newAmount = parseInt(event.target.value, 10);
    this.setState(getStateUpdate(newAmount));
  }

  buyClicked = () => {
    this.props.itemsBought(new ShopTransaction(this.state.potatoAmount, this.state.seedPotatoAmount), this.calculateTotalCost());
    this.setState({
      potatoAmount: 0,
      seedPotatoAmount: 0
    });
  }

  render() {
    return (
      <div className="shop-container darker-border-box">
        <div className="buy-item-container">
          <label>Buyable items</label> 
          <div className="single-shop-item">
            <label className="shop-item-label">Seed potatoes (á {this.state.seedPotatoBuyPrice})</label>
            <input className="item-amount-input" type="number" min="0" value={this.state.seedPotatoAmount} 
                   onChange={(event) => this.changeAmount(event, (amount) => ({seedPotatoAmount: amount}))}/>
          </div>
        </div>

        <div className="sell-item-container">
          <label>Sellable items</label> 
          <div className="single-shop-item">
            <label className="shop-item-label">Potatoes (á {this.state.potatoSellPrice})</label>
            <input className="item-amount-input" type="number" min="0" value={this.state.potatoAmount} 
                   onChange={(event) => this.changeAmount(event, (amount) => ({potatoAmount: amount}))}/>
          </div>
        </div>
        <div>
          <span className="shop-item-label">Total cost: {this.calculateTotalCost()}</span>
          <button disabled={!this.props.isBuyEnabled(this.calculateTotalCost())} onClick={this.buyClicked}>Deal!</button>
        </div>
      </div>
    );
  }
}