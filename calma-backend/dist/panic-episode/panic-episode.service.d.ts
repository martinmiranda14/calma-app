import { Repository } from 'typeorm';
import { PanicEpisode } from './panic-episode.entity';
import { CreatePanicEpisodeDto } from './dto/create-panic-episode.dto';
export declare class PanicEpisodeService {
    private panicEpisodeRepository;
    constructor(panicEpisodeRepository: Repository<PanicEpisode>);
    create(createDto: CreatePanicEpisodeDto): Promise<PanicEpisode>;
    findAll(): Promise<PanicEpisode[]>;
    findOne(id: string): Promise<PanicEpisode | null>;
    getStatistics(): Promise<{
        totalEpisodes: number;
        avgDurationSeconds: number;
        avgAnxietyImprovement: number;
        mostUsedTechniques: {
            name: string;
            count: number;
        }[];
        recentEpisodes: PanicEpisode[];
    }>;
}
