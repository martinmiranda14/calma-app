export declare class CreatePanicEpisodeDto {
    durationSeconds: number;
    initialAnxietyLevel?: number;
    finalAnxietyLevel?: number;
    techniquesUsed?: string[];
    notes?: string;
    location?: string;
    triggers?: string;
    needsFollowUp?: boolean;
}
