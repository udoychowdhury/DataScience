import dash
from dash import dcc, html
from dash.dependencies import Input, Output
from dash import dash_table
from dash.dash_table.Format import Group
import pandas as pd
import plotly.express as px
import dash_bootstrap_components as dbc
from scipy.stats import f_oneway

file_path = '/Users/udoychowdhury/Documents/DataScience/Assitantship/Conditionally Admitted Students Updated.xlsx'

# Read the Excel file
df = pd.read_excel(file_path)

# Initialize Dash app with Bootstrap
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP])

# Dashboard layout
app.layout = dbc.Container([
    html.H1('Student Data Analysis Dashboard', style={'textAlign': 'center', 'backgroundColor': 'darkgray', 'color': 'white', 'padding': '10px'}),
    dbc.Tabs([
        dbc.Tab(label="Data Visualization", children=[
            html.Div([
                dcc.Dropdown(
                    id='x-variable-selector',
                    options=[{'label': i, 'value': i} for i in df.columns],
                    value='ETHNICITY',
                    style={'width': '48%', 'display': 'inline-block'}
                ),
                dcc.Dropdown(
                    id='y-variable-selector',
                    options=[{'label': i, 'value': i} for i in df.columns if df[i].dtype == 'O'],
                    value='AGE',
                    style={'width': '48%', 'display': 'inline-block', 'marginLeft': '4%'}
                ),
                dcc.Graph(id='variable-relationship-graph')
            ]),
        ]),
        dbc.Tab(label="Sample Data", children=[
            dbc.Row([
                dbc.Col(html.Div([
                    dash_table.DataTable(
                        df.to_dict('records'), 
                        [{"name": i, "id": i} for i in df.columns],
                        filter_action='native',
                        sort_action='native',
                        page_size=10
                    )
                ]), width=12),
            ]),
        ]),
        dbc.Tab(label="Geographical Visualization", children=[
            dbc.Row([
                dbc.Col([
                    dcc.Dropdown(
                        id='x-variable-selector-geo',  # Unique ID for the dropdown component
                        options=[{'label': col, 'value': col} for col in df.columns],
                        placeholder="List of variables"
                    ),
                    dcc.Graph(id='geo-plot')
                ], width=12),
            ]),
        ]),
        dbc.Tab(label="About", children=[
            html.Div([
                html.H3("About this App"),
                dcc.Markdown("""
The Student Data Analysis Dashboard is an interactive web application designed to provide insights into student data through various visualizations and data exploration tools. Here's a brief overview of the features:

- **Data Visualization**: The app offers a variety of visualizations, including clustered bar charts, scatter plots, and geographical heatmaps. Users can select different variables to explore relationships and patterns within the data.

- **Sample Data Display**: Users can view a sample of the raw data in tabular format, allowing for easy browsing and filtering of individual records.

- **Geographical Visualization & User Input**: This tab allows users to visualize data geographically on a map of the East Coast of the United States. Users can select different variables to display as a heatmap, providing insights into spatial patterns within the dataset.

The dashboard is built using Dash, a Python framework for building analytical web applications, and incorporates Plotly for interactive data visualization. With its user-friendly interface and powerful analytical capabilities, the Student Data Analysis Dashboard is a valuable tool for exploring and analyzing student data.
""", style={'padding': '20px'})
            ])
        ]),
    ], style={'padding': '20px', 'backgroundColor': 'lightblue'})
])

# Callbacks for dynamic content
@app.callback(
    Output('variable-relationship-graph', 'figure'),
    [Input('x-variable-selector', 'value'), Input('y-variable-selector', 'value')]
)

def update_graph(x_var, y_var):
    grouped_data = df.groupby([x_var, y_var]).size().reset_index(name='Counts')
    fig = px.bar(grouped_data, x=x_var, y='Counts', color=y_var, barmode='group',
                 title=f'Clustered Bar Chart: {y_var} within {x_var}')
    return fig


# @app.callback(
#     Output('key-metrics', 'children'),
#     Input('input-1', 'value')
# )
def update_metrics(input1):
    total_students = len(df)
    return html.P(f'Total Students: {total_students}')

@app.callback(
    Output('geo-plot', 'figure'),
    [Input('x-variable-selector-geo', 'value')]  # Update the input ID
)
def update_geo_plot(x_var):
    # Filter the DataFrame to include only the East Coast portion of the United States
    east_coast_states = ['ME', 'NH', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA', 'DE', 'MD', 'VA', 'NC', 'SC', 'GA', 'FL']
    filtered_df = df[df['HS_STATE'].isin(east_coast_states)]

    # Create a heatmap of the count of records using the latitude and longitude coordinates
    fig = px.density_mapbox(filtered_df, lat='HS_LAT', lon='HS_LONG', z=filtered_df.index, radius=10,
                            mapbox_style="carto-positron",
                            title='Geography of Student High Schools')
    fig.update_layout(height=800)  # Adjust the height of the heatmap here
    return fig

if __name__ == '__main__':
    app.run_server(debug=True)