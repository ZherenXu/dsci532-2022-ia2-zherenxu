library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

df <- readr::read_csv(here::here('data', 'vgsales_2.csv'))

app$layout(
    dbcContainer(
        list(
            htmlH1('Dashr heroky deployment'),
            dccGraph(id='plot-area'),
            dccDropdown(
                id='col-select',
                options = colnames(df)[2:6] %>% purrr::map(function(col) list(label = col, value = col)),
                value='NA_Sales')
        )
    )
)

app$callback(
    output('plot-area', 'figure'),
    list(input('col-select', 'value')),
    function(xcol) {
        p <- ggplot(df, aes(x = Year, y = !!sym(xcol))) +
            geom_line(size=1)
        ggplotly(p)
    }
)

app$run_server(host = '0.0.0.0')
