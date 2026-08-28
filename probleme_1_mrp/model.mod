{string} Items = ...;
int cBuy[Items] = ...;
int cAsm[Items] = ...;
int demand[Items] = ...;

// Variables
dvar int+ x[Items];
dvar int+ y[Items];

// Objectif
minimize
  sum(i in Items) (cAsm[i] * x[i] + cBuy[i] * y[i]);

// contraintes
subject to {

  x["U"] + y["U"] >= demand["U"];
  x["R"] + y["R"] >= demand["R"];
  x["T"] + y["T"] >= demand["T"];

  x["S"] + y["S"] >= x["U"] + x["R"] + 2 * x["T"];
  x["W"] + y["W"] >= x["U"] + 2 * x["R"] + 2 * x["T"];
  x["C"] + y["C"] >= x["R"] + 2 * x["T"];

  x["H"] + y["H"] >= x["W"];
  x["P"] + y["P"] >= 36 * x["W"];
  x["L"] + y["L"] >= 84 * x["C"];
}

execute {
  writeln("===== Solution =====");
  for (var i in Items)
    if (x[i] > 0 || y[i] > 0)
      writeln(i, ": x=", x[i], " y=", y[i]);

  writeln("Coût total = ", cplex.getObjValue());
}
