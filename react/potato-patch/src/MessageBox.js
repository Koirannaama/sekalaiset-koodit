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
    console.log(this.props.messageData);
    return this.props.messageData.reduce((text, message) => {
      if (message.potatoesHarvested !== undefined) {
        return text + "Harvested " + message.potatoesHarvested + " potatoes.\n";
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