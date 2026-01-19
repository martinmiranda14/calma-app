import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('panic_episodes')
export class PanicEpisode {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @CreateDateColumn()
  startTime: Date;

  @Column({ type: 'datetime', nullable: true })
  endTime: Date;

  @Column({ type: 'int' })
  durationSeconds: number;

  @Column({ type: 'int', nullable: true })
  initialAnxietyLevel: number; // 1-10

  @Column({ type: 'int', nullable: true })
  finalAnxietyLevel: number; // 1-10

  @Column({ type: 'simple-array', nullable: true })
  techniquesUsed: string[]; // ['respiracion', 'grounding', etc]

  @Column({ type: 'text', nullable: true })
  notes: string;

  @Column({ type: 'text', nullable: true })
  location: string; // 'casa', 'trabajo', 'público', etc

  @Column({ type: 'text', nullable: true })
  triggers: string;

  @Column({ default: false })
  needsFollowUp: boolean;
}
