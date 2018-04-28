     H
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Select currency codes')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GP000020S - Select Currency Codes                            *
      *                                                               *
      *  Function:  This program allows a user to select a Currency   *
      *             Code.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031  *CREATE   Date 10Apr06                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
     F*****************************************************************
     FGP000020S#CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Select Currency Codes
      *
     FGPCURRL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Currency codes retrieval
      *
      /EJECT
      ** Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure
 
     D JBDTTM          DS
      ** Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
 
      ** ABO Define large string for CL cmd
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
 
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D A@CPY           DS
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      /EJECT
 
      ** Parameter declarations
     D P1PARM          DS
      ** FLD: Currency Codes
      ** B : MAP Currency Code
     D  P1CYCD                 1      3
      /EJECT
      *****************************************************************
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1CYCD        PARM      P1CYCD        WP0001            3
      *****************************************************************
      ** Initialize
     C                   EXSR      ZZINIT
 
     C                   DO        *HIVAL                                       DO
      ** Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      ** Display screen until reload requested
     C     W0RSF         DOWEQ     'N'                                          DOW
      ** Display screen
     C                   EXSR      CAEXFM
      ** Process response
      ** Cancel & exit program
     C   03              CAS                     ZXEXPG
      ** HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      ** Display next SFL page
     C   27              CAS                     BBLDSF
      ** Process screen input
     C                   CAS                     DAPR##
     C                   END
 
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BAIZSF - Initialise and load subfile page                    *
      *                                                               *
      *****************************************************************
     C     BAIZSF        BEGSR
 
      ** Clear subfile
 
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      ** Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
 
      ** Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    GCCYCD                         Currency Code
      ** Setup key
     C                   MOVEL     #2CYCD        GCCYCD                         Currency Code
     C     KPOS          SETLL     GPCURRD0
     C                   READ      GPCURRD0                             8782    *
      ** Save previous selector values
     C     *LIKE         DEFINE    #2SPAE        WZSPAE
     C                   MOVEL     #2SPAE        WZSPAE                         Spot Trade Acco
     C     *LIKE         DEFINE    #2FTAE        WZFTAE
     C                   MOVEL     #2FTAE        WZFTAE                         Fwd Trade Accou
     C     *LIKE         DEFINE    #2SWAE        WZSWAE
     C                   MOVEL     #2SWAE        WZSWAE                         Swap Trade Acco
     C     *LIKE         DEFINE    #2TAC4        WZTAC4
     C                   MOVEL     #2TAC4        WZTAC4                         Trade Account C
     C     *LIKE         DEFINE    #2TAC5        WZTAC5
     C                   MOVEL     #2TAC5        WZTAC5                         Trade Account C
     C     *LIKE         DEFINE    #2CDFN        WZCDFN
     C                   MOVEL     #2CDFN        WZCDFN                         Cedel Default N
     C     *LIKE         DEFINE    #2ECDN        WZECDN
     C                   MOVEL     #2ECDN        WZECDN                         Euroclear Defau
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYLC        WZTYLC
     C                   MOVEL     #2TYLC        WZTYLC                         Type of Last Ch
     C     *LIKE         DEFINE    #2SWCY        WZSWCY
     C                   MOVEL     #2SWCY        WZSWCY                         Swift Currency
     C     *LIKE         DEFINE    #2TXND        WZTXND
     C                   MOVEL     #2TXND        WZTXND                         Telex Notice Da
     C     *LIKE         DEFINE    #2PRRT        WZPRRT
     C                   MOVEL     #2PRRT        WZPRRT                         Par Rate
     C     *LIKE         DEFINE    #2SRC1        WZSRC1
     C                   MOVEL     #2SRC1        WZSRC1                         Statutory Retur
     C     *LIKE         DEFINE    #2SRC2        WZSRC2
     C                   MOVEL     #2SRC2        WZSRC2                         Statutory Retur
     C     *LIKE         DEFINE    #2SSNB        WZSSNB
     C                   MOVEL     #2SSNB        WZSSNB                         Sort Sequence N
     C     *LIKE         DEFINE    #2ERLC        WZERLC
     C                   MOVEL     #2ERLC        WZERLC                         Exchange Rate -
     C     *LIKE         DEFINE    #2MDIN        WZMDIN
     C                   MOVEL     #2MDIN        WZMDIN                         Multiply/Divide
     C     *LIKE         DEFINE    #2MDPR        WZMDPR
     C                   MOVEL     #2MDPR        WZMDPR                         Multiply/Divide
     C     *LIKE         DEFINE    #2MDHB        WZMDHB
     C                   MOVEL     #2MDHB        WZMDHB                         Multiply/Divide
     C     *LIKE         DEFINE    #2MDEX        WZMDEX
     C                   MOVEL     #2MDEX        WZMDEX                         Multiply/Divide
     C     *LIKE         DEFINE    #2NOSN        WZNOSN
     C                   MOVEL     #2NOSN        WZNOSN                         Nostro Shortnam
     C     *LIKE         DEFINE    #2SPDY        WZSPDY
     C                   MOVEL     #2SPDY        WZSPDY                         Spot Days
     C     *LIKE         DEFINE    #2HSRT        WZHSRT
     C                   MOVEL     #2HSRT        WZHSRT                         High Spot Rate
     C     *LIKE         DEFINE    #2LSPR        WZLSPR
     C                   MOVEL     #2LSPR        WZLSPR                         Low Spot Rate
     C     *LIKE         DEFINE    #2FXSD        WZFXSD
     C                   MOVEL     #2FXSD        WZFXSD                         DRS FX Spot Dat
     C     *LIKE         DEFINE    #2MMSD        WZMMSD
     C                   MOVEL     #2MMSD        WZMMSD                         DRS MM Spot Dat
     C     *LIKE         DEFINE    #2NQDP        WZNQDP
     C                   MOVEL     #2NQDP        WZNQDP                         Normally Quoted
     C     *LIKE         DEFINE    #2DICB        WZDICB
     C                   MOVEL     #2DICB        WZDICB                         Default Int. Ca
     C     *LIKE         DEFINE    #2SCEX        WZSCEX
     C                   MOVEL     #2SCEX        WZSCEX                         Scaling Exponen
     C     *LIKE         DEFINE    #2EBDA        WZEBDA
     C                   MOVEL     #2EBDA        WZEBDA                         Eurobond Data
     C     *LIKE         DEFINE    #2HBRT        WZHBRT
     C                   MOVEL     #2HBRT        WZHBRT                         Historic Broker
     C     *LIKE         DEFINE    #2ENC1        WZENC1
     C                   MOVEL     #2ENC1        WZENC1                         Euroclear Numer
     C     *LIKE         DEFINE    #2ENC2        WZENC2
     C                   MOVEL     #2ENC2        WZENC2                         Euroclear Numer
     C     *LIKE         DEFINE    #2CACD        WZCACD
     C                   MOVEL     #2CACD        WZCACD                         Cedel Alpha Cod
     C     *LIKE         DEFINE    #2CNMC        WZCNMC
     C                   MOVEL     #2CNMC        WZCNMC                         Cedel Numeric C
     C     *LIKE         DEFINE    #2WEDH        WZWEDH
     C                   MOVEL     #2WEDH        WZWEDH                         WED. Holiday
     C     *LIKE         DEFINE    #2MONH        WZMONH
     C                   MOVEL     #2MONH        WZMONH                         MON. Holiday
     C     *LIKE         DEFINE    #2TUEH        WZTUEH
     C                   MOVEL     #2TUEH        WZTUEH                         TUES. Holiday
     C     *LIKE         DEFINE    #2THUH        WZTHUH
     C                   MOVEL     #2THUH        WZTHUH                         THURS. Holiday
     C     *LIKE         DEFINE    #2FRIH        WZFRIH
     C                   MOVEL     #2FRIH        WZFRIH                         FRI. Holiday
     C     *LIKE         DEFINE    #2SATH        WZSATH
     C                   MOVEL     #2SATH        WZSATH                         SAT. Holiday
     C     *LIKE         DEFINE    #2SUNH        WZSUNH
     C                   MOVEL     #2SUNH        WZSUNH                         SUN. Holiday
     C     *LIKE         DEFINE    #2DPBF        WZDPBF
     C                   MOVEL     #2DPBF        WZDPBF                         Dec.Places in B
     C     *LIKE         DEFINE    #2BYSR        WZBYSR
     C                   MOVEL     #2BYSR        WZBYSR                         Buy Spread Rate
     C     *LIKE         DEFINE    #2BYSS        WZBYSS
     C                   MOVEL     #2BYSS        WZBYSS                         Buy Spread Sign
     C     *LIKE         DEFINE    #2SLSR        WZSLSR
     C                   MOVEL     #2SLSR        WZSLSR                         Sell Spread Rat
     C     *LIKE         DEFINE    #2SLSS        WZSLSS
     C                   MOVEL     #2SLSS        WZSLSS                         Sell Spread Sig
     C     *LIKE         DEFINE    #2CYCD        WZCYCD
     C                   MOVEL     #2CYCD        WZCYCD                         Currency Code
     C     *LIKE         DEFINE    #2CYNM        WZCYNM
     C                   MOVEL     #2CYNM        WZCYNM                         Currency Name
     C     *LIKE         DEFINE    #2SPRT        WZSPRT
     C                   MOVEL     #2SPRT        WZSPRT                         Spot Rate
     C     *LIKE         DEFINE    #2NBDP        WZNBDP
     C                   MOVEL     #2NBDP        WZNBDP                         Number of Decim
     C     *LIKE         DEFINE    #2DLCI        WZDLCI
     C                   MOVEL     #2DLCI        WZDLCI                         Dealing Currenc
      ** Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2EBDA        WQEBDA                         Eurobond Data
     C                   CALL      'QDCXLATE'
      ** Length
     C                   PARM      29            WQA5N             5 0
     C                   PARM      #2EBDA        WQEBDA                         Eurobond Data
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
     C     *LIKE         DEFINE    #2CYNM        WQCYNM                         Currency Name
     C                   CALL      'QDCXLATE'
      ** Length
     C                   PARM      14            WQA5N             5 0
     C                   PARM      #2CYNM        WQCYNM                         Currency Name
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      ** Load subfile page
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   EXSR      BBLDSF
 
     C     BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BBLDSF - Load subfile page                                   *
      *                                                               *
      *****************************************************************
     C     BBLDSF        BEGSR
 
      ** Re-establish fields in read-ahead record
 
     C   27              DO
     C  N82              READP     GPCURRD0                               90    *
     C  N82              READ      GPCURRD0                               90    *
     C                   END
 
      ** Setof record error indicators
     C                   MOVE      *ALL'0'       WKINDS            1
     C                   MOVEA     WKINDS        *IN(36)
      ** Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      ** Reset count of DBF records read
     C                   Z-ADD     *ZERO         ##RRRD            5 0
      ** Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      ** Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
 
      ** Load next SFL page until SFL page full,
      ** or scan limit reached,
      ** or end of file reached
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      ** Check selection fields - if fail, read next record
     C     #2SPAE        IFNE      *BLANK                                       Spot Trade Acco
     C     GCSPAE        CABNE     #2SPAE        CD020                          Spot Trade Acco
     C                   END
     C     #2FTAE        IFNE      *BLANK                                       Fwd Trade Accou
     C     GCFTAE        CABNE     #2FTAE        CD020                          Fwd Trade Accou
     C                   END
     C     #2SWAE        IFNE      *BLANK                                       Swap Trade Acco
     C     GCSWAE        CABNE     #2SWAE        CD020                          Swap Trade Acco
     C                   END
     C     #2TAC4        IFNE      *BLANK                                       Trade Account C
     C     GCTAC4        CABNE     #2TAC4        CD020                          Trade Account C
     C                   END
     C     #2TAC5        IFNE      *BLANK                                       Trade Account C
     C     GCTAC5        CABNE     #2TAC5        CD020                          Trade Account C
     C                   END
     C     #2CDFN        IFNE      *BLANK                                       Cedel Default N
     C     GCCDFN        CABNE     #2CDFN        CD020                          Cedel Default N
     C                   END
     C     #2ECDN        IFNE      *BLANK                                       Euroclear Defau
     C     GCECDN        CABNE     #2ECDN        CD020                          Euroclear Defau
     C                   END
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     GCLCD         CABNE     #2LCD         CD020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C     GCCHTP        CABNE     #2TYLC        CD020                          Type of Last Ch
     C                   END
     C     #2SWCY        IFNE      *BLANK                                       Swift Currency
     C     GCSWCY        CABNE     #2SWCY        CD020                          Swift Currency
     C                   END
     C     #2TXND        IFNE      *ZERO                                        Telex Notice Da
     C     GCTXND        CABNE     #2TXND        CD020                          Telex Notice Da
     C                   END
     C     #2PRRT        IFNE      *ZERO                                        Par Rate
     C     GCPRRT        CABNE     #2PRRT        CD020                          Par Rate
     C                   END
     C     #2SRC1        IFNE      *ZERO                                        Statutory Retur
     C     GCSRC1        CABNE     #2SRC1        CD020                          Statutory Retur
     C                   END
     C     #2SRC2        IFNE      *ZERO                                        Statutory Retur
     C     GCSRC2        CABNE     #2SRC2        CD020                          Statutory Retur
     C                   END
     C     #2SSNB        IFNE      *ZERO                                        Sort Sequence N
     C     GCSSNB        CABNE     #2SSNB        CD020                          Sort Sequence N
     C                   END
     C     #2ERLC        IFNE      *ZERO                                        Exchange Rate -
     C     GCERLC        CABNE     #2ERLC        CD020                          Exchange Rate -
     C                   END
     C     #2MDIN        IFNE      *BLANK                                       Multiply/Divide
     C     GCMDIN        CABNE     #2MDIN        CD020                          Multiply/Divide
     C                   END
     C     #2MDPR        IFNE      *BLANK                                       Multiply/Divide
     C     GCMDPR        CABNE     #2MDPR        CD020                          Multiply/Divide
     C                   END
     C     #2MDHB        IFNE      *BLANK                                       Multiply/Divide
     C     GCMDHB        CABNE     #2MDHB        CD020                          Multiply/Divide
     C                   END
     C     #2MDEX        IFNE      *BLANK                                       Multiply/Divide
     C     GCMDEX        CABNE     #2MDEX        CD020                          Multiply/Divide
     C                   END
     C     #2NOSN        IFNE      *BLANK                                       Nostro Shortnam
      ** Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GCNOSN                         Nostro Shortnam
      ** Length
     C                   PARM      10            WQA3N             3 0
      ** Start
     C                   PARM      1             WQB3N             3 0
      ** Mask
     C                   PARM                    #2NOSN
      ** Length
     C                   PARM      10            WQC3N             3 0
      ** Translate
     C                   PARM      '1'           WQD1              1
      ** Trim
     C                   PARM      '1'           WQE1              1
      ** Wild
     C                   PARM      '?'           WQF1              1
      ** Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             CD020
     C                   END
     C     #2SPDY        IFNE      *ZERO                                        Spot Days
     C     GCSPDY        CABNE     #2SPDY        CD020                          Spot Days
     C                   END
     C     #2HSRT        IFNE      *ZERO                                        High Spot Rate
     C     GCHSRT        CABNE     #2HSRT        CD020                          High Spot Rate
     C                   END
     C     #2LSPR        IFNE      *ZERO                                        Low Spot Rate
     C     GCLSPR        CABNE     #2LSPR        CD020                          Low Spot Rate
     C                   END
     C     #2FXSD        IFNE      *ZERO                                        DRS FX Spot Dat
     C     GCFXSD        CABNE     #2FXSD        CD020                          DRS FX Spot Dat
     C                   END
     C     #2MMSD        IFNE      *ZERO                                        DRS MM Spot Dat
     C     GCMMSD        CABNE     #2MMSD        CD020                          DRS MM Spot Dat
     C                   END
     C     #2NQDP        IFNE      *ZERO                                        Normally Quoted
     C     GCNQDP        CABNE     #2NQDP        CD020                          Normally Quoted
     C                   END
     C     #2DICB        IFNE      *BLANK                                       Default Int. Ca
     C     GCDICB        CABNE     #2DICB        CD020                          Default Int. Ca
     C                   END
     C     #2SCEX        IFNE      *ZERO                                        Scaling Exponen
     C     GCSCEX        CABNE     #2SCEX        CD020                          Scaling Exponen
     C                   END
     C     #2EBDA        IFNE      *BLANK                                       Eurobond Data
      ** Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GCEBDA                         Eurobond Data
      ** Length
     C                   PARM      29            WQA3N             3 0
      ** Start
     C                   PARM      1             WQB3N             3 0
      ** Mask
     C                   PARM                    WQEBDA
      ** Length
     C                   PARM      29            WQC3N             3 0
      ** Translate
     C                   PARM      '1'           WQD1              1
      ** Trim
     C                   PARM      '1'           WQE1              1
      ** Wild
     C                   PARM      '?'           WQF1              1
      ** Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             CD020
     C                   END
     C     #2HBRT        IFNE      *ZERO                                        Historic Broker
     C     GCHBRT        CABNE     #2HBRT        CD020                          Historic Broker
     C                   END
     C     #2ENC1        IFNE      *ZERO                                        Euroclear Numer
     C     GCENC1        CABNE     #2ENC1        CD020                          Euroclear Numer
     C                   END
     C     #2ENC2        IFNE      *ZERO                                        Euroclear Numer
     C     GCENC2        CABNE     #2ENC2        CD020                          Euroclear Numer
     C                   END
     C     #2CACD        IFNE      *BLANK                                       Cedel Alpha Cod
      ** Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GCCACD                         Cedel Alpha Cod
      ** Length
     C                   PARM      3             WQA3N             3 0
      ** Start
     C                   PARM      1             WQB3N             3 0
      ** Mask
     C                   PARM                    #2CACD
      ** Length
     C                   PARM      3             WQC3N             3 0
      ** Translate
     C                   PARM      '1'           WQD1              1
      ** Trim
     C                   PARM      '1'           WQE1              1
      ** Wild
     C                   PARM      '?'           WQF1              1
      ** Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             CD020
     C                   END
     C     #2CNMC        IFNE      *ZERO                                        Cedel Numeric C
     C     GCCNMC        CABNE     #2CNMC        CD020                          Cedel Numeric C
     C                   END
     C     #2WEDH        IFNE      *BLANK                                       WED. Holiday
     C     GCWEDH        CABNE     #2WEDH        CD020                          WED. Holiday
     C                   END
     C     #2MONH        IFNE      *BLANK                                       MON. Holiday
     C     GCMONH        CABNE     #2MONH        CD020                          MON. Holiday
     C                   END
     C     #2TUEH        IFNE      *BLANK                                       TUES. Holiday
     C     GCTUEH        CABNE     #2TUEH        CD020                          TUES. Holiday
     C                   END
     C     #2THUH        IFNE      *BLANK                                       THURS. Holiday
     C     GCTHUH        CABNE     #2THUH        CD020                          THURS. Holiday
     C                   END
     C     #2FRIH        IFNE      *BLANK                                       FRI. Holiday
     C     GCFRIH        CABNE     #2FRIH        CD020                          FRI. Holiday
     C                   END
     C     #2SATH        IFNE      *BLANK                                       SAT. Holiday
     C     GCSATH        CABNE     #2SATH        CD020                          SAT. Holiday
     C                   END
     C     #2SUNH        IFNE      *BLANK                                       SUN. Holiday
     C     GCSUNH        CABNE     #2SUNH        CD020                          SUN. Holiday
     C                   END
     C     #2DPBF        IFNE      *ZERO                                        Dec.Places in B
     C     GCDPBF        CABNE     #2DPBF        CD020                          Dec.Places in B
     C                   END
     C     #2BYSR        IFNE      *ZERO                                        Buy Spread Rate
     C     GCBYSR        CABNE     #2BYSR        CD020                          Buy Spread Rate
     C                   END
     C     #2BYSS        IFNE      *BLANK                                       Buy Spread Sign
     C     GCBYSS        CABNE     #2BYSS        CD020                          Buy Spread Sign
     C                   END
     C     #2SLSR        IFNE      *ZERO                                        Sell Spread Rat
     C     GCSLSR        CABNE     #2SLSR        CD020                          Sell Spread Rat
     C                   END
     C     #2SLSS        IFNE      *BLANK                                       Sell Spread Sig
     C     GCSLSS        CABNE     #2SLSS        CD020                          Sell Spread Sig
     C                   END
     C     #2CYNM        IFNE      *BLANK                                       Currency Name
      ** Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    GCDESC                         Currency Name
      ** Length
     C                   PARM      14            WQA3N             3 0
      ** Start
     C                   PARM      1             WQB3N             3 0
      ** Mask
     C                   PARM                    WQCYNM
      ** Length
     C                   PARM      14            WQC3N             3 0
      ** Translate
     C                   PARM      '1'           WQD1              1
      ** Trim
     C                   PARM      '1'           WQE1              1
      ** Wild
     C                   PARM      '?'           WQF1              1
      ** Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             CD020
     C                   END
     C     #2SPRT        IFNE      *ZERO                                        Spot Rate
     C     GCSPRT        CABNE     #2SPRT        CD020                          Spot Rate
     C                   END
     C     #2NBDP        IFNE      *ZERO                                        Number of Decim
     C     GCNBDP        CABNE     #2NBDP        CD020                          Number of Decim
     C                   END
     C     #2DLCI        IFNE      *BLANK                                       Dealing Currenc
     C     GCDLCI        CABNE     #2DLCI        CD020                          Dealing Currenc
     C                   END
      ** Load SFL fields
     C                   EXSR      MBFL#1
      ** Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      ** If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
     C                   WRITE     #SFLRCD
      *
     C     CD020         TAG
      ** Increment scan check count
     C                   ADD       1             ##RRRD
      ** Read next record
     C                   READ      GPCURRD0                             8782    *
     C                   END                                                    WOD
 
      ** If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      ** Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
 
      ** Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      ** Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
 
      ** If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      ** Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   END
 
     C     BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CAEXFM - Display screen                                      *
      *                                                               *
      *****************************************************************
     C     CAEXFM        BEGSR
 
      ** Update screen time
 
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      ** PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
      ** Set cursor by *SET CURSOR data
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      ** Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      ** Test cursor
     C                   EXSR      Y8TST
      ** Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      ** If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      ** Update job time
     C                   TIME                    ##JTM
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      ** Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         9283    *
 
     C     CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DAPR## - Process screen input                                *
      *                                                               *
      *****************************************************************
     C     DAPR##        BEGSR
 
      ** Validate Dealing Currency Ind.
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2DLCI        W0NSRQ            1            Dealing Currenc
      ** Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100770       Y2LSNO            7 0
     C     #2DLCI        PARM      #2DLCI        W0EXVL           20            Dealing Currenc
      ** Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
 
     C     *IN81         IFEQ      '1'
      ** Process subfile records
     C                   EXSR      DBPRSF
      ** If error, exit subroutine:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END
      ** Change of position specified
     C     WZSPAE        CASNE     #2SPAE        FBRQRL                         Spot Trade Acco
     C     WZFTAE        CASNE     #2FTAE        FBRQRL                         Fwd Trade Accou
     C     WZSWAE        CASNE     #2SWAE        FBRQRL                         Swap Trade Acco
     C     WZTAC4        CASNE     #2TAC4        FBRQRL                         Trade Account C
     C     WZTAC5        CASNE     #2TAC5        FBRQRL                         Trade Account C
     C     WZCDFN        CASNE     #2CDFN        FBRQRL                         Cedel Default N
     C     WZECDN        CASNE     #2ECDN        FBRQRL                         Euroclear Defau
     C     WZLCD         CASNE     #2LCD         FBRQRL                         Last Change Dat
     C     WZTYLC        CASNE     #2TYLC        FBRQRL                         Type of Last Ch
     C     WZSWCY        CASNE     #2SWCY        FBRQRL                         Swift Currency
     C     WZTXND        CASNE     #2TXND        FBRQRL                         Telex Notice Da
     C     WZPRRT        CASNE     #2PRRT        FBRQRL                         Par Rate
     C     WZSRC1        CASNE     #2SRC1        FBRQRL                         Statutory Retur
     C     WZSRC2        CASNE     #2SRC2        FBRQRL                         Statutory Retur
     C     WZSSNB        CASNE     #2SSNB        FBRQRL                         Sort Sequence N
     C     WZERLC        CASNE     #2ERLC        FBRQRL                         Exchange Rate -
     C     WZMDIN        CASNE     #2MDIN        FBRQRL                         Multiply/Divide
     C     WZMDPR        CASNE     #2MDPR        FBRQRL                         Multiply/Divide
     C     WZMDHB        CASNE     #2MDHB        FBRQRL                         Multiply/Divide
     C     WZMDEX        CASNE     #2MDEX        FBRQRL                         Multiply/Divide
     C     WZNOSN        CASNE     #2NOSN        FBRQRL                         Nostro Shortnam
     C     WZSPDY        CASNE     #2SPDY        FBRQRL                         Spot Days
     C     WZHSRT        CASNE     #2HSRT        FBRQRL                         High Spot Rate
     C     WZLSPR        CASNE     #2LSPR        FBRQRL                         Low Spot Rate
     C     WZFXSD        CASNE     #2FXSD        FBRQRL                         DRS FX Spot Dat
     C     WZMMSD        CASNE     #2MMSD        FBRQRL                         DRS MM Spot Dat
     C     WZNQDP        CASNE     #2NQDP        FBRQRL                         Normally Quoted
     C     WZDICB        CASNE     #2DICB        FBRQRL                         Default Int. Ca
     C     WZSCEX        CASNE     #2SCEX        FBRQRL                         Scaling Exponen
     C     WZEBDA        CASNE     #2EBDA        FBRQRL                         Eurobond Data
     C     WZHBRT        CASNE     #2HBRT        FBRQRL                         Historic Broker
     C     WZENC1        CASNE     #2ENC1        FBRQRL                         Euroclear Numer
     C     WZENC2        CASNE     #2ENC2        FBRQRL                         Euroclear Numer
     C     WZCACD        CASNE     #2CACD        FBRQRL                         Cedel Alpha Cod
     C     WZCNMC        CASNE     #2CNMC        FBRQRL                         Cedel Numeric C
     C     WZWEDH        CASNE     #2WEDH        FBRQRL                         WED. Holiday
     C     WZMONH        CASNE     #2MONH        FBRQRL                         MON. Holiday
     C     WZTUEH        CASNE     #2TUEH        FBRQRL                         TUES. Holiday
     C     WZTHUH        CASNE     #2THUH        FBRQRL                         THURS. Holiday
     C     WZFRIH        CASNE     #2FRIH        FBRQRL                         FRI. Holiday
     C     WZSATH        CASNE     #2SATH        FBRQRL                         SAT. Holiday
     C     WZSUNH        CASNE     #2SUNH        FBRQRL                         SUN. Holiday
     C     WZDPBF        CASNE     #2DPBF        FBRQRL                         Dec.Places in B
     C     WZBYSR        CASNE     #2BYSR        FBRQRL                         Buy Spread Rate
     C     WZBYSS        CASNE     #2BYSS        FBRQRL                         Buy Spread Sign
     C     WZSLSR        CASNE     #2SLSR        FBRQRL                         Sell Spread Rat
     C     WZSLSS        CASNE     #2SLSS        FBRQRL                         Sell Spread Sig
     C     WZCYCD        CASNE     #2CYCD        FBRQRL                         Currency Code
     C     WZCYNM        CASNE     #2CYNM        FBRQRL                         Currency Name
     C     WZSPRT        CASNE     #2SPRT        FBRQRL                         Spot Rate
     C     WZNBDP        CASNE     #2NBDP        FBRQRL                         Number of Decim
     C     WZDLCI        CASNE     #2DLCI        FBRQRL                         Dealing Currenc
     C                   END
 
     C     DAEXIT        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DBPRSF - Process modified sufile record                      *
      *                                                               *
      *****************************************************************
     C     DBPRSF        BEGSR
 
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      ** Process subfile record
     C                   EXSR      DCSFRC
     C                   MOVEL     *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
      ** Read next record
     C                   READC     #SFLRCD                                92    *
     C                   END
 
     C     DBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DCSFRC - Process subfile record                              *
      *                                                               *
      *****************************************************************
     C     DCSFRC        BEGSR
 
      ** Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKINDS        *IN(36)
     C                   SETOFF                                       84        *
      ** Check selection option
     C     #1SEL         CASEQ     '1'           DESLRC
     C                   END
 
     C     DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DESLRC - Select record & return to calling program           *
      *                                                               *
      *****************************************************************
     C     DESLRC        BEGSR
 
      ** Move record values to parameters
 
     C                   MOVEL     #1CYCD        P1CYCD                         Currency Code
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
 
     C     DEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FBRQRL - Request subfile reload                              *
      *                                                               *
      *****************************************************************
     C     FBRQRL        BEGSR
 
     C                   MOVEL     'Y'           W0RSF
 
     C     FBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MBFL#1 - Move to Subfile record                              *
      *                                                               *
      *****************************************************************
     C     MBFL#1        BEGSR
 
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     GCSPAE        #1SPAE                         Spot Trade Acco
     C                   MOVEL     GCFTAE        #1FTAE                         Fwd Trade Accou
     C                   MOVEL     GCSWAE        #1SWAE                         Swap Trade Acco
     C                   MOVEL     GCTAC4        #1TAC4                         Trade Account C
     C                   MOVEL     GCTAC5        #1TAC5                         Trade Account C
     C                   MOVEL     GCCDFN        #1CDFN                         Cedel Default N
     C                   MOVEL     GCECDN        #1ECDN                         Euroclear Defau
     C                   Z-ADD     GCLCD         #1LCD                          Last Change Dat
     C                   MOVEL     GCCHTP        #1TYLC                         Type of Last Ch
     C                   MOVEL     GCSWCY        #1SWCY                         Swift Currency
     C                   Z-ADD     GCTXND        #1TXND                         Telex Notice Da
     C                   Z-ADD     GCPRRT        #1PRRT                         Par Rate
     C                   Z-ADD     GCSRC1        #1SRC1                         Statutory Retur
     C                   Z-ADD     GCSRC2        #1SRC2                         Statutory Retur
     C                   Z-ADD     GCSSNB        #1SSNB                         Sort Sequence N
     C                   Z-ADD     GCERLC        #1ERLC                         Exchange Rate -
     C                   MOVEL     GCMDIN        #1MDIN                         Multiply/Divide
     C                   MOVEL     GCMDPR        #1MDPR                         Multiply/Divide
     C                   MOVEL     GCMDHB        #1MDHB                         Multiply/Divide
     C                   MOVEL     GCMDEX        #1MDEX                         Multiply/Divide
     C                   MOVEL     GCNOSN        #1NOSN                         Nostro Shortnam
     C                   Z-ADD     GCSPDY        #1SPDY                         Spot Days
     C                   Z-ADD     GCHSRT        #1HSRT                         High Spot Rate
     C                   Z-ADD     GCLSPR        #1LSPR                         Low Spot Rate
     C                   Z-ADD     GCFXSD        #1FXSD                         DRS FX Spot Dat
     C                   Z-ADD     GCMMSD        #1MMSD                         DRS MM Spot Dat
     C                   Z-ADD     GCNQDP        #1NQDP                         Normally Quoted
     C                   MOVEL     GCDICB        #1DICB                         Default Int. Ca
     C                   Z-ADD     GCSCEX        #1SCEX                         Scaling Exponen
     C                   MOVEL     GCEBDA        #1EBDA                         Eurobond Data
     C                   Z-ADD     GCHBRT        #1HBRT                         Historic Broker
     C                   Z-ADD     GCENC1        #1ENC1                         Euroclear Numer
     C                   Z-ADD     GCENC2        #1ENC2                         Euroclear Numer
     C                   MOVEL     GCCACD        #1CACD                         Cedel Alpha Cod
     C                   Z-ADD     GCCNMC        #1CNMC                         Cedel Numeric C
     C                   MOVEL     GCWEDH        #1WEDH                         WED. Holiday
     C                   MOVEL     GCMONH        #1MONH                         MON. Holiday
     C                   MOVEL     GCTUEH        #1TUEH                         TUES. Holiday
     C                   MOVEL     GCTHUH        #1THUH                         THURS. Holiday
     C                   MOVEL     GCFRIH        #1FRIH                         FRI. Holiday
     C                   MOVEL     GCSATH        #1SATH                         SAT. Holiday
     C                   MOVEL     GCSUNH        #1SUNH                         SUN. Holiday
     C                   Z-ADD     GCDPBF        #1DPBF                         Dec.Places in B
     C                   Z-ADD     GCBYSR        #1BYSR                         Buy Spread Rate
     C                   MOVEL     GCBYSS        #1BYSS                         Buy Spread Sign
     C                   Z-ADD     GCSLSR        #1SLSR                         Sell Spread Rat
     C                   MOVEL     GCSLSS        #1SLSS                         Sell Spread Sig
     C                   Z-ADD     GCRMCM        #1RMCM                         RM Cashflow Mag
     C                   MOVEL     GCRECI        #1RECI                         Record Id
     C                   MOVEL     GCDPRU        #1DPRU                         Default Priorit
     C                   MOVEL     GCDNOR        #1DNOR                         Delivery Notifi
     C                   MOVEL     GCNDWR        #1NDWR                         Non-Delivery Wa
     C                   MOVEL     GCGMPY        #1GMPY                         Generate Multip
     C                   MOVEL     GCDLCD        #1DLCD                         Delivery Code
     C                   MOVEL     GCRDFC        #1RDFC                         Round Down Inte
     C                   MOVEL     GCPMRT        #1PMRT                         Precious Metal
     C                   Z-ADD     GCRKSQ        #1RKSQ                         Currency Rankin
     C                   MOVEL     GCDFPC        #1DFPC                         Dft Fx Poss Pro
     C                   MOVEL     GCDDPC        #1DDPC                         Dft Dir Fund Pr
     C                   Z-ADD     GCTKCC        #1TKCC                         Telekurs Curren
     C                   Z-ADD     GCCQCD        #1CQCD                         Cheque Clearing
     C                   Z-ADD     GCSMLD        #1SMLD                         Smallest Denomi
     C                   MOVEL     GCCSCD        #1CSCD                         Cash Account Co
     C                   Z-ADD     GCISON        #1ISON                         Numeric ISO Cur
     C                   MOVEL     GCISFC        #1ISFC                         ISDA Financial
     C                   MOVEL     GCMACD        #1MACD                         Major Currency
     C                   MOVEL     GCFRAC        #1FRAC                         Fractions Flag
     C                   MOVEL     GCNUWD        #1NUWD                         Numbers and Wor
     C                   MOVEL     GCMICD        #1MICD                         Minor Currency
     C                   MOVEL     GCCYCD        #1CYCD                         Currency Code
     C                   MOVEL     GCDESC        #1CYNM                         Currency Name
     C                   Z-ADD     GCSPRT        #1SPRT                         Spot Rate
     C                   Z-ADD     GCNBDP        #1NBDP                         Number of Decim
     C                   MOVEL     GCDLCI        #1DLCI                         Dealing Currenc
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
 
     C     MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MEIZ#2 - Initialise subfile control                          *
      *                                                               *
      *****************************************************************
     C     MEIZ#2        BEGSR
 
     C                   MOVEL     *BLANK        #2SPAE                         Spot Trade Acco
     C                   MOVEL     *BLANK        #2FTAE                         Fwd Trade Accou
     C                   MOVEL     *BLANK        #2SWAE                         Swap Trade Acco
     C                   MOVEL     *BLANK        #2TAC4                         Trade Account C
     C                   MOVEL     *BLANK        #2TAC5                         Trade Account C
     C                   MOVEL     *BLANK        #2CDFN                         Cedel Default N
     C                   MOVEL     *BLANK        #2ECDN                         Euroclear Defau
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #2SWCY                         Swift Currency
     C                   Z-ADD     *ZERO         #2TXND                         Telex Notice Da
     C                   Z-ADD     *ZERO         #2PRRT                         Par Rate
     C                   Z-ADD     *ZERO         #2SRC1                         Statutory Retur
     C                   Z-ADD     *ZERO         #2SRC2                         Statutory Retur
     C                   Z-ADD     *ZERO         #2SSNB                         Sort Sequence N
     C                   Z-ADD     *ZERO         #2ERLC                         Exchange Rate -
     C                   MOVEL     *BLANK        #2MDIN                         Multiply/Divide
     C                   MOVEL     *BLANK        #2MDPR                         Multiply/Divide
     C                   MOVEL     *BLANK        #2MDHB                         Multiply/Divide
     C                   MOVEL     *BLANK        #2MDEX                         Multiply/Divide
     C                   MOVEL     *BLANK        #2NOSN                         Nostro Shortnam
     C                   Z-ADD     *ZERO         #2SPDY                         Spot Days
     C                   Z-ADD     *ZERO         #2HSRT                         High Spot Rate
     C                   Z-ADD     *ZERO         #2LSPR                         Low Spot Rate
     C                   Z-ADD     *ZERO         #2FXSD                         DRS FX Spot Dat
     C                   Z-ADD     *ZERO         #2MMSD                         DRS MM Spot Dat
     C                   Z-ADD     *ZERO         #2NQDP                         Normally Quoted
     C                   MOVEL     *BLANK        #2DICB                         Default Int. Ca
     C                   Z-ADD     *ZERO         #2SCEX                         Scaling Exponen
     C                   MOVEL     *BLANK        #2EBDA                         Eurobond Data
     C                   Z-ADD     *ZERO         #2HBRT                         Historic Broker
     C                   Z-ADD     *ZERO         #2ENC1                         Euroclear Numer
     C                   Z-ADD     *ZERO         #2ENC2                         Euroclear Numer
     C                   MOVEL     *BLANK        #2CACD                         Cedel Alpha Cod
     C                   Z-ADD     *ZERO         #2CNMC                         Cedel Numeric C
     C                   MOVEL     *BLANK        #2WEDH                         WED. Holiday
     C                   MOVEL     *BLANK        #2MONH                         MON. Holiday
     C                   MOVEL     *BLANK        #2TUEH                         TUES. Holiday
     C                   MOVEL     *BLANK        #2THUH                         THURS. Holiday
     C                   MOVEL     *BLANK        #2FRIH                         FRI. Holiday
     C                   MOVEL     *BLANK        #2SATH                         SAT. Holiday
     C                   MOVEL     *BLANK        #2SUNH                         SUN. Holiday
     C                   Z-ADD     *ZERO         #2DPBF                         Dec.Places in B
     C                   Z-ADD     *ZERO         #2BYSR                         Buy Spread Rate
     C                   MOVEL     *BLANK        #2BYSS                         Buy Spread Sign
     C                   Z-ADD     *ZERO         #2SLSR                         Sell Spread Rat
     C                   MOVEL     *BLANK        #2SLSS                         Sell Spread Sig
     C                   MOVEL     P1CYCD        #2CYCD                         Currency Code
     C                   MOVEL     *BLANK        #2CYNM                         Currency Name
     C                   Z-ADD     *ZERO         #2SPRT                         Spot Rate
     C                   Z-ADD     *ZERO         #2NBDP                         Number of Decim
     C                   MOVEL     *BLANK        #2DLCI                         Dealing Currenc
      * Drop ? from positioning key fields
     C                   MOVEL     #2CYCD        W0X1              1
     C     W0X1          IFEQ      '?'
     C     *LIKE         DEFINE    #2CYCD        W0CYCD          - 1
     C                   MOVE      #2CYCD        W0CYCD
     C                   MOVEL     W0CYCD        #2CYCD                         Currency Code
     C                   MOVE      ' '           #2CYCD
     C                   END
 
     C     MEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Y8TST - Test Cursor                                          *
      *                                                               *
      *****************************************************************
     C     Y8TST         BEGSR
 
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
 
     C     Y8EXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      ** Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
 
     C     ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZHHPKY - Display HELP text                                   *
      *                                                               *
      *****************************************************************
     C     ZHHPKY        BEGSR
 
      ** Signal help request
     C                   MOVEL     'Y'           W0HLP             1
 
      ** Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
 
      ** Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
 
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
 
      ** Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
 
     C     ZHEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZXEXPG - Cancel & exit program                               *
      *                                                               *
      *****************************************************************
     C     ZXEXPG        BEGSR
 
      ** Send message '*No value selected'
 
     C                   MOVEL     'Y2U0016'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y2U0016'     P0RTN
     C                   EXSR      ZYEXPG
 
     C     ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZYEXPG - Exit Program: Direct                                *
      *                                                               *
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Terminate program
     C                   SETON                                        LR
 
      ** Exit program
     C                   RETURN
 
     C     ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZZINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     ZZINIT        BEGSR
 
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
      ** Setup job date/time
 
     C                   Z-ADD     UDATE         ##JDT
      ** Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      ** Update screen time
     C                   TIME                    ##TME             6 0
      ** Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      ** Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      ** Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      ** Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      ** Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      ** Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      ** Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      ** Move main file information to JOB context
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
      ** Open files
     C                   OPEN      GP000020S#
     C                   OPEN      GPCURRL1
     C                   MOVEL     'N'           W0PMT             1
      ** Program mode
     C                   MOVEL     'SEL'         W0PMD             3
 
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      ** Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      ** Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      ** Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      ** Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
     C                   MOVEL     *BLANK        W0GRP             1
      ** USER: Initialize program
      ** Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      ** Copyright Statement - Standard Functions  * copyright
     C                   Z-ADD     99999         W0SLM                          *Scan limit
      ** Clear subfile control fields
     C                   EXSR      MEIZ#2
 
     C     ZZEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'PSSR   '     P0RTN
     C                   DUMP
 
      ** Route job back into Midas
 
     C                   MOVE      *ON           *INLR
     C                   CALL      'DBERRCTL'
     C                   END
 
     C                   ENDSR
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2006
