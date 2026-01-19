"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PanicEpisodeModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const panic_episode_entity_1 = require("./panic-episode.entity");
const panic_episode_service_1 = require("./panic-episode.service");
const panic_episode_controller_1 = require("./panic-episode.controller");
let PanicEpisodeModule = class PanicEpisodeModule {
};
exports.PanicEpisodeModule = PanicEpisodeModule;
exports.PanicEpisodeModule = PanicEpisodeModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([panic_episode_entity_1.PanicEpisode])],
        controllers: [panic_episode_controller_1.PanicEpisodeController],
        providers: [panic_episode_service_1.PanicEpisodeService],
        exports: [panic_episode_service_1.PanicEpisodeService],
    })
], PanicEpisodeModule);
//# sourceMappingURL=panic-episode.module.js.map