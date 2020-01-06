import { createAction, props } from '@ngrx/store';
import { ActivityReport } from '../models/activity-report';

export const saveForm = createAction("[Activity form] Submit form", props<{ submittedReport: ActivityReport }>());