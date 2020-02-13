import { createSelector } from '@ngrx/store';
import { ActivityReport, ArchiveActivityReport, ReportStatus } from '../models/activity-report';
import { REPORTS } from '../models/activity-report.mock';

const TYPES = [ "Poltergeist", "Ghost", "Crop circle", "Alien abduction", "Spontaneous combustion" ];

export function addNewActivity(state: State, props: { submittedReport: ActivityReport }): State {
  const archiveReport = { ...props.submittedReport, status: ReportStatus.Created };
  return { ...state, reportedActivities: state.reportedActivities.concat(archiveReport) };
}

export interface State {
  reportedActivities: ArchiveActivityReport[];
  activityTypes: string[];
}

export const initialState: State = { reportedActivities: REPORTS, activityTypes: TYPES };

export const selectActivityTypes = createSelector(
  (s: { activities: State }) => s.activities,
  (state: State) => state.activityTypes
);

export const selectAllReports = createSelector(
  (s: { activities: State }) => s.activities,
  (state: State) => state.reportedActivities
);
