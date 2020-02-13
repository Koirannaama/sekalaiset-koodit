import { ArchiveActivityReport, ReportStatus } from "./activity-report";

export const REPORTS: ArchiveActivityReport[] = [
    {
        location: "Burk",
        time: new Date(2019, 12, 20),
        status: ReportStatus.Created,
        items: [],
        type: "Poltergeist",
        invoked: false,
        additionalInfo: ""
    },
    {
        location: "Burk",
        time: new Date(2019, 12, 19),
        status: ReportStatus.Created,
        items: [],
        type: "Zombie",
        invoked: false,
        additionalInfo: ""
    }
];
