# 📱 TaskFlow Mobile

Application mobile développée avec **Flutter** permettant de gérer des projets et des tâches (création, consultation, suivi).  

---

## ✔️ Fonctionnalités principales

- Authentification utilisateur (connexion/inscription)
- Consultation de la liste des projets
- Détail d’un projet et de ses tâches
- Gestion des projets (membres, tâches, tags...)
- Consultation de la liste des tâches
- Gestion des tâches (statut, priorité, échéance, utilisateur assigné...)
- Mise à jour des informations et mot de passe de l'utilisateur connecté

---

## 🚀 Prérequis


- **Flutter SDK** (version recommandée : dernière version stable)
- **Dart SDK** (inclus avec Flutter)
- Un **IDE** compatible :
  - Android Studio
  - Visual Studio Code
  - IntelliJ IDEA
- Un **émulateur** ou **appareil physique** :
  - Android Emulator
  - iOS Simulator (macOS uniquement)
- Une **API backend fonctionnelle**

Pour vérifier que Flutter est correctement installé :

```bash
flutter doctor
```

---

## ⚙️ Installation

1. **Cloner le projet**
   ```bash
   git clone https://github.com/allecomte/taskflow-mobile.git
   cd taskflow-mobile
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l’application**
   ```bash
   flutter run
   ```

---

## 🧪 Lancer les tests

Exécuter tous les tests :
```bash
flutter test
```

Générer un rapport de couverture :
```bash
genhtml.bat coverage/lcov.info -o coverage/html
```

---

## 📐 Architecture

La documentation détaillée de l’architecture de l’application est disponible ici :  
👉 [Consulter la documentation d’architecture](docs/architecture.md)

---

📅 **Dernière mise à jour :** 31/01/2026