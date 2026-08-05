# ------------------------------------------------------------
# Producción científica por país (2024): per cápita e índice H
# Autor: Juan David Leongómez Peña
# Proyecto: MetaCiencia
#
# Descripción:
#   - Descarga SJR (países) directamente desde la web (parseo HTML).
#   - Carga población 2023 (OWID), normaliza nombres y mapea ISO3.
#   - Une con geometrías (rnaturalearth) usando ISO3 "limpio".
#   - Genera dos mapas:
#       (1) Publicaciones por millón (log, gris→magenta).
#       (2) Índice H (log, gris→magenta).
#   - Ensambla ambos en una figura con título y fuente.
#
# Requisitos:
#   tidyverse, readr, rvest, janitor, scales, countrycode, sf, rnaturalearth,
#   stringi, ggpubr
#
# Salida:
#   Objeto 'map.fin'. Guarda con ggsave() si quieres.
# ------------------------------------------------------------

# Paquetes ----
library(readxl)
library(tidyverse)
library(readr)
library(rvest)
library(janitor)
library(scales)
library(countrycode)
library(sf)
library(rnaturalearth)
library(stringi)
library(ggpubr)   # ggarrange(), annotate_figure(), text_grob()


# --- SJR + ISO3 ------------------------------------------------------------
# Descarga SJR (países) para 2025
dat.sjr <- read_excel("scimagojr country rank 1996-2025.xlsx") |>
  clean_names()

# Normaliza nombres (quita acentos/espacios) y mapea a ISO3.
# Se añaden 'custom_match' para casos frecuentes/conflictivos.
dat.sjr_iso <- dat.sjr |>
  mutate(
    Country_norm = trimws(stri_trans_general(country, "Latin-ASCII")),
    CODE = countrycode(
      Country_norm, "country.name", "iso3c",
      custom_match = c(
        "Russian Federation" = "RUS", "Czech Republic" = "CZE",
        "Congo, Dem. Rep." = "COD", "Congo, Rep." = "COG",
        "Viet Nam" = "VNM", "Ivory Coast" = "CIV",
        "Tanzania" = "TZA", "Korea, Rep." = "KOR",
        "Korea, South" = "KOR", "Korea, North" = "PRK",
        "Hong Kong" = "HKG", "Macao" = "MAC",
        "Haiti" = "HTI",
        "Saint Martin (French)" = "MAF",
        "Saint Martin (Dutch)"  = "SXM",
        # variantes a veces presentes
        "France" = "FRA", "Norway" = "NOR",
        "United Kingdom" = "GBR", "United States" = "USA"
      ),
      warn = TRUE
    )
  )

# --- Población 2023 (millones) --------------------------------------------
# Fuente: Our World in Data (UN WPP 2024), año 2023.
pop_owid <- read_csv(
  "https://ourworldindata.org/grapher/population.csv",
  show_col_types = FALSE
) |>
  filter(Year == 2023, nchar(Code) == 3) |>
  transmute(CODE = Code, pop_2023 = `Population` / 1e6)

# Publicaciones por millón de habitantes
dat.ppm <- dat.sjr_iso |>
  left_join(pop_owid, by = "CODE") |>
  mutate(`Publications per million` = documents / pop_2023)

# --- Geometrías con ISO3 "limpio" -----------------------------------------
# En rnaturalearth algunos registros traen iso_a3 = "-99".
# Construimos 'iso3_clean' priorizando iso_a3, luego iso_a3_eh, y si no adm0_a3.
world_sf <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") |>
  st_transform(4326) |>
  mutate(
    iso3_clean = dplyr::case_when(
      iso_a3    != "-99" ~ iso_a3,
      iso_a3_eh != "-99" ~ iso_a3_eh,
      TRUE               ~ adm0_a3
    )
  ) |>
  select(name_long, iso3_clean, geometry)

# Une SJR+población al mapa
map_sf <- world_sf |>
  left_join(
    dat.ppm |> select(CODE, `Publications per million`, `h_index`, documents),
    by = c("iso3_clean" = "CODE")
  ) |>
  # 0 → NA (usaremos trans = "log10")
  mutate(ppm = na_if(`Publications per million`, 0))

# --- Escalas logarítmicas y puntos de control -----------------------------
# Construimos límites, cortes y "stops" (values) *por variable* para no mezclar.

# 1) Publicaciones por millón
lims_ppm  <- c(1, max(map_sf$ppm, na.rm = TRUE))
brks_all  <- c(1, 10, 100, 1000, 10000)
brks_ppm  <- brks_all[brks_all >= lims_ppm[1] & brks_all <= lims_ppm[2]]
# Mantén gris hasta ~100, empieza a teñir a ~1500, magenta fuerte > 2000
vals_num_ppm <- c(lims_ppm[1], 200, 2000, 20000, lims_ppm[2])
vals_ppm <- rescale(log10(vals_num_ppm), to = c(0, 1), from = log10(lims_ppm))

# 2) Índice H (si hay ceros de H, se hacen NA para la escala log)
map_sf <- map_sf |>
  mutate(h_log = ifelse(`h_index` <= 0 | is.na(`h_index`), NA_real_, `h_index`))
lims_h   <- c(1, max(map_sf$h_log, na.rm = TRUE))
brks_h   <- brks_all[brks_all >= lims_h[1] & brks_all <= lims_h[2]]
vals_num_h <- c(lims_h[1], 10, 100, 1000, lims_h[2])
vals_h <- rescale(log10(vals_num_h), to = c(0, 1), from = log10(lims_h))

# Paleta (gris → magenta MetaCiencia)
pal_mc <- c("#3b3b3b", "#3b3b3b", "#3b3b3b", "#3f313c", "#d400aa")

# --- Mapas individuales ----------------------------------------------------
# (A) Índice H
p1 <- ggplot(map_sf) +
  geom_sf(aes(fill = h_log), color = "grey30", linewidth = 0.1) +
  scale_fill_gradientn(
    colours = pal_mc, values = vals_h,
    trans = "log10", limits = lims_h,
    breaks = brks_h, labels = comma,
    na.value = "grey80", name = "H Index",
    oob = squish
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom",
    legend.text = element_text(angle = 45, hjust = 1)
  )

# (B) Publicaciones por millón
p2 <- ggplot(map_sf) +
  geom_sf(aes(fill = ppm), color = "grey30", linewidth = 0.1) +
  scale_fill_gradientn(
    colours = pal_mc, values = vals_ppm,
    trans = "log10", limits = lims_ppm,
    breaks = brks_ppm, labels = comma,
    na.value = "grey80", name = "Publications per Million\nInhabitants",
    oob = squish
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom",
    legend.text = element_text(angle = 45, hjust = 1)
  )

# --- Figura final (dos paneles + título y fuente) --------------------------
map.fin <- annotate_figure(
  ggarrange(p2, p1, ncol = 2),
  top    = text_grob("Scientific production - 2025", face = "bold", size = 14),
  bottom = text_grob("Source: Scimago Journal & Country Rank", hjust = 1.1, x = 1, size = 10)
)

# Visualiza en el visor
map.fin

# (Opcional) Guardar en alta resolución:
ggsave("produccion_cientifica_2025.png", map.fin, width = 12, height = 5, dpi = 300)
