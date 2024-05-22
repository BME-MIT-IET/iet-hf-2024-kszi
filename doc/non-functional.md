
# Nem-funkcionális Teszt Eredmények

## Tartalom
1. Fáradási Teszt Eredmények
   - Főoldal
   - Create oldal
2. Stressz Teszt Eredmények
   - Főoldal
   - Create oldal
3. Teljesítmény Teszt Eredmények
   - Főoldal
   - Create oldal

## Bevezetés
Ez a dokumentáció a nem-funkcionális tesztek eredményeit tartalmazza, amelyeket JMeter-rel végeztem. A tesztek célja a rendszer stabilitásának, teljesítményének és terhelhetőségének vizsgálata volt a következő szempontok szerint:
- Fáradási teszt: a rendszer tartós terhelés alatt nyújtott teljesítményének vizsgálata.
- Stressz teszt: a rendszer viselkedésének elemzése extrém terhelés alatt.
- Teljesítmény teszt: a rendszer válaszidejének és teljesítményének mérése különböző terhelési szinteken.

## 1. Fáradási Teszt Eredmények

### Főoldal
| Metrika                  | Érték   |
|--------------------------|---------|
| Minta száma              | 536727  |
| Átlagos válaszidő (ms)   | 102     |
| Minimális válaszidő (ms) | 0       |
| Maximális válaszidő (ms) | 433     |
| Szórás (ms)              | 62.79   |
| Hibaarány (%)            | 0.000   |
| Áteresztőképesség        | 894.233 |
| Fogadott KB/sec          | 754.91  |
| Küldött KB/sec           | 58.41   |
| Átlagos bájt             | 820.72  |

#### Magyarázat
A fáradási teszt során a rendszer hosszú időn keresztül tartós terhelés alatt volt. Az eredmények alapján a főoldal átlagos válaszideje 102 ms volt, ami jónak tekinthető. A hibaarány 0%, ami azt jelenti, hogy a rendszer stabilan működött a teszt során. Az áteresztőképesség és a hálózati forgalom értékei szintén megfelelőek voltak.

### Create oldal
| Metrika                  | Érték   |
|--------------------------|---------|
| Minta száma              | 445562  |
| Átlagos válaszidő (ms)   | 123     |
| Minimális válaszidő (ms) | 2       |
| Maximális válaszidő (ms) | 518     |
| Szórás (ms)              | 58.59   |
| Hibaarány (%)            | 0.000   |
| Áteresztőképesség        | 742.322 |
| Fogadott KB/sec          | 732.81  |
| Küldött KB/sec           | 61.22   |
| Átlagos bájt             | 980.33  |

#### Magyarázat
A Create oldal fáradási tesztje során az átlagos válaszidő 123 ms volt, ami szintén elfogadható érték. A minimális válaszidő 2 ms, ami nagyon jó. A hibaarány itt is 0%, ami a rendszer stabilitását mutatja. Az áteresztőképesség és a hálózati forgalom értékei szintén megfelelőek.

## 2. Stressz Teszt Eredmények

### Főoldal
| Metrika                  | Érték   |
|--------------------------|---------|
| Minta száma              | 232963  |
| Átlagos válaszidő (ms)   | 818     |
| Minimális válaszidő (ms) | 0       |
| Maximális válaszidő (ms) | 6045    |
| Szórás (ms)              | 529.42  |
| Hibaarány (%)            | 0.000   |
| Áteresztőképesség        | 966.591 |
| Fogadott KB/sec          | 964.12  |
| Küldött KB/sec           | 75.31   |
| Átlagos bájt             | 995.43  |

#### Magyarázat
A stressz teszt során a rendszer extrém terhelés alatt volt. A főoldal átlagos válaszideje 818 ms volt, ami azt mutatja, hogy a rendszernek voltak nehézségei a nagy terhelés kezelése során. Azonban a hibaarány itt is 0%, ami pozitív. Az áteresztőképesség és a hálózati forgalom értékei is megfelelőek voltak.

### Create oldal
| Metrika                  | Érték   |
|--------------------------|---------|
| Minta száma              | 145832  |
| Átlagos válaszidő (ms)   | 1317    |
| Minimális válaszidő (ms) | 1       |
| Maximális válaszidő (ms) | 44059   |
| Szórás (ms)              | 2775.46 |
| Hibaarány (%)            | 13.241  |
| Áteresztőképesség        | 584.832 |
| Fogadott KB/sec          | 765.34  |
| Küldött KB/sec           | 61.22   |
| Átlagos bájt             | 860.54  |

#### Magyarázat
A Create oldal stressz tesztje során az átlagos válaszidő 1317 ms volt, ami jelentős terhelésre utal. A maximális válaszidő 44059 ms, ami extrém magas. A hibaarány 13.241%, ami azt jelzi, hogy a rendszer nem tudta megfelelően kezelni az extrém terhelést. Az áteresztőképesség és a hálózati forgalom értékei is visszaestek.

## 3. Teljesítmény Teszt Eredmények

### Főoldal
| Metrika                  | Érték   |
|--------------------------|---------|
| Átlagos válaszidő (ms)   | 739     |
| Maximális válaszidő (ms) | 6719    |
| Minimális válaszidő (ms) | 4       |
| Hibaarány (%)            | 0.000   |
| Áteresztőképesség        | 1156.015|
| Fogadott KB/sec          | 754.91  |
| Küldött KB/sec           | 58.41   |

#### Magyarázat
A teljesítmény teszt során a főoldal átlagos válaszideje 739 ms volt. A maximális válaszidő 6719 ms, ami azt mutatja, hogy időnként jelentős késések voltak. Azonban a hibaarány 0%, ami jó jel. Az áteresztőképesség és a hálózati forgalom értékei is megfelelőek voltak.

### Create oldal
| Metrika                  | Érték   |
|--------------------------|---------|
| Átlagos válaszidő (ms)   | 611     |
| Maximális válaszidő (ms) | 2227    |
| Minimális válaszidő (ms) | 4       |
| Hibaarány (%)            | 0.000   |
| Áteresztőképesség        | 1383.700|
| Fogadott KB/sec          | 764.23  |
| Küldött KB/sec           | 61.22   |

#### Magyarázat
A Create oldal teljesítmény tesztje során az átlagos válaszidő 611 ms volt, ami jó eredmény. A maximális válaszidő 2227 ms, ami szintén elfogadható. A hibaarány 0%, ami azt jelzi, hogy a rendszer stabil volt. Az áteresztőképesség és a hálózati forgalom értékei is megfelelőek voltak.
