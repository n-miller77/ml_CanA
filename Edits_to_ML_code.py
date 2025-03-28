# changed f1_score(y_test, y_pred, average='weighted') to f1_score(y_test, y_pred, average='macro')
# changed all cases of F1 to F1_macro, F1_scores to F1_macro_scores

#changed to 'load data' section to: 
df = data.drop(['Genome_ID'], axis=1)
df['Niche'] = df['Niche'].str.lower().map({'blood': 0, 'urine': 1})
print(df['Niche'].value_counts())


# Took the for loop out at the end and replaced with:
print(f"Running Optuna for Blood vs Urine")

    # Label encoding
original_niches = df['Niche'].copy()
le = LabelEncoder()
df['Niche'] = le.fit_transform(df['Niche'])
niche_mapping = dict(zip(le.transform(le.classes_), le.classes_))

    # Clean column names
data2 = clean_column_names(df)
X = df.drop('Niche', axis=1)
y = df['Niche']

    # Select top k features
k = min(20000, X.shape[1])  # Ensure k does not exceed the number of features
bestfeatures = SelectKBest(score_func=f_classif, k=k)
fit = bestfeatures.fit(X, y)
cols = bestfeatures.get_support(indices=True)
X_reduced = X.iloc[:, cols]

    # Prepare final dataframe
final_df = X_reduced.copy()
final_df['Niche'] = y

final_df = clean_column_names(final_df)
X = final_df.drop('Niche', axis=1)
y = final_df['Niche']






# added a train/test column to my CSV file.

###Then change the first part of the code to this: 
## Load Data

data = pd.read_csv('/storage/home/hcoda1/2/emehlferber3/scratch/30K_Genomes/XGBoost/Data_Prep/Panaroo_111_merged/XGBoost_Input_Grouped_Panaroo_111.csv')

# split into train and test 
train_df = data[data['Train/Test'] == 'Train'].copy()
test_df = data[data['Train/Test'] == 'Test'].copy()

train_df = train_df.drop(['Genome_ID', 'Train/Test'], axis=1)
test_df = test_df.drop(['Genome_ID', 'Train/Test'], axis=1)

df = pd.concat([train_df, test_df])

# Explicit mapping of niches (blood=0, urine=1)
df['Niche'] = df['Niche'].str.lower().map({'blood': 0, 'urine': 1})

# Check niche counts across the entire dataset
print(df['Niche'].value_counts())


train_df['Niche'] = train_df['Niche'].str.lower().map({'blood': 0, 'urine': 1})
test_df['Niche'] = test_df['Niche'].str.lower().map({'blood': 0, 'urine': 1})
