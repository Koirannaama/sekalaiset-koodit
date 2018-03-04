import React, { Component } from 'react';
import './ShopView.css';

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

  render() {
    return (
      <div className="shop-container darker-border-box">
        <div className="buy-item-container">
          <label>Buyable items</label> 
          <div className="single-shop-item">
            <label className="shop-item-label">Seed potatoes (á {this.state.seedPotatoBuyPrice})</label>
            <input className="item-amount-input" type="number" min="0" value={this.state.seedPotatoAmount} onChange={this.changeSeedPotatoAmount}/>
          </div>
        </div>

        <div className="sell-item-container">
          <label>Sellable items</label> 
          <div className="single-shop-item">
            <label className="shop-item-label">Potatoes (á {this.state.potatoSellPrice})</label>
            <input className="item-amount-input" type="number" min="0" value={this.state.potatoAmount} onChange={this.changePotatoAmount}/>
          </div>
        </div>
        <div>
          <span>Total cost: {this.calculateTotalCost()}</span>
          <button>Deal!</button>
        </div>
      </div>
    );
  }
}