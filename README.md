# rstudio-onprem
RStudio project designed to run on-premises

Hvis det trengs endringer som f.eks. nye R-pakker eller installasjon av ulike OS-komponenter, gjøres følgende:

Lag branch.

Gjør kodeendringer og commit lokalt

Kjør ‘git push’ til GitHub

Lag Pull Request.

Merge Pull Request til main, da vil endringene komme til staging miljøet.
Bruk gjerne “Squash and merge” i PR'en, da blir alle commits merget til en enkelt commit.

Etter endringene er kommet i staging miljøet lag en "release" i GitHub.

Gå til Releases · statisticsnorway/rstudio-onprem

Trykk “Draft a new release”

Under “Choose a tag”, lag et nytt tagnavn (f.eks. 0.1.7)

Gi en beskrivende tittel og en description

Trykk “Publish release”
Da flyttes endringene i staging videre til Prod-server.

For oppgradering av OS-versjon på image følges samme prosedyre som over.
Sett inn ønsket versjon her: https://github.com/statisticsnorway/rstudio-onprem/blob/518e316d96689caaa441aaaa2c74ee058265d836/docker/rstudio/Dockerfile#L1C19-L1C19
