# ================================= Imports =================================
# For web application
import dash  
# For further designing each tab
import dash_bootstrap_components as dbc  
# For HTML and Core components
from dash import dcc, html  
# For DataTable component
from dash import dash_table  
from dash.dash_table.Format import Group  
# Input and Output for callbacks
from dash.dependencies import Input, Output  

# For handling data
import pandas as pd  
import numpy as np  

# For interactive plotting
import plotly.express as px  

# For statistical functions
from scipy import stats  
# For One-way ANOVA test
from scipy.stats import f_oneway  
# For Pearson correlation coefficient function
from scipy.stats import pearsonr  

# ================================= Imports =================================





# ================================= Read Excel File =================================
file_path = '/Users/udoychowdhury/Documents/Assitantship/Conditionally Admitted Students Updated.xlsx'
df = pd.read_excel(file_path)

# Replace NaN with NULL
df.replace({pd.NA: 'NULL', pd.NaT: 'NULL'}, inplace=True)

# Create only Numeric and Object columns for later use
numerical_columns = df.select_dtypes(include=['float64', 'int64']).columns
object_columns = df.select_dtypes(include='object').columns
object_df = df[object_columns]
# ================================= Read Excel File =================================





# ================================= Create small variables for later use =================================
# Create The About Text For The App
about_text = """
This Conditional Admits Student Data Analysis Dashboard is an interactive web application designed to provide insights into student data through various visualizations and data exploration tools. Here's a brief overview of the features:
  
- **Sample Data Display**: Users can view a sample of the raw data in tabular format, allowing for easy browsing and filtering of individual records.

- **Pearson's Coefficient Correlation**: Pearson's Coefficient calculation among variables serves to measure the strength of association between numerical variables. The logic is the same as explained above in Cramer's V Correlation. There are two scatter plots, the first one takes an x and y, and the second takes just the y. In the first plot, you will see a scatter plot and OLS line to see the relation between both variables. In the second plot, you will pick the y variable and see the correlation coefficients it has against all other numerical variables in the dataset.

- **Cramer's V Correlation**: Cramer's V calculation among variables serves to measure the strength of association between categorical variables in a contingency table. A value closer to 1 indicates a strong association, implying that the variables are highly dependent on each other and changes in one variable are likely to correspond with changes in the other variable. Conversely, a value closer to 0 suggests a weaker association, indicating that changes in one variable may not significantly affect the other variable.

- **Geographical Visualization & User Input**: This tab allows users to visualize data geographically on a map of the East Coast of the United States. It shows how many students from each county went to what high school on the East Coast.

The dashboard is built using Dash, a Python framework for building analytical web applications, and incorporates Plotly for interactive data visualization.
"""

# Custom color scale: Red (low), Yellow (mid), Light Green (high)
color_scale = [
    [0, 'red'], 
    [0.5, 'yellow'],
    [1, 'lightgreen'] 
]

# Design the tabs
tab_style = {
    # Make it somewhat transparent
    'backgroundColor': 'rgba(255, 255, 255, 0.5)', 
    # Format the border
    'border': '1px solid #ddd',
    'color': 'black' 
}

# Design the tab labels
label_style = {
    'color': 'black', 
    'fontWeight': 'bold'
}
# ================================= Create The About Text For The App =================================





# ================================= Functions To Aid Later Graph Code =================================
# Function to Calulcate Cramers V values for categorical variables
def calculate_cramers_v(x, y):
    # Create a contingency table
    contingency_table = pd.crosstab(x, y)
    
    # Calculate the chi-squared test statistic, p-value, degrees of freedom, and expected frequencies
    chi2, p, dof, expected = stats.chi2_contingency(contingency_table, correction=False)
    
    # Total number of observations
    N = np.sum(contingency_table.values)
    
    # Calculate the minimum dimension minus one (for Cramer's V formula)
    min_dim = min(contingency_table.shape) - 1
    
    # Actual Cramer's V calculation
    result = np.sqrt((chi2 / N) / min_dim)
    
    return result

# Function to calculate Cramer's V values for all variables when y is picked
def cramer_v_for_all_vars(df, y_var):
    # Initialize results df, make y variable first
    results = [{'Variable': y_var, 'Cramers_V': 1.0}]
    
    # Iterate over each column in the DataFrame
    for col in df.columns:
        # Skip the 'ID' column since it shows inaccurate result
        if col != 'ID':
            # Get the values of the current column and the target variable
            x = df[col]
            y = df[y_var]
            
            # Calculate the Cramer's V value for the current column and add it to the results
            cramers_v_value = calculate_cramers_v(x, y)
            results.append({'Variable': col, 'Cramers_V': cramers_v_value})
    
    # Create a DataFrame from results
    return pd.DataFrame(results)
# ================================= Functions To Aid Later Graph Code =================================





# ================================= Initialize Dash App =================================
# Bootstrap used to allow more display options
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP])
# ================================= Initialize Dash App =================================





