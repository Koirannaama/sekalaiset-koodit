import React from 'react';
import './MineField.scss';
import { Square } from '../square/Square';

export class MineField extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="mine-field">
        {this.props.field.map((row, x) => 
          <div className="row">
            {row.map((block, y) => <Square data={block} onClick={() => this.props.squareClick(x, y)}></Square>)}
          </div>)}
      </div>
    );
  }
}