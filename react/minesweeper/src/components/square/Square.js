import React from 'react';
import './Square.scss';

export class Square extends React.Component {
  constructor(props) {
    super(props);
  }

  get content() {
    if (!this.props.data.opened) {
      return '';
    }
    if (this.props.data.type === 'b') {
      return 'b';
    }
    return this.props.data.number;
  }

  render() {
    return (
      <div className={`square ${this.props.data.opened ? 'open' : 'closed'}`} onClick={() => this.props.onClick()}>
        {this.content}
      </div>
    );
  }
}