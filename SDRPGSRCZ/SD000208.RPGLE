     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Maintain Withholding Tax Rate Dft Matrix')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000208 - Withholding Tax Rate Default Matrix               *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             profit centre default file.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Note: Core amendments to this program must be applied        *
      *        via the core synon model.                              *
      *                                                               *
      *  Last Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT003 - Withholding Tax Enhancement                         *
      *                                                               *
      *****************************************************************
     FSD000208DFCF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Withholding Tax Rate Default Matrix Maintenance
      *
     FSDWTDML1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * RTV : Withholding Tax Rate Default Matrix Retrieval index
      *
     FSDWTRCL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Withholding Tax Rate Code retrieval
      *
     FSDBRCHL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0005)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Branch codes retrieval
      *
     FSDBOOKL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0006)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Book details retrieval
      *
     FSDCURRL2  IF   E           K DISK    USROPN
     F                                     INFDS(ID0007)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Currency details retrieval
      *
     FSDCTRYL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0008)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Country of Domicile details retrieval
      *
     FSDINSTL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0009)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Institution Code retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0010)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Module retrieval
      *
     F***SDRETLPD  IF   E             DISK    USROPN
     F***                                     INFDS(ID0011)
     F***                                     INFSR(*PSSR)
      *** RTV : Midas SD Retail Account Code Retrieval
      *
     FSDACODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0011)
     F                                     INFSR(*PSSR)
      *** RTV : Midas SD Retail Account Code Retrieval
      *
     F*INVTO     IF   E           K DISK    USROPN
     F*                                     INFDS(ID0012)
     F*                                     INFSR(*PSSR)
      * RTV : Midas SD Investment Type retrieval
      *
     FFDDTSTL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0013)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Deal type/subtypes retrieval
      *
     FSDBANKL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0015)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Bank details ICD retrieval
      *
     FSDWTDML0  UF A E           K DISK    USROPN
     F                                     RENAME(SDWTDMD0:SDWTDMD2)
     F                                     COMMIT
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * UPD : Withholding Tax Rate Default Matrix Update index
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
      *
     D**                                                                                      AUA012
     D**********          OAR1        9 10                                                    AUA012
     D** Withholding Tax Rate Default Matrix Array to hold ordered Base Fields
     D** according to their priorities.
     D**
     D/EJECT
     D**
     D IAR1            S             14    DIM(9)
     D** Withholding Tax Rate Default Matrix Array to hold ordered Base Fields
     D** according to their priorities.
     D**
     D/EJECT
     D**
     D SHR1            S             20    DIM(9)
     D** Withholding Tax Rate Default Matrix Array to hold ordered Base Field
     D** LHS Texts according to their associated field priorities.
     D**
     D SHR2            S             20    DIM(9)  CTDATA PERRCD(1)
     D** Withholding Tax Rate Default Matrix Array to hold LHS Text Text for all
     D** base fields.
     D**
     D/EJECT
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
      * Long constants
     D @CN#            S              6    DIM(9)  CTDATA PERRCD(1)
     D @CN             S             25    DIM(9)  ALT(@CN#)
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D DATA            DS          1024
     D  #1BRCH                 1      3
     D  #1BOOK                 4      5
     D  #1CURY                 6      8
     D  #1CTRY                 9     10
     D  #1CUTY                11     11
     D  #1INST                12     13
     D  #1MODU                14     15
     D  #1TRTY                16     25
     D  #1TRST                26     27
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D DfltPr          DS
      * Default Priorities
     D  DMBR                   1      1  0
     D  DMBO                   2      2  0
     D  DMCU                   3      3  0
     D  DMCD                   4      4  0
     D  DMCT                   5      5  0
     D  DMIN                   6      6  0
     D  DMMO                   7      7  0
     D  DMTY                   8      8  0
     D  DMTS                   9      9  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D YBRDCS          DS            22
     D YCRDCS          DS            22
     D UUOAR1          DS
     D  #DWPM1                 1     10
     D  #DWPM2                11     20
     D  #DWPM3                21     30
     D  #DWPM4                31     40
     D  #DWPM5                41     50
     D  #DWPM6                51     60
     D  #DWPM7                61     70
     D  #DWPM8                71     80
     D  #DWPM9                81     90
     D  OAR1                   1     90
     D                                     DIM(9)
     D*
     D UUSDY         E DS                  EXTNAME(DSSDY)                       087380
      *
      * INCOMING DS FROM AP TO HOLD DATA READ FROM FILE
      *
     D D@USER        E DS                  EXTNAME(MUSERDD)
      *
      * DS TO HOLD DATA READ FROM FILE TO BE USED WITHIN THE PROGRAM
      *
     D A@CPY           DS
     D* MKI Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              MKI Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
     D ID0004          DS           528
      * File information data structure
      *
     D ID0005          DS           528
      * File information data structure
      *
     D ID0006          DS           528
      * File information data structure
      *
     D ID0007          DS           528
      * File information data structure
      *
     D ID0008          DS           528
      * File information data structure
      *
     D ID0009          DS           528
      * File information data structure
      *
     D ID0010          DS           528
      * File information data structure
      *
     D ID0011          DS           528
      * File information data structure
      *
     D ID0012          DS           528
      * File information data structure
      *
     D ID0013          DS           528
      * File information data structure
      *
     D ID0014          DS           528
      * File information data structure
      *
     D ID0015          DS           528
      * File information data structure
      *
     D ID0016          DS           528
      * File information data structure                                                       AUA012
      *                                                                                       AUA012
     D ID0017          DS           528
      * File information data structure                                                       AUA012
      *                                                                                       AUA012
      /EJECT
      * Parameter declarations
     D P1PARM          DS            35
      * RCD: Withholding Tax Rate Dft Matrix  Retrieval index
      * I:MAP Branch code
     D  P1BRCH                 1      3
      * I:MAP Book Code
     D  P1BOOK                 4      5
      * I:MAP Currency
     D  P1CURY                 6      8
      * I:MAP Country of Domicile
     D  P1CTRY                 9     10
      * I:MAP Customer Type
     D  P1CUTY                11     11
      * I:MAP Institution Code
     D  P1INST                12     13
      * I:MAP Module
     D  P1MODU                14     15
      * I:MAP Transaction Type
     D  P1TRTY                16     25
      * I:MAP Transaction Subtype
     D  P1TRST                26     27
      * I:MAP Default Main Tax Rate Code
     D  P1TXR1                28     29
      * I:MAP Default Secondary Tax Rate Code
     D  P1TXR2                30     31
      * I : MAP Last Change Date
     D  P1LCD                 32     34P 0
      * I : MAP Type of Last Change
     D  P1TYPC                35     35
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0001                 1     10
     D  ZA0002                 1     10
     D  ZA0003                 1     10
     D  ZA0004                 1     10
     D  ZA0005                 1     10
     D  ZA0006                 1     10
     D  ZA0007                 1     10
     D  ZA0008                 1     10
     D  ZA0009                 1     10
     D  ZA009A                 1     10
     D  ZA0010                 1     10
     D  ZA0011                11     12
     D  ZA0012                13     32
     D  ZA0013                 1     10
     D  ZA0014                11     12
     D  ZA0015                13     32
     D  ZA0016                 1     10
     D  ZA0017                11     12
     D  ZA0018                13     32
     D  ZA0019                 1     10
     D  ZA0020                11     12
     D  ZA0021                13     32
     D  ZA0022                 1     10
     D  ZA0023                11     12
     D  ZA0024                13     32
     D  ZA0025                 1     10
     D  ZA0026                11     12
     D  ZA0027                13     32
     D  ZA0028                 1     10
     D  ZA0029                11     12
     D  ZA0030                13     32
     D  ZA0031                 1     10
     D  ZA0032                11     12
     D  ZA0033                13     32
     D  ZA0034                 1     10
     D  ZA0035                11     12
     D  ZA0036                13     32
     D  ZA034A                 1     10
     D  ZA035A                11     12
     D  ZA036A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0037                 1     10
     D  ZA0038                 1     10
     D  ZA0039                 1     10
     D  ZA0040                 1     10
     D  ZA0041                 1     10
     D  ZA0042                 1     10
     D  ZA0043                 1     10
     D  ZA0044                 1     10
     D  ZA0045                 1     10
     D  ZA045A                 1     10
     D  ZA0046                 1     10
     D  ZA0047                11     12
     D  ZA0048                13     32
     D  ZA0049                 1     10
     D  ZA0050                11     12
     D  ZA0051                13     32
     D  ZA0052                 1     10
     D  ZA0053                11     12
     D  ZA0054                13     32
     D  ZA0055                 1     10
     D  ZA0056                11     12
     D  ZA0057                13     32
     D  ZA0058                 1     10
     D  ZA0059                11     12
     D  ZA0060                13     32
     D  ZA0061                 1     10
     D  ZA0062                11     12
     D  ZA0063                13     32
     D  ZA0064                 1     10
     D  ZA0065                11     12
     D  ZA0066                13     32
     D  ZA0067                 1     10
     D  ZA0068                11     12
     D  ZA0069                13     32
     D  ZA0070                 1     10
     D  ZA0071                11     12
     D  ZA0072                13     32
     D  ZA070A                 1     10
     D  ZA071A                11     12
     D  ZA072A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0073                 1     10
     D  ZA0074                 1     10
     D  ZA0075                 1     10
     D  ZA0076                 1     10
     D  ZA0077                 1     10
     D  ZA0078                 1     10
     D  ZA0079                 1     10
     D  ZA0080                 1     10
     D  ZA0081                 1     10
     D  ZA081A                 1     10
     D  ZA0082                 1     10
     D  ZA0083                11     12
     D  ZA0084                13     32
     D  ZA0085                 1     10
     D  ZA0086                11     12
     D  ZA0087                13     32
     D  ZA0088                 1     10
     D  ZA0089                11     12
     D  ZA0090                13     32
     D  ZA0091                 1     10
     D  ZA0092                11     12
     D  ZA0093                13     32
     D  ZA0094                 1     10
     D  ZA0095                11     12
     D  ZA0096                13     32
     D  ZA0097                 1     10
     D  ZA0098                11     12
     D  ZA0099                13     32
     D  ZA0100                 1     10
     D  ZA0101                11     12
     D  ZA0102                13     32
     D  ZA0103                 1     10
     D  ZA0104                11     12
     D  ZA0105                13     32
     D  ZA0106                 1     10
     D  ZA0107                11     12
     D  ZA0108                13     32
     D  ZA106A                 1     10
     D  ZA107A                11     12
     D  ZA108A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0109                 1     10
     D  ZA0110                 1     10
     D  ZA0111                 1     10
     D  ZA0112                 1     10
     D  ZA0113                 1     10
     D  ZA0114                 1     10
     D  ZA0115                 1     10
     D  ZA0116                 1     10
     D  ZA0117                 1     10
     D  ZA117A                 1     10
     D  ZA0118                 1     10
     D  ZA0119                11     12
     D  ZA0120                13     32
     D  ZA0121                 1     10
     D  ZA0122                11     12
     D  ZA0123                13     32
     D  ZA0124                 1     10
     D  ZA0125                11     12
     D  ZA0126                13     32
     D  ZA0127                 1     10
     D  ZA0128                11     12
     D  ZA0129                13     32
     D  ZA0130                 1     10
     D  ZA0131                11     12
     D  ZA0132                13     32
     D  ZA0133                 1     10
     D  ZA0134                11     12
     D  ZA0135                13     32
     D  ZA0136                 1     10
     D  ZA0137                11     12
     D  ZA0138                13     32
     D  ZA0139                 1     10
     D  ZA0140                11     12
     D  ZA0141                13     32
     D  ZA0142                 1     10
     D  ZA0143                11     12
     D  ZA0144                13     32
     D  ZA142A                 1     10
     D  ZA143A                11     12
     D  ZA144A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0145                 1     10
     D  ZA0146                11     12
     D  ZA0147                13     32
     D  ZA0148                 1     10
     D  ZA0149                11     12
     D  ZA0150                13     32
     D  ZA0151                 1     10
     D  ZA0152                11     12
     D  ZA0153                13     32
     D  ZA0154                 1     10
     D  ZA0155                11     12
     D  ZA0156                13     32
     D  ZA0157                 1     10
     D  ZA0158                11     12
     D  ZA0159                13     32
     D  ZA0160                 1     10
     D  ZA0161                11     12
     D  ZA0162                13     32
     D  ZA0163                 1     10
     D  ZA0164                11     12
     D  ZA0165                13     32
     D  ZA0166                 1     10
     D  ZA0167                11     12
     D  ZA0168                13     32
     D  ZA0169                 1     10
     D  ZA0170                11     12
     D  ZA0171                13     32
     D  ZA169A                 1     10
     D  ZA170A                11     12
     D  ZA171A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0172                 1     10
     D  ZA0173                 1     10
     D  ZA0174                 1     10
     D  ZA0175                 1     10
     D  ZA0176                 1     10
     D  ZA0177                 1     10
     D  ZA0178                 1     10
     D  ZA0179                 1     10
     D  ZA0180                 1     10
     D  ZA180A                 1     10
     D  ZA0181                 1     10
     D  ZA0182                11     12
     D  ZA0183                13     32
     D  ZA0184                 1     10
     D  ZA0185                11     12
     D  ZA0186                13     32
     D  ZA0187                 1     10
     D  ZA0188                11     12
     D  ZA0189                13     32
     D  ZA0190                 1     10
     D  ZA0191                11     12
     D  ZA0192                13     32
     D  ZA0193                 1     10
     D  ZA0194                11     12
     D  ZA0195                13     32
     D  ZA0196                 1     10
     D  ZA0197                11     12
     D  ZA0198                13     32
     D  ZA0199                 1     10
     D  ZA0200                11     12
     D  ZA0201                13     32
     D  ZA0202                 1     10
     D  ZA0203                11     12
     D  ZA0204                13     32
     D  ZA0205                 1     10
     D  ZA0206                11     12
     D  ZA0207                13     32
     D  ZA205A                 1     10
     D  ZA206A                11     12
     D  ZA207A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0208                 1     10
     D  ZA0209                 1     10
     D  ZA0210                 1     10
     D  ZA0211                 1     10
     D  ZA0212                 1     10
     D  ZA0213                 1     10
     D  ZA0214                 1     10
     D  ZA0215                 1     10
     D  ZA0216                 1     10
     D  ZA216A                 1     10
     D  ZA0217                 1     10
     D  ZA0218                11     12
     D  ZA0219                13     32
     D  ZA0220                 1     10
     D  ZA0221                11     12
     D  ZA0222                13     32
     D  ZA0223                 1     10
     D  ZA0224                11     12
     D  ZA0225                13     32
     D  ZA0226                 1     10
     D  ZA0227                11     12
     D  ZA0228                13     32
     D  ZA0229                 1     10
     D  ZA0230                11     12
     D  ZA0231                13     32
     D  ZA0232                 1     10
     D  ZA0233                11     12
     D  ZA0234                13     32
     D  ZA0235                 1     10
     D  ZA0236                11     12
     D  ZA0237                13     32
     D  ZA0238                 1     10
     D  ZA0239                11     12
     D  ZA0240                13     32
     D  ZA0241                 1     10
     D  ZA0242                11     12
     D  ZA0243                13     32
     D  ZA241A                 1     10
     D  ZA242A                11     12
     D  ZA243A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0244                 1     10
     D  ZA0245                 1     10
     D  ZA0246                 1     10
     D  ZA0247                 1     10
     D  ZA0248                 1     10
     D  ZA0249                 1     10
     D  ZA0250                 1     10
     D  ZA0251                 1     10
     D  ZA0252                 1     10
     D  ZA252A                 1     10
     D  ZA0253                 1     10
     D  ZA0254                11     12
     D  ZA0255                13     32
     D  ZA0256                 1     10
     D  ZA0257                11     12
     D  ZA0258                13     32
     D  ZA0259                 1     10
     D  ZA0260                11     12
     D  ZA0261                13     32
     D  ZA0262                 1     10
     D  ZA0263                11     12
     D  ZA0264                13     32
     D  ZA0265                 1     10
     D  ZA0266                11     12
     D  ZA0267                13     32
     D  ZA0268                 1     10
     D  ZA0269                11     12
     D  ZA0270                13     32
     D  ZA0271                 1     10
     D  ZA0272                11     12
     D  ZA0273                13     32
     D  ZA0274                 1     10
     D  ZA0275                11     12
     D  ZA0276                13     32
     D  ZA0277                 1     10
     D  ZA0278                11     12
     D  ZA0279                13     32
     D  ZA277A                 1     10
     D  ZA278A                11     12
     D  ZA279A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'
     D  ZA0280                 1     10
     D  ZA0281                 1     10
     D  ZA0282                 1     10
     D  ZA0283                 1     10
     D  ZA0284                 1     10
     D  ZA0285                 1     10
     D  ZA0286                 1     10
     D  ZA0287                 1     10
     D  ZA0288                 1     10
     D  ZA288A                 1     10
     D  ZA0289                 1     10
     D  ZA0290                11     12
     D  ZA0291                13     32
     D  ZA0292                 1     10
     D  ZA0293                11     12
     D  ZA0294                13     32
     D  ZA0295                 1     10
     D  ZA0296                11     12
     D  ZA0297                13     32
     D  ZA0298                 1     10
     D  ZA0299                11     12
     D  ZA0300                13     32
     D  ZA0301                 1     10
     D  ZA0302                11     12
     D  ZA0303                13     32
     D  ZA0304                 1     10
     D  ZA0305                11     12
     D  ZA0306                13     32
     D  ZA0307                 1     10
     D  ZA0308                11     12
     D  ZA0309                13     32
     D  ZA0310                 1     10
     D  ZA0311                11     12
     D  ZA0312                13     32
     D  ZA0313                 1     10
     D  ZA0314                11     12
     D  ZA0315                13     32
     D  ZA313A                 1     10
     D  ZA314A                11     12
     D  ZA315A                13     32
      * Message data for 'W.T.R.D.M. Filed  Error'                                            AUA012
     D  ZA0316                 1     10
     D  ZA0317                 1     10
     D  ZA0318                 1     10
     D  ZA0319                 1     10
     D  ZA0320                 1     10
     D  ZA0321                 1     10
     D  ZA0322                 1     10
     D  ZA0323                 1     10
     D  ZA0324                 1     10
     D  ZA324A                 1     10
     D  ZA0325                 1     10
     D  ZA0326                11     12
     D  ZA0327                13     32
     D  ZA0328                 1     10
     D  ZA0329                11     12
     D  ZA0330                13     32
     D  ZA0331                 1     10
     D  ZA0332                11     12
     D  ZA0333                13     32
     D  ZA0334                 1     10
     D  ZA0335                11     12
     D  ZA0336                13     32
     D  ZA0337                 1     10
     D  ZA0338                11     12
     D  ZA0339                13     32
     D  ZA0440                 1     10
     D  ZA0441                11     12
     D  ZA0442                13     32
     D  ZA0443                 1     10
     D  ZA0444                11     12
     D  ZA0445                13     32
     D  ZA0446                 1     10
     D  ZA0447                11     12
     D  ZA0448                13     32
     D  ZA0449                 1     10
     D  ZA0500                11     12
     D  ZA0501                13     32
     D  ZA449A                 1     10
     D  ZA500A                11     12
     D  ZA501A                13     32
 
      // Variables Declaration
     D Exists          S               N
 
     I*
     I* Rename field PLDPCD to avoid compliation error
     I*
     IFDDTSTPD
     I              PLDPCD                      XXDPCD
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         RCD: Tax Rate Code
     C     P2ANCD        PARM                    WP0001            1            Action Code
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Conduct screen conversation
     C                   DO        *HIVAL
      * Start new transaction
     C                   MOVEL     'Y'           W0TRN             1
      * Process current transaction
     C     W0TRN         DOWEQ     'Y'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Reset screen fields
     C   05              CAS                     MALDSC
      * Process screen input
     C                   CAS                     DAPRSC
     C                   END
      *
     C                   END
      *
     C                   END
      *****************************************************************
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            29
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Enable PUTOVR
     C                   SETON                                        86
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPRSC        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * USER: Process command keys
      * CASE: DTL.*CMD key is *Delete
     C     *IN10         IFEQ      '1'                                          *IF
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   MOVEL     WUSPTT        WUTRTY                         Trans Type
      * Delete Tax Rate Dft - Withholding Tax Rate Default Matrix *
     C                   EXSR      SADLRC
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
     C                   COMMIT
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     WUSPTT        WUTRTY                         Trans Type
      * Retrieve W.T.R.D.M. Record - Withholding Tax Rate Default Matrix *
     C                   EXSR      SCRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Send message 'Record Already Deleted'
     C                   MOVEL     'USR0838'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: DTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
      * CASE: PAR.Action Code is Amend
     C     P2ANCD        IFEQ      'A'                                          *IF
     C                   ROLBK
     C                   END                                                    *FI
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate screen input
     C                   EXSR      DBVLSC
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: User defined action
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Insert Processing
     C                   EXSR      UASUBR                                       Insert Processi
     C                   ELSE
      * CASE: PAR.Action Code is Amend
     C     P2ANCD        IFEQ      'A'                                          *IF
      * Amend Processing
     C                   EXSR      UDSUBR                                       Amend Processin
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Request new transaction
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBVLSC        BEGSR
      *================================================================
      * Validate screen input
      *================================================================
      * USER: Validate fields
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
      * Send message 'F3/F10/F12 only valid opt'
     C                   MOVEL     'USR0536'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      DBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Bypass ref file checks if error already detected
     C   99              GOTO      DBEXIT
      * Check reference to Main Withholding tax rate code
     C                   EXSR      VACKRL1
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9940      *
     C                   END
      * Check reference to Secondary Withholding tax rate code
     C                   EXSR      VACKRL2
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9941      *
     C                   END
      * CALC: Screen function fields
      * Take Screen function fields and place them into the corresponding
      * File function fields in order to validate each entry individually
      * Set DTL To Screen Fun Fld - Withholding Tax Rate Default Matrix *
     C**
     C** Set-up Branch Code
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMBH        H                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(H)       UUBRCH            7               ¦IF 2
     C     UUBRCH        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '3'           WUBHLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUBHLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(H)       WUBHSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUBHSN                            ¦
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code
     C**
     C     WUWMBK        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMBK        B                 1 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(B)       UUBOOK            8               ¦IF 2
     C     UUBOOK        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUBKLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUBKLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(B)       WUBKSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUBKSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Currency
     C**
     C     WUWMCY        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMCY        C                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(C)       UUCURY            7               ¦IF 2
     C     UUCURY        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '3'           WUCYLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUCYLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(C)       WUCYSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUCYSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Country of Domicile
     C**
     C     WUWMCR        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMCR        D                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(D)       UUCTRY            8               ¦IF 2
     C     UUCTRY        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUCRLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUCRLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(D)       WUCRSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUCRSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Customer Type
     C**
     C     WUWMCT        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMCT        U                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(U)       UUCUTY            9               ¦IF 2
     C     UUCUTY        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '1'           WUCTLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUCTLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(U)       WUCTSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUCTSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Institution Code
     C**
     C     WUWMIS        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMIS        I                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(I)       UUINST            8               ¦IF 2
     C     UUINST        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUISLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUISLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(I)       WUISSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUISSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Module
     C**
     C     WUWMMO        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMMO        M                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(M)       UUMODU            8               ¦IF 2
     C     UUMODU        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUMOLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUMOLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(M)       WUMOSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUMOSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Transaction Type
     C**
     C     WUWMTT        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMTT        T                 2 0             ¦
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(T)       WUTTSN                            ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   Z-ADD     0             WUTTSNLength      2 0
     C                   EVAL      WUTTSNLength = %len(%trim(WUTTSN))
     C                   MOVE      *BLANKS       WUTTLN                            ¦¦
     C     WUTTSNLength  IFEQ      2
     C     WUTTSNLength  OREQ      10
     C*****              Do nothing, it is either valid or trapped elsewhere
     C                   ELSE
     C                   MOVE      '2'           WUTTLN                            ¦¦
     C                   ENDIF
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUTTSN                            ¦
     C                   END
     C** Set-up Transaction Subtype
     C**
     C     WUWMTS        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMTS        S                 2 0             ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(S)       UUTRST            8               ¦IF 2
     C     UUTRST        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUTSLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUTSLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(S)       WUTSSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUTSSN                            ¦
     C                   END                                                      IF 1
      *
      * USER: Validate relations
      * Set File Fields to Screen Fields
     C                   EXSR      UESUBR                                       Set File Fields
      *********** Branch Code Validation
      * if Entered & Multibranching On LN0592
      * CASE: WRK.Multi-branching Indicator is Multi-branched
     C     WUMBIN        IFEQ      'Y'                                          *IF
      * CASE: WRK.Branch    Screen Fld is Not Blank
     C     WUBHSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Branch  Length Check is Blank
     C     WUBHLN        IFEQ      *BLANK                                       *IF
      * Check Exist of branch cd - Branch Codes  *
     C                   EXSR      SIRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      UFSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUBHSN                         Branch    Scree
     C                   MOVEL     #1BRCH        WUBHSN                         Branch    Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UGSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is Not Blank or 0
     C     WUWMBH        IFEQ      1                                            *IF
     C     WUWMBH        OREQ      2
     C     WUWMBH        OREQ      3
     C     WUWMBH        OREQ      4
     C     WUWMBH        OREQ      5
     C     WUWMBH        OREQ      6
     C     WUWMBH        OREQ      7
     C     WUWMBH        OREQ      8
     C     WUWMBH        OREQ      9
     C                   MOVEL     WUSBRC        #1BRCH                         Branch code
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Book Code Validation
      * Book Code if Entered
      * CASE: WRK.Book Code Screen Fld is Not Blank
     C     WUBKSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Book Length Check is Blank
     C     WUBKLN        IFEQ      *BLANK                                       *IF
      * Check Existance Of Book. - Book Details  *
     C                   EXSR      SJRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      UHSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUBKSN                         Book Code Scree
     C                   MOVEL     #1BOOK        WUBKSN                         Book Code Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UISUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Currency Validation
      * Currency if Entered
      * CASE: WRK.Currency  Screen Fld is Not Blank
     C     WUCYSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Currency Length Check is Blank
     C     WUCYLN        IFEQ      *BLANK                                       *IF
      * Check Existance Of Currency - Currency Codes  *
     C                   EXSR      SKRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      UJSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUCYSN                         Currency  Scree
     C                   MOVEL     #1CURY        WUCYSN                         Currency  Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UKSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Country of Domicile Validation
      * Country of Domicile if Entered
      * CASE: WRK.Ctry of Dom Screen Fld is Not Blank
     C     WUCRSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Ctry of Dom Length Check is Blank
     C     WUCRLN        IFEQ      *BLANK                                       *IF
      * Check Existance Of Ctry of Dom - Country of Domicile *
     C                   EXSR      SLRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      ULSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUCRSN                         Ctry of Dom Scree
     C                   MOVEL     #1CTRY        WUCRSN                         Ctry of Dom Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UMSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Customer Type Validation
      * Customer Type if Entered
      * CASE: WRK.Customer Type Screen Fld is Not Blank
     C     WUCTSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Customer Type Length Check is Blank
     C     WUCTLN        IFEQ      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUCTSN                         Customer Ty Scree
     C                   MOVEL     #1CUTY        WUCTSN                         Customer Ty Scree
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UNSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Institution Code Validation
      * Institution Code if Entered
      * CASE: WRK.Inst Code Screen Fld is Not Blank
     C     WUISSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Inst Code Length Check is Blank
     C     WUISLN        IFEQ      *BLANK                                       *IF
      * Check Existance Of Inst Code - Institution Code  *
     C                   EXSR      SMRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      UOSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUISSN                         Inst Code Scree
     C                   MOVEL     #1INST        WUISSN                         Inst Code Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UPSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Module Validation
      * Module if Entered
      * CASE: WRK.Module Screen Fld is Not Blank
     C     WUMOSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Module Length Check is Blank
     C     WUMOLN        IFEQ      *BLANK                                       *IF
      * Check Existance Of Module - Module *
     C                   EXSR      SNRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      UQSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUMOSN                         Module Scree
     C                   MOVEL     #1MODU        WUMOSN                         Module Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      URSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      ************ Transaction Type Validation
      * Transaction Type if Entered
      * CASE: WRK.Trans Type Screen Fld is Not Blank
     C     WUTTSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Trans Type Length Check is Blank
     C     WUTTLN        IFEQ      *BLANK                                       *IF
      * Check Existance Of Trans Type - Transaction Type *
     C                   EXSR      SORVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      USSUBR                                       Seton Screen Er
     C     #1MODU        IFEQ      *BLANKS
     C                   EXSR      UQSUBR
     C                   ENDIF
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUTTSN                         Trans Ty Scree
     C                   MOVEL     #1TRTY        WUTTSN                         Trans Ty Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      UTSUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END
      ************ Transaction Subtype Validation
      * Transaction Subtype if Entered
      * CASE: WRK.Trans S Type Screen Fld is Not Blank
     C     WUTSSN        IFNE      *BLANK                                       *IF
      * CASE: WRK.Trans S Type  Length Check is Blank
     C     WUTSLN        IFEQ      *BLANK                                       *IF
      * Check Existance Trans S Type - Transaction Subtype *
     C                   EXSR      SPRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
     C     W0RTN         OREQ      'USS0552'
      * Seton Screen Error Flag For Function Field In error
     C                   EXSR      UUSUBR                                       Seton Screen Er
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUTSSN                         Trans S Ty Scree
     C                   MOVEL     #1TRST        WUTSSN                         Trans S Ty Scree
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Seton Screen Error Flag For Function Field Too Long
     C                   EXSR      VASUBR                                       Seton Screen Er
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      * Reload Screen if Defer Confirm Requested
      * CASE: PGM.*Defer confirm is Defer confirm
     C     W0DCF         IFEQ      'Y'                                          *IF
      * Load DTL Screen Fields - Withholding Tax Rate Default Matrix *
     C**
     C** Move each database field into the associated section of the
     C** array in order to display all the details into the screen
     C** output fields.
     C**
     C** To place the field into the correct portion of the array make
     C** use of the priorities specified for each field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H
     C** Initialise Branch Code Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUBRCH        UUBFLD
     C** Move Long Store Bch Code  to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD           10
     C                   MOVEL     WUBOOK        UUBFLD
     C** Move Store Book Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(B)
     C                   END                                                      IF 1
     C** Set-up Currency
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCURY        UUBFLD
     C** Move Long Store Currency to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(C)
     C                   END                                                      IF 1
     C** Set-up Country of Domicile
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCTRY        UUBFLD
     C** Move Long Store Ctry od Domicile to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(D)
     C                   END                                                      IF 1
     C** Set-up Customer Type
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCUTY        UUBFLD
     C** Move Long Store Cust Type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(U)
     C                   END                                                      IF 1
     C** Set-up Institution Code
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMIS        I
     C** Initialise User Id Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUINST        UUBFLD
     C** Move Long Store Institution Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(I)
     C                   END                                                      IF 1
     C** Set-up Module
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M
     C** Initialise Base Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUMODU        UUBFLD
     C** Move Long Store Module to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(M)
     C                   END                                                      IF 1
     C** Set-up Transaction Type
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUTRTY        UUBFLD
     C** Move Long Store Transaction type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(T)
     C                   END                                                      IF 1
     C** Set-up Transaction Subtype
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUTRST        UUBFLD
     C** Move Long Store Trans Subtype to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(S)
     C                   END                                                      IF 1
     C/EJECT
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     IAR1(1)       #DWPM1
     C                   MOVEA     IAR1(2)       #DWPM2
     C                   MOVEA     IAR1(3)       #DWPM3
     C                   MOVEA     IAR1(4)       #DWPM4
     C                   MOVEA     IAR1(5)       #DWPM5
     C                   MOVEA     IAR1(6)       #DWPM6
     C                   MOVEA     IAR1(7)       #DWPM7
     C                   MOVEA     IAR1(8)       #DWPM8
     C                   MOVEA     IAR1(9)       #DWPM9
     C**
     C                   END                                                    *FI
      * Default Tax Rate required
     C     #1TXR1        IFEQ      *BLANK                                       IF
     C                   SETON                                        9940      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Default Tax Rate (2) required
     C*****#1TXR2        IFEQ      *BLANK                                       IF
     C*****              SETON                                        9941      *
      * Send message '*Value required'
     C*****              MOVEL     'Y2U0001'     ZAMSID
     C*****              MOVEL     'Y2USRMSG'    ZAMSGF
     C*****              EXSR      ZASNMS
     C*****              END                                                    FI
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for screen
      *================================================================
      *
     C                   MOVEL     '0'           *IN71
     C     #DWPT1        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN71
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN79
     C     #DWPT2        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     #DWPT3        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     #DWPT4        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN76
     C     #DWPT5        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN75
     C     #DWPT6        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN75
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN74
     C     #DWPT7        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN74
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN73
     C     #DWPT8        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN73
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN72
     C     #DWPT9        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN72
     C                   END                                                    *FI
      *
     C     P2ANCD        IFNE      'D'
     C                   ELSE
     C                   MOVE      '1'           *IN30
     C                   END                                                    *FI
      *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   MALDSC        BEGSR
      *================================================================
      * Load screen from passed parameters
      *================================================================
     C                   MOVEL     P1BRCH        #1BRCH                         Branch Code
     C                   MOVEL     P1BOOK        #1BOOK                         Book Code
     C                   MOVEL     P1CURY        #1CURY                         Currency
     C                   MOVEL     P1CTRY        #1CTRY                         Country of Domicile
     C                   MOVEL     P1CUTY        #1CUTY                         Customer Type
     C                   MOVEL     P1INST        #1INST                         Institution Code
     C                   MOVEL     P1MODU        #1MODU                         Module
     C                   MOVEL     P1TRTY        #1TRTY                         Transaction Type
     C                   MOVEL     P1TRST        #1TRST                         Transaction Subtype
      *
     C                   Z-ADD     P1LCD         #1LCD                          Last Change Dat
     C                   MOVEL     P1TYPC        #1TYPC                         Type of Last Ch
     C                   MOVEL     *BLANK        #DWPT1                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM1                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT2                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM2                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT3                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM3                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT4                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM4                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT5                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM5                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT6                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM6                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT7                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM7                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT8                         Pty Def Prof Ma
     C                   MOVEL     *BLANK        #DWPM8                         Priority Def Pr
     C                   MOVEL     *BLANK        #DWPT9                         Pty Def WH Ma
     C                   MOVEL     *BLANK        #DWPM9                         Priority Def WH
      *
     C                   MOVEL     P1TXR1        #1TXR1                         Default Tax Rate Cod
     C                   MOVEL     P1TXR2        #1TXR2                         Default Tax Rate Cod
      * CALC: Screen function fields
      * Take Screen function fields and place them into the corresponding
      * File function fields in order to validate each entry individually
      * Set DTL To Screen Fun Fld - Withholding Tax Rate Default Matrix *
     C**
     C** Set-up Branch Code
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMBH        H                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(H)       UUBRCH            7               ¦IF 2
     C     UUBRCH        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '3'           WUBHLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUBHLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(H)       WUBHSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUBHSN                            ¦
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code
     C**
     C     WUWMBK        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMBK        B                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(B)       UUBOOK            8               ¦IF 2
     C     UUBOOK        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUBKLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUBKLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(B)       WUBKSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUBKSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Currency
     C**
     C     WUWMCY        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMCY        C                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(C)       UUCURY            7               ¦IF 2
     C     UUCURY        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '3'           WUCYLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUCYLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(C)       WUCYSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUCYSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Country of Domicile
     C**
     C     WUWMCR        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMCR        D                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(D)       UUCTRY            8               ¦IF 2
     C     UUCTRY        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUCRLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUCRLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(D)       WUCRSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUCRSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Customer Type
     C**
     C     WUWMCT        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMCT        U                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(U)       UUCUTY            9               ¦IF 2
     C     UUCUTY        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '1'           WUCTLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUCTLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(U)       WUCTSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUCTSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Institution Code
     C**
     C     WUWMIS        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMIS        I                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(I)       UUINST            8               ¦IF 2
     C     UUINST        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUISLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUISLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(I)       WUISSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUISSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Module
     C**
     C     WUWMMO        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMMO        M                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(M)       UUMODU            8               ¦IF 2
     C     UUMODU        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUMOLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUMOLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(M)       WUMOSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUMOSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Transaction Type
     C**
     C     WUWMTT        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMTT        T                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      *BLANKS       WUTTLN                            ¦¦
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(T)       WUTTSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVEL     *BLANKS       WUTTSN                            ¦
     C                   END                                                      IF 1
     C** Set-up Transaction Subtype
     C**
     C     WUWMTS        IFNE      0                                              IF 1
     C                   Z-ADD     WUWMTS        S                                 ¦
     C** Check that the value entered into the field does not exceed
     C** the length of the database file field.               ¦
     C**                   ¦                                  ¦
     C                   MOVE      OAR1(S)       UUTRST            8               ¦IF 2
     C     UUTRST        IFNE      *BLANK                                          ¦¦
     C                   MOVE      '2'           WUTSLN                            ¦¦
     C                   ELSE                                                      ¦¦
     C                   MOVE      *BLANKS       WUTSLN                            ¦¦
     C                   END                                                       ¦IF 2
     C** Move array element ( Screen Fun Field ) to DB Field according
     C** to the fields priority on General Ledger Details.    ¦
     C**                   ¦                                  ¦
     C                   MOVEA     OAR1(S)       WUTSSN                            ¦
     C                   ELSE                                                      ¦
     C                   MOVE      *BLANKS       WUTSSN                            ¦
     C                   END                                                      IF 1
     C**
      * USER: Load screen
      * Save Input Parameters for deletion of record in amend mode
     C                   EXSR      UVSUBR                                       Save Input Para
      * Load DTL Screen Headers - Withholding Tax Rate Default Matrix *
     C**
     C** Move each DB field LHS Text into the associated section of the
     C** array in order to move the correct LHS Text into the screen
     C** LHS Text output fields.
     C**
     C** To place the text into the correct portion of the array make
     C** use of the priorities specified for each base field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code LHS Text
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(1)       SHR1(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code LHS Text
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(2)       SHR1(B)
     C                   END                                                      IF 1
     C** Set-up Currency LHS Text
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(3)       SHR1(C)
     C                   END                                                      IF 1
     C** Set-up Country of Domicile LHS Text
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(4)       SHR1(D)
     C                   END                                                      IF 1
     C** Set-up Customer Type LHS Text
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(5)       SHR1(U)
     C                   END                                                      IF 1
     C** Set-up Institution Code LHS Text
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMIS        I
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(6)       SHR1(I)
     C                   END                                                      IF 1
     C** Set-up Module LHS Text
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M
     C** Move LHS Text into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(7)       SHR1(M)
     C                   END                                                      IF 1
     C** Set-up Transaction Type LHS Text
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(8)       SHR1(T)
     C                   END                                                      IF 1
     C** Set-up Transaction Subtype LHS Text
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S
     C** Move LHS Texts 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVE      SHR2(9)       SHR1(S)
     C                   END                                                      IF 1
      *
      *
     C** Load Screen Function Fields With LHS Text
     C**
     C                   MOVEA     SHR1(1)       #DWPT1
     C                   MOVEA     SHR1(2)       #DWPT2
     C                   MOVEA     SHR1(3)       #DWPT3
     C                   MOVEA     SHR1(4)       #DWPT4
     C                   MOVEA     SHR1(5)       #DWPT5
     C                   MOVEA     SHR1(6)       #DWPT6
     C                   MOVEA     SHR1(7)       #DWPT7
     C                   MOVEA     SHR1(8)       #DWPT8
     C                   MOVEA     SHR1(9)       #DWPT9
     C**
     C**
      * CASE: PAR.Action Code is Amend or Delete
     C     P2ANCD        IFEQ      'A'                                          *IF
     C     P2ANCD        OREQ      'D'
      * Blank out Asterisk Key values in order to display Blanks to the
      * User on amending an item
      * Blank '*'s in Key Field
      * Branch code
     C                   EXSR      UWSUBR                                       Branch Code
      * Book Code
     C                   EXSR      UXSUBR                                       Book Code
      * Currency
     C                   EXSR      UYSUBR                                       Currency
      * Country of Domicile
     C                   EXSR      UZSUBR                                       Country of Domicile
      * Customer Type
     C                   EXSR      NASUBR                                       Customer Type
      * Institution Code
     C                   EXSR      NBSUBR                                       Institution Code
      * Module
     C                   EXSR      NCSUBR                                       Module
      * Transaction Type
     C                   EXSR      NDSUBR                                       Transaction Type
      * Transaction Subtype
     C                   EXSR      NESUBR                                       Transaction Subtype
      *
      * Load DTL screen fields from key values.
      * Set File Fields to Screen Fields
     C                   EXSR      NFSUBR                                       Set File Fields
      * Load DTL Screen Fields - Withholding Tax Rate Default Matrix *
     C**
     C** Move each database field into the associated section of the
     C** array in order to display all the details into the screen
     C** output fields.
     C**
     C** To place the field into the correct portion of the array make
     C** use of the priorities specified for each field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code
     C**
     C**  IF Multibranching Switched On then Branch Code Will be          LN0592
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0       LN0592
     C     WUMBIN        IFEQ      'Y'                                                         LN059
     C**                                                                  LN0592
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H
     C** Initialise Branch Code Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUBRCH        UUBFLD
     C** Move Long Store Bch Code  to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C** Set-up Book Code
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD           10
     C                   MOVEL     WUBOOK        UUBFLD
     C** Move Store Book Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(B)
     C                   END                                                      IF 1
     C** Set-up Currency
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCURY        UUBFLD
     C** Move Long Store Currency to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(C)
     C                   END                                                      IF 1
     C** Set-up Country of Domicile
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCTRY        UUBFLD
     C** Move Long Store Ctry od Domicile to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(D)
     C                   END                                                      IF 1
     C** Set-up Customer Type
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUCUTY        UUBFLD
     C** Move Long Store Cust Type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(U)
     C                   END                                                      IF 1
     C** Set-up Institution Code
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMIS        I
     C** Initialise User Id Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUINST        UUBFLD
     C** Move Long Store Institution Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(I)
     C                   END                                                      IF 1
     C** Set-up Module
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M
     C** Initialise Base Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUMODU        UUBFLD
     C** Move Long Store Module to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(M)
     C                   END                                                      IF 1
     C** Set-up Transaction Type
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUTRTY        UUBFLD
     C** Move Long Store Transaction type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(T)
     C                   END                                                      IF 1
     C** Set-up Transaction Subtype
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S
     C** Initialise Base Storage Field
     C**                   ¦
     C                   MOVE      *BLANKS       UUBFLD
     C                   MOVEL     WUTRST        UUBFLD
     C** Move Long Store Trans Subtype to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBFLD        IAR1(S)
     C                   END                                                      IF 1
     C/EJECT
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     IAR1(1)       #DWPM1
     C                   MOVEA     IAR1(2)       #DWPM2
     C                   MOVEA     IAR1(3)       #DWPM3
     C                   MOVEA     IAR1(4)       #DWPM4
     C                   MOVEA     IAR1(5)       #DWPM5
     C                   MOVEA     IAR1(6)       #DWPM6
     C                   MOVEA     IAR1(7)       #DWPM7
     C                   MOVEA     IAR1(8)       #DWPM8
     C                   MOVEA     IAR1(9)       #DWPM9
      *
     C                   END                                                    *FI
      * Setup Screen Heading - Withholding Tax Rate Default Matrix *
     C**************************************************************** ON THE
     C*
     C* SET UP SCREEN HEADING IN WHITHOLDING TAX RATE DEF MAT PMTVAL INPUT
     C*
     C**************************************************************** ON THE
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C     P2ANCD        IFEQ      'A'                                          .-If 1
     C     P2ANCD        OREQ      'D'                                          .-If 1
     C* Setup footer text:
     C* Withholding Tax Rate Default Matrix Maintenance
     C                   MOVEL     'USS0540'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##URPT
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE                                                   ¦- X 1
     C     P2ANCD        IFEQ      'I'                                          ¦.-If 2
     C* Setup footer text:
     C* New Withholding Tax Rate Default Matrix
     C                   MOVEL     'USS0540'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##URPT
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END                                                    ¦'-Fi 2
     C                   END                                                    '- Fi 1
     C*
      * Set-up Screen Ftr PMTVAL - Standard Functions  *
     C*****************************************************************
     C*
     C*  CHANGE THE CONTENTS OF THE FOOTER COMMAND KEY TEXT ACCORDING
     C*  TO THE ACTION CODE OF THE PROGRAM - THIS CODE IS TO BE USED
     C*  IN PROMPT & VALIDATE RECORDS WHICH DIRECTLY UPDATE A FILE
     C*  AND USE A PROMPT & VALIDATE RECORD FUNCTION INSTEAD OF AN EDIT
     C*  RECORD OR AN EDIT FILE
     C*
     C*****************************************************************
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   NASUBR        BEGSR
      *================================================================
      * Customer Type
      *================================================================
     C                   MOVEL     P1CUTY        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUCUTY                         Customer Type
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1CUTY        WUCUTY                         Customer Type
     C                   END                                                    *FI
      *================================================================
     CSR   NAEXIT        ENDSR
      /EJECT
     CSR   NBSUBR        BEGSR
      *================================================================
      * Institution Code
      *================================================================
     C                   MOVEL     P1INST        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUINST                         Institution Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1INST        WUINST                         Institution Code
     C                   END                                                    *FI
      *================================================================
     CSR   NBEXIT        ENDSR
      /EJECT
     CSR   NCSUBR        BEGSR
      *================================================================
      * Module
      *================================================================
     C                   MOVEL     P1MODU        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUMODU                         Module
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1MODU        WUMODU                         Module
     C                   END                                                    *FI
      *================================================================
     CSR   NCEXIT        ENDSR
      /EJECT
     CSR   NDSUBR        BEGSR
      *================================================================
      * Transaction Type
      *================================================================
     C                   MOVEL     P1TRTY        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUTRTY                         Transaction Type
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1TRTY        WUTRTY                         Transaction Type
     C                   END                                                    *FI
      *================================================================
     CSR   NDEXIT        ENDSR
      /EJECT
     CSR   NESUBR        BEGSR
      *================================================================
      * Transaction Subtype
      *================================================================
     C                   MOVEL     P1TRST        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUTRST                         Transaction Subtype
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1TRST        WUTRST                         Transaction Subtype
     C                   END                                                    *FI
      *================================================================
     CSR   NEEXIT        ENDSR
      /EJECT
     CSR   NFSUBR        BEGSR
      *================================================================
      * Set File Fields to Screen Fields
      *================================================================
     C                   MOVEL     *BLANK        WUBHSN                         Branch    Scree
     C                   MOVEL     WUBRCH        WUBHSN                         Branch    Scree
     C                   MOVEL     *BLANK        WUBKSN                         Book Code Scree
     C                   MOVEL     WUBOOK        WUBKSN                         Book Code Scree
     C                   MOVEL     *BLANK        WUCYSN                         Currency  Scree
     C                   MOVEL     WUCURY        WUCYSN                         Currency  Scree
     C                   MOVEL     *BLANK        WUCRSN                         Ctry Dom  Scree
     C                   MOVEL     WUCTRY        WUCRSN                         Ctry Dom  Scree
     C                   MOVEL     *BLANK        WUCTSN                         Cust Type Scree
     C                   MOVEL     WUCUTY        WUCTSN                         Cust Type Scree
     C                   MOVEL     *BLANK        WUISSN                         Inst Code Scree
     C                   MOVEL     WUINST        WUISSN                         Inst Code Scree
     C                   MOVEL     *BLANK        WUMOSN                         Module    Scree
     C                   MOVEL     WUMODU        WUMOSN                         Module    Scree
     C                   MOVEL     *BLANK        WUTTSN                         Trans     Scree
     C                   MOVEL     WUTRTY        WUTTSN                         Trans     Scree
     C                   MOVEL     *BLANK        WUTSSN                         Trans S   Scree
     C                   MOVEL     WUTRST        WUTSSN                         Trans S   Scree
      *
      *================================================================
     CSR   NFEXIT        ENDSR
      /EJECT
     CSR   SADLRC        BEGSR
      *================================================================
      * Delete Withhold Tax Rate Dft - Withhold Tax Rate Dft Matrix  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
     C                   CALL      'WN0010'                                                    S0121
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C                   PARM      'D'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SAEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SAEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SAEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SAEXIT                                       *QUIT
     C                   END                                                    *FI
      * Move key fields to SDWTDMD1
     C                   MOVEL     WUSPBH        BRCH                           Branch Code
     C                   MOVEL     WUSPBK        BOOK                           Book Code
     C                   MOVEL     WUSPCY        CURY                           Currency
     C                   MOVEL     WUSPCR        CTRY                           Country of Domicile
     C                   MOVEL     WUSPCT        CUTY                           Customer Type
     C                   MOVEL     WUSPIS        INST                           Institution Code
     C                   MOVEL     WUSPMO        MODU                           Module
     C                   MOVEL     WUSPTT        TRTY                           Transaction Type
     C                   MOVEL     WUSPTS        TRST                           Transaction Subtype
      *
     C     KLDLSA        KLIST
     C                   KFLD                    BRCH                           Branch Code
     C                   KFLD                    BOOK                           Book Code
     C                   KFLD                    CURY                           Currency
     C                   KFLD                    CTRY                           Country of Domicile
     C                   KFLD                    CUTY                           Customer Type
     C                   KFLD                    INST                           Institution Code
     C                   KFLD                    MODU                           Module
     C                   KFLD                    TRTY                           Transaction Type
     C                   KFLD                    TRST                           Transaction Subtype
      *
      *
     C     KLDLSA        CHAIN     SDWTDMD2                           9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
      *................................................................
      *
     C                   DELETE    SDWTDMD2                             91      *
      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDWTDMPD'    AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Retrieve W.T.R.D.M Record - Withholding Tax Rate Default Matrix *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    BRCH                           Branch Code
     C                   KFLD                    BOOK                           Book Code
     C                   KFLD                    CURY                           Currency
     C                   KFLD                    CTRY                           Country of Domicile
     C                   KFLD                    CUTY                           Customer Type
     C                   KFLD                    INST                           Institution Code
     C                   KFLD                    MODU                           Module
     C                   KFLD                    TRTY                           Transaction Type
     C                   KFLD                    TRST                           Transaction Subtype
      *
      * Move fields to key list
     C                   MOVEL     WUSPBH        BRCH                           Branch Code
     C                   MOVEL     WUSPBK        BOOK                           Book Code
     C                   MOVEL     WUSPCY        CURY                           Currency
     C                   MOVEL     WUSPCR        CTRY                           Country of Domicile
     C                   MOVEL     WUSPCT        CUTY                           Customer Type
     C                   MOVEL     WUSPIS        INST                           Institution Code
     C                   MOVEL     WUSPMO        MODU                           Module
     C                   MOVEL     WUSPTT        TRTY                           Transaction Type
     C                   MOVEL     WUSPTS        TRST                           Transaction Subtype
      *
     C     KRSSC         CHAIN     SDWTDMD0                           90        *
      *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0655'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCRRC        BEGSR
      *================================================================
      * Create Withholding Tax Rate Dft - Withholding Tax Rate Dft Matrix  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to SDWTDMD1
     C                   MOVEL     #1BRCH        BRCH                           Branch Code
     C                   MOVEL     #1BOOK        BOOK                           Book Code
     C                   MOVEL     #1CURY        CURY                           Currency
     C                   MOVEL     #1CTRY        CTRY                           Country of Domicile
     C                   MOVEL     #1CUTY        CUTY                           Customer Type
     C                   MOVEL     #1INST        INST                           Institution Code
     C                   MOVEL     #1MODU        MODU                           Module
     C                   MOVEL     #1TRTY        TRTY                           Transaction Type
     C                   MOVEL     #1TRST        TRST                           Transaction Subtype
      *
     C                   MOVEL     #1TXR1        TXR1                           Default Tax Rate
     C                   MOVEL     #1TXR2        TXR2                           Default Tax Rate
     C                   Z-ADD     WURDNB        LCD                            Last Change Dat
     C                   MOVEL     'I'           TYPC                           Type of Last Ch
      *
      * USER: Processing before Data update
      * Set Key Fields to '*'s if Key field is blank
     C                   EXSR      UBSUBR                                       Set Key Fields
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
     C                   CALL      'WN0010'                                                    S0121
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C                   PARM      'I'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     KLCRSD        KLIST
     C                   KFLD                    BRCH                           Branch Code
     C                   KFLD                    BOOK                           Book Code
     C                   KFLD                    CURY                           Currency
     C                   KFLD                    CTRY                           Country of Domicile
     C                   KFLD                    CUTY                           Customer Type
     C                   KFLD                    INST                           Institution Code
     C                   KFLD                    MODU                           Module
     C                   KFLD                    TRTY                           Transaction Type
     C                   KFLD                    TRST                           Transaction Subtype
      *
      * Check for duplicate primary key
      *
     C     KLCRSD        SETLL     SDWTDMD2                               90    *
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USS0541'     W0RTN             7
      * Send message 'Withholding Tax Rate Dft Matr EX'
     C                   MOVEL     'USS0541'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C                   WRITE     SDWTDMD2                             91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SECHRC
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDWTDMPD'    AHFLNM                         Filename
      *
     C     KLCHSE        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSE        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFDLRC        BEGSR
      *================================================================
      * Delete For Amend W.T.R.D.M. - Withholding Tax Rate Dft Matrix *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
     C                   CALL      'WN0010'                                                    S0121
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C                   PARM      'A'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Move key fields to SDWTDMD1
     C                   MOVEL     WUSPBH        BRCH                           Branch Code
     C                   MOVEL     WUSPBK        BOOK                           Book Code
     C                   MOVEL     WUSPCY        CURY                           Currency
     C                   MOVEL     WUSPCR        CTRY                           Country of Domicile
     C                   MOVEL     WUSPCT        CUTY                           Customer Type
     C                   MOVEL     WUSPIS        INST                           Institution Code
     C                   MOVEL     WUSPMO        MODU                           Module
     C                   MOVEL     WUSPTT        TRTY                           Transaction Type
     C                   MOVEL     WUSPTS        TRST                           Transaction Subtype
      *
     C     KLDLSF        KLIST
     C                   KFLD                    BRCH                           Branch Code
     C                   KFLD                    BOOK                           Book Code
     C                   KFLD                    CURY                           Currency
     C                   KFLD                    CTRY                           Country of Domicile
     C                   KFLD                    CUTY                           Customer Type
     C                   KFLD                    INST                           Institution Code
     C                   KFLD                    MODU                           Module
     C                   KFLD                    TRTY                           Transaction Type
     C                   KFLD                    TRST                           Transaction Subtype
      *
     C     KLDLSF        CHAIN     SDWTDMD2                           9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
      *................................................................
      *
     C                   DELETE    SDWTDMD2                             91      *
      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * No File Control changes required since this function
      * has been written to amend a Withholding Tax Rate record by
      * deleting the existing record and creating a new WH Tax Rate rec
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCRRC        BEGSR
      *================================================================
      * Create For Amend W.H.T.R.D.M - Withholding Tax Rate Dft Matrix *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to SDWTDMD1
     C                   MOVEL     #1BRCH        BRCH                           Branch Code
     C                   MOVEL     #1BOOK        BOOK                           Book Code
     C                   MOVEL     #1CURY        CURY                           Currency
     C                   MOVEL     #1CTRY        CTRY                           Country of Domicile
     C                   MOVEL     #1CUTY        CUTY                           Customer Type
     C                   MOVEL     #1INST        INST                           Institution Code
     C                   MOVEL     #1MODU        MODU                           Module
     C                   MOVEL     #1TRTY        TRTY                           Transaction Type
     C                   MOVEL     #1TRST        TRST                           Transaction Subtype
      *
     C                   MOVEL     #1TXR1        TXR1                           Default Tax Rate
     C                   MOVEL     #1TXR2        TXR2                           Default Tax Rate
     C                   Z-ADD     WURDNB        LCD                            Last Change Dat
     C                   MOVEL     'A'           TYPC                           Type of Last Ch
      *
      * USER: Processing before Data update
      * Move *'s to Blank Keys
      * Branch
      * CASE: PAR.Branch code is blank
     C     BRCH          IFEQ      *BLANK                                       *IF
      * Move * to Branch - Withholding Tax Rate Default Matrix *
     C                   MOVEL     '***'         BRCH                           Branch code
     C                   END                                                    *FI
      * Book Code
      * CASE: PAR.Book Code is equal to blank
     C     BOOK          IFEQ      *BLANK                                       *IF
     C                   MOVE      '**'          BOOK                           Book Code
     C                   END                                                    *FI
      * Currency
      * CASE: PAR.Currency is Blank
     C     CURY          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '***'         CURY                           Currency
     C                   END                                                    *FI
      * Country of Domicile
      * CASE: PAR.Country of Domicile is Blank
     C     CTRY          IFEQ      *BLANK                                       *IF
     C                   MOVE      '**'          CTRY                           Country of Domicile
     C                   END                                                    *FI
      * Customer Type
      * CASE: PAR.Customer Type is Blank
     C     CUTY          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '*'           CUTY                           Customer Type
     C                   END                                                    *FI
      * Institution Code
      * CASE: PAR.Institution Code is Blank
     C     INST          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '**'          INST                           Transaction Type
     C                   END                                                    *FI
      * Module
      * CASE: PAR.Module Code is Blank
     C     MODU          IFEQ      *BLANK                                       *IF
     C                   MOVE      '**'          MODU                           Module
     C                   END                                                    *FI
      * Transaction Type
      * CASE: PAR.Transaction Type is Blank
     C     TRTY          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '********'    TRTY                           Transaction Type
     C                   MOVE      '**'          TRTY                           Transaction Type
     C                   END                                                    *FI
      * Transaction Subtype
      * CASE: PAR.Transaction Subtype is Blank
     C     TRST          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '**'          TRST                           Transaction Subtype
     C                   END                                                    *FI
      *
      * Window Processing is covered in the Delete For Amend Fucntion
     C     KLCRSG        KLIST
     C                   KFLD                    BRCH                           Branch Code
     C                   KFLD                    BOOK                           Book Code
     C                   KFLD                    CURY                           Currency
     C                   KFLD                    CTRY                           Country of Domicile
     C                   KFLD                    CUTY                           Customer Type
     C                   KFLD                    INST                           Institution Code
     C                   KFLD                    MODU                           Module
     C                   KFLD                    TRTY                           Transaction Type
     C                   KFLD                    TRST                           Transaction Subtype
      *
      * Check for duplicate primary key
      *
     C     KLCRSG        SETLL     SDWTDMD2                               90    *
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USS0541'     W0RTN             7
      * Send message 'Withholding Tax Rate Default Matrix EX'
     C                   MOVEL     'USS0541'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C                   WRITE     SDWTDMD2                             91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * File controls changed to reflect fact that a record has been amen
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SHCHRC
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDWTDMPD'    AHFLNM                         Filename
      *
     C     KLCHSH        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSH        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SHEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YCRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Check Exist of branch cd - Branch Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    A8BRCD                         Branch code
      * Move fields to key list
     C                   MOVEL     #1BRCH        A8BRCD                         Branch code
     C     KRSSI         CHAIN     @A8REB0                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0075'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJRVGN        BEGSR
      *================================================================
      * Check Existance Of Book. - Book Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSJ         KLIST
     C                   KFLD                    BDBKCD                         Book Code
      * Move fields to key list
     C                   MOVEL     #1BOOK        BDBKCD                         Book Code
     C     KRSSJ         CHAIN     @BDREDK                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0085'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SJEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * Check Existance Of Currency - Currency   *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    A6CYCD                         Ccy Code
      * Move fields to key list
     C                   MOVEL     #1CURY        A6CYCD                         Ccy Code
     C     KRSSK         CHAIN     @CURRK5                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0013'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SKEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   SLRVGN        BEGSR
      *================================================================
      * Check Existance Of Country of Domicile - Country of Domicile *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSL         KLIST
     C                   KFLD                    A4CNCD                         Ctry of Dom
      * Move fields to key list
     C                   MOVEL     #1CTRY        A4CNCD                         Ctry of Dom
     C     KRSSL         CHAIN     @A4REBR                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0013'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SLEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SLEXIT        ENDSR
      /EJECT
     CSR   SMRVGN        BEGSR
      *================================================================
      * Check Existance Of Inst Code - Institution Code *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSM         KLIST
     C                   KFLD                    AKLINC                         Inst Code
      * Move fields to key list
     C                   MOVEL     #1INST        AKLINC                         Inst Code
     C     KRSSM         CHAIN     @AKREBI                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0057'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SMEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SMEXIT        ENDSR
      /EJECT
     CSR   SNRVGN        BEGSR
      *================================================================
      * Check Existance Of Module - Module  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Module must be 'DL', 'RE' or 'SE' only.
     C     #1MODU        IFNE      'DL'
     C     #1MODU        ANDNE     'RE'
      * USER: Processing if Data record Invalid
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SNEXIT
     C                   ELSE
      *
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SNEXIT        ENDSR
      /EJECT
     CSR   SORVGN        BEGSR
      *================================================================
      * Check Existance Of Trans Type - Transaction Type  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        VTRAN             1
      * If Module is 'DL'
     C     #1MODU        IFEQ      'DL'
      * Trans Type must be 'TD' 'CD' or 'IT' only.
     C     #1TRTY        IFEQ      'TD'
     C     #1TRTY        OREQ      'CD'
     C     #1TRTY        OREQ      'IT'
     C                   MOVEL     'V'           VTRAN                          *Ck Valid cd
     C                   ELSE
     C                   MOVEL     'I'           VTRAN                          *Ck Valid cd
     C                   END
     C                   END
      *
      * If Module is 'RE'
     C     #1MODU        IFEQ      'RE'
      * Trans Type must be a Retail Account code
     C*****1             CHAIN     SDRETLD0                           82
     C******IN82         IFEQ      '0'
     C*****#1TRTY        ANDEQ     BMACCD
     C*****              MOVEL     'V'           VTRAN                          *Ck Valid cd
     C*****              ELSE
     C*****              MOVEL     'I'           VTRAN                          *Ck Valid cd
     C*****              END
      /free
        Chain #1TRTY SDACODL1;
        Exists = %found(SDACODL1);
        // Check TRTY in ACOD;
        If Exists and A5ACTY = 'R' and A5TOIN = 'N';
          VTRAN = 'V';
        else;
          VTRAN = 'I';
        endif;
      /end-free
     C                   END
      *
      * If Module is empty
     C     #1MODU        IFEQ      '  '                                         *IF
      * Trans Type cannot be entered
     C                   MOVEL     'I'           VTRAN                          *Ck Valid cd
     C                   END                                                    *FI
      *
      * If Module is 'SE'
     C*****#1MODU        IFEQ      'SE'                                         *IF
      * Trans Type must be an investment type
      * Define keylist
     C*****KRSSO         KLIST
     C*****              KFLD                    INVT                           Invst Code
      * Move fields to key list
     C*****              MOVEL     #1TRTY        INVT                           Invst Code
     C*****KRSSO         CHAIN     INVTPDF                            90        *
     C******IN90         IFEQ      '1'                                          *IF
      * Data record not found
     C*****              MOVEL     'I'           VTRAN                          *Ck Valid cd
     C*****              ELSE
     C*****              MOVEL     'V'           VTRAN                          *Ck Valid cd
     C*****              END
     C*****              END
      *
     C     VTRAN         IFEQ      'I'
      * Data record Invalid
     C                   MOVEL     'USR0057'     W0RTN             7
      * USER: Processing if Data record Invalid
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SOEXIT
     C                   END
      *
     C     VTRAN         IFEQ      'V'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SOEXIT        ENDSR
      /EJECT
     CSR   SPRVGN        BEGSR
      *================================================================
      * Check Existance Trans Sub-Type - Transaction Subtype *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If Module is 'DL'
     C     #1MODU        IFEQ      'DL'
      * Define keylist
     C     KRSSP         KLIST
     C                   KFLD                    DTPE11                         Deal type
     C                   KFLD                    DLST11                         Deal Sub-type
      * Move fields to key list
     C                   MOVEL     #1TRTY        DTPE11                         Trans Type
     C                   MOVEL     #1TRST        DLST11                         Trans S.Ty
     C     KRSSP         CHAIN     FDDTSTPD                           90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0043'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SPEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
     C                   END
      *
      * If Module is 'RE', no need
     C     #1MODU        IFEQ      'RE'
     C     #1TRST        ANDNE     *BLANKS
      * Data record Invalid
     C                   MOVEL     'USS0552'     W0RTN                          *Return code
     C                   GOTO      SPEXIT
     C                   ELSE
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *
      * If Module is 'SE'
     C     #1MODU        IFEQ      'SE'
      * Trans Type must be 'I' or 'D' only.
     C     #1TRST        IFNE      'I'
     C     #1TRST        ANDNE     'D'
      * Data record Invalid
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SPEXIT
     C                   ELSE
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
     C                   END
      *================================================================
     CSR   SPEXIT        ENDSR
     CSR   SQRVGN        BEGSR
      *========================================================================
      * Obtain Withholding Tax Rate Def Pty - System Value WHTDftMtrxPriorities
      *========================================================================
     C                   Eval      P@Op01 = 'WHTDftMtrxPriorities'
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       P@Rtcd            7
     C                   Parm                    P@Op01           20
     C                   Parm      *Blanks       P@Vl01          200
     C                   Parm      *Blanks       P@Op02           20
     C                   Parm      *Blanks       P@Vl02          200
     C                   Parm      *Blanks       P@Op03           20
     C                   Parm      *Blanks       P@Vl03          200
     C                   Parm      *Blanks       P@Op04           20
     C                   Parm      *Blanks       P@Vl04          200
     C                   Parm      *Blanks       P@Op05           20
     C                   Parm      *Blanks       P@Vl05          200
     C                   Parm      *Blanks       P@Op06           20
     C                   Parm      *Blanks       P@Vl06          200
     C                   Parm      *Blanks       P@Op07           20
     C                   Parm      *Blanks       P@Vl07          200
     C                   Parm      *Blanks       P@Op08           20
     C                   Parm      *Blanks       P@Vl08          200
     C                   Parm      *Blanks       P@Op09           20
     C                   Parm      *Blanks       P@Vl09          200
     C                   Parm      *Blanks       P@Op10           20
     C                   Parm      *Blanks       P@Vl10          200
 
      **  If the Return Code is blank, set Default Priorities
     C                   If        P@Rtcd = *Blanks
     C                   Eval      DfltPr = P@Vl01
      * PAR = DB1 By name
     C                   Z-ADD     DMBR          WUWMBH                         WH Tax Rate Def Matr
     C                   Z-ADD     DMBO          WUWMBK                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCU          WUWMCY                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCD          WUWMCR                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCT          WUWMCT                         WH Tax Rate Def Matr
     C                   Z-ADD     DMIN          WUWMIS                         WH Tax Rate Def Matr
     C                   Z-ADD     DMMO          WUWMMO                         WH Tax Rate Def Matr
     C                   Z-ADD     DMTY          WUWMTT                         WH Tax Rate Def Matr
     C                   Z-ADD     DMTS          WUWMTS                         WH Tax Rate Def Matr
      *
     C                   Else
      * Data record not found
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SQEXIT
     C                   EndIf
      *
      *================================================================
     CSR   SQEXIT        ENDSR
      /EJECT
     CSR   SRRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSR         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSR         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SREXIT        ENDSR
      /EJECT
     CSR   SSRVGN        BEGSR
      *================================================================
      * Retrieve Single Branch Cd - Bank Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSS         KLIST
     C                   KFLD                    BJBANK                         Bank
      * Move fields to key list
     C                   MOVE      *BLANK        BJBANK                         Bank
     C                   MOVEL     'BANK'        BJBANK                         Bank
     C     KRSSS         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SSEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BJSBRC        WUSBRC                         Single Branch C
     C                   END
      *================================================================
     CSR   SSEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Insert Processing
      *================================================================
      * Create Withholding Tax Rate Dft - Withholding Tax Rate Dft Matrix *
     C                   EXSR      SDCRRC
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
     C                   COMMIT
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
      * Clear All Screen Input Fields
     C                   EXSR      UCSUBR                                       Clear All Scree
     C                   END                                                    *FI
      *================================================================
     CSR   UAEXIT        ENDSR
      /EJECT
     CSR   UBSUBR        BEGSR
      *================================================================
      * Set Key Fields to '*'s if Key field is blank
      *================================================================
      * Move *'s to Blank Keys
      * Branch
      * CASE: PAR.Branch code is blank
     C     BRCH          IFEQ      *BLANK                                       *IF
      * Move * to Branch - Withholding Tax Rate Default Matrix *
     C                   MOVEL     '***'         BRCH                           Branch code
     C                   END                                                    *FI
      * Book Code
      * CASE: PAR.Book Code is equal to blank
     C     BOOK          IFEQ      *BLANK                                       *IF
     C                   MOVE      '**'          BOOK                           Book Code
     C                   END                                                    *FI
      * Currency
      * CASE: PAR.Currency is Blank
     C     CURY          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '***'         CURY                           Currency
     C                   END                                                    *FI
      * Country of Domicile
      * CASE: PAR.Country of Domicile is Blank
     C     CTRY          IFEQ      *BLANK                                       *IF
     C                   MOVE      '**'          CTRY                           Country of Domicile
     C                   END                                                    *FI
      * Customer Type
      * CASE: PAR.Customer Type is Blank
     C     CUTY          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '*'           CUTY                           Customer Type
     C                   END                                                    *FI
      * Institution Code
      * CASE: PAR.Institution Code is Blank
     C     INST          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '**'          INST                           Transaction Type
     C                   END                                                    *FI
      * Module
      * CASE: PAR.Module Code is Blank
     C     MODU          IFEQ      *BLANK                                       *IF
     C                   MOVE      '**'          MODU                           Module
     C                   END                                                    *FI
      * Transaction Type
      * CASE: PAR.Transaction Type is Blank
     C     TRTY          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '********'    TRTY                           Transaction Type
     C                   MOVE      '**'          TRTY                           Transaction Type
     C                   END                                                    *FI
      * Transaction Subtype
      * CASE: PAR.Transaction Subtype is Blank
     C     TRST          IFEQ      *BLANK                                       *IF
     C                   MOVEL     '**'          TRST                           Transaction Subtype
     C                   END                                                    *FI
      *
      *================================================================
     CSR   UBEXIT        ENDSR
      /EJECT
     CSR   UCSUBR        BEGSR
      *================================================================
      * Clear All Screen Input Fields
      *================================================================
     C                   MOVEL     *BLANK        #DWPM1                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM2                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM3                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM4                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM5                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM6                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM7                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM8                         Priority Def WH
     C                   MOVEL     *BLANK        #DWPM9                         Priority Def WH
      *
     C                   MOVEL     *BLANK        #1TXR1                         Dft Tax Rate Code
     C                   MOVEL     *BLANK        #1TXR2                         Dft Tax Rate Code
      *================================================================
     CSR   UCEXIT        ENDSR
      /EJECT
     CSR   UDSUBR        BEGSR
      *================================================================
      * Amend Processing
      *================================================================
      * Delete existing Profit centre record
     C                   MOVEL     WUSPTT        WUTRTY                         Trans Type
      * Delete For Amend W.T.R.D.M. - Withholding Tax Rate Dft Matrix *
     C                   EXSR      SFDLRC
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
      * Create new Withholding Tax Rate record but only increase file controls
      * 'No of Amends' and not 'No Of Inserts' or 'No of Deletes'.
      * Create For Amend W.T.R.D.M - Withholding Tax Rate Default Matrix *
     C                   EXSR      SGCRRC
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
     C                   COMMIT
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   ELSE
      * CASE: PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UDEXIT        ENDSR
      /EJECT
     CSR   UESUBR        BEGSR
      *================================================================
      * Set File Fields to Screen Fields
      *================================================================
     C                   MOVEL     WUBHSN        #1BRCH                         Branch Code
     C                   MOVEL     WUBKSN        #1BOOK                         Book Code
     C                   MOVEL     WUCYSN        #1CURY                         Currency
     C                   MOVEL     WUCRSN        #1CTRY                         Country of Domicile
     C                   MOVEL     WUCTSN        #1CUTY                         Customer Type
     C                   MOVEL     WUISSN        #1INST                         Institution Code
     C                   MOVEL     WUMOSN        #1MODU                         Module
     C                   MOVEL     WUTTSN        #1TRTY                         Transaction Type
     C                   MOVEL     WUTSSN        #1TRST                         Transaction Subtype
      *
      *================================================================
     CSR   UEEXIT        ENDSR
      /EJECT
     CSR   UFSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Branch Code
      *================================================================
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 1st
     C     WUWMBH        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0001                         Priority Def WH
      * Send message 'W.T.R.D.M. Branch   Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 2nd
     C     WUWMBH        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0002                         Priority Def WH
      * Send message 'W.T.R.D.M. Branch   Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 3rd
     C     WUWMBH        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0003                         Priority Def WH
      * Send message 'W.T.R.D.M. Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 4th
     C     WUWMBH        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0004                         Priority Def WH
      * Send message 'W.T.R.D.M. Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 5th
     C     WUWMBH        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0005                         Priority Def WH
      * Send message 'W.T.R.D.M. Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 6th
     C     WUWMBH        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0006                         Priority Def WH
      * Send message 'W.T.R.D.M. Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 7th
     C     WUWMBH        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0007                         Priority Def WH
      * Send message 'W.T.R.D.M. Branch Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 8th
     C     WUWMBH        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0008                         Priority Def WH
      * Send message 'W.T.R.D.M Branch   Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 9th
     C     WUWMBH        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0009                         Priority Def WH
      * Send message 'W.T.R.D.M. Branch Error'
     C                   MOVEL     'USR0761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UFEXIT        ENDSR
      /EJECT
     CSR   UGSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Branch Code
      *================================================================
     C                   MOVEL     @CN(01)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 1st
     C     WUWMBH        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0010                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0011                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0012                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 2nd
     C     WUWMBH        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0013                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0014                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0015                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 3rd
     C     WUWMBH        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0016                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0017                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0018                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 4th
     C     WUWMBH        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0019                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0020                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0021                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 5th
     C     WUWMBH        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0022                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0023                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0024                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 6th
     C     WUWMBH        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0025                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0026                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0027                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.Prof C Def Matrix-Branch is 7th
     C     WUWMBH        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0028                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0029                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0030                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Branch is 8th
     C     WUWMBH        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0031                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0032                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0033                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.Prof C Def Matrix-Branch is 9th
     C     WUWMBH        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0034                         Priority Def WH
     C                   MOVEL     WUBHLN        ZA0035                         Branch  Length
     C                   MOVEL     WUPFIE        ZA0036                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UGEXIT        ENDSR
      /EJECT
     CSR   UHSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Book Code
      *================================================================
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 1st
     C     WUWMBK        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0037                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 2nd
     C     WUWMBK        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0038                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 3rd
     C     WUWMBK        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0039                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 4th
     C     WUWMBK        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0040                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 5th
     C     WUWMBK        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0041                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 6th
     C     WUWMBK        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0042                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 7th
     C     WUWMBK        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0043                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 8th
     C     WUWMBK        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0044                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 9th
     C     WUWMBK        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0045                         Priority Def WH
      * Send message 'W.T.R.D.M Book     Error'
     C                   MOVEL     'USR0758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UHEXIT        ENDSR
      /EJECT
     CSR   UISUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Book Code
      *================================================================
     C                   MOVEL     @CN(02)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 1st
     C     WUWMBK        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0046                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0047                         Book    Length
     C                   MOVEL     WUPFIE        ZA0048                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 2nd
     C     WUWMBK        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0049                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0050                         Book    Length
     C                   MOVEL     WUPFIE        ZA0051                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 3rd
     C     WUWMBK        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0052                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0053                         Book    Length
     C                   MOVEL     WUPFIE        ZA0054                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 4th
     C     WUWMBK        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0055                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0056                         Book    Length
     C                   MOVEL     WUPFIE        ZA0057                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 5th
     C     WUWMBK        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0058                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0059                         Book    Length
     C                   MOVEL     WUPFIE        ZA0060                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 6th
     C     WUWMBK        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0061                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0062                         Book    Length
     C                   MOVEL     WUPFIE        ZA0063                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 7th
     C     WUWMBK        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0064                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0065                         Book    Length
     C                   MOVEL     WUPFIE        ZA0066                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 8th
     C     WUWMBK        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0067                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0068                         Book    Length
     C                   MOVEL     WUPFIE        ZA0069                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Book is 9th
     C     WUWMBK        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0070                         Priority Def WH
     C                   MOVEL     WUBKLN        ZA0071                         Book    Length
     C                   MOVEL     WUPFIE        ZA0072                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UIEXIT        ENDSR
      /EJECT
     CSR   UJSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Currency
      *================================================================
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 1st
     C     WUWMCY        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0073                         Priority Def WH
      * Send message 'W.T.R.D.M Currency Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 2nd
     C     WUWMCY        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0074                         Priority Def WH
      * Send message 'W.T.R.D.M Currency   Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 3rd
     C     WUWMCY        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0075                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 4th
     C     WUWMCY        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0076                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 5th
     C     WUWMCY        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0077                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 6th
     C     WUWMCY        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0078                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 7th
     C     WUWMCY        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0079                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 8th
     C     WUWMCY        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0080                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 9th
     C     WUWMCY        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0081                         Priority Def WH
      * Send message 'W.T.R.D.M Currency     Error'
     C                   MOVEL     'USS0542'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UJEXIT        ENDSR
      /EJECT
     CSR   UKSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Currency Code
      *================================================================
     C                   MOVEL     @CN(03)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 1st
     C     WUWMCY        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0082                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0083                         Currency  Length
     C                   MOVEL     WUPFIE        ZA0084                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 2nd
     C     WUWMCY        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0085                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0086                         Currency  Length
     C                   MOVEL     WUPFIE        ZA0087                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 3rd
     C     WUWMCY        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0088                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0089                         Currency  Length
     C                   MOVEL     WUPFIE        ZA0090                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 4th
     C     WUWMCY        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0091                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0092                         Currency Length
     C                   MOVEL     WUPFIE        ZA0093                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 5th
     C     WUWMCY        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0094                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0095                         Currency Length
     C                   MOVEL     WUPFIE        ZA0096                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 6th
     C     WUWMCY        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0097                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0098                         Currency Length
     C                   MOVEL     WUPFIE        ZA0099                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 7th
     C     WUWMCY        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0100                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0101                         Currency  Length
     C                   MOVEL     WUPFIE        ZA0102                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 8th
     C     WUWMCY        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0103                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0104                         Currency  Length
     C                   MOVEL     WUPFIE        ZA0105                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Currency is 9th
     C     WUWMCY        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0106                         Priority Def WH
     C                   MOVEL     WUCYLN        ZA0107                         Currency  Length
     C                   MOVEL     WUPFIE        ZA0108                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UKEXIT        ENDSR
      /EJECT
     CSR   ULSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Ctry of Domicile
      *================================================================
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 1st
     C     WUWMCR        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0109                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 2nd
     C     WUWMCR        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0110                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom   Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 3rd
     C     WUWMCR        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0111                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom     Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 4th
     C     WUWMCR        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0112                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom  Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 5th
     C     WUWMCR        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0113                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom   Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 6th
     C     WUWMCR        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0114                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom  Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 7th
     C     WUWMCR        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0115                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom   Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 8th
     C     WUWMCR        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0116                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom  Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 9th
     C     WUWMCR        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0117                         Priority Def WH
      * Send message 'W.T.R.D.M Ctry of Dom  Error'
     C                   MOVEL     'USS0543'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   ULEXIT        ENDSR
      /EJECT
     CSR   UMSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Ctry of Dom
      *================================================================
     C                   MOVEL     @CN(04)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 1st
     C     WUWMCR        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0118                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0119                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0120                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 2nd
     C     WUWMCR        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0121                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0122                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0123                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 3rd
     C     WUWMCR        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0124                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0125                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0126                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 4th
     C     WUWMCR        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0127                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0128                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0129                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 5th
     C     WUWMCR        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0130                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0131                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0132                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 6th
     C     WUWMCR        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0133                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0134                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0135                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 7th
     C     WUWMCR        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0136                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0137                         Ctry of Dom Length
     C                   MOVEL     WUPFIE        ZA0138                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 8th
     C     WUWMCR        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0139                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0140                         Ctry of Dom  Length
     C                   MOVEL     WUPFIE        ZA0141                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Ctry of Dom is 9th
     C     WUWMCR        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0142                         Priority Def WH
     C                   MOVEL     WUCRLN        ZA0143                         Ctry of Dom  Length
     C                   MOVEL     WUPFIE        ZA0144                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UMEXIT        ENDSR
      /EJECT
     CSR   UNSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Cust Type
      *================================================================
     C                   MOVEL     @CN(05)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 1st
     C     WUWMCT        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0145                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0146                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0147                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 2nd
     C     WUWMCT        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0148                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0149                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0150                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 3rd
     C     WUWMCT        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0151                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0152                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0153                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 4th
     C     WUWMCT        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0154                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0155                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0156                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 5th
     C     WUWMCT        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0157                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0158                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0159                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 6th
     C     WUWMCT        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0160                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0161                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0162                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 7th
     C     WUWMCT        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0163                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0164                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0165                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 8th
     C     WUWMCT        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0166                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0167                         Cust Type  Length
     C                   MOVEL     WUPFIE        ZA0168                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Cust Type is 9th
     C     WUWMCT        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0169                         Priority Def WH
     C                   MOVEL     WUCTLN        ZA0170                         Cust Type Length
     C                   MOVEL     WUPFIE        ZA0171                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UNEXIT        ENDSR
      /EJECT
     CSR   UOSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Institution Code
      *================================================================
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 1st
     C     WUWMIS        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0172                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 2nd
     C     WUWMIS        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0173                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code   Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 3rd
     C     WUWMIS        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0174                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 4th
     C     WUWMIS        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0175                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 5th
     C     WUWMIS        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0176                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 6th
     C     WUWMIS        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0177                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code  Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 7th
     C     WUWMIS        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0178                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 8th
     C     WUWMIS        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0179                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code  Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 9th
     C     WUWMIS        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0180                         Priority Def WH
      * Send message 'W.T.R.D.M Inst Code Error'
     C                   MOVEL     'USS0544'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UOEXIT        ENDSR
      /EJECT
     CSR   UPSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Inst Code
      *================================================================
     C                   MOVEL     @CN(06)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 1st
     C     WUWMIS        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0181                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0182                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0183                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 2nd
     C     WUWMIS        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0184                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0185                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0186                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 3rd
     C     WUWMIS        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0187                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0188                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0189                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 4th
     C     WUWMIS        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0190                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0191                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0192                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 5th
     C     WUWMIS        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0193                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0194                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0195                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 6th
     C     WUWMIS        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0196                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0197                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0198                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 7th
     C     WUWMIS        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0199                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0200                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0201                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 8th
     C     WUWMIS        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0202                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0203                         Inst Code  Length
     C                   MOVEL     WUPFIE        ZA0204                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Inst Code is 9th
     C     WUWMIS        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0205                         Priority Def WH
     C                   MOVEL     WUISLN        ZA0206                         Inst Code Length
     C                   MOVEL     WUPFIE        ZA0207                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UPEXIT        ENDSR
      /EJECT
     CSR   UQSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Module
      *================================================================
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 1st
     C     WUWMMO        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0208                         Priority Def WH
      * Send message 'W.T.R.D.M Module Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 2nd
     C     WUWMMO        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0209                         Priority Def WH
      * Send message 'W.T.R.D.M Module   Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 3rd
     C     WUWMMO        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0210                         Priority Def WH
      * Send message 'W.T.R.D.M Module Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 4th
     C     WUWMMO        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0211                         Priority Def WH
      * Send message 'W.T.R.D.M Module Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 5th
     C     WUWMMO        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0212                         Priority Def WH
      * Send message 'W.T.R.D.M Module Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 6th
     C     WUWMMO        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0213                         Priority Def WH
      * Send message 'W.T.R.D.M Module  Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 7th
     C     WUWMMO        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0214                         Priority Def WH
      * Send message 'W.T.R.D.M Module Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 8th
     C     WUWMMO        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0215                         Priority Def WH
      * Send message 'W.T.R.D.M Module  Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 9th
     C     WUWMMO        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0216                         Priority Def WH
      * Send message 'W.T.R.D.M Module Error'
     C                   MOVEL     'USS0545'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UQEXIT        ENDSR
      /EJECT
     CSR   URSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Module
      *================================================================
     C                   MOVEL     @CN(07)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 1st
     C     WUWMMO        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0217                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0218                         Module Length
     C                   MOVEL     WUPFIE        ZA0219                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 2nd
     C     WUWMMO        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0220                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0221                         Module Length
     C                   MOVEL     WUPFIE        ZA0222                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 3rd
     C     WUWMMO        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0223                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0224                         Module Length
     C                   MOVEL     WUPFIE        ZA0225                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 4th
     C     WUWMMO        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0226                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0227                         Module Length
     C                   MOVEL     WUPFIE        ZA0228                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 5th
     C     WUWMMO        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0229                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0230                         Module Length
     C                   MOVEL     WUPFIE        ZA0231                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 6th
     C     WUWMMO        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0232                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0233                         Module Length
     C                   MOVEL     WUPFIE        ZA0234                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 7th
     C     WUWMMO        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0235                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0236                         Module Length
     C                   MOVEL     WUPFIE        ZA0237                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 8th
     C     WUWMMO        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0238                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0239                         Module  Length
     C                   MOVEL     WUPFIE        ZA0240                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Module is 9th
     C     WUWMMO        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0241                         Priority Def WH
     C                   MOVEL     WUMOLN        ZA0242                         Module Length
     C                   MOVEL     WUPFIE        ZA0243                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UREXIT        ENDSR
      /EJECT
     CSR   USSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -Trans Type
      *================================================================
     C                   MOVEL     'USS0546'     ZAMSID
     C     #1MODU        IFEQ      'DL'                                         *IF
     C                   MOVEL     'USS0554'     ZAMSID
     C                   ENDIF                                                  *FI
     C     #1MODU        IFEQ      'RE'                                         *IF
     C                   MOVEL     'USS0555'     ZAMSID
     C                   ENDIF                                                  *FI
     C     #1MODU        IFEQ      '  '                                         *IF
     C                   MOVEL     'USS0560'     ZAMSID
     C                   ENDIF                                                  *FI
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 1st
     C     WUWMTT        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0244                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 2nd
     C     WUWMTT        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0245                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 3rd
     C     WUWMTT        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0246                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 4th
     C     WUWMTT        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0247                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 5th
     C     WUWMTT        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0248                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 6th
     C     WUWMTT        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0249                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 7th
     C     WUWMTT        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0250                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 8th
     C     WUWMTT        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0251                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 9th
     C     WUWMTT        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0252                         Priority Def WH
      * Send message 'W.T.R.D.M Trans Type Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   USEXIT        ENDSR
      /EJECT
     CSR   UTSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -Trans Type
      *================================================================
     C                   MOVEL     @CN(08)       WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 1st
     C     WUWMTT        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0253                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0255                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0256                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 2nd
     C     WUWMTT        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0256                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0257                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0258                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 3rd
     C     WUWMTT        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0259                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0260                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0261                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 4th
     C     WUWMTT        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0262                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0263                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0264                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 5th
     C     WUWMTT        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0265                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0266                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0267                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 6th
     C     WUWMTT        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0268                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0269                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0270                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 7th
     C     WUWMTT        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0271                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0272                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0273                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 8th
     C     WUWMTT        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0274                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0275                         Trans Type  Length
     C                   MOVEL     WUPFIE        ZA0276                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-Trans Type is 9th
     C     WUWMTT        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0277                         Priority Def WH
     C                   MOVEL     WUTTLN        ZA0278                         Trans Type Length
     C                   MOVEL     WUPFIE        ZA0279                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UTEXIT        ENDSR
      /EJECT
     CSR   UUSUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field In error -T. Subtype
      *================================================================
     C     W0RTN         IFEQ      'Y2U0005'
     C                   MOVEL     'USS0547'     ZAMSID
     C                   ELSE
     C                   MOVEL     'USS0552'     ZAMSID
     C                   ENDIF
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 1st
     C     WUWMTS        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0280                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 2nd
     C     WUWMTS        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0281                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 3rd
     C     WUWMTS        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0282                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 4th
     C     WUWMTS        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0283                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 5th
     C     WUWMTS        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0284                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 6th
     C     WUWMTS        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0285                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype  Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 7th
     C     WUWMTS        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0286                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 8th
     C     WUWMTS        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0287                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype  Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 9th
     C     WUWMTS        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0288                         Priority Def WH
      * Send message 'W.T.R.D.M T. Subtype Error'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UUEXIT        ENDSR
      /EJECT
     CSR   VASUBR        BEGSR
      *================================================================
      * Seton Screen Error Flag For Function Field Too Long -T. Subtype
      *================================================================
     C                   MOVEL     @CN(9)        WUPFIE                         W.T.R.D.M. Fld In
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 1st
     C     WUWMTS        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM1        ZA0289                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0290                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0291                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 2nd
     C     WUWMTS        IFEQ      2                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM2        ZA0292                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0293                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0294                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 3rd
     C     WUWMTS        IFEQ      3                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM3        ZA0295                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0296                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0297                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 4th
     C     WUWMTS        IFEQ      4                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM4        ZA0298                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0299                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0300                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 5th
     C     WUWMTS        IFEQ      5                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM5        ZA0301                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0302                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0303                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 6th
     C     WUWMTS        IFEQ      6                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM6        ZA0304                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0305                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0306                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 7th
     C     WUWMTS        IFEQ      7                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM7        ZA0307                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0308                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0309                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 8th
     C     WUWMTS        IFEQ      8                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM8        ZA0310                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0311                         T. Subtype  Length
     C                   MOVEL     WUPFIE        ZA0312                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: WRK.WH Tax Rate Def Matrix-T. Subtype is 9th
     C     WUWMTS        IFEQ      9                                            *IF
      * Setup message data for message
     C                   MOVEL     #DWPM9        ZA0313                         Priority Def WH
     C                   MOVEL     WUTSLN        ZA0314                         T. Subtype Length
     C                   MOVEL     WUPFIE        ZA0315                         W.T.R.D.M. Fld In
      * Send message 'W.T.R.D.M. Field too Long'
     C                   MOVEL     'USS0550'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   UVSUBR        BEGSR
      *================================================================
      * Save Input Parameters for deletion of record in amend mode
      *================================================================
     C                   MOVEL     P1BRCH        WUSPBH                         Save W.T.R.D.M. H
     C                   MOVEL     P1BOOK        WUSPBK                         Save W.T.R.D.M. B
     C                   MOVEL     P1CURY        WUSPCY                         Save W.T.R.D.M. C
     C                   MOVEL     P1CTRY        WUSPCR                         Save W.T.R.D.M. D
     C                   MOVEL     P1CUTY        WUSPCT                         Save W.T.R.D.M. U
     C                   MOVEL     P1INST        WUSPIS                         Save W.T.R.D.M. I
     C                   MOVEL     P1MODU        WUSPMO                         Save W.T.R.D.M. M
     C                   MOVEL     P1TRTY        WUSPTT                         Save W.T.R.D.M. T
     C                   MOVEL     P1TRST        WUSPTS                         Save W.T.R.D.M. S
      *
      *================================================================
     CSR   UVEXIT        ENDSR
      /EJECT
     CSR   UWSUBR        BEGSR
      *================================================================
      * Book code
      *================================================================
     C                   MOVEL     P1BOOK        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUBOOK                         Book Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1BOOK        WUBOOK                         Book Code
     C                   END                                                    *FI
      *================================================================
     CSR   UWEXIT        ENDSR
      /EJECT
     CSR   UXSUBR        BEGSR
      *================================================================
      * Currency
      *================================================================
     C                   MOVEL     P1CURY        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUCURY                         Currency
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1CURY        WUCURY                         Currency
     C                   END                                                    *FI
      *================================================================
     CSR   UXEXIT        ENDSR
      /EJECT
     CSR   UYSUBR        BEGSR
      *================================================================
      * Country of Domicile
      *================================================================
     C                   MOVEL     P1CTRY        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUCTRY                         Country of Domicile
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1CTRY        WUCTRY                         Country of Domicile
     C                   END                                                    *FI
      *================================================================
     CSR   UYEXIT        ENDSR
      /EJECT
     CSR   UZSUBR        BEGSR
      *================================================================
      * Branch
      *================================================================
     C                   MOVEL     P1BRCH        WUCAKY                         Check For Aster
      * CASE: WRK.Check For Asterisk in Key is Asterisk
     C     WUCAKY        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        WUBRCH                         Branch code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     P1BRCH        WUBRCH                         Branch code
     C                   END                                                    *FI
      *================================================================
     CSR   UZEXIT        ENDSR
      /EJECT
     CSR   VACKRL1       BEGSR
      *================================================================
      * Check reference to Main Withholding Tax Rate Code
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *
     C     #1TXR1        IFEQ      *BLANK
     C                   GOTO      VACEXT1
     C                   END
      *
     C     KLVADS        KLIST
     C                   KFLD                    WTRC                           Tax Rate Code
      * Setup key
     C                   MOVEL     #1TXR1        WTRC                           Tax Rate Code
     C     KLVADS        CHAIN     SDWTRCD0                           9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VACEXT1
     C                   END
      * Send message 'WH Tax Rate Code       NF'
     C                   MOVEL     'USS0533'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'USS0533'     W0RTN
      *================================================================
     CSR   VACEXT1       ENDSR
      /EJECT
     CSR   VACKRL2       BEGSR
      *================================================================
      * Check reference to Secondary Withholding Tax Rate Code
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *
     C     #1TXR2        IFEQ      *BLANK
     C                   GOTO      VACEXT2
     C                   END
      * Setup key
     C                   MOVEL     #1TXR2        WTRC                           Tax Rate Code
     C     KLVADS        CHAIN     SDWTRCD0                           9091      *
     C     *IN90         IFEQ      '0'
     C     #1TXR1        ANDNE     #1TXR2
      * Record found and different from  no.1 - move back any virtuals
     C                   GOTO      VACEXT2
     C                   END
     C     #1TXR1        IFEQ      #1TXR2
      * Send message 'WH Tax Rate Code       NF'
     C                   MOVEL     'USS0551'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'USS0551'     W0RTN
     C                   ELSE
      * Send message 'WH Tax Rate Code       NF'
     C                   MOVEL     'USS0533'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'USS0533'     W0RTN
     C                   END
      *================================================================
     CSR   VACEXT2       ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      * CASE: DTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
      * CASE: PAR.Action Code is Amend
     C     P2ANCD        IFEQ      'A'                                          *IF
     C                   ROLBK
     C                   END                                                    *FI
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Default Main Tax Rate Code
     C                   MOVEL     *BLANK        WUTXR1            2
      * Define work field Default Secondary Tax Rate Code
     C                   MOVEL     *BLANK        WUTXR2            2
      * Define work field Save W.T.R.D.M. Branch
     C                   MOVEL     *BLANK        WUSPBH            3
      * Define work field Save W.T.R.D.M. Book Code
     C                   MOVEL     *BLANK        WUSPBK            2
      * Define work field Save W.T.R.D.M. Currency
     C                   MOVEL     *BLANK        WUSPCY            3
      * Define work field Save W.T.R.D.M. Country of Domicile
     C                   MOVEL     *BLANK        WUSPCR            2
      * Define work field Save W.T.R.D.M. Customer Type
     C                   MOVEL     *BLANK        WUSPCT            1
      * Define work field Save W.T.R.D.M. Institution Code
     C                   MOVEL     *BLANK        WUSPIS            2
      * Define work field Save W.T.R.D.M. Module
     C                   MOVEL     *BLANK        WUSPMO            2
      * Define work field Save W.T.R.D.M. Transaction Type
     C                   MOVEL     *BLANK        WUSPTT           10
      * Define work field Save W.T.R.D.M. Transaction Subtype
     C                   MOVEL     *BLANK        WUSPTS            2
      * Define work field Save W.T.R.D.M. Country of Risk                                     AUA012
     C                   MOVEL     *BLANK        WUSPCK            2
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field WH Tax Rate Def Matrix-Branch
     C                   Z-ADD     *ZERO         WUWMBH            2 0
      * Define work field WH Tax Rate Def Matrix-Book
     C                   Z-ADD     *ZERO         WUWMBK            2 0
      * Define work field WH Tax Rate Def Matrix-Currency
     C                   Z-ADD     *ZERO         WUWMCY            2 0
      * Define work field WH Tax Rate Def Matrix-Country of Domicile
     C                   Z-ADD     *ZERO         WUWMCR            2 0
      * Define work field WH Tax Rate Def Matrix-Customer Type
     C                   Z-ADD     *ZERO         WUWMCT            2 0
      * Define work field WH Tax Rate Def Matrix-Institution Code
     C                   Z-ADD     *ZERO         WUWMIS            2 0
      * Define work field WH Tax Rate Def Matrix-Module
     C                   Z-ADD     *ZERO         WUWMMO            2 0
      * Define work field WH Tax Rate Def Matrix-Transaction Type
     C                   Z-ADD     *ZERO         WUWMTT            2 0
      * Define work field WH Tax Rate Def Matrix-Transaction Subtype
     C                   Z-ADD     *ZERO         WUWMTS            2 0
      * Define work field WH Tax Rate Def Matrix-Country of Risk                              AUA012
     C                   Z-ADD     *ZERO         WUWMCK            2 0
      * Define work field Branch Code   Screen Fld
     C                   MOVEL     *BLANK        WUBHSN           10
      * Define work field Book Code     Screen Fld
     C                   MOVEL     *BLANK        WUBKSN           10
      * Define work field Currency      Screen Fld
     C                   MOVEL     *BLANK        WUCYSN           10
      * Define work field Country of Domicile Screen Fld
     C                   MOVEL     *BLANK        WUCRSN           10
      * Define work field Customer Type Screen Fld
     C                   MOVEL     *BLANK        WUCTSN           10
      * Define work field Institution Code Screen Fld
     C                   MOVEL     *BLANK        WUISSN           10
      * Define work field Module        Screen Fld
     C                   MOVEL     *BLANK        WUMOSN           10
      * Define work field Transaction Type Screen Fld
     C                   MOVEL     *BLANK        WUTTSN           10
      * Define work field Transaction Subtype Screen Fld
     C                   MOVEL     *BLANK        WUTSSN           10
      * Define work field Country of Risk Screen Fld                                          AUA012
     C                   MOVEL     *BLANK        WUCRSK           10
      * Define work field Branch Code length Check
     C                   MOVEL     *BLANK        WUBHLN            1
      * Define work field W.T.R.D.M. Fld In Error Txt
     C                   MOVEL     *BLANK        WUPFIE           20
      * Define work field Book Code  Length Check
     C                   MOVEL     *BLANK        WUBKLN            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field Currency Length Check
     C                   MOVEL     *BLANK        WUCYLN            1
      * Define work field Deal Sub-type Code
     C                   MOVEL     *BLANK        WUDSTC            2
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Country of Domicile Length Check
     C                   MOVEL     *BLANK        WUCRLN            1
      * Define work field Single Branch Code
     C                   MOVEL     *BLANK        WUSBRC            3
      * Define work field Customer Type Legth Check
     C                   MOVEL     *BLANK        WUCTLN            1
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Institution Code Length Check
     C                   MOVEL     *BLANK        WUISLN            1
      * Define work field Module Length Check
     C                   MOVEL     *BLANK        WUMOLN            1
      * Define work field Transaction Type Length Check
     C                   MOVEL     *BLANK        WUTTLN            2
      * Define work field Transaction Subtype Length Check
     C                   MOVEL     *BLANK        WUTSLN            1
      * Define work field Country of Risk Length Check                                        AUA012
     C                   MOVEL     *BLANK        WUCRLK            1
      * Define work field Check For Asterisk in Key
     C                   MOVEL     *BLANK        WUCAKY            1
      * Define work field Branch Code
     C                   MOVEL     *BLANK        WUBRCH            3
      * Define work field Book Code
     C                   MOVEL     *BLANK        WUBOOK            2
      * Define work field Currency
     C                   MOVEL     *BLANK        WUCURY            3
      * Define work field Country of Domicile
     C                   MOVEL     *BLANK        WUCTRY            3
      * Define work field Customer Type
     C                   MOVEL     *BLANK        WUCUTY            1
      * Define work field Institution Code
     C                   MOVEL     *BLANK        WUINST            2
      * Define work field Module
     C                   MOVEL     *BLANK        WUMODU            2
      * Define work field Transaction Type
     C                   MOVEL     *BLANK        WUTRTY           10
      * Define work field Transaction Subtype
     C                   MOVEL     *BLANK        WUTRST            2
      * Define work field Country of Risk                                                     AUA012
     C                   MOVEL     *BLANK        WUCTRK            3
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
     C* Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   OPEN      SD000208DF
     C                   OPEN      SDWTDML0
     C                   OPEN      SDFCTLL0
     C                   OPEN      SDWTDML1
     C                   OPEN      SDWTRCL1
     C                   OPEN      SDBRCHL1
     C                   OPEN      SDBOOKL1
     C                   OPEN      SDCURRL2
     C                   OPEN      SDCTRYL1
     C                   OPEN      SDINSTL1
     C                   OPEN      SDMMODL1
     C                   OPEN      SDACODL1
     C*****              OPEN      SDRETLPD
     C*****              OPEN      INVTO
     C                   OPEN      FDDTSTL1
     C                   OPEN      SDBANKL1
      * Dummy move for compiler
     C                   MOVE      '0'           @CN#(1)
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * SD0491V Precompiler - Profit Centre Dft Matrix  *
      * End of change S01459.
      * Copyright Statement 1988 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Obtain Withholding Tax Rate Def Pty - General Ledger Details  *
     C                   EXSR      SQRVGN
     C                   MOVEL     'Y'           WUMFTS                         S01212
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Withholding Tax Rate Def Mat DATA DS - Withholding Tax Rate Default Matrix *
      * Get 'Window required' ind - MIDAS Trans Types  *
     C                   EXSR      SRRVGN
     C                   END                                                    *FI
      * Start of Fix LN0592
      * Retrieve Single Branch Cd - Bank Details  *
     C                   EXSR      SSRVGN
      * End of Fix LN0592
      * Load screen
     C                   EXSR      MALDSC
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      * Standard Midas PSSR processing.
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'PSSR   '     P0RTN
     C                   DUMP
      *
      ** Route job back into Midas.
      *
     C                   SETON                                        LR
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
      *
**CTDATA SHR2
Branch Code ........
Book Code ..........
Currency ...........
Country of Domicile.
Customer Type ......
Institution Code ...
Module .............
Product Type........
Product Subtype.....
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2015
**CTDATA @CN#
00001 Branch Code
00002 Book Code
00003 Currency
00004 Country of Domicile
00005 Customer Type
00006 Institution Code
00007 Module
00008 Product Type
00009 Product Subtype
