import React, { Component } from 'react';
import './ResourcesView.css';

export class ResourcesView extends Component {
  render() {
    return (
      <div className="resources-container">
        <div className="single-resource-container">
          <label className="resource-label">Money:</label>
          <span>{this.props.money}</span>
        </div>
        <div className="single-resource-container">
          <label className="resource-label">Seed potatoes:</label>
          <span>{this.props.seeds}</span>
        </div>
      </div>
    )
  }
}