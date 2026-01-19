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
exports.PanicEpisodeController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const panic_episode_service_1 = require("./panic-episode.service");
const create_panic_episode_dto_1 = require("./dto/create-panic-episode.dto");
let PanicEpisodeController = class PanicEpisodeController {
    panicEpisodeService;
    constructor(panicEpisodeService) {
        this.panicEpisodeService = panicEpisodeService;
    }
    create(createDto) {
        return this.panicEpisodeService.create(createDto);
    }
    findAll() {
        return this.panicEpisodeService.findAll();
    }
    getStatistics() {
        return this.panicEpisodeService.getStatistics();
    }
    findOne(id) {
        return this.panicEpisodeService.findOne(id);
    }
};
exports.PanicEpisodeController = PanicEpisodeController;
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Register a new panic episode' }),
    (0, swagger_1.ApiResponse)({ status: 201, description: 'Episode registered successfully' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_panic_episode_dto_1.CreatePanicEpisodeDto]),
    __metadata("design:returntype", void 0)
], PanicEpisodeController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get all panic episodes' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], PanicEpisodeController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('statistics'),
    (0, swagger_1.ApiOperation)({ summary: 'Get panic episodes statistics' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], PanicEpisodeController.prototype, "getStatistics", null);
__decorate([
    (0, common_1.Get)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Get a specific panic episode' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], PanicEpisodeController.prototype, "findOne", null);
exports.PanicEpisodeController = PanicEpisodeController = __decorate([
    (0, swagger_1.ApiTags)('panic-episodes'),
    (0, common_1.Controller)('panic-episodes'),
    __metadata("design:paramtypes", [panic_episode_service_1.PanicEpisodeService])
], PanicEpisodeController);
//# sourceMappingURL=panic-episode.controller.js.map