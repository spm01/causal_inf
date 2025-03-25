#%%
import pandas as pd
import os 
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
import statsmodels.api as sm
import statsmodels.formula.api as smf
import numpy as np
from sklearn import preprocessing

#%%
#set dir and import file
os.chdir('C:\\Users\\Sean\\Desktop\\Python\\DS_Projects\\flagship_research')
df = pd.read_csv('research.csv')
# %%
#check data for issues
print(df.head())
print(df.dtypes)

#%%
#get rid of time column
df = df.drop('時間戳記', axis=1)

# %%
#clearing out string values from observations
df['手機時間'] = df['手機時間'].map(lambda x: x.rstrip("小時以上"))
df['手機時間'] = df['手機時間'].map(lambda x: x.rstrip("小時"))
df['睡眠時間'] = df['睡眠時間'].map(lambda x: x.rstrip("小時"))
df['睡眠時間'] = df['睡眠時間'].map(lambda x: x.rstrip("時以上"))
df['運動時間'] = df['運動時間'].map(lambda x: x.rstrip("小時"))
df['運動時間'] = df['運動時間'].map(lambda x: x.rstrip("小時以上"))
#%%
#rename columns
df = df.rename(columns={'年齡':'age', '手機時間':'phone_time',"睡眠時間":"sleep_time", "運動時間":'workout_time','身體狀況':'health_status',"飲食熱量":'cal_intake',})
# %%
#set up replacing binned obs with int values
#create needed mappings
mapping1 = {'0-1': 1, '1-2': 2, "2-3": 3, "3-4": 4, "4-5": 5, "5-6": 6, "6-7":7, "7-8": 8, "8": 9}
mapping2 = {'4': 0, '4-5': 1, "5-6": 2, "6-7": 3, "7-8": 4, "8-9": 5, "9":6}
mapping3 = {'0-500':0, '500-1000':1, '1000-1500':2, '1500-2000':3, "2000-2500":4, "2500-3000":5,"3000+":6}

#define function to replace
def num_change(df, column, mapping):
    df[column] = df[column].replace(mapping)
    return df

#execute replacement
df = num_change(df, "phone_time", mapping1)
df = num_change(df, "sleep_time", mapping2)
df = num_change(df, "workout_time", mapping1)
df = num_change(df, "cal_intake", mapping3)

#%%
#check for any Nan values in data
print(df.isna())
# %%
#check for basic summary stats
print(df.describe())
# %%
#deal with missing values
#impute mean values into Nan values
df['cal_intake'].fillna(df['cal_intake'].mean(),inplace = True)
print(df.describe())

#%%
#no more Nan values
print(df.isna())

# %%
'''
#create initial plot to visualize relationships between variables
X = df['phone_time']
Y = df["health_status"]

plt.scatter(X,Y)
plt.xlim(0,)
plt.xticks(ticks=range(1,10), labels=['0-1','1-2',"2-3","3-4","4-5","5-6","6-7","7-8","8+"])
plt.xlabel("Daily Average Phone Usage")
plt.ylabel("Self-Reported Health Status")
plt.show()

X = df['sleep_time']
plt.scatter(X,Y)
plt.xlim(0,)
plt.xticks(ticks=range(1,8), labels=['4','4-5',"5-6","6-7","7-8","8-9","9+"])
plt.xlabel("Daily Average Sleep Time")
plt.ylabel("Self-Reported Health Status")
plt.show()

X = df['workout_time']
plt.scatter(X,Y)
plt.xlim(0,)
plt.xticks(ticks=range(1,10), labels=['0-1','1-2',"2-3","3-4","4-5","5-6","6-7","7-8","8+"])
plt.xlabel("Average Weekly Workout Time")
plt.ylabel("Self-Reported Health Status")
plt.show()

X = df['cal_intake']
plt.figure(figsize=(10,10))
plt.gcf().subplots_adjust(bottom=0.20)
plt.scatter(X,Y)
plt.xlim(0,)
plt.xticks(ticks=range(1,8),labels=['0-500','500-1000','1000-1500','1500-2000', "2000-2500", "2500-3000","3000+"])
plt.xticks(rotation=45)
plt.xlabel('Average Daily Caloric Intake')
plt.ylabel("Self-Reported Health Status")
plt.show()
'''
# %%
#create correlation matrix between variables
matrix = np.corrcoef(df[['health_status','phone_time','sleep_time','workout_time','cal_intake']])
print(matrix)
#positive relationship found between each variable??


#%%
#check for variable collinearity using Variance Inflation Factor
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.tools.tools import add_constant
#set independent variables
X = add_constant(df)
#calculate VIF for each variable
print(pd.Series([variance_inflation_factor(X.values, i)
           for i in range(X.shape[1])],
           index = X.columns)
)
#output values are between 1.05 - 1.41 indicating low probability of multicolinearity
#%%
#normalize variables before regression
df_step = preprocessing.normalize(df, axis=0)
scaled_df = pd.DataFrame(df_step, columns = df.columns)

#%%
#create multiple linear regression to evaluate potential relationships
#X = scaled_df[['phone_time','sleep_time','workout_time','cal_intake']]
#Y = scaled_df['health_status']

model1 = smf.ols(formula= 'health_status ~ phone_time + sleep_time + workout_time + cal_intake', data=scaled_df).fit(cov_type="HC0")
print(model1.summary())

#%%
#create multiple linear regression including interaction terms
model2 = smf.ols(formula='health_status ~ phone_time + sleep_time + workout_time + cal_intake + phone_time:sleep_time + phone_time:workout_time', data = scaled_df).fit(cov_type="HC0")
print(model2.summary())
#%%
model2_pvals = model2.pvalues
print(model2_pvals)
#all values are statistically insignificant
#no interaction exists between phonetime/sleeptime and phonetime/workouttime
