import 'dart:math' as math;

class Calculos {
  double masa1;
  double masa2;
  double angulo;
  double coefFriccion;
  double peso1 = 0;
  double peso2 = 0;
  double normal = 0;
  double friccion = 0;
  double aceleracion = 0;
  double tension = 0;

  final double gravedad = 9.8;

  Calculos(this.masa1, this.masa2, this.angulo, this.coefFriccion);

  void calculoPesoObjetoSobreSuperficie() {
    double anguloEnRadianes = angulo * math.pi / 180; // Convierte el ángulo a radianes
    peso1 = masa1 * gravedad * math.sin(anguloEnRadianes);
  }

  void calculoPesoObjetoSuspendido() {
    peso2 = masa2 * gravedad;
  }

  void calculoNormalYFriccion() {
    double anguloEnRadianes = angulo * math.pi / 180;
    normal = masa1 * gravedad * math.cos(anguloEnRadianes);
    print(normal);
    friccion = coefFriccion * normal;
  }

  void calculoAceleracion() {
    calculoPesoObjetoSobreSuperficie();
    calculoPesoObjetoSuspendido();
    calculoNormalYFriccion();

    aceleracion = (peso2 - peso1 - friccion) / (masa1 + masa2);
    if(aceleracion < 0) {
      aceleracion = aceleracion * -1;
    }
  }

  void calculoTension() {
    calculoAceleracion();
    tension = (masa2 * gravedad) - (masa2 * aceleracion);
  }
}

