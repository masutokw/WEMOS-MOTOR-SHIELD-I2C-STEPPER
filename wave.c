#include "wave.h"
void generate_wave(int percent)
{int n;
   for (n=0;n<=32;n++){
   wave[n]=(wave_f[n]*percent)/100;  }
}