# ================================= Dashboard Layout =================================
# Set up the layout of the dashboard using Bootstrap containers and tabs
app.layout = dbc.Container([
    # Image at the top of dashboard
    html.Img(src='/assets/official-stockton-logo.png', 
             style={'width': '55%', 'height': '100px', 'position': 'relative',  'display': 'block', 'margin': 'auto'}),
    # Main title of dashboard
    html.Div([
        html.Div([
            html.Div([
                    html.H1('Conditional Admit Students', style={'textAlign': 'center', 'color': 'black'}),
                    html.H2('Data Analysis Dashboard', style={'textAlign': 'center', 'color': 'black'}),
                ], style={'backgroundColor': 'rgba(255, 255, 255, 0.5)', 'padding': '10px', 'position': 'relative', 'width': '100%'}),
            ], style={'display': 'flex', 'justifyContent': 'space-between', 'alignItems': 'center'}),
    ]),
        # Add background image
    html.Div(
        style={'backgroundImage': 'url("/assets/StocktonProfessionalLogo.png")',
            'backgroundSize': 'cover',
            'backgroundRepeat': 'no-repeat',
            'position': 'fixed',
            # Configure the size
            'width': '100%', 
            'height': '100vh',
            # Center the image
            'top': 0,
            'left': 0,
            'display': 'flex',
            'justifyContent': 'center', 
            'alignItems': 'center',
            # Make it transparent
            'opacity': 0.2,
            # Make it go behind the tabs
            'zIndex': -1}
    ),

    # Tabs for different sections of the dashboard
    dbc.Tabs([
        # Tab for About section
        dbc.Tab(label="About", children=[
            html.Div([

                # Information about the dashboard
                html.H3("About this App"),

                # Style the contents
                dcc.Markdown(about_text, style={'padding': '20px'})
            ])
        ], 
        style=tab_style,
        label_style= label_style),

        # Tab for Sample Data
        dbc.Tab(label="Sample Data", children=[

            # Row for organizing components horizontally
            dbc.Row([

                # Column for displaying the DataTable
                dbc.Col(html.Div([

                    # Display the sample data in a DataTable
                    dash_table.DataTable(

                        # Convert df to dict
                        df.to_dict('records'), 

                        # Define DataTable columns
                        [{"name": i, "id": i} for i in df.columns],

                        # Enable filtering
                        filter_action='native', 

                        # Enable sorting
                        sort_action='native',
                        page_size=25 
                    )
                    # Set column width (12 is full)
                ]), width=12),
            ]),
        ], 
        style=tab_style,
        label_style= label_style),

        # Tab for Pearson's Coefficient Correlation
        dbc.Tab(label='Pearson\'s Coefficient Correlation', children=[

            # Dropdowns and graphs for scatterplot for given x and y variable (numerical)
            html.Div([

                # Dropdown for x
                dcc.Dropdown(
                    id='x-variable-dropdown-pearson',
                    options=[{'label': col, 'value': col} for col in numerical_columns],
                    placeholder='Select X Variable'
                ),

                # Dropdown for y
                dcc.Dropdown(
                    id='y-variable-dropdown-pearson',
                    options=[{'label': col, 'value': col} for col in numerical_columns],
                    placeholder='Select Y Variable'
                ),

                # Graph for displaying the XY scatter plot for pearson
                dcc.Graph(id='xy-scatter-plot-pearson')
            ]),

            # Dropdowns and graphs for given y variable against all other variables (numerical)
            html.Div([

                # Dropdown for target variable (y)
                dcc.Dropdown(
                    id='y-variable-dropdown-pearson-all',
                    options=[{'label': col, 'value': col} for col in numerical_columns],
                    placeholder='Select Y Variable'
                ),

                # Graph for displaying the correlation scatter plot for pearson
                dcc.Graph(id='correlation-scatter-plot-pearson-all')
            ]),
        ],
        style=tab_style,
        label_style= label_style),

        # Tab for Cramer's V Calculation
        dbc.Tab(label='Cramers V Calculation', children=[

            # Dropdown for target variable (y)
            dcc.Dropdown(
                id='y-variable-dropdown-cramers-v',

                # Do not use ID column because it shows incorrect value as each value is unique
                options=[{'label': i, 'value': i} for i in df.columns if df[i].dtype == 'object' and i != 'ID'],
                placeholder='Select Y Variable'
            ),

            # Graph for displaying the correlation scatter plot for Cramers V
            dcc.Graph(id='correlation-scatter-plot-cramers-v')
        ],
        style=tab_style,
        label_style= label_style),

        # Tab for Geographical Visualization
        dbc.Tab(label="Geographical Visualization", children=[

            # Row for organizing components horizontally
            dbc.Row([

                # Column for displaying map
                dbc.Col([

                    # Dropdown for list of variables 
                        # Tried this but it doesnt do anything work but taking it out also messes with it so I just left it
                    dcc.Dropdown(
                        id='variable-selector-geo', 
                        options=[{'label': col, 'value': col} for col in df.columns],
                        placeholder="List of variables"
                    ),

                    # Graph the east coast map
                    dcc.Graph(id='eastcoast-plot-geo')
                ], width=12),
            ]),
        ], 
        style=tab_style,
        label_style= label_style),

        # Styling the tabs
    ], style={'padding': '20px', 'backgroundColor': 'transparent', 'border': 'none'}) 
])
# ================================= Dashboard Layout =================================





