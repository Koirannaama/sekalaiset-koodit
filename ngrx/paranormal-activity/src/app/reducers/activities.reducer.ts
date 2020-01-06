import { createReducer, on, Action } from '@ngrx/store';
import { initialState, addNewActivity, State } from '../state/state';
import { saveForm } from '../actions/form.actions';

const reducer = createReducer(
  initialState,
  on(saveForm, addNewActivity)
);

export function getReducer(state: State, action: Action) {
  return reducer(state, action);
}