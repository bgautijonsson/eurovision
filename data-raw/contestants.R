contestants <- vroom::vroom(
    "https://github.com/Spijkervet/eurovision-dataset/releases/download/2020.0/contestants.csv"
)


usethis::use_data(contestants, overwrite = TRUE)


countries <- contestants |>
    dplyr::distinct(
        year,
        to_country_id,
        to_country
    )

usethis::use_data(countries, overwrite = TRUE)
