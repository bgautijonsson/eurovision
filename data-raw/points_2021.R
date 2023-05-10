library(rvest)


# Total -------------------------------------------------------------------


d <- read_html("html_tables/2021_total.html")



cols <- d |>
    html_elements("td") |>
    html_attr("data-from")
cols <- cols[2:40]



tab <- d |>
    html_table(header = T)


total <- tab[[1]] |>
    set_names(
        "row", "flag", "to", "total", cols, "drop"
    ) |>
    select(-row, -flag, -drop) |>
    pivot_longer(c(-to, -total), names_to = "from", values_to = "points")


# Public ------------------------------------------------------------------



d <- read_html("html_tables/2021_public.html")



cols <- d |>
    html_elements("td") |>
    html_attr("data-from")

cols <- cols[2:40]



tab <- d |>
    html_table(header = T)


public <- tab[[1]] |>
    set_names(
        "row", "flag", "to", "total", cols, "drop"
    ) |>
    select(-row, -flag, -drop) |>
    pivot_longer(c(-to, -total), names_to = "from", values_to = "points")



# Jury --------------------------------------------------------------------

d <- read_html("html_tables/2021_jury.html")



cols <- d |>
    html_elements("td") |>
    html_attr("data-from")
cols <- cols[2:40]



tab <- d |>
    html_table(header = T)


jury <- tab[[1]] |>
    set_names(
        "row", "flag", "to", "total", cols, "drop"
    ) |>
    select(-row, -flag, -drop) |>
    pivot_longer(c(-to, -total), names_to = "from", values_to = "points")



points_2021 <- total |>
    mutate(type = "total_points") |>
    bind_rows(
        public |>
            mutate(type = "tele_points")
    ) |>
    bind_rows(
        jury |>
            mutate(type = "jury_points")
    ) |>
    select(-total) |>
    pivot_wider(names_from = type, values_from = points) |>
    mutate(
        from = countrycode(from, origin = "genc2c", destination = "country.name"),
        year = 2021,
        round = "final"
    )

use_data(points_2021, overwrite = TRUE)
