{string} Lots = ...;

int nbPeriodes = ...;
range T = 1..nbPeriodes;

range Age = 0..9;

int ageinit[Lots] = ...;
int demande[T] = ...;
int effic[Age] = ...;

int c[i in Lots][t in T] = effic[ageinit[i] + (t-1)];

dvar boolean x[Lots][T];

maximize sum(i in Lots, t in T) c[i][t] * x[i][t];

subject to {

  forall(i in Lots)
    sum(t in T) x[i][t] == 1;

  forall(t in T)
    sum(i in Lots) x[i][t] == demande[t];
}

execute {
  var total = 0;
  writeln("=== Plan d'écoulement optimal ===");

  for (var t = 1; t <= nbPeriodes; t++) {
    write("Mois ", t, " : ");

    for (var i in Lots) {
      if (x[i][t] == 1) {
        write(i, " ");
        total += c[i][t];
      }
    }
    writeln();
  }

  writeln("Somme efficacites = ", total);
  writeln("Efficacite moyenne = ", (total/12.0), " %");
}
