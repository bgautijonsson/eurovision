points <- vroom::vroom("https://github.com/Spijkervet/eurovision-dataset/releases/download/2020.0/votes.csv") |>
    dplyr::select(year, round, from_country, to_country, total_points, tele_points, jury_points) |>
    dplyr::inner_join(
        countries |>
            dplyr::rename(from = to_country),
        by = dplyr::join_by(year, from_country == to_country_id)
    ) |>
    dplyr::inner_join(
        countries |>
            dplyr::rename(to = to_country),
        by = dplyr::join_by(year, to_country == to_country_id)
    ) |>
    group_by(
        year, round, from, to
    ) |>
    summarise_at(
        vars(total_points, tele_points, jury_points),
        sum
    ) |>
    ungroup() |>
    bind_rows(
        points_2021,
        points_2022
    )



usethis::use_data(points, overwrite = TRUE)
