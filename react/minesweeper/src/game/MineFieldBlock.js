export class MineFieldBlock {
  constructor(type, number = 0, opened = false) {
    this.type = type;
    this.opened = opened;
    this.number = number;
  }

  open() {
    return new MineFieldBlock(this.type, this.number, true);
  }

  isMine() {
    return this.type === 'b';
  }
}