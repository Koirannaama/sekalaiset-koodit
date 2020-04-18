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
    let blocksToOpen = this.findBlocksToOpen(x, y);
    let isEmpty = (x, y) => blocksToOpen.some(([openX, openY]) => openX === x && openY === y);
    let newField = this.state.mineField.map(
      (row, i) => row.map((block, j) => isEmpty(i, j) ? block.open() : block)
    );

    this.state = {
      ...this.state,
      mineField: newField,
      gameOver: this.state.mineField[x][y].isMine
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
}