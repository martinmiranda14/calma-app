import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { PanicEpisodeService } from './panic-episode.service';
import { CreatePanicEpisodeDto } from './dto/create-panic-episode.dto';

@ApiTags('panic-episodes')
@Controller('panic-episodes')
export class PanicEpisodeController {
  constructor(private readonly panicEpisodeService: PanicEpisodeService) {}

  @Post()
  @ApiOperation({ summary: 'Register a new panic episode' })
  @ApiResponse({ status: 201, description: 'Episode registered successfully' })
  create(@Body() createDto: CreatePanicEpisodeDto) {
    return this.panicEpisodeService.create(createDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all panic episodes' })
  findAll() {
    return this.panicEpisodeService.findAll();
  }

  @Get('statistics')
  @ApiOperation({ summary: 'Get panic episodes statistics' })
  getStatistics() {
    return this.panicEpisodeService.getStatistics();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a specific panic episode' })
  findOne(@Param('id') id: string) {
    return this.panicEpisodeService.findOne(id);
  }
}
