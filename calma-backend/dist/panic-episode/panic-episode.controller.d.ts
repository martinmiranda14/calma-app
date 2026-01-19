import { PanicEpisodeService } from './panic-episode.service';
import { CreatePanicEpisodeDto } from './dto/create-panic-episode.dto';
export declare class PanicEpisodeController {
    private readonly panicEpisodeService;
    constructor(panicEpisodeService: PanicEpisodeService);
    create(createDto: CreatePanicEpisodeDto): Promise<import("./panic-episode.entity").PanicEpisode>;
    findAll(): Promise<import("./panic-episode.entity").PanicEpisode[]>;
    getStatistics(): Promise<{
        totalEpisodes: number;
        avgDurationSeconds: number;
        avgAnxietyImprovement: number;
        mostUsedTechniques: {
            name: string;
            count: number;
        }[];
        recentEpisodes: import("./panic-episode.entity").PanicEpisode[];
    }>;
    findOne(id: string): Promise<import("./panic-episode.entity").PanicEpisode | null>;
}
