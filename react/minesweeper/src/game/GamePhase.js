const WIN = 'WIN';
const LOSS = 'LOSS';
const IN_PROGRESS = 'IN_PROGRESS';

export class GamePhase {
  constructor(phase = IN_PROGRESS) {
    this.phase = phase;
  }

  newGame() {
    return new GamePhase(IN_PROGRESS);
  }

  win() {
    return new GamePhase(WIN);
  }

  lose() {
    return new GamePhase(LOSS);
  }

  get inProgress() {
    return this.phase === IN_PROGRESS;
  }

  get lost() {
    return this.phase === LOSS;
  }

  get won() {
    return this.phase === WIN;
  }
}