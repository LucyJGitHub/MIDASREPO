     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM CSW213 Initialisation Program')               *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00118 - Initialise SWIFT ISO Country Codes file and       *
      *             Country Codes Table                               *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD023678           Date 21Nov13               *
      *                 MD023120           Date 12Nov13               *
      *                 MD022852           Date 16Oct13               *
      *                 MD021816           Date 26Aug13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023678 - IBAN is incorrectly generated due to wrong        *
      *             BBAN Bank Length                                  *
      *  MD023120 - Re-run of ISO Country Code initialisation program *
      *             should not reset the values that were previously  *
      *             set-up by the bank                                *
      *  MD022852 - Countries description must be in CAPS during      *
      *             initialization                                    *
      *  MD021816 - ISO Country Code IM's IBAN Req MT102/103 field is *
      *             not initialised to 'N'.                           *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      *
     FMEISOCL2  UF A E           K DISK
     FSDCTRYL2  UF A E           K DISK
     FMEIBNSL0  IF   E           K DISK                                                     MD023120
      *
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)                         MD023120
      *                                                                                     MD023120
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD023120
      *                                                                                     MD023120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD023120
      *                                                                                     MD023120
     D RUNDAT        E DS                  EXTNAME(RUNDAT)                                  MD022852
      *                                                                                     MD022852
      ** The Following /COPY Line Includes All The Defined Fields In                        MD022852
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.                           MD022852
      *                                                                                     MD022852
     D/COPY ZACPYSRC,PSDS                                                                   MD022852
      *                                                                                     MD022852
     DISOCtyCdAR       S             57    DIM(83) CTDATA
      *
     DISOCtyCdDS       DS
     D DSISOC                  1      2
     D DSIBAC                  3      4
     D DSIBAR                  5      5
     D DSSCHT                  6      6
     D DSSEPA                  7      7
     D DSISOD                  8     37
     D DSBISP                 38     39  0
     D DSBILN                 40     41  0
     D DSBRSP                 42     43  0
     D DSBRLN                 44     45  0
     D DSINLN                 46     47  0
     D DSACSP                 48     49  0
     D DSACLN                 50     51  0
     D DSTILN                 52     53  0
     D DSBBLN                 54     55  0
     D DSTBLN                 56     57  0
      *
     D UpCase          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZÎ'                    MD022852
     D LoCase          C                   'abcdefghijklmnopqrstuvwxyzî'                    MD022852
      *
     DIx               S              3  0 INZ(0)
      *                                                                                     MD023120
     D CFT004          S              1                                                     MD023120
     D CSW213          S              1                                                     MD023120
     D CFT050          S              1                                                     MD023120
     D RetCode         S              7                                                     MD023120
     D Mode            S              1                                                     MD023120
     D PRtCd           S              7                                                     MD023120
     D POptn           S              7                                                     MD023120
     D PSard           S              6                                                     MD023120
 
      *****************************************************************                     MD023120
      *                                                               *                     MD023120
      *  SRMain - Main Subroutine                                     *                     MD023120
      *                                                               *                     MD023120
      *  Called by: *INZSR                                            *                     MD023120
      *                                                               *                     MD023120
      *****************************************************************                     MD023120
      *
      ** Main Processing
      *
     C     SRMAIN        BEGSR                                                              MD023120
      *                                                                                     MD023120
     C     *DTAARA       DEFINE                  RUNDAT                                     MD022852
     C                   IN        RUNDAT                                                   MD022852
      *                                                                                     MD022852
     C     *LOVAL        SETLL     MEIBNSL0                                                 MD023120
     C                   READ      MEIBNSL0                                                 MD023120
     C                   IF        %EOF(MEIBNSL0)                                           MD023120
      *                                                                                     MD023120
     C                   EVAL      Ix = 1
 
     C                   DOW       Ix <= 83
     C                   MOVE      ISOCtyCdAR(Ix)ISOCtyCdDS
 
     C     DSISOC        CHAIN     MEISOCL2
     C                   IF        %FOUND(MEISOCL2)
     C                   IF        Mode = '1' AND M3IBAC = *BLANKS                          MD023120
     C                   EXSR      SRNewFlds
     C                   EXSR      SRJobFlds                                                MD022852
     C                   EVAL      M3ACTY = 'A'                                             MD022852
     C                   UPDATE    MEISOCD0
     C                   ENDIF                                                              MD023120
     C                   ELSE
     C                   CLEAR                   MEISOCD0                                   MD022852
     C                   EXSR      SROldFlds
     C                   EXSR      SRNewFlds
     C                   EXSR      SRJobFlds                                                MD022852
     C                   EVAL      M3ACTY = 'I'                                             MD022852
     C                   WRITE     MEISOCD0
     C                   ENDIF
 
     C     DSISOC        CHAIN     SDCTRYL2
     C                   IF        %FOUND(SDCTRYL2)
     C                             AND (Mode = '1' OR NOT %FOUND(MEISOCL2))                 MD023120
 
     C                   IF        DSISOC = DSIBAC
     C                   EVAL      A4BBAN = DSBBLN
     C**********         EVAL      A4BBRL = DSBILN                                          MD023678
     C                   EVAL      A4BBRL = DSTBLN                                          MD023678
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      DSIBAC = 'FI'
     C                   EVAL      A4BBAN = 14
     C                   EVAL      A4BBRL = 6
     C                   WHEN      DSIBAC = 'FR' OR
     C                             DSIBAC = 'IT'
     C                   EVAL      A4BBAN = 23
     C**********         EVAL      A4BBRL = 5                                               MD023678
     C                   EVAL      A4BBRL = 10                                              MD023678
     C                   WHEN      DSIBAC = 'GB'
     C                   EVAL      A4BBAN = 18
     C**********         EVAL      A4BBRL = 4                                               MD023678
     C                   EVAL      A4BBRL = 10                                              MD023678
     C                   WHEN      DSIBAC = 'NO'
     C                   EVAL      A4BBAN = 11
     C                   EVAL      A4BBRL = 4
     C                   ENDSL
     C                   ENDIF
 
     C                   UPDATE    SDCTRYD0
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
                                                                                            MD023120
     C                   ENDIF                                                              MD023120
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR                                                              MD023120
      *****************************************************************
      *                                                               *
      *  SRNewFlds - Set up new MEISOCPD fields                       *
      *                                                               *
      *  Called By: Main                                              *
      *                                                               *
      *****************************************************************
 
     C     SRNewFlds     BEGSR
 
     C                   EVAL      M3SCHT = DSSCHT
     C                   EVAL      M3SEPA = DSSEPA
     C                   EVAL      M3IBAC = DSIBAC
     C                   EVAL      M3IBAR = DSIBAR
     C                   EVAL      M3OCDT = 0
     C                   EVAL      M3MCDT = 0
     C                   EVAL      M3CCSP = 1
     C                   EVAL      M3CCLN = 2
     C                   EVAL      M3ICSP = 3
     C                   EVAL      M3ICLN = 2
 
     C                   IF        DSBBLN <> 0
     C                   EVAL      M3BBSP = 5
     C                   ELSE
     C                   EVAL      M3BBSP = 0
     C                   ENDIF
 
     C                   EVAL      M3BISP = DSBISP
     C                   EVAL      M3BILN = DSBILN
     C                   EVAL      M3BRSP = DSBRSP
     C                   EVAL      M3BRLN = DSBRLN
     C                   EVAL      M3INLN = DSINLN
     C                   EVAL      M3ACSP = DSACSP
     C                   EVAL      M3ACLN = DSACLN
     C                   EVAL      M3TILN = DSTILN
     C                   EVAL      M3BBLN = DSBBLN
     C                   EVAL      M3TBLN = DSTBLN
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SROldFlds - Set up old MEISOCPD fields                       *
      *                                                               *
      *  Called By: Main                                              *
      *                                                               *
      *****************************************************************
 
     C     SROldFlds     BEGSR
 
     C                   EVAL      M3ISOC = DSISOC
     C**********         EVAL      M3ISOD = DSISOD                                          MD022852
     C                   EVAL      M3ISOD = %XLATE(LoCase:UpCase:DSISOD)                    MD022852
     C                   EVAL      M3EEAM = 'N'
     C                   EVAL      M3FATF = 'N'
     C                   EVAL      M3MFID = 'N'
     C                   EVAL      M3M205 = 'N'
 
     C                   ENDSR
      *****************************************************************                     MD022852
      *                                                               *                     MD022852
      *  SRJobFlds - Set up job MEISOCPD fields                       *                     MD022852
      *                                                               *                     MD022852
      *  Called By: Main                                              *                     MD022852
      *                                                               *                     MD022852
      *****************************************************************                     MD022852
     C     SRJobFlds     BEGSR                                                              MD022852
                                                                                            MD022852
     C                   EVAL      M3ACJN = PSJobName                                       MD022852
     C                   EVAL      M3ACUN = PSUser                                          MD022852
     C                   EVAL      M3ACTM = PSRunTime                                       MD022852
     C                   EVAL      M3ACDA = AGMRDT                                          MD022852
                                                                                            MD022852
     C                   ENDSR                                                              MD022852
      *****************************************************************                     MD023120
      *                                                               *                     MD023120
      *  *INZSR - Initialization Subroutine                           *                     MD023120
      *                                                               *                     MD023120
      *  Called By: Main                                              *                     MD023120
      *                                                               *                     MD023120
      *****************************************************************                     MD023120
                                                                                            MD023120
     C     *INZSR        BEGSR                                                              MD023120
                                                                                            MD023120
      ** Entry parameters                                                                   MD023120
                                                                                            MD023120
     C     *ENTRY        PLIST                                                              MD023120
     C                   PARM                    RetCode                                    MD023120
     C                   PARM                    Mode                                       MD023120
                                                                                            MD023120
      ** Check if CFT004 (IBAN Numbers) is switched on                                      MD023120
                                                                                            MD023120
     C                   CALL      'AOSARDR0'                                               MD023120
     C                   PARM      *BLANKS       PRtCd                                      MD023120
     C                   PARM      '*VERIFY'     POptn                                      MD023120
     C                   PARM      'CFT004'      PSard                                      MD023120
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD023120
                                                                                            MD023120
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                  MD023120
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD023120
     C                   EVAL      DBKEY  = 'CFT004'                                        MD023120
     C                   EVAL      DBASE  = 1                                               MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
     C                   EVAL      CFT004 = 'N'                                             MD023120
     C                   IF        PRtCd = *BLANKS                                          MD023120
     C                   EVAL      CFT004 = 'Y'                                             MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
      ** Check if CSW213 (SWIFT 2013) is switched on                                        MD023120
                                                                                            MD023120
     C                   CALL      'AOSARDR0'                                               MD023120
     C                   PARM      *BLANKS       PRtCd                                      MD023120
     C                   PARM      '*VERIFY'     POptn                                      MD023120
     C                   PARM      'CSW213'      PSard                                      MD023120
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD023120
                                                                                            MD023120
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                  MD023120
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD023120
     C                   EVAL      DBKEY  = 'CSW213'                                        MD023120
     C                   EVAL      DBASE  = 2                                               MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
     C                   EVAL      CSW213 = 'N'                                             MD023120
     C                   IF        PRtCd = *BLANKS                                          MD023120
     C                   EVAL      CSW213 = 'Y'                                             MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
      ** Check is CFT050 (SWIFTRef Directories Upload) is switched on                       MD023120
                                                                                            MD023120
     C                   CALL      'AOSARDR0'                                               MD023120
     C                   PARM      *BLANKS       PRtCd                                      MD023120
     C                   PARM      '*VERIFY'     POptn                                      MD023120
     C                   PARM      'CFT050'      PSard                                      MD023120
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD023120
                                                                                            MD023120
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                  MD023120
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD023120
     C                   EVAL      DBKEY  = 'CFT050'                                        MD023120
     C                   EVAL      DBASE  = 3                                               MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
     C                   EVAL      CFT050 = 'N'                                             MD023120
     C                   IF        PRtCd = *BLANKS                                          MD023120
     C                   EVAL      CFT050 = 'Y'                                             MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
     C                   IF        (CSW213 = 'Y' OR CFT050 = 'Y')                           MD023120
     C                             AND CFT004 = 'Y'                                         MD023120
     C                   EXSR      SRMAIN                                                   MD023120
     C                   ELSE                                                               MD023120
     C                   EVAL      *INLR = *ON                                              MD023120
     C                   RETURN                                                             MD023120
     C                   ENDIF                                                              MD023120
                                                                                            MD023120
     C                   ENDSR                                                              MD023120
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      ** Added ADADYY Andorra and BRBR   Brazil
      ** IBANReqInMT102103 is mandatory; Changed BBANBankLen of WF to 0;
      ** Amend IM IBAN Req MT102/103 field to 'N'                                           MD021816
