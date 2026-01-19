import { IsInt, Min, Max, IsOptional, IsString, IsBoolean, IsArray } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreatePanicEpisodeDto {
  @ApiProperty({ description: 'Duration of the episode in seconds' })
  @IsInt()
  @Min(0)
  durationSeconds: number;

  @ApiPropertyOptional({ description: 'Initial anxiety level (1-10)', minimum: 1, maximum: 10 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  initialAnxietyLevel?: number;

  @ApiPropertyOptional({ description: 'Final anxiety level (1-10)', minimum: 1, maximum: 10 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  finalAnxietyLevel?: number;

  @ApiPropertyOptional({ description: 'Techniques used during episode', type: [String] })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  techniquesUsed?: string[];

  @ApiPropertyOptional({ description: 'Optional notes about the episode' })
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ description: 'Location where episode occurred' })
  @IsOptional()
  @IsString()
  location?: string;

  @ApiPropertyOptional({ description: 'Identified triggers' })
  @IsOptional()
  @IsString()
  triggers?: string;

  @ApiPropertyOptional({ description: 'Whether follow-up is needed' })
  @IsOptional()
  @IsBoolean()
  needsFollowUp?: boolean;
}
