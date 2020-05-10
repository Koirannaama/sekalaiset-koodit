import React from 'react';
import './App.scss';
import { MineField } from './components/minefield/MineField';
import { MineCounter } from './components/mine-counter/MineCounter';
import { MineSweeperGame } from './game/MineSweeperGame';


class App extends React.Component {
  constructor(props) {
    super(props);
    this.game = new MineSweeperGame();
    this.state = {
      gameState: this.game.state,
      message: ''
    };
  }

  startNewGame() {
    this.game = new MineSweeperGame();
    this.setState({...this.state, gameState: this.game.state});
  }

  openBlock(x, y) {
    if (!this.game.state.phase.inProgress) {
      return;
    }

    this.game.openBlockAt(x,y);
    this.setState({
      ...this.state,
      gameState: this.game.state,
      message: this.createPhaseMessage(this.game.state.phase)
    });
  }

  markBlock(x, y) {
    if (!this.game.state.phase.inProgress) {
      return;
    }

    this.game.markBlockAt(x, y);
    this.setState({ ...this.state, gameState: this.game.state });
  }

  createPhaseMessage(phase) {
    if (phase.lost) {
      return 'Game over';
    }
    else if (phase.won) {
      return 'Minesweeper is you!';
    }
    return '';
  }

  render() {
    return (
      <div className="app">
        <div class="game-box">
          <MineField
            field={this.state.gameState.mineField}
            squareClick={(x, y) => this.openBlock(x, y)}
            rightClick={(x, y) => this.markBlock(x, y)}>
          </MineField>
          <div class="game-controls">
            <button onClick={() => this.startNewGame()}>New game</button>
            <MineCounter markedCount={this.game.markedCount} totalCount={this.game.totalCount}/>
          </div>
          <div>{this.state.message}</div>
        </div>
      </div>
    );
  }
}

export default App;
