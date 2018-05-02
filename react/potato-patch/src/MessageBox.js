import React, { Component } from 'react';
import "./MessageBox.css";

export class MessageBox extends Component {
  constructor(props) {
    super(props);
    this.state = {
      messageText: ""
    }
  }

  generateMessageText = () => {
    return this.props.messageData.reduce((text, message) => {
      if (message.potatoesHarvested !== undefined) {
        return text + "Harvested " + message.potatoesHarvested + " potatoes and got " + message.seedsHarvested + " seeds.\n";
      }
      else if (message.potatoesEaten !== undefined) {
        return text + "You ate " + message.potatoesEaten + " potatoes over the last season.\n";
      }
      return text;
    }, "");
  }

  render() {
    return (
      <div>
        <textarea readOnly className="message-box" value={this.generateMessageText()}>
        </textarea>
      </div>
    );
  }
}