import { MineFieldGenerator } from "./MineFieldGenerator";
import { GamePhase } from "./GamePhase";

export class MineSweeperState {
  constructor() {
    this.mineField = new MineFieldGenerator().generateMineField();
    this.phase = new GamePhase();
  }
}

export class MineSweeperGame {
  constructor() {
    this.state = new MineSweeperState();
    this.generator = new MineFieldGenerator();
  }

  openBlockAt(x, y) {
    if (this.state.mineField[x][y].marked) {
      return;
    }
    
    let blocksToOpen = this.findBlocksToOpen(x, y);
    let isEmpty = (x, y) => blocksToOpen.some(([openX, openY]) => openX === x && openY === y);
    let newField = this.state.mineField.map(
      (row, i) => row.map((block, j) => isEmpty(i, j) ? block.open() : block)
    );

    const hitMine = this.state.mineField[x][y].isMine;
    let phase = this.state.phase;
    if (hitMine) {
      phase = phase.lose();
    } else if (!this.squaresLeft(newField)) {
      phase = phase.win();
    }

    this.state = {
      ...this.state,
      mineField: newField,
      phase: phase
    };
  }

  markBlockAt(x, y) {    
    const updatedField = this.state.mineField.map(
      (row, i) => row.map((block, j) => x === i && y === j ? block.toggleMarking() : block)
    );

    this.state = {
      ...this.state,
      mineField: updatedField
    };
  }

  findBlocksToOpen(x, y, blocks = []) {
    if (!this.state.mineField[x] || !this.state.mineField[x][y]) return blocks;

    let block = this.state.mineField[x][y];

    if (block.opened || blocks.some(([i, j]) => i === x && j === y)) {
      return blocks;
    }

    blocks.push([x, y]);
    if (block.number !== 0 || block.isMine) {
      return blocks;
    }

    this.findBlocksToOpen(x+1, y, blocks);
    this.findBlocksToOpen(x, y+1, blocks);
    this.findBlocksToOpen(x-1, y, blocks);
    this.findBlocksToOpen(x, y-1, blocks);
    this.findBlocksToOpen(x+1, y+1, blocks);
    this.findBlocksToOpen(x-1, y-1, blocks);
    this.findBlocksToOpen(x+1, y-1, blocks);
    this.findBlocksToOpen(x-1, y+1, blocks);
    return blocks;
  }

  squaresLeft(mineField) {
    return mineField.some(
      row => row.some(
        block => {
          return !block.isMine && !block.opened;        
        }
      )
    );
  }
}