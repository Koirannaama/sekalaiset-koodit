export const spring = "spring";
export const fall = "fall";
export const summer = "summer";
export const winter = "winter";

export function advance(currentSeason) {
  if (currentSeason === spring) {
    return summer;
  }
  else if (currentSeason === summer) {
    return fall;
  }
  else if (currentSeason === fall) {
    return winter;
  }
  else if (currentSeason === winter) {
    return spring;
  }
}