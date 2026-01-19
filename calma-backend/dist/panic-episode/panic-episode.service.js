"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PanicEpisodeService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const panic_episode_entity_1 = require("./panic-episode.entity");
let PanicEpisodeService = class PanicEpisodeService {
    panicEpisodeRepository;
    constructor(panicEpisodeRepository) {
        this.panicEpisodeRepository = panicEpisodeRepository;
    }
    async create(createDto) {
        const episode = this.panicEpisodeRepository.create(createDto);
        episode.endTime = new Date();
        return this.panicEpisodeRepository.save(episode);
    }
    async findAll() {
        return this.panicEpisodeRepository.find({
            order: { startTime: 'DESC' },
        });
    }
    async findOne(id) {
        return this.panicEpisodeRepository.findOne({ where: { id } });
    }
    async getStatistics() {
        const episodes = await this.findAll();
        const totalEpisodes = episodes.length;
        const avgDuration = episodes.length > 0
            ? episodes.reduce((sum, ep) => sum + ep.durationSeconds, 0) / episodes.length
            : 0;
        const episodesWithAnxietyData = episodes.filter(ep => ep.initialAnxietyLevel && ep.finalAnxietyLevel);
        const avgImprovement = episodesWithAnxietyData.length > 0
            ? episodesWithAnxietyData.reduce((sum, ep) => sum + (ep.initialAnxietyLevel - ep.finalAnxietyLevel), 0) / episodesWithAnxietyData.length
            : 0;
        const techniquesCount = {};
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
};
exports.PanicEpisodeService = PanicEpisodeService;
exports.PanicEpisodeService = PanicEpisodeService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(panic_episode_entity_1.PanicEpisode)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], PanicEpisodeService);
//# sourceMappingURL=panic-episode.service.js.map