** ISOCtyCdAR
ADADYY Andorra                       05040904081312242000
AEAEN  United Arab Emirates          05030000000816231903
ALALN  Albania                       05030805081316282408
ATATYYYAustria                       05050000051011201605
AXFIN YAland Islands                 05060000021108181406
AZAZN  Republic of Azerbaijan        05040000000920282404
BABAN  Bosnia and Herzegovina        05030803031110201606
BEBEYYYBelgium                       05030000030809161203
BGBGYYYBulgaria                      05040904081310221808
BHBHN  Bahrain                       05040000000914221804
BLFRN  Saint Barthelemy              05051005101513272310
BRBRN  Brazil                        05081305001812292508
BVNOYY Bouvet Island                 05040000040907151104
CHCHYYYSwitzerland                   05050000051012211705
CRCRN  Costa Rica                    05030000000814211703
CYCYYYYCyprus                        05030805081316282408
CZCZYYYCzech Republic                05040000040916242004
DEDEYYYGermany                       05080000081310221808
DKDKYYYDenmark                       05040000040910181404
DODON  Dominican Republic            05040000000920282404
EEEEYYYEstonia                       05020000020714201602
ESESYYYSpain                         05040904081312242008
FIFIYYYFinland                       05060000021108181406
FOFON YFaeroe Island                 05040000040910181404
FRFRYYYFrance                        05051005101513272310
GBGBYYYUnited Kingdom                05040906101508221810
GEGEN  Georgia                       05020000000716221802
GFFRYYYFrench Guyana                 05051005101513272310
GGGBN  Guernsey                      05040906101508221810
GIGIYYYGibraltar                     05040000040915231904
GLGLN YGreenland                     05040000040910181404
GPFRYYYGuadeloupe                    05051005101513272310
GRGRYYYGreece                        05030804071216272307
GTGTN  Guatemala                     05040000000920282404
HRHRN  Croatia                       05070000071210211707
HUHUYYYHungary                       05030804071217282407
IEIEYYYIreland                       05040906101508221810
ILILYN Israel                        05030803061113231906
IMGBN  Island of Man                 05040906101508221810
ISISYYYIceland                       05040000040918262204
ITITYYYItaly                         06051105101612272310
JEGBN  Jersey                        05040906101508221810
KWKWN  Kuwait                        05040000000922302604
KZKZN  Kazakhstan                    05030000000813201603
LBLBN  Lebanon                       05040000000920282404
LILIYYYLiechtenstein(Principality of)05050000051012211705
LTLTYYYLithuania                     05050000051011201605
LULUYYYLuxembourg                    05030000030813201603
LVLVYYYLatvia                        05040000040913211704
MCMCYYYMonaco                        05051005101513272310
MDMDN  Republic of Moldova           05020000000718242002
MEMEN  Montenegro                    05030000030815221803
MFFRN  Saint Martin (French Part)    05051005101513272310
MKMKN  Macedonia                     05030000030812191503
MQFRYYYMartinique                    05051005101513272310
MRMRN  Mauritania                    05051005001513272310
MTMTYYYMalta                         05040905091418312709
MUMUN  Mauritius                     05061102081318302608
NCFRN  New Caledonia                 05051005101513272310
NLNLYYYThe Netherland                05040000040910181404
NONOYYYNorway                        05040000040907151104
PFFRN  French Polynesia              05051005101513272310
PKPKN  Pakistan                      05040000000916242004
PLPLYYYPoland                        05080000081316282408
PMFRYYYSaint Pierre et Miquelon      05051005101513272310
PSPSN  Palestinian Territory,Occupied05040000000921292504
PTPTYYYPortugal                      05040904081313252108
REFRYYYReunion                       05051005101513272310
ROROYYYRomania                       05040000040916242004
RSRSN  Serbia                        05030000030815221803
SASAN  Saudi Arabia                  05020000020718242002
SESEYYYSweden                        05030000030817242003
SISIYYYSlovenia                      05050000021010191505
SJNOYY Svalbard et île jan mayen     05040000040907151104
SKSKYYYSlovak Republic               05040000040916242004
SMSMYY San Marino                    06051105101612272310
TFFRYY French Southern Territories   05051005101513272310
TNTNN  Tunisia                       05020703021015242005
TRTRN  Turkey                        05050000051017262205
VAITN  Vatican                       06051105101612272310
VGVGN  Virgin Islands, British       05040000000916242004
WFFRN  Wallis and Futuna Islands     05051005101513272300
YTFRN YMayotte                       05051005101513272310
