# GuardaRio · App do Cidadão (Flutter)

> Global Solution 2026/2 · CitizenTech · Mobile Application Development

**Alerta comunitário de enchentes: o rio avisa antes de subir.**

## Integrantes

| Nome | RM |
|---|---|
| Henrique Spoltore Moreno Pavão dos Santos | RM568130 |
| Raphael Oliveira Sinelli Mendonça | RM568346 |
| Arthur Lins Belarmino | RM566845 |

## A solução

O GuardaRio é uma CitizenTech de alerta antecipado de enchentes. Estações IoT de baixo custo medem o nível do rio e a chuva, tocam uma sirene local mesmo sem internet e enviam as leituras para a nuvem, que gera alertas automáticos para a área.

Este app é a interface do cidadão: mostra o nível do rio e o risco em cores, os alertas com o que fazer, os abrigos com vaga (com filtros de pets e acessibilidade), recebe relatos dos moradores com prioridade calculada e ajuda a montar o kit de emergência.

## Cidadão beneficiado

Moradores de áreas ribeirinhas e de baixada, em especial quem tem menos tempo e meios para sair na cheia: idosos, pessoas com deficiência, famílias sem carro.

**Persona:** Dona Cida, 67 anos, mora no Jardim Pantanal (zona leste de São Paulo, às margens do Tietê) com o neto e uma cadela. Na última cheia só saiu quando a água estava no joelho, porque não sabia se o abrigo aceitava a cadela. No app ela vê o risco em cores, recebe o alerta com o que fazer e encontra um abrigo com vaga que aceita pets.

## ODS relacionados

| ODS | Como o app contribui |
|---|---|
| **11** Cidades e comunidades sustentáveis (meta 11.5) | Alerta hiperlocal e antecipado, abrigos com vaga visível e relatos priorizados. |
| **13** Ação contra a mudança do clima (metas 13.1 e 13.3) | Alerta precoce e kit de emergência educativo. |
| **3** Saúde e bem-estar (meta 3.d) | Evacuação antes do pico e menos exposição à água contaminada. |
| **10** Redução das desigualdades (meta 10.2) | Uso sem login para informação de segurança e filtro de abrigo acessível (PcD). |

## Telas (11)

| # | Tela | O que demonstra |
|---|---|---|
| 1 | Boas-vindas | `Image`, navegação para Login ou para o app sem conta |
| 2 | Login | `Form` + `GlobalKey<FormState>`, `TextFormField` com `validator`, `SnackBar` de erro |
| 3 | Início | Card do nível do rio com régua colorida, `GridView` de atalhos, **estado**: "Simular subida" muda nível, cor e gera alerta automático |
| 4 | Alertas | `ListView` de cards coloridos por nível |
| 5 | Detalhe do alerta | **Passagem de parâmetro** (objeto `Alerta` pelo construtor) |
| 6 | Abrigos | **Estado**: `FilterChip` (pets, PcD, com vagas, favoritos) e favoritar |
| 7 | Detalhe do abrigo | **Passagem de parâmetro** (objeto `Abrigo`), ocupação com `LinearProgressIndicator` |
| 8 | Novo relato | **Formulário**: `DropdownButtonFormField`, validações, `AlertDialog` de confirmação |
| 9 | Meus relatos | **Parâmetro de volta** (`Navigator.pop(context, relato)`) e lista atualizada com `setState` |
| 10 | Kit de emergência | **Estado**: `CheckboxListTile` e contador "Itens prontos: X de 12" |
| 11 | Perfil | Dados do usuário, atalhos e sair |

Navegação: `BottomNavigationBar` (Início, Alertas, Abrigos, Perfil) e `Navigator.push` com `MaterialPageRoute`.

Identidade visual: `ThemeData` único (azul `#1F7AB8`, cores fixas de risco, espaçamentos 8/16/24, cards com raio 12).

Dados: mockados em `lib/data/mock_data.dart` (a entrega não exige backend). Gerenciamento de estado somente com `StatefulWidget` e `setState()`.

## Estrutura

```
lib/
  main.dart
  data/mock_data.dart        dados de exemplo e regras de risco/alerta
  models/                    NivelRisco, Alerta, Abrigo, Relato
  screens/                   uma tela por arquivo
  theme/app_theme.dart       ThemeData e espaçamentos
  utils/formatos.dart        formatação de data
  widgets/nivel_chip.dart    selo colorido de risco
assets/logo.png
```

## Como executar

Pré-requisitos: Flutter 3.27 ou superior e um emulador Android (ou celular com depuração USB).

```bash
git clone <URL_DO_REPOSITORIO>
cd guardario-mobile
flutter pub get
flutter run
```

**Usuário de teste:** `cida@guardario.com` / `123456`
(Ou toque em "Continuar sem conta": alertas, abrigos e nível do rio são públicos; só o relato exige login.)

### Roteiro rápido para testar

1. Entre com o usuário de teste.
2. No Início, toque em **Simular subida** até o risco chegar em ALERTA: aparece um alerta automático.
3. Abra **Abrigos**, ligue os filtros "Aceita pets" e "Com vagas" e favorite um abrigo.
4. Toque em **Novo relato**, tente enviar vazio (erros em vermelho), preencha, confirme no diálogo.
5. Veja o relato em **Perfil > Meus relatos**.
6. Marque itens no **Kit de emergência** e veja o contador mudar.

## Publicação (APK)

O APK release está na aba **Releases** deste repositório, gerado a partir do último commit com:

```bash
flutter build apk --release
```

Arquivo: `build/app/outputs/flutter-apk/app-release.apk`

## Vídeo

Link (YouTube, não listado): <COLOCAR_LINK_DO_VIDEO>