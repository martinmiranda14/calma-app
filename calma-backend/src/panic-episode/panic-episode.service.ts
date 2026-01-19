import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PanicEpisode } from './panic-episode.entity';
import { CreatePanicEpisodeDto } from './dto/create-panic-episode.dto';

@Injectable()
export class PanicEpisodeService {
  constructor(
    @InjectRepository(PanicEpisode)
    private panicEpisodeRepository: Repository<PanicEpisode>,
  ) {}

  async create(createDto: CreatePanicEpisodeDto): Promise<PanicEpisode> {
    const episode = this.panicEpisodeRepository.create(createDto);
    episode.endTime = new Date(); // El episodio termina cuando se registra
    return this.panicEpisodeRepository.save(episode);
  }

  async findAll(): Promise<PanicEpisode[]> {
    return this.panicEpisodeRepository.find({
      order: { startTime: 'DESC' },
    });
  }

  async findOne(id: string): Promise<PanicEpisode | null> {
    return this.panicEpisodeRepository.findOne({ where: { id } });
  }

  async getStatistics() {
    const episodes = await this.findAll();

    const totalEpisodes = episodes.length;
    const avgDuration = episodes.length > 0
      ? episodes.reduce((sum, ep) => sum + ep.durationSeconds, 0) / episodes.length
      : 0;

    const episodesWithAnxietyData = episodes.filter(
      ep => ep.initialAnxietyLevel && ep.finalAnxietyLevel
    );

    const avgImprovement = episodesWithAnxietyData.length > 0
      ? episodesWithAnxietyData.reduce(
          (sum, ep) => sum + (ep.initialAnxietyLevel - ep.finalAnxietyLevel),
          0
        ) / episodesWithAnxietyData.length
      : 0;

    // Técnicas más usadas
    const techniquesCount: Record<string, number> = {};
    episodes.forEach(ep => {
      ep.techniquesUsed?.forEach(tech => {
        techniquesCount[tech] = (techniquesCount[tech] || 0) + 1;
      });
    });

    return {
      totalEpisodes,
      avgDurationSeconds: Math.round(avgDuration),
      avgAnxietyImprovement: Math.round(avgImprovement * 10) / 10,
      mostUsedTechniques: Object.entries(techniquesCount)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 3)
        .map(([name, count]) => ({ name, count })),
      recentEpisodes: episodes.slice(0, 5),
    };
  }
}
