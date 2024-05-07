# Feladatkiírás:
Deployment segítése (Docker, Vagrant, felhő szolgáltatásba telepítés, ha értelmes az adott alkalmazás esetén...)

# Feladat:
Az alkalmazás két komponensből áll: az InForm.Server a backend szerverkét szolgáló ASP.NET projekt, ami a felhasznált REST API-t biztosítja; és az InForm.Web, ami a webes frontend, Blazor WASM projektként megvalósítva. Ezek külön telepíthetőek, egyszerűen egy konfiguráció beállítása kapcsolja az egyiket a másikhoz.
A feladat ezeknek a komponenseknek a docker konténerekbe csomagolása.

## hibajegy:
https://github.com/BME-MIT-IET/iet-hf-2024-kszi/issues/4[#4]

# Megvalósítás:
A feladatot 2 részre szettem szét. Az első rész a `server.dockerfile`.


## server.dockerfile:

### használata:
Ebből a fileból a `docker build -f server.Dockerfile -t server-img .`  parancs kiadásával lehet egy server.img nevű docker image-t generálni.
Az imagebből a `docker run -p 5217:5217 --name server server-img` parancsal lehet konténert készíteni illetve azt futtatni, amely az 5217-es porton fogha tudni fogadni a kéréseket.

### működése:
Először beimportálja a dotnet sdk-t, amivel a buildelést fogja végezni,
Ezután létrehoz és belép a kontéren belül az app mappába majd oda átmásolja a teljes projektet. Ezután a dotnet restore lefuttatásával a projekt függőségeit helyreállítja és szükség esetén letölti. Ezt követően a dotnet publishal lebuildeli és egyben közzéteszi a projektet majd ezt elhelyezi az out mappában
Végül az asp.netet beincludolva a megnyitja az 5217-es portot átmásolja az out mappa tartalmát a lebuildelt környezetből majd futtatja a szervert a dotnet Inform.Server.dll parancs kiadásával indításkor.

## client.dockerfile:

### használata:
Használata a szerveréhez nagyon hasonló, a  `docker build -f client.Dockerfile -t client-img .` paranccsal lehet image-t készíteni majd abból futó konténert a `docker run --name server client-img` paranccsal.

### működés:
A buildelés része egy az egyben megegyezik a `server.dockerfile` esetével. Azt követően egy nginx környezetet includolok be, megnyitom a 80as portot, majd a `/usr/share/nginx/html` mappába átmásolom a lebuildelt balzor projekt wwwroot mappáját. Ahhoz hogy a webserver megfelelően működjön be kell konfigurálni. Ehhez létrehoztam egy `nginx.conf` file-t ami a szerver konfigurációját tartalmazza. Ebben megadtam, hogy a 80as porton jelenítse meg a `/usr/share/nginx/html` tartalmát. Ezt átmásolom a konténerbe

## Eredmények
A docker rendkívül hasznos és jó koncepció, azonban rengeteg bonyolutságot visz az elkészítése egy hozzá nem értő számára a projektbe és rendkívül nehéz debuggolni. Ezen belül mind a build mind a run részénél adódhatnak olyna hibák, melyek kiszűrése nehézkes mivel nem elég visszajelzést. Ennek ellenére, hogy már vannak kész dockerfileok a deployolás nagyban leegyszerűsödik hosszútávon.