import pandas as pd

df = pd.read_csv('Data/student.csv');
print(df)
df.to_json('temp.json', orient='records', lines=False)