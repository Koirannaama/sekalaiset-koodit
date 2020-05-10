import React from 'react';
import './MineCounter.scss';

export class MineCounter extends React.Component {
    render() {
      return (
        <div className="mine-counter">
          <div className="marked">
            <span>Marked</span>
            <span>{this.props.markedCount}</span>
          </div>
          <div className="total">
            <span>Total</span>
            <span>{this.props.totalCount}</span>
          </div>
        </div>
      );
    }
}