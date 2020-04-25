import React from 'react';
import './MineField.scss';
import { Square } from '../square/Square';

export class MineField extends React.Component {
  render() {
    return (
      <div className="mine-field">
        {this.props.field.map((row, x) => 
          <div className="row">
            {row.map((block, y) =>
              <Square data={block} onClick={() => this.props.squareClick(x, y)} onRightClick={() => this.props.rightClick(x, y)}>
              </Square>)
            }
          </div>)}
      </div>
    );
  }
}