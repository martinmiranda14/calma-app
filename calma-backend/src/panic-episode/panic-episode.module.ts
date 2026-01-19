import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PanicEpisode } from './panic-episode.entity';
import { PanicEpisodeService } from './panic-episode.service';
import { PanicEpisodeController } from './panic-episode.controller';

@Module({
  imports: [TypeOrmModule.forFeature([PanicEpisode])],
  controllers: [PanicEpisodeController],
  providers: [PanicEpisodeService],
  exports: [PanicEpisodeService],
})
export class PanicEpisodeModule {}
