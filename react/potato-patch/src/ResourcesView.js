import React, { Component } from 'react';
import './ResourcesView.css';

export class ResourceLine extends Component {
  render() {
    return (
      <div className="single-resource-container">
        <label className="resource-label">{this.props.label}:</label>
        <span>{this.props.resource}</span>
      </div>
    );
  }
}

export class ResourcesView extends Component {
  render() {
    return (
      <div className="resources-container darker-border-box">
        <ResourceLine label="Money" resource={this.props.money}/>
        <ResourceLine label="Seed potatoes" resource={this.props.seeds}/>
        <ResourceLine label="Potatoes" resource={this.props.potatoes}/>
      </div>
    )
  }
}