// ---------- PARAMETRES ----------
int T = ...;
range PERIOD = 1..T;

float d[PERIOD] = ...;
float ch = ...;
float cI = ...;
float cL = ...;

float P0 = ...;
float I0 = ...;

int Pdisrupt = ...;

range SCEN = 1..T;

// ---------- VARIABLES DE DECISION ----------
dvar float+ P[PERIOD];
dvar float+ Up[PERIOD];
dvar float+ Down[PERIOD];

dvar float+ I[SCEN,PERIOD];
dvar float+ Lost[SCEN,PERIOD];

dvar float Z;

dexpr float VarCost = sum(t in PERIOD) ch * (Up[t] + Down[t]);

// ---------- OBJECTIF ----------
minimize Z;

// ---------- CONTRAINTES ----------
subject to {

  // 1) Bilans stock/ventes
  forall(s in SCEN) {

    // Période 1
    I[s,1] == I0
              + (s==1 ? Pdisrupt : P[1])
              - d[1]
              + Lost[s,1];

    // Périodes 2..T
    forall(t in PERIOD : t > 1)
      I[s,t] == I[s,t-1]
                + (s==t ? Pdisrupt : P[t])
                - d[t]
                + Lost[s,t];

    I[s,T] == I0;
  }

  // 2) Variation de production
  P[1] - P0 == Up[1] - Down[1];
  forall(t in PERIOD : t > 1)
    P[t] - P[t-1] == Up[t] - Down[t];

  P[T] == P0;

  // 3) Définition du pire coût
  forall(s in SCEN)
    Z >= VarCost
         + sum(t in PERIOD) (cI * I[s,t] + cL * Lost[s,t]);
}

// ---------- AFFICHAGE DES RESULTATS ----------
execute {
  writeln("===== PLAN ROBUSTE =====");
  writeln("P = ", P);
  writeln("Up = ", Up);
  writeln("Down = ", Down);
  writeln("VarCost = ", VarCost);
  writeln("Z (worst-case) = ", Z);

  writeln("\n===== DETAILS PAR SCENARIO =====");
  for(var s in SCEN){
    writeln("Scenario s=", s, " (incident en periode ", s, ")");
    writeln(" I[s,*] = ", I[s]);
    writeln(" Lost[s,*] = ", Lost[s]);
  }
}
