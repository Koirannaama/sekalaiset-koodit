import { MineFieldBlock } from "./MineFieldBlock";
import { MineFieldGenerator } from "./MineFieldGenerator";

export class MineSweeperState {
  constructor() {
    this.gameOver = false;
    this.mineField = new MineFieldGenerator().generateMineField();
  }
}

export class MineSweeperGame {
  constructor() {
    this.state = new MineSweeperState();
    this.generator = new MineFieldGenerator();
  }

  openBlockAt(x, y) {
    let newField = this.state.mineField.map(
      (row, i) => row.map((block, j) => i === x && j === y ? block.open() : block)
    );
    this.state = {
      ...this.state,
      mineField: newField,
      gameOver: this.state.mineField[x][y].type === 'b'
    };
  }
}