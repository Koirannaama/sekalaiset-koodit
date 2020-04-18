import React from 'react';
import './App.scss';
import { MineField } from './components/minefield/MineField';
import { MineSweeperGame } from './game/MineSweeperGame';


class App extends React.Component {
  constructor(props) {
    super(props);
    this.game = new MineSweeperGame();
    this.state = {
      gameState: this.game.state
    };
  }

  startNewGame() {
    this.game = new MineSweeperGame();
    this.setState({...this.state, gameState: this.game.state});
  }

  openBlock(x, y) {
    if (this.game.state.gameOver) {
      return;
    }

    this.game.openBlockAt(x,y);
    this.setState({...this.state, gameState: this.game.state});
  }

  render() {
    return (
      <div className="app">
        <div>
          <MineField field={this.state.gameState.mineField} squareClick={(x, y) => this.openBlock(x, y)}></MineField>
          <div>
            <button onClick={() => this.startNewGame()}>New game</button>
            <span>{this.state.gameState.gameOver ? 'Game over' : ''}</span>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
