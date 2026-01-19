#!/usr/bin/env python3
"""
Generador de Tonos de Frecuencias de Sanación
Genera tonos puros de 432Hz y 528Hz para ejercicios de respiración
"""

import numpy as np
from scipy.io import wavfile
import os

def generate_tone(frequency, duration=60, sample_rate=44100, fade_duration=0.5):
    """
    Genera un tono puro de frecuencia específica

    Args:
        frequency: Frecuencia en Hz (432, 528, etc.)
        duration: Duración en segundos (default: 60)
        sample_rate: Sample rate en Hz (default: 44100)
        fade_duration: Duración del fade in/out en segundos (default: 0.5)

    Returns:
        numpy array con la onda de audio
    """
    print(f"Generando tono de {frequency} Hz ({duration} segundos)...")

    # Generar array de tiempo
    t = np.linspace(0, duration, int(sample_rate * duration), dtype=np.float32)

    # Generar onda sinusoidal pura
    wave = np.sin(2 * np.pi * frequency * t)

    # Aplicar fade in y fade out para evitar clicks
    fade_samples = int(sample_rate * fade_duration)

    if fade_samples > 0:
        # Fade in (inicio)
        fade_in = np.linspace(0, 1, fade_samples, dtype=np.float32)
        wave[:fade_samples] *= fade_in

        # Fade out (final)
        fade_out = np.linspace(1, 0, fade_samples, dtype=np.float32)
        wave[-fade_samples:] *= fade_out

    # Normalizar a rango de 16-bit (-32768 a 32767)
    # Usar 80% del rango máximo para evitar clipping
    wave = np.int16(wave * 32767 * 0.8)

    return wave


def main():
    """Función principal que genera los tonos"""

    print("=" * 60)
    print("Generador de Tonos de Frecuencias de Sanación")
    print("=" * 60)
    print()

    # Crear directorio de salida si no existe
    output_dir = "audio_files"
    os.makedirs(output_dir, exist_ok=True)
    print(f"📁 Directorio de salida: {output_dir}/")
    print()

    # Configuración de tonos a generar
    tones = [
        {"freq": 432, "name": "432hz", "description": "Frecuencia Natural (calmante)"},
        {"freq": 528, "name": "528hz", "description": "Frecuencia del Amor (sanación)"},
    ]

    # Generar cada tono
    for tone in tones:
        print(f"🎵 {tone['description']}")

        # Generar tono
        audio_data = generate_tone(
            frequency=tone['freq'],
            duration=60,  # 60 segundos
            sample_rate=44100,
            fade_duration=0.5  # 0.5 segundos de fade
        )

        # Guardar como WAV
        output_path = os.path.join(output_dir, f"{tone['name']}.wav")
        wavfile.write(output_path, 44100, audio_data)

        # Calcular tamaño del archivo
        file_size_mb = os.path.getsize(output_path) / (1024 * 1024)

        print(f"   ✅ Guardado: {output_path}")
        print(f"   📊 Tamaño: {file_size_mb:.2f} MB")
        print()

    print("=" * 60)
    print("✨ ¡Archivos generados exitosamente!")
    print("=" * 60)
    print()
    print("Próximos pasos:")
    print("1. Copiar archivos WAV a: calma_flutter/assets/audio/")
    print("2. Actualizar pubspec.yaml con rutas de assets")
    print("3. Modificar audio_service.dart para usar setAsset()")
    print()
    print("Comandos sugeridos:")
    print(f"  mkdir -p calma_flutter/assets/audio")
    print(f"  cp {output_dir}/*.wav calma_flutter/assets/audio/")
    print()


if __name__ == "__main__":
    try:
        main()
    except ImportError as e:
        print("❌ Error: Faltan dependencias requeridas")
        print()
        print("Por favor instala las dependencias con:")
        print("  pip install numpy scipy")
        print()
        print(f"Detalles del error: {e}")
    except Exception as e:
        print(f"❌ Error inesperado: {e}")
        import traceback
        traceback.print_exc()
