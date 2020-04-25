import React from 'react';
import './Square.scss';

export class Square extends React.Component {
  get content() {
    if (!this.props.data.opened) {
      return '';
    }
    if (this.props.data.isMine) {
      return 'b';
    }
    return this.props.data.number;
  }

  get classes() {
    return `square ${this.props.data.opened ? 'open' : 'closed'} ${this.props.data.marked ? 'marked' : ''}`;
  }

  rightClick(event) {
    event.preventDefault();
    this.props.onRightClick()
    return false;
  }

  render() {
    return (
      <div
        className={this.classes}
        onClick={() => this.props.onClick()}
        onContextMenu={event => this.rightClick(event)}>
        {this.content}
      </div>
    );
  }
}