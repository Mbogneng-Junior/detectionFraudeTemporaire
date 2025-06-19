# src/features/build_features.py

import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler

def create_engineered_features(df):
    """
    Crée les nouvelles caractéristiques (features).
    """
    df_copy = df.copy()
    
    # 1. Features sur le temps
    seconds_in_day = 24 * 60 * 60
    df_copy['hour_of_day'] = (df_copy['Time'] % seconds_in_day) / 3600
    
    # 2. Features sur le montant
    # Utilisation de log1p pour éviter les problèmes avec les montants de 0
    df_copy['Amount_log'] = np.log1p(df_copy['Amount'])
    
    # (Optionnel) Vitesse des transactions (à ajouter si vous voulez tester plus tard)
    # df_copy['time_diff'] = df_copy['Time'].diff().fillna(0)
    
    return df_copy

def preprocess_data(df, apply_feature_engineering=False):
    """
    Prétraite les données : normalisation, feature engineering (optionnel) et séparation.
    """
    df_processed = df.copy()

    # Appliquer le feature engineering si demandé
    if apply_feature_engineering:
        print("Application du Feature Engineering...")
        df_processed = create_engineered_features(df_processed)
        # Supprimer les colonnes originales qui ont été transformées pour éviter la redondance
        # On garde 'Time' pour le tri, on le supprimera plus tard
        df_processed = df_processed.drop(['Amount'], axis=1)

    # Normaliser les colonnes 'Time' et 'Amount' (ou 'Amount_log' si elle existe)
    scaler = StandardScaler()
    
    cols_to_scale = ['Time', 'Amount']
    if 'Amount_log' in df_processed.columns:
        cols_to_scale = ['Time', 'Amount_log']

    df_processed[cols_to_scale] = scaler.fit_transform(df_processed[cols_to_scale])

    # Séparation temporelle des données (ex: 80% pour l'entraînement, 20% pour le test)
    df_processed = df_processed.sort_values('Time') # Assurer que les données sont triées
    train_size = int(len(df_processed) * 0.8)
    
    train_df = df_processed.iloc[:train_size]
    test_df = df_processed.iloc[train_size:]

    # Séparer les features (X) de la cible (y)
    X_train = train_df.drop('Class', axis=1)
    y_train = train_df['Class']
    X_test = test_df.drop('Class', axis=1)
    y_test = test_df['Class']
    
    # On peut maintenant supprimer 'Time' car il a servi au tri et à la création de features
    X_train = X_train.drop('Time', axis=1, errors='ignore')
    X_test = X_test.drop('Time', axis=1, errors='ignore')
    
    print(f"Taille du jeu d'entraînement : {len(X_train)} lignes")
    print(f"Taille du jeu de test : {len(X_test)} lignes")

    return X_train, y_train, X_test, y_test