# ================================= Call Backs And Functions =================================
# Pearson's Correlation Coefficient
# Callback to update x and y scatter plot
@app.callback(
    Output('xy-scatter-plot-pearson', 'figure'),
    [Input('x-variable-dropdown-pearson', 'value'), Input('y-variable-dropdown-pearson', 'value')]
)

def update_xy_scatter(x_var, y_var):
    if x_var and y_var:
        # Calculate Pearson correlation coefficient
        corr, _ = pearsonr(df[x_var], df[y_var])  

        # Create scatter plot with user input variables
        fig = px.scatter(df, x=x_var, y=y_var, title=f'{x_var} vs {y_var} (Correlation: {corr:.2f})',
                         # Add OLS line
                         trendline="ols")

        # Update scatter points to black and OLS line to red
        fig.update_traces(marker=dict(color='black'), selector=dict(mode='markers'))
        fig.update_traces(line=dict(color='red'), selector=dict(type='scatter', mode='lines'),
                          # Configure the hover option to not show anything only show coordinates
                            # Extra removes additional information since there was excess information before
                          hovertemplate='(%{x}, %{y:.2f})<extra></extra>')
        return fig
    
    return px.scatter()

# Callback to update Pearson's correlation coefficient scatter plot for all variables
@app.callback(
    Output('correlation-scatter-plot-pearson-all', 'figure'),
    [Input('y-variable-dropdown-pearson-all', 'value')]
)

# Function for Pearson's correlation coefficient scatter plot for all variables
def update_correlation_plot(y_var):
    if y_var:

        # Initialize results list 
        results = []

        # Iterate over numerical columns
        for col in numerical_columns:

            # Calculate Pearson correlation coefficient
            corr, _ = pearsonr(df[y_var], df[col])

            # Append correlation result to results list
            results.append({'Variable': col, 'Correlation': corr})

        # Create df from correlation results
        results_df = pd.DataFrame(results)

        # Create scatter plot with user input on y
        fig = px.scatter(results_df, x='Variable', y='Correlation', color='Correlation',
                         title=f'Correlation with {y_var}',
                         
                        # Format hover text to display Cramer's V with two decimal points
                        hover_data={'Variable': True, 'Correlation': ':.2f'},
                        color_continuous_scale=color_scale)
        
        return fig 
    
    # Return empty scatter plot if no Y variable is selected
    return px.scatter()  

# Cramer's V Correlation
# Callback to update Cramer's V scatter plot for all vairblaes
@app.callback(
    Output('correlation-scatter-plot-cramers-v', 'figure'),
    [Input('y-variable-dropdown-cramers-v', 'value')]
)

# Function for Cramer's V scatter plot for all vairblaes
def update_cramers_v_plot(y_variable):
    if y_variable:
        # Calculate Cramer's V for all object columns with function defined earlier
        results_df = cramer_v_for_all_vars(object_df, y_variable)

        # Replace NaN values in 'Cramers_V' with a default size
        min_valid_value = results_df['Cramers_V'].min(skipna=True)
        results_df['Cramers_V'].fillna(min_valid_value, inplace=True)

        # Create scatter plot with user input on y
        fig = px.scatter(results_df, x='Variable', y='Cramers_V', color='Cramers_V',
                        title=f"Cramer's V Across Categorical Variables with {y_variable}",

                        # Format hover text to display Cramer's V with two decimal points
                        hover_data={'Variable': True, 'Cramers_V': ':.2f'},
                        color_continuous_scale=color_scale,
        
                        # Use 'Cramers_V' for marker size
                        size='Cramers_V',
                        size_max=15)
        fig.update_layout(height=800)

        return fig 
    
    # Return empty scatter plot if no Y variable is selected
    return px.scatter()

# Callback to update the geographical heatmap plot for the East Coast
@app.callback(
    Output('eastcoast-plot-geo', 'figure'),
    [Input('variable-selector-geo', 'value')]
)

def update_geo_plot(x_var):

    # Filter to include only the East Coast portion of United States
    east_coast_states = ['ME', 'NH', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA', 'DE', 'MD', 'VA', 'NC', 'SC', 'GA', 'FL']
    filtered_df = df[df['HS_STATE'].isin(east_coast_states)]

    # Convert index to a column for hover data
    filtered_df['Count'] = filtered_df.index

    # Create a heatmap of the count of records using the latitude and longitude coordinates
    fig = px.density_mapbox(filtered_df, lat='HS_LAT', lon='HS_LONG', z='Count', radius=10,
                            mapbox_style="carto-positron",
                            title='Geography of Student High Schools',
                            hover_data=['HS_STATE', 'HS_COUNTY', 'Count'])
                                # Tried to change the color but it didnt work
                            # color_continuous_scale=["green", "red"]))

    fig.update_layout(height=800)
    

    return fig 
# ================================= Call Backs And Functions =================================





# ================================= Run the App =================================
if __name__ == '__main__':
    app.run_server(debug=True)
# ================================= Run the App =================================