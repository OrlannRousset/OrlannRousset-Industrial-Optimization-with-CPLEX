int T = ...;
range PERIOD = 1..T;

// paramètres
float d[PERIOD] = ...;
float ch = ...;
float cI = ...;
float P0 = ...;
float I0 = ...;

// variables
dvar float+ P[PERIOD];
dvar float+ I[PERIOD];
dvar float+ Up[PERIOD];
dvar float+ Down[PERIOD];

// objectif
minimize
  sum(t in PERIOD) (ch * (Up[t] + Down[t]) + cI * I[t]);

// contraintes
subject to {

  // bilan de stock
  I[1] == I0 + P[1] - d[1];
  forall(t in PERIOD : t > 1)
    I[t] == I[t-1] + P[t] - d[t];

  // variation de production
  P[1] - P0 == Up[1] - Down[1];
  forall(t in PERIOD : t > 1)
    P[t] - P[t-1] == Up[t] - Down[t];

  // niveaux finaux
  I[T] == I0;
  P[T] == P0;
}
