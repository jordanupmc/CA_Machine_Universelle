# Compilation S-UM

Projet CA compilation vers la machine universelle

## Pour commencer

Ces instructions vont vous permettre de lancer correctement le projet, que ce soit l'interpreteur ou le compilateur.

### Prérequis

The OCaml toplevel, version 4.01.0+ocp1
Java 8

### Installation

Pour compiler l'interpreteur
```
ant compile
```


Pour compiler le compilateur
```
./compile.sh
```

Enfin vous pouvez lancer la machine sur un programme source
```
./runMachine.sh sandmark.umz
```

## Lancer les tests
Pour lancer les tests contenu dans le dossiers tests/

```
ant Testeur
```

### Style des tests

Pour ajouter un test au dossier tests il faut créer 3 fichier: .input .output .sum

## Build

Ant, pour l'interpreteur  

## Auteur

* **Jeudy Jordan** 

