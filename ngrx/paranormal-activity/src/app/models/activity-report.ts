export interface ActivityReport {
  time: Date;
  location: string;
  additionalInfo: string;
  type: string;
  items: string[];
  invoked: boolean;
}

export enum ReportStatus {
  Created,
  Approved,
  Disapproved
}

export interface ArchiveActivityReport extends ActivityReport {
  status: ReportStatus;
}