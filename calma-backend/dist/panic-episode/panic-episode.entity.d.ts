export declare class PanicEpisode {
    id: string;
    startTime: Date;
    endTime: Date;
    durationSeconds: number;
    initialAnxietyLevel: number;
    finalAnxietyLevel: number;
    techniquesUsed: string[];
    notes: string;
    location: string;
    triggers: string;
    needsFollowUp: boolean;
}
