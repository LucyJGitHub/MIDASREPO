     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  OVRDBF FILE(GPICTYL0) TOFILE(GPICTRYL0)                      *              CGP001 MD058188
/*OVR *  OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                     *                       CSD031
/**** *  RPGBASE                                                      *                     MD058188
/*STD *  RPGSQLBND                                                    *                     MD058188
/*EXI *  TEXT('Midas SD Country codes maintenance')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0181R - Edit country codes                                 *
      *                                                               *
      *  Function:  This program maintaines country codes records     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD058188           Date 11May21               *
      *                 MD058081           Date 11May21               *
      *                 247341             Date 24May19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD030956           Date 09Oct14               *
      *                 CTI006             Date 31Mar14               *
      *                 MD027804           Date 30Jun14               *
      *                 MD027093           Date 30May14               *
      *                 MD026498           Date 29Apr14               *
      *                 CGL132             Date 01May13               *
      *                 MD021672           Date 22Aug13               *
      *                 MD023056           Date 28Oct13               *
      *                 MD022332           Date 10Sep13               *
      *                 CSW213             Date 03Jun13               *
      *                 AR754499           Date 05May11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25904           Date 09Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255381             Date 11Jul08               *
      *                 BUG14090           Date 01Jun07               *
      *                 BUG13884           Date 07May07               *
      *                 239141             Date 06Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 BUG11806           Date 30Jul06               *
      *                 BUG11779           Date 25Jul06               *
      *                 BUG11769           Date 25Jul06               *
      *                 BUG11706           Date 17Jul06               *
      *                 BUG11705           Date 17Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 236137             Date 21Sep05               *
      *                 233195             Date 25Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 232543             Date 29Mar05               *
      *                 CGL032             Date 05Jul04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3164            Date 10Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 TCA105             Date 01Apr04               *
      *                 CGP001             Date 08Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             DATE 07Jul99               *
      *                 CFT004             Date 22Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD003             Date 02JAN98               *
      *                 122096             DATE 22AUG97               *
      *                 S01408             DATE 02AUG96               *
      *                 S01461             DATE 14JAN94               *
      *                 S01459             DATE 14JAN94               *
      *                 S01461             Date 17JAN94               *
      *                 S01459             Date 17JAN94               *
      *                 S01437             Date  9SEP93               *
      *                 S01117             Date 07MAR90               *
      *                 S01216             Date 10FEB90               *
      *                 S01212             Date 24JAN90               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058188 - Deliverable Data Split for Global files           *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  247341 - Do not validate if the country code is ISO standard *
      *           during deletion. Applied for MD031175               *
      *         - Applied for MD053397.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *             (Recompile)                                       *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  MD027804 - Fields should be in a protected mode during       *
      *             delete action                                     *
      *  MD027093 - Country Codes Issues (Recompile)                  *
      *  MD026498 - Mandatory field country of tax is disabled        *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD021672 - Amending a country code validates ISOM screen     *
      *  MD023056 - Warning error should still allow to continue      *
      *             transaction of country                            *
      *  MD022332 - Warning error is not displayed when ISO country   *
      *             code is found in ISO country code                 *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  AR754499 - In the Country Codes Maintenance, fields Currency *
      *             of Tax and Country of Tax (Y/N) are not being     *
      *             displayed (Child: AR754500)                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  CSC043 - MidasPlus IASP Enablement                           *
      *  BUG25904 - Reverse 255381.
      *  255381 - Allow up to 34 in BBAN Length                       *
      *  BUG14090 - Error displayed upon selecting region code        *
      *  BUG13884 - Data mapping error on member SDCTRYL0             *
      *  239141 - Do not allow deletion of country code if there is   *
      *           still an active customer in SDCUSTPD where BBCNCZ   *
      *           equals the country code to be deleted.              *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG11806 - Extension tables processing.                      *
      *  BUG11779 - Changed CSD031's display indicator from 41 to 50  *
      *             to accomodate proper display of screen fields     *
      *             (Recompile)                                       *
      *  BUG11769 - Accept to Zone narrative became Central Data and  *
      *             Effective Date field became protected             *
      *  BUG11706 - Error message appears when amending details       *
      *  BUG11705 - CSD031 is *OFF, Eff Date and Central Data fields  *
      *             are displayed. *IN45 was used by 232543.          *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  236137 - Change Control for CGL031                           *
      *  233195 - Ctry Codes Maint Rpt Freq and Joint A/C Type default*
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *  BUG3644 - Serious Error in Collateralised Lending            *
      *  BUG3164 - Field Weighting Code is blank in file SDCTRYPD.    *
      *            Need to ensure that zero is written to file        *
      *            instead of blank during insert or amend operation. *
      *  CGL014 - Collaterals Processing                              *
      *  TCA105 - Country Name should be free-format if CGP001 is on  *
      *  CGP001 - Global Processing.                                  *
      *           - SDWEIG* files renamed to GPWEIG*.                 *
      *           - AOWEIGR0 renamed to GPAOWEIGR0.                   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  122096 - Addition of call to SD0520X to save deleted         *
      *           records for audit during COB.                       *
      *  S01408 - Addition of core hook:                              *
      *           - WN0481CCP1 (shared window hook)                   *
      *  S01461 - The Midas Export module processing was removed      *
      *           and moved to the Eureka platform.                   *
      *  S01459 - Addition of Midas headerbox.                        *
      *  S01437 - ADDITION OF 'MIDAS EXPORT VALUE MLOC'               *
      *  S01117 - RELEASE 10 PROCESSING                               *
      *  S01216 - SYNON R1 ENHANCEMENTS                               *
      *  S01212 - /Copy and Window Processing                         *
      *                                                               *
      *****************************************************************
     F*
     F/COPY WNCPYSRC,SD0181RFPG
     F*
     FSD0181R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Country codes maintenance
      *
     FSDCTRYL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Country Codes             Retrieval index
      *
     F*GPCTRYL1* IF   E           K DISK    USROPN                                          MD058188
     F**********                           INFDS(ID0005)                                    MD058188
     F**********                           INFSR(*PSSR)                                     MD058188
     F**********                           RENAME(GPCTRYD0:GPCTRYD1)                        MD058188
      * RTV : Country Codes             Retrieval index                                       CSD031
      *                                                                                       CSD031
     FSDREGNL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Region Codes              Retrieval index
      *
     FGPREGNL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0006)
     F                                     INFSR(*PSSR)
      * RTV : Region Codes              Retrieval index                                       CSD031
      *                                                                                       CSD031
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     FSDCTRYL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Country codes update
      *
     F*GPCTRYL0* UF A E           K DISK    USROPN                                          MD058188
     F**********                           COMMIT                                           MD058188
      * UPD : Central Country codes update                                                    CSD031
      *                                                                                       CSD031
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061007
     F**********                           COMMIT                                           MD061007
     F**********                           INFDS(ID0004)                                    MD061007
     F**********                           INFSR(*PSSR)                                     MD061007
      * UPD : Midas SD Standing data controls update
      *
     FSDCUSTLJ  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Customer Codes                                                                  239141
      *                                                                                       239141
     FCLINTL1   IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Customer Master Details                                                         247341
      *                                                                                       247341
     FSDCNLML1  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Country Limits                                                                  247341
      *                                                                                       247341
     F*GPICTYL0* IF   E           K DISK    USROPN                                          MD058188
     F**********                           INFSR(*PSSR)                                     MD058188
     F**********                           RENAME(GPICTRYD0:GPICTYD0)                       MD058188
      *                                                                                       CGP001
      ** Midas GP Global Account Codes X-Reference                                            CGP001
      *                                                                                       CGP001
     FGPZONEL0  IF   E           K DISK
      ** Zone                                                                                 CSD031
     FGZSDBANK  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      ** Bank Details ICD Keyed on DNWD                                                       CSD031
     F*MEISOCL1IF  E           K        DISK                           UC            CSW213 MD058081
     F**********                                    KINFDS ID0007                    CSW213 MD058081
     F**********                                    KINFSR *PSSR                     CSW213 MD058081
      ** RTV : Midas ME SWIFT ISO country retrieval                                           CSW213
      *                                                                                       CSW213
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D OVRC            S             80    DIM(1) CTDATA PERRCD(1)
      ** Override Command Array                                                               CGP001
      *                                                                                       CGP001
     D*
     D/COPY WNCPYSRC,SD0181REPG
     D*COPY*ZSRSRC,ZALIGNZ1                                               CFT004            MD058188
     D/COPY ZSRSRC,ZALIGNZ1LE                                                               MD058188
     D*
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D****/COPY QWINDSRC,FSE1DTA                                          S01229
     D*COPY*QWINDSRC,SD0180GDTA                                           S01229            MD058188
     D/COPY QWINDSRC,SD0180GDTL                                                             MD058188
     D*
     D/COPY WNCPYSRC,SD0181RIPG
     D*
     D DATALX          DS          1024
     D  W1CNCD                 1      2
     D  #1ISOC                 3      4
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(SDCTRYL0)
      * UPD : Midas SD Country codes update
      * Current/previous master file format fields for change control
      *
     D**********#1DBRC      DS                             50             CFT004
     D**********#1DBRC      DS                             54      CFT004 CPB001
     D**********#1DBRC      DS                             63                         CPB001 BUG3644
     D***#1DBRC******DS                             73                                BUG3644 CSD031
     D***#1DBRC      DS                            108                               CSD031 BUG11706
     D***#1DBRC      DS                            118                             BUG11706 BUG13884
     D***#1DBRC*     DS                            164                             BUG13884   CER045
     D***#1DBRC*     DS                            167                                 CER045 CGL132
     D #1DBRC          DS           181
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D*QSDFC1***     E DS                  EXTNAME(SDFCTLL0)                                MD061007
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YBRDCS          DS            22
     D**********YCRDCS      DS                             50             CFT004
     D**********YCRDCS      DS                             54      CFT004 CPB001
     D**********YCRDCS      DS                             63                          CPB001 CGL032
     D***YCRDCS*     DS                             72                                 CGL032 CER045
     D***YCRDCS*     DS                             76                                 CER045 CGL132
     D YCRDCS          DS            89
     D YDRDCS          DS            22
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
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
      *                                                                                       CSW213
     D ID0007          DS           528
      ** File information data structure                                                      CSW213
      *
     D ID0005          DS           528
      * File information data structure                                                       CSD031
      *                                                                                       CSD031
     D ID0006          DS           528
      ** File information data structure                                                      CSD031
      *                                                                                       CSD031
      /EJECT
      * Parameter declarations
     D P1PARM          DS             2
      * KEY: Country Codes             Retrieval index
      * I : MAP Country Code
     D  P1CNCD                 1      2
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Key Field
     D  ZA0003                 2     11
      * Message data for 'Quest. Mark inv(non key)'
      * Region Name
     D  ZA0004                 1     30
      * Message data for 'Asterisk invalid'
      * Region Name
     D  ZA0005                 1     30
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0006                 1     10
     D LDA             DS           256
      ** Local data area for database error details                                           CGP001
      *                                                                                       CGP001
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D WDTQ            DS
     D  WPFNAM                 1     10
     D  WKEYS                 11     40
     D  WDATA                 41    296
     D PDQMSG          DS          4040
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       CGP001
      ** Data Structure for Switchable Features Details                                       CGP001
      *                                                                                       CGP001
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CPB001
      * DS for access programs                                            CPB001
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CPB001
      * DS for access programs                                            CPB001
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CPB001
      * External DS for Currency Details                                  CPB001
     D*SDWEIG***E*DSSDWEIGPD***                                                        CPB001 CGP001
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)
      * External DS for Weighting Code Details                            CPB001
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details                                                         CGL032
      *                                                                                       CSD031
     D GPCURR        E DS                  EXTNAME(GPCURRPD)
      ** External DS for Global Currencies                                                    CSD031
      *                                                                                       CSD031
     D MEISOC        E DS                  EXTNAME(MEISOJW0)                                MD058188
     D GPICTRY       E DS                  EXTNAME(GPICYJW0)                                MD058188
     D**********    'XLIB/SDCSNDDTQ'      C         PGMB                               CSD031 CSC043
     D PGMB            C                   CONST('XPLIB/SDCSNDDTQ')
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Country Co
     C     P2ANCD        PARM                    WP0001            1            Action Code
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1CNCD        IFEQ      *BLANK                                       Country Code
      * One or more key fields is blank
     C     *IN05         OREQ      '1'
      * HOME: Reset screen fields
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
      ** Initialize ISO found flag                                                          MD023056
     C                   MOVEL     ' '           ISOFND            1
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Switch between *ADD/*CHANGE modes
     C   09              CAS                     BCCHMD
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      ** Check ISO Country Code                                                               CSW213
     C   15              CAS                     CHKISO
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
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
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    A4CNCD                         Country Code
      * Setup key
     C                   MOVEL     #1CNCD        A4CNCD                         Country Code
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C*****KRTV*         CHAIN     GPCTRYD1                           9091                  MD058188
     C                   ENDIF
     C                   ELSE
     C     KRTV          CHAIN     @A4REBR                            9091      *
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * Verify record existence against program mode
     C     W0PMD         IFNE      'ADD'
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'Country Codes          NF'
     C                   MOVEL     'USR0067'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RSFF - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RSFF
     C*
     C                   END                                                    *FI
      * USER: Initialize detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Main Menu   F10=Delete   F12=Previous   F15=ISO Country Code                      CSW213
     C                   MOVEL     'USR4841'     WUMSID
     C                   ELSE
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   ENDIF
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Exit  F12=Previous  F15=ISO Country Code                                          CSW213
     C                   MOVEL     'USR4840'     WUMSID                         Message Identifier
     C                   ELSE
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   ENDIF
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Main Menu   F12=Previous   F15=ISO Country Code                                   CSW213
     C                   MOVEL     'USR4839'     WUMSID
     C                   ELSE
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   ENDIF
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
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RISE - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RISE
     C*
     C                   END                                                    *FI
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'Country Codes          EX'
     C                   MOVEL     'USR0068'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * USER: Initialize detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Main Menu   F10=Delete   F12=Previous   F15=ISO Country Code                      CSW213
     C                   MOVEL     'USR4841'     WUMSID
     C                   ELSE
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   ENDIF
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Exit  F12=Previous  F15=ISO Country Code                                          CSW213
     C                   MOVEL     'USR4840'     WUMSID                         Message Identifier
     C                   ELSE
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   ENDIF
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Main Menu   F12=Previous   F15=ISO Country Code                                   CSW213
     C                   MOVEL     'USR4839'     WUMSID
     C                   ELSE
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   ENDIF
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
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RISN - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RISN
     C*
     C                   END                                                    *FI
     C                   END
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * Start of SAR S01117
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Check for ? in key field
     C                   MOVEL     #1CNCD        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CNCD        ZA0001                         Country Code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   GOTO      BFEXIT                                       *QUIT
     C                   END                                                    *FI
      * Test for * in key field
     C                   MOVEL     #1CNCD        WUIVKF                         If value in key
      * CASE: WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     '*'           ZA0002                         If value in key
     C                   MOVEL     #1CNCD        ZA0003                         Country Code
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   GOTO      BFEXIT                                       *QUIT
     C                   END                                                    *FI
      * Check for duplicate record
      * get country codes - Country Codes  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Send message '*Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of SAR S01117
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RVKS - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RVKS
     C*
     C                   END                                                    *FI
      * Country Code required
     C     #1CNCD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                                       CGP001
      ** If CGP001 is enabled, check country                                                  CGP001
      ** code in ISO country code file                                                        CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C     P2ANCD        ANDNE     'D'
     C                   EXSR      SRVICT
     C                   ENDIF
      *                                                                                       CGP001
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      ** Check ISO Country Code                                                               CSW213
     C   15              CAS                     CHKISO
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPOF        BEGSR
      *                                                                                       CGP001
     C                   Z-ADD     80            PLEN             15 5
      *                                                                                       CGP001
     C                   MOVE      OVRC(1)       PCMD             80
      *                                                                                       CGP001
     C**********         CALL      'QCMDEXC'                                                MD058188
     C**********         PARM                    PCMD                                       MD058188
     C**********         PARM                    PLEN                                       MD058188
      *                                                                                       CGP001
     C**********         OPEN      GPICTYL0                                                 MD058188
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVICT - Validates Country code in ISO Country code file     *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVICT        BEGSR
      *                                                                                       CGP001
     C                   MOVE      #1CNCD        KCNCD             2
      *                                                                                       CGP001
     C*****KCNCD         CHAIN(N)  GPICTYL0                           46                    MD058188
     C/EXEC SQL                                                                             MD058188
     C+ SELECT *                                                                            MD058188
     C+ into :GPICTRY                                                                       MD058188
     C+ from GPICYJW0                                                                       MD058188
     C+ where CNCNCD = :KCNCD                                                               MD058188
     C/END-EXEC                                                                             MD058188
      *                                                                                       CGP001
     C******IN46         IFEQ      *ON                                                      MD058188
     C     SQLCODE       IFEQ      100                                                      MD058188
     C                   SETON                                        9931
     C                   MOVEL     'USR9784'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
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
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RPKR - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RPKR
     C*
     C                   END                                                    *FI
      * F12 - Exit Previous Screen Processing
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C  N10              CAS                     DCVLDL
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * USER: Validate detail screen fields
      * Disable 'ENTER' when in Delete mode
      * Delete processing.
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10 Only Valid Options'
     C                   MOVEL     'USR0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * Start of change S01461
      * Remove Midas Export module processing.
      * End of change S01461
      * Test for ? or * in Country Code
     C                   MOVEL     #1CNNM        WUINVC                         Invalid Charact
      * Invalid character processing.
      * CASE: WRK.Invalid Characters is Question mark
     C     WUINVC        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CNNM        ZA0004                         Country Name
      * Send message 'Quest. Mark inv(non key)'
     C                   MOVEL     'USR1163'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.Invalid Characters is Asterisk
     C     WUINVC        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CNNM        ZA0005                         Country Name
      * Send message 'Asterisk invalid'
     C                   MOVEL     'USR1164'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * /COPY
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RVSF - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RVSF
     C*
     C                   END                                                    *FI
      * Check relations
      * Check reference to Region Codes
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9933      *
     C                   END
      * Skip validating other fields when on Region Code Prompt                             BUG14090
     C     WK1X01        IFEQ      '?'
     C                   MOVE      *OFF          *IN46
     C                   GOTO      DCEXIT
     C                   ENDIF
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RSFF - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RSFF
     C*
     C                   END                                                    *FI
      * USER: Validate detail screen relations
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RVSR - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RVSR
     C*
     C                   END                                                    *FI
      * Country Name required
     C     #1CNNM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      **If*CGP001*is*enabled, Country Name                                             CGP001 TCA105
      **should*be*an*ISO*Country Name.                                                 CGP001 TCA105
     C***********CGP001****IFEQ 'Y'                                                    CGP001 TCA105
     C***********#1CNNM****IFNE CNCNNM                                                 CGP001 TCA105
     C*********************SETON                     9931                              CGP001 TCA105
     C*********************MOVEL'USR9785' ZAMSID                                       CGP001 TCA105
     C*********************MOVEL'SDUSRMSG'ZAMSGF                                       CGP001 TCA105
     C*********************EXSR ZASNMS                                                 CGP001 TCA105
     C*********************ENDIF                                                       CGP001 TCA105
     C*********************ENDIF                                                       CGP001 TCA105
      * ISO Country code required
     C     #1ISOC        IFEQ      *BLANK                                       IF
      * ISO Country code is not required                                                      CGP001
      * if CGP001 is enabled                                                                  CGP001
     C     CGP001        ANDEQ     'N'
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C/COPY WNCPYSRC,SD0181RC06
      *                                                                   CFT004
      *** If CFT004 is switched on                                        CFT004
      *                                                                   CFT004
     C     CFT004        IFEQ      'Y'                                                         CFT00
     C     CSW213        ANDEQ     'N'
     C     CFT050        ANDEQ     'N'
      *                                                                   CFT004
     C                   MOVE      *IN99         TMPIND            1                           CFT00
     C                   MOVE      *BLANKS       ZFIELD                                        CFT00
     C                   MOVE      #1BBAN        ZFIELD                                        CFT00
     C                   Z-ADD     0             ZADEC                                         CFT00
     C                   Z-ADD     2             ZADIG                                         CFT00
     C                   EXSR      ZALIGN                                                      CFT00
      *                                                                   CFT004
      *** Field must be numeric                                           CFT004
      *                                                                   CFT004
     C     *IN99         IFEQ      *ON                                                         CFT00
     C                   MOVE      *ON           *IN34                                         CFT00
     C                   MOVEL     'USR3716'     ZAMSID                                        CFT00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      ZFIELD        #1BBAN                                        CFT00
     C                   MOVE      #1BBAN        W#BBAN            2 0                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
     C                   MOVE      *BLANKS       ZFIELD                                        CFT00
     C                   MOVE      #1BBRL        ZFIELD                                        CFT00
     C                   EXSR      ZALIGN                                                      CFT00
      *                                                                   CFT004
      *** Field must be numeric                                           CFT004
      *                                                                   CFT004
     C     *IN99         IFEQ      *ON                                                         CFT00
     C                   MOVE      *ON           *IN35                                         CFT00
     C                   MOVEL     'USR3717'     ZAMSID                                        CFT00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      ZFIELD        #1BBRL                                        CFT00
     C                   MOVE      #1BBRL        W#BBRL            2 0                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
     C                   MOVE      TMPIND        *IN99                                         CFT00
      *                                                                   CFT004
     C     *IN34         IFEQ      *ON                                                         CFT00
     C     *IN35         OREQ      *ON                                                         CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
      *** If fields are numeric, validate                                 CFT004
      *                                                                   CFT004
     C     *IN34         IFEQ      *OFF                                                        CFT00
     C     *IN35         ANDEQ     *OFF                                                        CFT00
      *                                                                   CFT004
      *** If BBAN length is entered,  BBAN length must be greater than    CFT004
      *** 0, and less or equal to 30                                      CFT004
      *                                                                   CFT004
     C     W#BBAN        IFNE      0                                                           CFT00
     C     W#BBAN        IFLE      0                                                           CFT00
     C********** W#BBAN    ORGT 30                                                     CFT004 255381
     C********** W#BBAN    ORGT 34                                                   255381 BUG25904
     C     W#BBAN        ORGT      30
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   MOVE      *ON           *IN34                                         CFT00
     C                   MOVEL     'USR3718'     ZAMSID                                        CFT00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
      *** Entry of BBAN bank length is only allowed if BBAN length is     CFT004
      *** greater than 0                                                  CFT004
      *                                                                   CFT004
     C     W#BBRL        IFNE      0                                                           CFT00
     C     W#BBAN        IFEQ      0                                                           CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   MOVE      *ON           *IN35                                         CFT00
     C                   MOVEL     'USR3719'     ZAMSID                                        CFT00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ELSE                                                                  CFT00
      *                                                                   CFT004
      *** If BBAN bank length is entered,  BBAN bank length must be       CFT004
      *** greater then 0, and less or equal to 10                         CFT004
      *                                                                   CFT004
     C     W#BBRL        IFLT      0                                                           CFT00
     C     W#BBRL        ORGT      10                                                          CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   MOVE      *ON           *IN35                                         CFT00
     C                   MOVEL     'USR3720'     ZAMSID                                        CFT00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ELSE                                                                  CFT00
      *                                                                   CFT004
      *** If BBAN bank length is entered,  BBAN bank length must be       CFT004
      *** less tHAN BBAN LENGTH                                           CFT004
      *                                                                   CFT004
     C     W#BBRL        IFGT      W#BBAN                                                      CFT00
     C                   MOVE      *ON           *IN98                                         CFT00
     C                   MOVE      *ON           *IN38                                         CFT00
     C                   MOVEL     'USR3721'     ZAMSID                                        CFT00
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
     C     WUN4ST        IFEQ      'Y'                                          IF             CPB00
     C     CTI006        OREQ      'Y'
      * Associated Currency required                                      CPB001
     C     #1CTAY        IFEQ      *BLANK                                       IF             CPB00
     C                   SETON                                        9937      *              CPB00
      * Send message '*Value required'                                    CPB001
     C                   MOVEL     'Y2U0001'     ZAMSID                                        CPB00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   END                                                    FI             CPB00
      *                                                                   CPB001
     C     #1CTAY        IFNE      *BLANKS                                                     CPB00
     C                   MOVEL     #1CTAY        WCTAY             1                           CPB00
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C     'GP'          CAT       'AOCURRR0'    WPGM             10
     C                   CALL      WPGM
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #1CTAY        @KEY
     C     GPCURR        PARM      GPCURR        DSSDY
     C                   ELSE
     C                   CALL      'AOCURRR0'                                                  CPB00
     C                   PARM      '       '     @RTCD             7                           CPB00
     C                   PARM      '*KEY   '     @OPTN             7                           CPB00
     C                   PARM      #1CTAY        @KEY              3                           CPB00
     C     SDCURR        PARM      SDCURR        DSSDY                                         CPB00
     C                   ENDIF
      *                                                                   CPB001
     C     @RTCD         IFNE      *BLANKS                                                     CPB00
     C                   SETON                                        9937      *              CPB00
     C                   MOVEL     'Y2U0061'     ZAMSID                                        CPB00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   ELSE                                                                  CPB00
     C     WCTAY         IFEQ      '?'                                                         CPB00
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   MOVEL     GCCYCD        #1CTAY
     C                   ELSE
     C                   MOVEL     A6CYCD        #1CTAY                                        CPB00
     C                   ENDIF
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 CPB00
      * Zip Code cannot be blank                                          CPB001
     C     #1CTZP        IFEQ      *BLANK                                       IF             CPB00
     C     *IN65         ANDEQ     *OFF
     C                   SETON                                        9938      *              CPB00
      * Send message '*Zip code cannot be blank                           CPB001
     C                   MOVEL     'Y2U0059'     ZAMSID                                        CPB00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   END                                                    FI             CPB00
      * Weighting code is optional                                        CPB001
     C     #1CTWC        IFNE      *BLANKS                                      - B1           CPB00
     C     #1CTWC        ANDNE     *ZEROS                                                      CPB00
     C     *IN65         ANDEQ     *OFF
     C                   MOVEL     #1CTWC        WORK              2 0                         CPB00
     C                   MOVEL     'GP'          AOPGM            10
     C                   MOVE      'AOWEIGR0'    AOPGM
     C**********           CALL 'AOWEIGR0'                                             CPB001 CGP001
     C                   CALL      AOPGM
     C                   PARM      *BLANKS       @RTCD             7                           CPB00
     C                   PARM      '*KEY   '     @OPTN             7                           CPB00
     C                   PARM                    #1CTWC                                        CPB00
     C********** SDWEIG    PARM SDWEIG    DSFDY                                        CPB001 CGP001
     C     GPWEIG        PARM      GPWEIG        DSFDY
      *                                                                   CPB001
     C     @RTCD         IFNE      *BLANKS                                                     CPB00
     C                   SETON                                        9939      *              CPB00
      * Send message '*Weighting Code not Valid'                          CPB001
     C                   MOVEL     'Y2U0060'     ZAMSID                                        CPB00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CPB00
     C                   EXSR      ZASNMS                                                      CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                                       CGL014
      ** Validate Weighting Code if CGL014 is on                                              CGL014
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     #1CTWC        ANDNE     *BLANKS
     C     #1CTWC        ANDNE     *ZEROS
     C     *IN39         ANDEQ     *OFF
     C     *IN65         ANDEQ     *OFF
      *                                                                                       CGL014
     C                   MOVEL     'GP'          AOPGM
     C                   MOVE      'AOWEIGR0'    AOPGM
     C                   CALL      AOPGM
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    #1CTWC
     C     GPWEIG        PARM      GPWEIG        DSFDY
      *                                                                                       CGL014
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        9939
     C                   MOVEL     'Y2U0060'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL014
      ** Validate the End of Tax Year, Reporting Frequency, Currency of Tax, and              CGL032
      ** Joint Account Management fields if CGL032 is enabled.                                CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'
      *                                                                                       CGL032
      ** Validate End of Tax Year if necessary.                                               CGL032
      *                                                                                       CGL032
     C     #1ETXY        IFNE      *BLANKS
      *                                                                                       CGL032
      ** Is it a 4-digit number?                                                              CGL032
      *                                                                                       CGL032
     C                   MOVE      *BLANKS       PZFLD            16
     C                   MOVE      #1ETXY        PZFLD
      *                                                                                       CGL032
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PZRTN             7
     C                   PARM                    PZFLD            16
     C                   PARM      *ZERO         PZADEC            1 0
     C                   PARM      4             PZADIG            2 0
     C                   PARM      *BLANKS       PZAFLD           16
      *                                                                                       CGL032
     C     PZRTN         IFNE      *BLANKS
      *                                                                                       CGL032
      ** End of Tax Year must be numeric.                                                     CGL032
      *                                                                                       CGL032
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN99
     C**********           MOVEL'USR4700' ZAMSID                                       CGL032 CGL035
     C                   MOVEL     'USR4805'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      EVETY
     C                   ENDIF
      *                                                                                       CGL032
      ** Is it a valid month & day under the current year and date format?                    CGL032
      *                                                                                       CGL032
      ** Get the month, day, and year values.                                                 CGL032
      *                                                                                       CGL032
     C                   MOVE      BJMRDT        WYEAR             2 0
      *                                                                                       CGL032
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     #1ETXY        WMONTH            2 0
     C                   MOVE      #1ETXY        WDAY              2 0
     C                   ELSE
     C                   MOVE      #1ETXY        WMONTH
     C                   MOVEL     #1ETXY        WDAY
     C                   ENDIF
      *                                                                                       CGL032
     C                   MOVEL     #1ETXY        WDATE             6
     C                   MOVE      WYEAR         WDATE
     C                   MOVE      WDATE         PZDATE
      *                                                                                       CGL032
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PZERR             7
     C                   PARM                    PZDATE            6 0
     C                   PARM      BJDFIN        PZDATF            1
     C                   PARM      *ZERO         PZDAYN            5 0
      *                                                                                       CGL032
      ** Recover when a leap year error occurs.                                               CGL032
      *                                                                                       CGL032
     C     PZERR         IFNE      *BLANKS
     C     WMONTH        ANDEQ     2
     C     WDAY          ANDEQ     29
      *                                                                                       CGL032
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     WMONTH        WETXY             4
     C                   MOVE      '28'          WETXY
     C                   ELSE
     C                   MOVE      WMONTH        WETXY
     C                   MOVEL     '28'          WETXY
     C                   ENDIF
      *                                                                                       CGL032
     C                   MOVE      WETXY         #1ETXY
     C                   MOVEL     WETXY         WDATE
     C                   MOVE      WYEAR         WDATE
     C                   MOVE      WDATE         PZDATE
      *                                                                                       CGL032
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PZERR             7
     C                   PARM                    PZDATE            6 0
     C                   PARM      BJDFIN        PZDATF            1
     C                   PARM      *ZERO         PZDAYN            5 0
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
     C     PZERR         IFNE      *BLANKS
      *                                                                                       CGL032
      ** End of Tax Year must be valid date.                                                  CGL032
      *                                                                                       CGL032
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN99
     C**********           MOVEL'USR4701' ZAMSID                                       CGL032 CGL035
     C                   MOVEL     'USR4806'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      EVETY
     C                   ENDIF
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
     C     EVETY         TAG
      *                                                                                       CGL032
      ** Validate Reporting Frequency if necessary.                                           CGL032
      *                                                                                       CGL032
     C     #1RPFQ        IFEQ      *BLANKS
      *                                                                                       CGL032
     C     #1ETXY        IFNE      *BLANKS
     C     *IN41         ANDEQ     *OFF
      *                                                                                       CGL032
      ***Reporting*Frequency*is*mandatory*if*End*of*Tax*Year*has*been*input.           CGL032 233195
      *                                                                                CGL032 233195
     C**********           MOVE *ON       *IN42                                        CGL032 233195
     C**********           MOVE *ON       *IN99                                        CGL032 233195
     C**********           MOVEL'USR4702' ZAMSID                                       CGL032 CGL035
     C**********           MOVEL'USR4807' ZAMSID                                       CGL035 233195
     C**********           MOVEL'SDUSRMSG'ZAMSGF                                       CGL032 233195
     C**********           EXSR ZASNMS                                                 CGL032 233195
     C**********           GOTO EVRFQ                                                  CGL032 233195
     C**********           ENDIF                                                       CGL032 233195
      *                                                                                       CGL032
      ** At this point, Reporting Frequency must be defaulted to 'Y'.                         CGL032
      *                                                                                       CGL032
     C                   MOVE      'Y'           #1RPFQ
     C                   ENDIF
      *                                                                                       CGL032
     C                   ELSE
      *                                                                                       CGL032
     C     #1RPFQ        IFNE      'M'
     C     #1RPFQ        ANDNE     'Q'
     C     #1RPFQ        ANDNE     'X'
     C     #1RPFQ        ANDNE     'Y'
      *                                                                                       CGL032
      ** Reporting Frequency must be 'M', 'Q', 'X', or 'Y' if input.                          CGL032
      *                                                                                       CGL032
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C**********           MOVEL'USR4703' ZAMSID                                       CGL032 CGL035
     C                   MOVEL     'USR4808'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      EVRFQ
     C                   ENDIF
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
     C     EVRFQ         TAG
      *                                                                                       232543
     C                   ENDIF
      *                                                                                       232543
      ** Condition Currency of Tax on CGL031                                                  232543
      *                                                                                       232543
     C     CGL031        IFEQ      'Y'
      *                                                                                       232543
      ** Validate Currency of Tax if necessary.                                               CGL032
      *                                                                                       CGL032
     C     #1TXCY        IFNE      *BLANKS
      *                                                                                       CGL032
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1TXCY        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *                                                                                       CGL032
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CGL032
     C     '?'           SCAN      #1TXCY        WIDX              1 0
     C     WIDX          IFNE      *ZERO
     C                   MOVE      A6CYCD        #1TXCY
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CGL032
     C                   ELSE
      *                                                                                       CGL032
     C                   SELECT
      *                                                                                       CGL032
     C     PRTCD         WHENEQ    '*NRF   '
      *                                                                                       CGL032
      ** Currency of Tax must be a valid currency.                                            CGL032
      *                                                                                       CGL032
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN99
     C**********           MOVEL'USR4704' ZAMSID                                       CGL032 CGL035
     C                   MOVEL     'USR4809'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CGL032
     C     PRTCD         WHENEQ    '*NOSEL '
     C                   MOVE      A4TXCY        #1TXCY
     C                   MOVE      A4CTTX        #1CCTS
     C                   MOVE      'Y'           W0DCF
      *                                                                                       CGL032
     C                   OTHER
      *                                                                                       CGL032
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     #1TXCY        DBKEY
     C                   Z-ADD     102           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *                                                                                       CGL032
     C                   ENDSL
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
     C     #1CCTS        IFEQ      *BLANKS
      *                                                                                       236137
      ** Country of Tax is mandatory.                                                         236137
      *                                                                                       236137
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR4922'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     #1CCTS        IFNE      'Y'
     C     #1CCTS        ANDNE     'N'
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR4923'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     A4CTTX        IFEQ      'Y'
     C     #1CCTS        ANDEQ     'N'
     C                   CALL      'SD000781'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    #1CNCD
     C                   ELSE
     C     A4CTTX        IFEQ      'N'
     C     #1CCTS        ANDEQ     'Y'
     C                   CALL      'SD000782'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    #1CNCD
     C     @RTCD         IFEQ      '*NFOUND'
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR4924'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'N'           #1CCTS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       236137
     C                   ENDIF
      *                                                                                       232543
     C     CGL032        IFEQ      'Y'
      *                                                                                       232543
      ** Validate Joint Account Management if necessary.                                      CGL032
      *                                                                                       CGL032
     C     #1JAMG        IFNE      *BLANK
      *                                                                                       CGL032
     C     #1JAMG        IFNE      '1'
     C     #1JAMG        ANDNE     '2'
     C     #1JAMG        ANDNE     '3'
      *                                                                                       CGL032
      ** Joint Account Management must be '1', '2', or '3' if input.                          CGL032
      *                                                                                       CGL032
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
     C**********           MOVEL'USR4705' ZAMSID                                       CGL032 CGL035
     C                   MOVEL     'USR4810'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGL032
     C**********           ELSE                                                       CGL032  233195
      **********                                                                      CGL032  233195
      ***At*this*point,*Joint*A/c*Management*must*be*defaulted*to*'1'.*               CGL032  233195
      **********                                                                      CGL032  233195
     C**********           MOVE '1'       #1JAMG                                      CGL032  233195
     C                   ENDIF
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
      ** Validate GRI Country code if CER045 is enabled.                                      CER045
      *                                                                                       CER045
     C     CER045        IFEQ      'Y'
     C                   EXSR      VALGRI
     C                   ENDIF
      *                                                                                       CER045
      *                                                                                       CER045
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
     C     *IN99         IFEQ      '0'
     C                   EXSR      CHKISO
     C                   ELSE
     C                   MOVE      ' '           ISOFND
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      *                                                                                       CGL132
     C     CGL132        IFEQ      'Y'
     C     CGL133        ANDEQ     'N'
      *                                                                                       CGL132
      ** FATCA Agreement Type default is 'UKN'                                                CGL132
      *                                                                                       CGL132
     C     #1FAAT        IFEQ      *BLANKS
     C                   MOVE      'UKN'         #1FAAT
     C                   ENDIF
      *                                                                                       CGL132
      ** Validate FATCA Agreement Type                                                        CGL132
      ** FATCA Agreement Type must be 'M1R', 'M1N', 'M2R',                                    CGL132
      ** 'M2N', 'NOA' or 'UKN'                                                                CGL132
      *                                                                                       CGL132
     C     #1FAAT        IFNE      'M1R'
     C     #1FAAT        ANDNE     'M1N'
     C     #1FAAT        ANDNE     'M2R'
     C     #1FAAT        ANDNE     'M2N'
     C     #1FAAT        ANDNE     'NOA'
     C     #1FAAT        ANDNE     'UKN'
     C                   MOVE      *ON           *IN99
     C**********           MOVE *ON       *IN47                                      CGL132 MD026498
     C                   MOVE      *ON           *IN53
     C                   MOVEL     'USS0260'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGL132
      ** FATCA Indicia default is 'N'                                                         CGL132
      *                                                                                       CGL132
     C     #1FAIN        IFEQ      *BLANKS
     C                   MOVE      'N'           #1FAIN
     C                   ENDIF
      *                                                                                       CGL132
      ** Validate FATCA Indicia                                                               CGL132
      ** FATCA Indicia must be either 'Y' or 'N'                                              CGL132
      *                                                                                       CGL132
     C     #1FAIN        IFNE      *BLANKS
     C     #1FAIN        ANDNE     'Y'
     C     #1FAIN        ANDNE     'N'
     C                   MOVE      *ON           *IN99
     C**********           MOVE *ON       *IN48                                      CGL132 MD026498
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'USS0261'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGL132
     C                   ENDIF
     C/COPY WNCPYSRC,SD0181RC04
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         WEACC             5 0
      *                                                                                       CSD031
      ** called from Central level                                                            CSD031
      *                                                                                       CSD031
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
      *                                                                                       CSD031
     C     #1AACC        IFEQ      *BLANK
     C                   MOVE      'N'           #1AACC
     C                   ENDIF
      *                                                                                       CSD031
      ** 'accept to zone' if entered should be 'Y' or 'N'.                                    CSD031
      *                                                                                       CSD031
     C     #1AACC        IFNE      'Y'
     C     #1AACC        ANDNE     'N'
     C     #1AACC        ANDNE     *BLANKS
     C                   MOVEL     'SCC0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN48
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *                                                                                       CSD031
     C     #1AACC        IFEQ      *BLANKS
     C                   MOVE      'N'           #1AACC
     C                   ENDIF
      *                                                                                       CSD031
      ** effective date may only be entered if 'accept to zone' is 'N'.                       CSD031
      *                                                                                       CSD031
     C     #1AACC        IFNE      'N'
     C     #1EACC        ANDNE     *BLANK
     C                   MOVEL     'CSD0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *                                                                                       CSD031
      ** effective date is invalid                                                            CSD031
      *                                                                                       CSD031
     C     #1AACC        IFEQ      'N'
     C     #1EACC        ANDNE     *BLANK
      *                                                                                       CSD031
     C                   TESTN                   #1EACC               80
     C                   MOVE      #1EACC        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANK        ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C     ZERR          IFEQ      '*ERROR*'
     C     *IN80         OREQ      *OFF
     C                   MOVEL     'ASM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN99
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WEACC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RPCK - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RPCK
     C*
     C                   END                                                    *FI
      * Start of SAR S01117
      * CASE: DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of SAR S01117
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Countries - EDTREC - Country Codes  *
     C                   EXSR      SBCRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Countries - EDTREC - Country Codes  *
     C                   EXSR      SDDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Countries - EDTREC - Country Codes  *
     C                   EXSR      SFCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P1CNCD        IFEQ      *BLANK                                       Country Code
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
      * Enable key screen
     C                   SETON                                        87        *
      *                                                                                     MD027804
     C                   MOVEL     '0'           *IN79
     C     P2ANCD        IFEQ      'D'
     C                   MOVEL     '1'           *IN79
     C                   ENDIF
      *                                                                                     MD027804
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     *BLANK        #1MLOC                         Midas Export Va
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1CNNM                         Country Name
     C     CGP001        IFEQ      'N'
     C                   MOVEL     *BLANK        #1ISOC                         ISO Country cod
     C                   ENDIF
     C                   MOVEL     *BLANK        #1RGCD                         Region Code
     C                   MOVEL     *BLANK        #1BBAN                         BBAN tot. lngthCFT00
     C                   MOVEL     *BLANK        #1BBRL                         BBAN bank lngthCFT00
     C                   MOVEL     *BLANK        #1CTAY                                        CPB00
     C                   MOVEL     *BLANK        #1CTZP                                        CPB00
     C                   MOVEL     *BLANK        #1CTWC                                        CPB00
     C                   MOVE      *BLANKS       #1ETXY
     C                   MOVE      *BLANKS       #1RPFQ
     C                   MOVE      *BLANKS       #1TXCY
     C                   MOVE      *BLANKS       #1JAMG
     C                   MOVE      *BLANK        #1EACC
     C                   MOVE      *BLANK        #1AACC
     C                   MOVE      *BLANK        #1GPDT
      ** Initialise GRI country code screen field if CER045 is enabled.                       CER045
     C     CER045        IFEQ      'Y'
     C                   MOVE      *ZEROS        #1GRIC                         GRI Country code
     C                   ENDIF
      ** FATCA fields                                                                         CGL132
     C                   MOVEL     *BLANK        #1FAAT
     C                   MOVEL     *BLANK        #1FAIN
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A4REBR fields to screen
      *================================================================
     C                   MOVEL     A4MLOC        #1MLOC                         Midas Export Va
     C                   Z-ADD     A4LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A4TYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     A4CNCD        #1CNCD                         Country Code
     C                   MOVEL     A4CNNM        #1CNNM                         Country Name
     C                   MOVEL     A4ISOC        #1ISOC                         ISO Country cod
     C                   MOVEL     A4RGCD        #1RGCD                         Region Code
     C                   MOVEL     A4BBAN        #1BBAN                         BBAN tot. lngthCFT00
     C                   MOVEL     A4BBRL        #1BBRL                         BBAN bank lngthCFT00
     C     *IN85         IFEQ      *ON                                                         CPB00
     C                   MOVEL     A4CTAY        #1CTAY                                        CPB00
     C                   MOVEL     A4CTZP        #1CTZP                                        CPB00
     C     A4CTWC        IFEQ      *ZERO                                                       CPB00
     C                   MOVEL     *BLANK        #1CTWC                                        CPB00
     C                   ELSE                                                                  CPB00
     C                   MOVEL     A4CTWC        #1CTWC                                        CPB00
     C                   ENDIF                                                                 CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                                       CGL014
     C     *IN84         IFEQ      *ON
     C     A4CTWC        IFEQ      *ZERO
     C                   MOVEL     *BLANK        #1CTWC
     C                   ELSE
     C                   MOVEL     A4CTWC        #1CTWC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD046        IFEQ      'Y'
     C                   MOVEL     A4GPDT        #1GPDT
     C                   MOVEL     A4AACC        #1AACC
     C     A4EACC        IFNE      *ZERO
     C                   CALL      'ZDATE2'                             90
     C                   PARM      A4EACC        PDATE             5 0
     C                   PARM      BJDFIN        PDTFMT            1
     C                   PARM      *ZEROS        PCVTDT            6 0
     C                   PARM      *BLANKS       PALPDT            7
     C                   MOVE      PCVTDT        #1EACC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL014
      ** Move relevant file fields to screen fields if CGL032 is enabled.                     CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'
      *                                                                                       CGL032
     C     A4ETXY        IFNE      *ZERO
     C                   MOVE      A4ETXY        #1ETXY
     C                   ELSE
     C                   MOVE      *BLANKS       #1ETXY
     C                   ENDIF
      *                                                                                       CGL032
     C                   MOVE      A4RPFQ        #1RPFQ
     C**********           MOVE A4TXCY    #1TXCY                                       CGL032 232543
     C                   MOVE      A4JAMG        #1JAMG
     C                   ENDIF
      *                                                                                       CGL032
      ** Move relevant file fields to screen fields if CGL031 is enabled.                     232543
      *                                                                                       232543
     C     CGL031        IFEQ      'Y'
      *                                                                                       232543
     C                   MOVE      A4TXCY        #1TXCY
     C                   MOVE      A4CTTX        #1CCTS
     C                   ENDIF
      *                                                                                       232543
      ** Move GRI country code to screen field if CER045 is enabled.                          CER045
      *                                                                                       CER045
     C     CER045        IFEQ      'Y'
     C                   MOVE      A4GRIC        #1GRIC
     C                   ENDIF
      *                                                                                       CER045
      *                                                                                       CSW213
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
     C********** #1CNCD    CHAINMEISOCL1             90                              CSW213 MD058081
     C                   CALL      'AOMSOCR0'                           90                  MD058081
     C                   PARM      *BLANKS       @RTCD             7                        MD058081
     C                   PARM      '*KEY'        @OPTN             7                        MD058081
     C                   PARM      #1CNCD        @ISOC             2                        MD058081
     C     MEISOC        PARM      MEISOC        DSFDY                                      MD058081
     C********** *IN90     IFEQ '0'                                                  CSW213 MD058081
     C     @RTCD         IFEQ      *BLANKS                                                  MD058081
     C                   MOVEL     M3BBLN        #1BBAN
     C**********           MOVELM3BILN    #1BBRL                                     CSW213 MD021672
     C                   MOVEL     M3TBLN        #1BBRL
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** FATCA fields                                                                         CGL132
     C                   MOVEL     A4FAAT        #1FAAT
     C                   MOVEL     A4FAIN        #1FAIN
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1CNCD        #1CNCD                         Country Code
      * USER: Initialize key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RIKS - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RIKS
     C*
     C                   END                                                    *FI
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * get country codes - Country Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    A4CNCD                         Country Code
      * Move fields to key list
     C                   MOVEL     #1CNCD        A4CNCD                         Country Code
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C*****KRSSA         CHAIN     GPCTRYL1                           90                    MD058188
     C                   ENDIF
     C                   ELSE
     C     KRSSA         CHAIN     @A4REBR                            90        *
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0067'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCRRC        BEGSR
      *================================================================
      * Create Countries - EDTREC - Country Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A4REBS
     C                   MOVEL     #1CNCD        A4CNCD                         Country Code
     C                   MOVEL     #1RGCD        A4RGCD                         Region Code
     C                   Z-ADD     WURDNB        A4LCD                          Last Change Dat
     C                   MOVEL     'I'           A4TYLC                         Type of Last Ch
     C                   MOVEL     #1CNNM        A4CNNM                         Country Name
      *                                                                                     BUG13884
     C                   CALL      'ZAGENTS'
     C                   PARM      ZATMST        ZATMST           26
     C                   MOVE      ZATMST        A4TMST
      *                                                                                       CSD031
     C     *INU1         IFEQ      *OFF
     C                   MOVE      *BLANK        A4GPDT
     C                   MOVE      *BLANK        A4AACC
     C                   Z-ADD     *ZERO         A4EACC
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   MOVE      'Y'           A4GPDT
     C                   MOVE      #1AACC        A4AACC
     C                   Z-ADD     WEACC         A4EACC
     C                   ENDIF
      *                                                                                       CSD031
     C     CGP001        IFEQ      'Y'
     C                   MOVEL     #1CNCD        A4ISOC                         ISO Country cod
     C                   ELSE
     C                   MOVEL     #1ISOC        A4ISOC                         ISO Country cod
     C                   ENDIF
     C                   MOVEL     #1MLOC        A4MLOC                         Midas Export Va
     C                   MOVEL     #1BBAN        A4BBAN                         BBAN tot. lngthCFT00
     C                   MOVEL     #1BBRL        A4BBRL                         BBAN bank lngthCFT00
     C     *IN85         IFEQ      *ON                                                         CPB00
     C                   MOVEL     #1CTAY        A4CTAY                                        CPB00
     C                   MOVEL     #1CTZP        A4CTZP                                        CPB00
     C                   MOVE      #1CTWC        A4CTWC                                        CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                                       CGL014
     C     *IN84         IFEQ      *ON
     C                   MOVE      #1CTWC        A4CTWC
     C                   ENDIF
      *                                                                                      BUG3164
      ** Before writing to file, check if field Weighting Code                               BUG3164
      ** is blank.  If so, change to zero.                                                   BUG3164
      *                                                                                      BUG3164
     C     #1CTWC        IFEQ      *BLANKS
     C                   Z-ADD     *ZERO         A4CTWC
     C                   ENDIF
      *                                                                                       CGL032
      ** Move relevant screen fields to file fields if CGL032 is enabled.                     CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'
     C                   MOVE      #1ETXY        A4ETXY
     C                   MOVE      #1RPFQ        A4RPFQ
     C**********           MOVE #1TXCY    A4TXCY                                       CGL032 232543
     C                   MOVE      #1JAMG        A4JAMG
     C                   ELSE
     C                   Z-ADD     *ZERO         A4ETXY
     C                   MOVE      *BLANKS       A4RPFQ
     C**********           MOVE *BLANKS   A4TXCY                                       CGL032 232543
     C                   MOVE      *BLANKS       A4JAMG
     C                   ENDIF
      *
      ** Move relevant screen fields to file fields if CGL031 is enabled.                     232543
      *                                                                                       232543
     C     CGL031        IFEQ      'Y'
     C                   MOVE      #1TXCY        A4TXCY
     C                   MOVE      #1CCTS        A4CTTX
     C                   ELSE
     C                   MOVE      *BLANKS       A4TXCY
     C                   MOVE      *BLANKS       A4CTTX
     C                   ENDIF
      *                                                                                       CER045
      ** Move screen GRI Country code to file field if CER045 is enabled.                     CER045
      *                                                                                       CER045
     C     CER045        IFEQ      'Y'
     C                   MOVE      #1GRIC        A4GRIC
     C                   ELSE
     C                   Z-ADD     *ZERO         A4GRIC
     C                   ENDIF
      ** FATCA fields                                                                         CGL132
     C                   MOVEL     #1FAAT        A4FAAT
     C                   MOVEL     #1FAIN        A4FAIN
      *
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0181RC01
     C     WLAYR         IFEQ      'Z'
      *                                                                                       CER001
     C     LOOP          DOUEQ     'N'
     C                   MOVE      'N'           LOOP              1
     C                   MOVE      'N'           W0DCF
     C                   MOVEL     #1CNCD        W1CNCD
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C                   CALL      'SD0183'
     C                   PARM                    @RTNCD            7
     C                   PARM      'I'           @ACTCD            1
     C                   PARM                    DATALX
     C                   PARM      *BLANK        W0RTN
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVE      'Y'           W0DCF
     C                   ITER
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'
     C                   CALL      'SD0184'
     C                   PARM                    @RTNCD
     C                   PARM      'I'           @ACTCD
     C                   PARM                    DATALX
     C                   PARM      *BLANK        W0RTN
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C                   MOVE      'Y'           LOOP
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDDO
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     ULX043        OREQ      'Y'
     C     W0RTN         IFNE      *BLANKS
     C                   GOTO      SBEXIT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      * CASE: WRK.Window required is Yes
     C     WUD2DD        IFEQ      *BLANK                                       *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
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
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0181RCBW - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RCBW
     C*
     C                   END                                                    *FI
      * 00/Copy member SD0181RCBU - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RCBU
     C*
     C                   END                                                    *FI
     C     KLCRSB        KLIST
     C                   KFLD                    A4CNCD                         Country Code
      * Check for duplicate primary key
     C********** KLCRSB    SETLL@A4REBS                  90*                                  CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C*****KLCRSB        SETLL     GPCTRYD0                               90                MD058188
     C                   ENDIF
     C                   ELSE
     C     KLCRSB        SETLL     @A4REBS                                90
     C                   ENDIF
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0068'     W0RTN             7
      * Send message 'Country Codes          EX'
     C                   MOVEL     'USR0068'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C**********           WRITE@A4REBS                91  *                                  CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C**********         WRITE     GPCTRYD0                             91                  MD058188
     C                   ENDIF
     C                   ELSE
     C                   WRITE     @A4REBS                              91
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   EXSR      SRSEND
     C                   ENDIF
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Start of SAR S01117
      * Change File Control Filename from CNTRYS to SDCTRYPD
      * Change Standing Data Cont - Standing Data Controls  *
     C     *INU1         IFEQ      *OFF
     C     CSD046        ANDEQ     'Y'
     C     CSD046        OREQ      'N'
     C                   EXSR      SCCHRC
      * End of SAR S01117
      * Update TABLETH - Country Codes  *
     C                   CALL      'TABLETH'                            90      Update TABLETH
     C     W0RTN         PARM      *BLANK        WQ0003            7            *Return code
     C                   PARM      A4CNCD        WQ0004            2            Country Code
     C                   PARM      A4RGCD        WQ0005            2            Region Code
     C                   PARM      A4CNNM        WQ0006           30            Country Name
     C                   PARM      A4TYLC        WQ0007            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0008            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETH'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RCAU - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RCAU
     C*
     C                   END                                                    *FI
     C                   ENDIF
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDCTRYPD'    AHFLNM                         Filename
      *
     C     KLCHSC        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSC        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
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
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDDLRC        BEGSR
      *================================================================
      * Delete Countries - EDTREC - Country Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C/COPY WNCPYSRC,SD0181RC02
     C     WLAYR         IFEQ      'Z'
      *                                                                                       CER001
     C     LOOP          DOUEQ     'N'
     C                   MOVE      'N'           LOOP
     C                   MOVE      'N'           W0DCF
     C                   MOVEL     #1CNCD        W1CNCD
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C                   CALL      'SD0183'
     C                   PARM                    @RTNCD            7
     C                   PARM      'D'           @ACTCD            1
     C                   PARM                    DATALX
     C                   PARM      *BLANK        W0RTN
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVE      'Y'           W0DCF
     C                   ITER
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'
     C                   CALL      'SD0184'
     C                   PARM                    @RTNCD
     C                   PARM      'D'           @ACTCD
     C                   PARM                    DATALX
     C                   PARM      *BLANK        W0RTN
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C                   MOVE      'Y'           LOOP
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDDO
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     ULX043        OREQ      'Y'
     C     W0RTN         IFNE      *BLANKS
     C                   GOTO      SDEXIT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      * Call Window Manager
      * CASE: WRK.Window required is Yes
     C     WUD2DD        IFEQ      *BLANK                                       *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
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
      * 00/Copy member SD0181RDBW - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RDBW
     C*
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RDBU - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RDBU
     C*
     C                   END                                                    *FI
      * Move key fields to @A4REBS
     C                   MOVEL     #1CNCD        A4CNCD                         Country Code
      *
     C     KLDLSD        KLIST
     C                   KFLD                    A4CNCD                         Country Code
     C********** KLDLSD    CHAIN@A4REBS              9091  *                                  CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C*****KLDLSD        CHAIN     GPCTRYD0                           9091                  MD058188
     C                   ENDIF
     C                   ELSE
     C     KLDLSD        CHAIN     @A4REBS                            9091
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C********** KLDLSD    SETLL@A4REBS              9091  *                                  CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C*****KLDLSD        SETLL     GPCTRYD0                           9091                  MD058188
     C                   ENDIF
     C                   ELSE
     C     KLDLSD        SETLL     @A4REBS                            9091
     C                   ENDIF
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *                                                                                       239141
      * Check if an active customer is linked to the country code for deletion                239141
      *                                                                                       239141
     C     KLDLSD        CHAIN     SDCUSTLJ                           90
     C     *IN90         IFEQ      '0'
      * Customer with this country code still exists                                          239141
     C                   MOVEL     'Y2U0070'     W0RTN             7
      * Send message '*Record cnnot  be deleted'                                              239141
     C                   MOVEL     'Y2U0070'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   ENDIF
      *                                                                                       247341
      * Check if a Customer Master Details is linked to the country code for                  247341
      * deletion                                                                              247341
     C     KLDLSD        CHAIN     CLINTL1                            90
     C     *IN90         IFEQ      '0'
      * Customer with this country code still exists                                          247341
     C                   MOVEL     'Y2U0072'     W0RTN             7
      * Send message '*Record cannot be deleted'                                              247341
     C                   MOVEL     'Y2U0072'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   ENDIF
      *                                                                                       247341
      * Check if a Country Limits record still exist before deletion                          247341
      *                                                                                       247341
     C     KLDLSD        CHAIN     SDCNLML1                           90
     C     *IN90         IFEQ      '0'
      * Country Limits with this country code still exists                                    247341
     C                   MOVEL     'Y2U0073'     W0RTN             7
      * Send message '*Record cannot be deleted'                                              247341
     C                   MOVEL     'Y2U0073'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   ENDIF
      *................................................................
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   MOVE      'D'           A4TYLC
     C                   EXSR      SRSEND
     C                   ENDIF
     C**********           DELET@A4REBS                91  *                                  CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C**********         DELETE    GPCTRYD0                             91                  MD058188
     C                   ENDIF
     C                   ELSE
     C                   DELETE    @A4REBS                              91
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * Start of change 122096
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDCTRYPD'    PAFNME                         File name
     C                   MOVEL     #1CNCD        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of change 122096
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change File Control Filename from CNTRYS to SDCTRYPD
      * Change Standing Data Cont - Standing Data Controls  *
     C     *INU1         IFEQ      *OFF
     C     CSD046        ANDEQ     'Y'
     C     CSD046        OREQ      'N'
     C                   EXSR      SECHRC
      * End of SAR S01117
      * Update TABLETH - Country Codes  *
     C                   CALL      'TABLETH'                            90      Update TABLETH
     C     W0RTN         PARM      *BLANK        WQ0009            7            *Return code
     C                   PARM      A4CNCD        WQ0010            2            Country Code
     C                   PARM      A4RGCD        WQ0011            2            Region Code
     C                   PARM      A4CNNM        WQ0012           30            Country Name
     C                   PARM      'D'           WQ0013            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0014            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETH'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0180RDAU - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RDAU
     C*
     C                   END                                                    *FI
     C                   ENDIF
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
     C                   MOVEL     'SDCTRYPD'    AHFLNM                         Filename
      *
     C     KLCHSE        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSE        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
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
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
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
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Countries - EDTREC - Country Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @A4REBS
     C                   MOVEL     #1CNCD        A4CNCD                         Country Code
      *
     C     KLCHSF        KLIST
     C                   KFLD                    A4CNCD                         Country Code
     C********** KLCHSF    CHAIN@A4REBS              9091  *                                  CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C*****KLCHSF        CHAIN     GPCTRYD0                           9091                  MD058188
     C                   ENDIF
     C                   ELSE
     C     KLCHSF        CHAIN     @A4REBS                            9091
     C                   ENDIF
      *
     C     *IN90         IFEQ      '1'
      * Record not found
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
     C                   GOTO      SFEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C**********         UNLOCK    GPCTRYL0                             91                  MD058188
     C                   ENDIF
     C                   ELSE
     C                   UNLOCK    SDCTRYL0                             91      *
     C                   ENDIF
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @A4REBS
     C                   MOVEL     #1RGCD        A4RGCD                         Region Code
     C                   Z-ADD     WURDNB        A4LCD                          Last Change Dat
     C                   MOVEL     'A'           A4TYLC                         Type of Last Ch
     C                   MOVEL     #1CNNM        A4CNNM                         Country Name
     C                   MOVEL     #1ISOC        A4ISOC                         ISO Country cod
     C                   MOVEL     #1MLOC        A4MLOC                         Midas Export Va
     C                   MOVEL     #1BBAN        A4BBAN                         BBAN tot. lngthCFT00
     C                   MOVEL     #1BBRL        A4BBRL                         BBAN bank lngthCFT00
     C     *IN85         IFEQ      *ON                                                         CPB00
     C                   MOVEL     #1CTAY        A4CTAY                                        CPB00
     C                   MOVEL     #1CTZP        A4CTZP                                        CPB00
     C                   MOVE      #1CTWC        A4CTWC                                        CPB00
     C                   ENDIF                                                                 CPB00
      *                                                                                       CGL014
     C     *IN84         IFEQ      *ON
     C                   MOVE      #1CTWC        A4CTWC
     C                   ENDIF
      *                                                                                      BUG3164
      ** Before update to file, check if field Weighting Code                                BUG3164
      ** is blank.  If so, change to zero.                                                   BUG3164
      *                                                                                      BUG3164
     C     #1CTWC        IFEQ      *BLANKS
     C                   Z-ADD     *ZERO         A4CTWC
     C                   ENDIF
      *                                                                                       CGL032
      ** Move relevant screen fields to file fields if CGL032 is enabled.                     CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'
     C                   MOVE      #1ETXY        A4ETXY
     C                   MOVE      #1RPFQ        A4RPFQ
     C**********           MOVE #1TXCY    A4TXCY                                       CGL032 232543
     C                   MOVE      #1JAMG        A4JAMG
     C                   ELSE
     C                   Z-ADD     *ZERO         A4ETXY
     C                   MOVE      *BLANKS       A4RPFQ
     C**********           MOVE *BLANKS   A4TXCY                                       CGL032 232543
     C                   MOVE      *BLANKS       A4JAMG
     C                   ENDIF
      *
      ** Move relevant screen fields to file fields if CGL031 is enabled.                     232543
      *                                                                                       232543
     C     CGL031        IFEQ      'Y'
     C                   MOVE      #1TXCY        A4TXCY
     C                   MOVE      #1CCTS        A4CTTX
     C                   ELSE
     C                   MOVE      *BLANKS       A4TXCY
     C                   MOVE      *BLANKS       A4CTTX
     C                   ENDIF
      *                                                                                       CGL132
     C                   MOVEL     #1FAAT        A4FAAT
     C                   MOVEL     #1FAIN        A4FAIN
      *                                                                                       232543
     C     *INU1         IFEQ      *OFF
     C                   MOVE      *BLANK        A4GPDT
     C                   MOVE      *BLANK        A4AACC
     C                   Z-ADD     *ZERO         A4EACC
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   MOVE      'Y'           A4GPDT
     C                   MOVE      #1AACC        A4AACC
     C                   Z-ADD     WEACC         A4EACC
     C                   ENDIF
      *                                                                                       CER045
      ** Move screen GRI Country code to file field if CER045 is enabled.                     CER045
      *                                                                                       CER045
     C     CER045        IFEQ      'Y'
     C                   MOVE      #1GRIC        A4GRIC
     C                   ENDIF
      *                                                                                       CER045
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0181RC03
     C     WLAYR         IFEQ      'Z'
      *                                                                                       CER001
     C     LOOP          DOUEQ     'N'
     C                   MOVE      'N'           LOOP
     C                   MOVE      'N'           W0DCF
     C                   MOVEL     #1CNCD        W1CNCD
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C                   CALL      'SD0183'
     C                   PARM                    @RTNCD            7
     C                   PARM      'A'           @ACTCD            1
     C                   PARM                    DATALX
     C                   PARM      *BLANK        W0RTN
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVE      'Y'           W0DCF
     C                   ITER
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'
     C                   CALL      'SD0184'
     C                   PARM                    @RTNCD
     C                   PARM      'A'           @ACTCD
     C                   PARM                    DATALX
     C                   PARM      *BLANK        W0RTN
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C     W0RTN         OREQ      'USR0563'
     C     W0RTN         OREQ      'Y2U0004'
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'USR0790'
     C                   MOVE      'Y'           LOOP
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDDO
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C     ULX043        OREQ      'Y'
     C     W0RTN         IFNE      *BLANKS
     C                   GOTO      SFEXIT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDIF
      * CASE: WRK.Window required is Yes
     C     WUD2DD        IFEQ      *BLANK                                       *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
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
      * 00/Copy member SD0181RBUW - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RBUW
     C*
     C                   END                                                    *FI
      * 00/Copy member SD0181RBDU - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RBDU
     C*
     C                   END                                                    *FI
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C**********         UPDATE    GPCTRYD0                                                 MD058188
     C                   ENDIF
     C                   ELSE
     C                   UPDATE    @A4REBS                              91      *
     C                   ENDIF
     C                   ELSE
      * Release record lock
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C**********         UNLOCK    GPCTRYL0                                                 MD058188
     C                   ENDIF
     C                   ELSE
     C                   UNLOCK    SDCTRYL0                             91      *
     C                   ENDIF
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C     CSD046        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   EXSR      SRSEND
     C                   ENDIF
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change File Control Filename from CNTRYS to SDCTRYPD
      * Change Standing Data Cont - Standing Data Controls  *
     C     *INU1         IFEQ      *OFF
     C     CSD046        ANDEQ     'Y'
     C     CSD046        OREQ      'N'
     C                   EXSR      SGCHRC
      * End of SAR S01117
      * Update TABLETH - Country Codes  *
     C                   CALL      'TABLETH'                            90      Update TABLETH
     C     W0RTN         PARM      *BLANK        WQ0015            7            *Return code
     C                   PARM      A4CNCD        WQ0016            2            Country Code
     C                   PARM      A4RGCD        WQ0017            2            Region Code
     C                   PARM      A4CNNM        WQ0018           30            Country Name
     C                   PARM      A4TYLC        WQ0019            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0020            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETH'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181RADU - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181RADU
     C*
     C                   END                                                    *FI
     C                   ENDIF
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDCTRYPD'    AHFLNM                         Filename
      *
     C     KLCHSG        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSG        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SGEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
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
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * get practically everythin - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSH         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0006                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SHEXIT                                       *QUIT
     C                   GOTO      SHEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     BGSDGL        WUSDGL                         Standing data/G
     C                   MOVEL     BGDLFX        WUDLFX                         Dealing: FX
     C                   MOVEL     BGSYLN        WUSYLN                         Syndicated Loan
     C                   MOVEL     BGEXMG        WUEXMG                         Exposure Manage
     C                   MOVEL     BGCSLN        WUCSLN                         Customer Lendin
     C                   MOVEL     BGRTBN        WURTBN                         Retail Banking
     C                   MOVEL     BGMSDL        WUMSDL                         Midas/Swift dir
     C                   MOVEL     BGSECS        WUSECS                         Securities
     C                   MOVEL     BGAURC        WUAURC                         Auto-reconcilia
     C                   MOVEL     BGFDTR        WUFDTR                         Funds Transfer
     C                   MOVEL     BGFUOP        WUFUOP                         Futures & Optio
     C                   MOVEL     BGNWMI        WUNWMI                         Message Managem
     C                   MOVEL     BGFIIN        WUFIIN                         FRA/IRS Indicat
     C                   MOVEL     BGDLMM        WUDLMM                         Dealing: MM
     C                   MOVEL     BGTRMG        WUTRMG                         Treasury Manage
     C                   MOVEL     BGRKMG        WURKMG                         Interest Risk M
     C                   MOVEL     BGMFIC        WUMFIC                         Microfiche
     C                   MOVEL     BGIOAC        WUIOAC                         Interest on acc
     C                   MOVEL     BGCFMT        WUCFMT                         Confirmation Ma
     C                   MOVEL     BGRCFI        WURCFI                         Report Control
     C                   MOVEL     BGOPDK        WUOPDK                         Optical Disk
     C                   MOVEL     BGNUST        WUNUST                         History & Audit
     C                   MOVEL     BGNZST        WUNZST                         Midas Export Da
     C                   MOVEL     BGN4ST        WUN4ST                         Midas PB ModuleCPB00
     C*                                                                   CPB001
     C** Sets indicator 85 ON if PB presents                              CPB001
     C     BGN4ST        IFEQ      'Y'                                                         CPB00
     C                   MOVE      *ON           *IN85                                         CPB00
     C                   ELSE                                                                  CPB00
     C                   MOVE      *OFF          *IN85                                         CPB00
     C                   ENDIF                                                                 CPB00
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSI         CHAIN     @BGREC8                            90        *
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
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1CNCD        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Country Code
     C                   CALL      'SD0180S'                            90      Select Country
     C                   PARM      *BLANK        W0RTN             7
     C     #1CNCD        PARM      #1CNCD        WQ0001            2            Country Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0180S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        9931      *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to Region Codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1RGCD        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Region Code
     C                   CALL      'SD0190S'                            90      Select Region C
     C                   PARM      *BLANK        W0RTN             7
     C     #1RGCD        PARM      #1RGCD        WQ0002            2            Region Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0190S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        9933      *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VBEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1RGCD        IFEQ      *BLANK                                       Region Code
     C                   GOTO      VBEXIT
     C                   END
      *
     C     KLVBA3        KLIST
     C                   KFLD                    A3RGCD                         Region Code
      * Setup key
     C                   MOVEL     #1RGCD        A3RGCD                         Region Code
     C     *INU1         IFEQ      *ON
     C     KLVBA3        CHAIN     GPREGNL1                           9091
     C                   ELSE
     C     KLVBA3        CHAIN     @A3REBX                            9091      *
     C                   ENDIF
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'Region Codes           NF'
     C                   MOVEL     'USR0065'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR0065'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
      /EJECT                                                                                  CER045
     CSR   VALGRI        BEGSR
      *================================================================                       CER045
      * Validate GRI Country Code                                                             CER045
      *================================================================                       CER045
     C                   MOVE      #1GRIC        WUGRIC            3            Wrk GRI ctry cde
      *                                                                                       CER045
      ** GRI Country code should not be blank                                                 CER045
     C     WUGRIC        IFEQ      *BLANKS
     C                   SETON                                        52        GRI cde err inde
     C                   SETON                                        99        Global err flag
     C                   MOVEL     'USR8428'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      VALEXT
     C                   ENDIF
      *                                                                                       CER045
      ** GRI Country code should be numeric                                                   CER045
      *                                                                                       CER045
     C                   MOVE      *BLANKS       PZFLD
     C                   MOVE      WUGRIC        PZFLD
      *                                                                                       CER045
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PZRTN
     C                   PARM                    PZFLD
     C                   PARM      *ZERO         PZADEC
     C                   PARM      3             PZADIG
     C                   PARM      *BLANKS       PZAFLD
      *                                                                                       CER045
     C     PZRTN         IFNE      *BLANKS
     C                   SETON                                        52        GRI cde err inde
     C                   SETON                                        99        Global err flag
     C                   MOVEL     'USR8429'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      VALEXT
     C                   ENDIF
      *                                                                                       CER045
     C                   MOVE      PZAFLD        #1GRIC
      *                                                                                       CER045
      *================================================================                       CER045
     CSR   VALEXT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y1SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y1EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C     @#DFMT        IFEQ      '#RCDKEY'
      * KEY Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
     C     @#DFMT        IFEQ      '#RCDDTL1'
      * DETAIL Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
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
     C                   PARM      1             YYLGCT            5 0          # of grps
     C                   PARM      W0GRP         YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0181REPP - Country Codes  * S01212
     C*
     C/COPY WNCPYSRC,SD0181REPP
     C*
     C                   END                                                    *FI
      * Start of SAR S01117
      * Processing for Fast Exit
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of SAR S01117
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C**********         CLOSE     GPICTYL0                                                 MD058188
     C                   ENDIF
      *
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
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field Invalid Characters
     C                   MOVEL     *BLANK        WUINVC            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window required
     C                   MOVEL     *BLANK        WUD2DD            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Standing data/Gen.Ledger
     C                   MOVEL     *BLANK        WUSDGL            1
      * Define work field Dealing: FX
     C                   MOVEL     *BLANK        WUDLFX            1
      * Define work field Syndicated Loans (REDUN)
     C                   MOVEL     *BLANK        WUSYLN            1
      * Define work field Exposure Management
     C                   MOVEL     *BLANK        WUEXMG            1
      * Define work field Customer Lending
     C                   MOVEL     *BLANK        WUCSLN            1
      * Define work field Retail Banking
     C                   MOVEL     *BLANK        WURTBN            1
      * Define work field Midas/Swift direct link
     C                   MOVEL     *BLANK        WUMSDL            1
      * Define work field Securities
     C                   MOVEL     *BLANK        WUSECS            1
      * Define work field Auto-reconciliations
     C                   MOVEL     *BLANK        WUAURC            1
      * Define work field Funds Transfer
     C                   MOVEL     *BLANK        WUFDTR            1
      * Define work field Futures & Options
     C                   MOVEL     *BLANK        WUFUOP            1
      * Define work field Message Management
     C                   MOVEL     *BLANK        WUNWMI            1
      * Define work field FRA/IRS Indicator
     C                   MOVEL     *BLANK        WUFIIN            1
      * Define work field Dealing: MM
     C                   MOVEL     *BLANK        WUDLMM            1
      * Define work field Treasury Management
     C                   MOVEL     *BLANK        WUTRMG            1
      * Define work field Interest Risk Management
     C                   MOVEL     *BLANK        WURKMG            1
      * Define work field Microfiche
     C                   MOVEL     *BLANK        WUMFIC            1
      * Define work field Interest on accounts
     C                   MOVEL     *BLANK        WUIOAC            1
      * Define work field Confirmation Matching
     C                   MOVEL     *BLANK        WUCFMT            1
      * Define work field Report Control Facility
     C                   MOVEL     *BLANK        WURCFI            1
      * Define work field Optical Disk
     C                   MOVEL     *BLANK        WUOPDK            1
      * Define work field History & Audit Facility
     C                   MOVEL     *BLANK        WUNUST            1
      * Define work field Midas Export Data Module
     C                   MOVEL     *BLANK        WUNZST            1
      * Define work field Midas Private Banking Module                    CPB001
     C                   MOVEL     *BLANK        WUN4ST            1                           CPB00
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      *                                                                                       CSD031
      ** Check if switchable feature CSD046 is on                                             CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CSD046'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSD046  '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD046            1
     C                   MOVE      *ON           *IN45
     C                   ELSE
     C                   MOVE      'N'           CSD046
     C                   ENDIF
      *                                                                                       CSD031
     C**********           MOVE *INU1     *IN41                                      CSD031 BUG11769
     C                   MOVE      *INU1         *IN50
      *                                                                                       CSD031
      **  Use access program to read bank details file                                        CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C     CSD046        IFEQ      'Y'
     C                   OPEN      GZSDBANK
     C                   READ      GZSDBANK                               90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'GZSDBANK'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   CLOSE     GZSDBANK
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                     BUG11806
     C                   MOVE      'Z'           WLAYR             1
      *                                                                                     BUG11806
     C     CSD046        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVE      'G'           WLAYR
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SD0181RC05
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
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
     C                   OPEN      SD0181R#
     C**********           OPEN SDCTRYL1                                                      CSD031
     C     *INU1         IFEQ      *ON
     C     CSD046        IFEQ      'Y'
     C**********         OPEN      GPCTRYL0                                                 MD058188
     C**********         OPEN      GPCTRYL1                                                 MD058188
     C                   OPEN      GPREGNL1
     C                   ENDIF
     C                   ELSE
     C                   OPEN      SDCTRYL0
     C                   OPEN      SDCTRYL1
     C                   OPEN      SDREGNL1
     C                   ENDIF
     C                   OPEN      SDMMODL1
     C**********           OPEN SDCTRYL0                                                      CSD031
     C**********         OPEN      SDFCTLL0                                                 MD061007
     C                   OPEN      SDCUSTLJ
     C                   OPEN      CLINTL1
     C                   OPEN      SDCNLML1
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of S01459
      * SD0181R Precompiler - Country Codes  *
      * Remove the last amend box function
      * Remove the creation parameters function
      * End of S01459
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Set-up DTL Screen Footer - Standard Functions  *
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
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
      ** F3=Main Menu   F10=Delete   F12=Previous   F15=ISO Country Code                      CSW213
     C                   MOVEL     'USR4841'     WUMSID
     C                   ELSE
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   ENDIF
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
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
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
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * get practically everythin - MIDAS Modules  *
     C                   EXSR      SHRVGN
      * Start of change S01461
      * Remove Midas Export module processing.
      * End of change S01461
      * Mode Processing
      * Insert processing.
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
     C                   MOVEL     'Y'           WUMFTS                         S01212
      * Windows and /COPYs.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SIRVGN
      * Data Structure Country - Country Codes  *
      * 00/Copy member SD0181RFPG - Country Codes  *
      * 00/Copy member SD0181REPG - Country Codes  *
      * 00/Copy member SD0181RIPG - Country Codes  *
      * 00/Copy member SD0181RCPG - Country Codes  *
     C*
     C/COPY WNCPYSRC,SD0181RCPG
     C*
      * 00/Copy member SD0181ROPG - Country Codes  *
     C                   END                                                    *FI
      *                                                                                       CGL032
      ** Access Bank Details.                                                                 CGL032
      *                                                                                       CGL032
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CGL032
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   Z-ADD     101           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                   CFT004
      *** Check if CFT004 is switched on                                  CFT004
      *                                                                   CFT004
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      '       '     @RTCD             7                           CFT00
     C                   PARM      '*VERIFY'     @OPTN             7                           CFT00
     C                   PARM      'CFT004'      @SARD             6                           CFT00
      *                                                                   CFT004
     C     @RTCD         IFEQ      *BLANK                                                      CFT00
     C                   MOVE      'Y'           CFT004            1                           CFT00
     C                   MOVE      *ON           *IN36                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      'N'           CFT004                                        CFT00
     C                   MOVE      *OFF          *IN36                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT004
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
      *                                                                                       CGL014
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL014'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL014
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL014            1
     C                   MOVE      *ON           *IN84
     C                   ELSE
     C                   MOVE      'N'           CGL014
     C                   ENDIF
      *                                                                                       CGP001
      ** Check if CGP001 is enabled.                                                          CGP001
      *                                                                                       CGP001
     C     *DTAARA       DEFINE                  LDA
      *                                                                                       CGP001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGP001'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CGP001
     C                   MOVE      'N'           CGP001            1
     C                   MOVE      *OFF          *IN68
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001
     C                   MOVE      *ON           *IN68
      *                                                                                       CGP001
      ** Open the Global Processing Files.                                                    CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPOF
      *                                                                                       CGP001
     C                   ELSE
      *                                                                                       CGP001
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP001'      DBKEY
     C                   MOVEL     '07'          DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CER001
      ** Check if ULX004 is enabled.                                                          CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'ULX004'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER001
     C     PRTCD         IFNE      '*NRF   '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0181R'     DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX004'      DBKEY
     C                   Z-ADD     01            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX004            1
     C                   ELSE
     C                   MOVE      'N'           ULX004
     C                   ENDIF
      *                                                                                       CER001
      ** Check if ULX043 is enabled.                                                          CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'ULX043'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER001
     C     PRTCD         IFNE      '*NRF   '
     C     PRTCD         ANDNE     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0181R'     DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'ULX043'      DBKEY
     C                   Z-ADD     02            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX043            1
     C                   ELSE
     C                   MOVE      'N'           ULX043
     C                   ENDIF
      *                                                                                       CGL032
      ** Check if CGL032 is enabled.                                                          CGL032
      *                                                                                       CGL032
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL032'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL032
     C                   MOVE      'N'           CGL032            1
     C                   MOVE      *OFF          *IN40
      *                                                                                       CGL032
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL032
     C                   MOVE      *ON           *IN40
     C                   ELSE
      *                                                                                       CGL032
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGL032'      DBKEY
     C                   Z-ADD     102           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL032
     C                   ENDIF
      *                                                                                       CGL032
      ** Check if CGL031 is enabled.                                                          232543
      *                                                                                       232543
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL031'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       232543
     C                   MOVE      'N'           CGL031            1
     C**********           MOVE *OFF      *IN45                                      232543 BUG11705
     C                   MOVE      *OFF          *IN47
      *                                                                                       232543
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL031
     C**********           MOVE *ON       *IN45                                      232543 BUG11705
     C                   MOVE      *ON           *IN47
     C                   ELSE
      *                                                                                       232543
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGL031'      DBKEY
     C                   Z-ADD     102           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       232543
     C                   ENDIF
      *                                                                                       232543
      ** Check if CER045 is enabled.                                                          CER045
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER045'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CER045
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER045            1
     C**********           MOVE *ON       *IN47                                      CER045 AR754499
     C                   MOVE      *ON           *IN51
     C                   ELSE
     C                   MOVE      'N'           CER045
     C**********           MOVE *OFF      *IN47                                      CER045 AR754499
     C                   MOVE      *OFF          *IN51
     C                   ENDIF
      *                                                                                       CER045
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0181R'     DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CER045'      DBKEY
     C                   Z-ADD     103           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CTI006
      ** Check if CTI006 is enabled.                                                          CTI006
      *                                                                                       CTI006
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CTI006'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CTI006
     C                   MOVE      *OFF          *IN65
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CTI006            1
     C                   MOVE      *ON           *IN85
     C     WUN4ST        IFNE      'Y'
     C                   MOVE      *ON           *IN65
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CTI006
     C                   ENDIF
      *                                                                                       CTI006
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0181R'     DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CTI006'      DBKEY
     C                   Z-ADD     104           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER045
      *                                                                                       CSW213
      ** Check if SWIFT Changes 2013 (CSW213) is installed                                    CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW213
     C     PRTCD         IFEQ      'CSW2013'
     C                   MOVE      'Y'           CSW213            1
     C                   ELSE
     C                   MOVE      'N'           CSW213
     C                   ENDIF
      *                                                                                       CSW213
      *** Check if CFT050 is switched on                                                      CSW213
      *                                                                                       CSW213
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT050'      @SARD
      *                                                                                       CSW213
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CFT050            1
     C                   ELSE
     C                   MOVE      'N'           CFT050
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      '0'           *IN84
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
     C**********           OPEN MEISOCL1                                             CSW213 MD058081
     C                   MOVE      '1'           *IN84
     C                   ENDIF
      *                                                                                       CSW213
      ** Controls displaying of BBAN & BANK fields and F15 key                                CSW213
     C     CFT004        IFEQ      'Y'
     C     CSW213        ANDEQ     'Y'
     C     CFT050        OREQ      'Y'
     C                   MOVE      '0'           *IN36
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if CGL132 is switched on                                                       CGL132
      *                                                                                       CGL132
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL132'      @SARD
      *                                                                                       CGL132
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL132            1
     C**********           MOVE *ON       *IN49                                      CGL132 MD026498
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVE      'N'           CGL132
     C**********           MOVE *OFF      *IN49                                      CGL132 MD026498
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
      *                                                                                       CGL132
      ** Check if CGL133 is switched on                                                       CGL132
      *                                                                                       CGL132
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL133'      @SARD
      *                                                                                       CGL132
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL133            1
     C**********           MOVE *ON       *IN50                                      CGL132 MD026498
     C                   MOVE      *ON           *IN56
     C                   ELSE
     C                   MOVE      'N'           CGL133
     C**********           MOVE *OFF      *IN50                                      CGL132 MD026498
     C                   MOVE      *OFF          *IN56
     C                   ENDIF
      *                                                                                       CGL132
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT                                                                                  CSW213
     C     CHKISO        BEGSR
      *================================================================                       CSW213
      * Check ISO                                                                             CSW213
      *================================================================                       CSW213
     C                   MOVEL     #1CNCD        #1ISOC
     C     ISOFND        IFEQ      ' '
      *                                                                                     MD023056
     C********** #1ISOC    CHAINMEISOCL1             90                              CSW213 MD058081
     C                   CALL      'AOMSOCR0'                           90                  MD058081
     C                   PARM      *BLANKS       @RTCD             7                        MD058081
     C                   PARM      '*KEY'        @OPTN             7                        MD058081
     C                   PARM      #1ISOC        @ISOC             2                        MD058081
     C     MEISOC        PARM      MEISOC        DSFDY                                      MD058081
     C********** *IN90     IFEQ '1'                                                  CSW213 MD058081
     C     @RTCD         IFNE      *BLANKS                                                  MD058081
     C                   MOVE      '1'           *IN99
     C                   MOVEL     'SDM0158'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'N'           ISOFND
     C                   ELSE
     C     *IN15         IFEQ      '1'
     C                   CALL      'ME1740'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      'E'           PMODE             1
     C                   PARM                    #1ISOC
     C                   MOVEL     ' '           ISOFND
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD023056
     C                   ELSE
     C     *IN15         IFEQ      '1'
     C                   CALL      'ME1740'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      'E'           PMODE             1
     C                   PARM                    #1ISOC
     C                   MOVEL     ' '           ISOFND
     C                   ENDIF
      *                                                                                     MD023056
     C                   ENDIF
     C                   ENDSR
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
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0181RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0181RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058188
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058188
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0181RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     C*COPY*ZSRSRC,ZALIGNZ2                                               CFT004            MD058188
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058188
      /EJECT                                                                                  CSD031
     CSR   SRSEND        BEGSR
      *================================================================                       CSD031
      * Setup details and send message to data queue                                          CSD031
      *================================================================                       CSD031
     C                   MOVEL     'GPCTRYPD'    WPFNAM
     C                   MOVEL     #1CNCD        WKEYS
     C                   MOVEL     @1DBRC        WDATA
     C                   MOVEL     WDTQ          PDQMSG
     C     'SD'          CAT       'ACCPDTQ'     PDQNAM           10
      *                                                                                       CSD031
     C     *LOVAL        SETLL     GPZONEL0
     C                   READ      GPZONEL0                               90
     C     *IN90         DOWEQ     *OFF
     C     ZOMSYS        CAT       'DPLIB'       PDQLIB
     C********** ZOMSYS    CAT  PGMB      PGMNAM 16                                    CSD031 CSC043
     C     ZOMSYS        CAT       PGMB          PGMNAM           17
     C                   CALL      PGMNAM
     C                   PARM                    PDQNAM
     C                   PARM                    PDQLIB           10
     C                   PARM                    PDQMSG
     C                   READ      GPZONEL0                               90
     C                   ENDDO
      *================================================================                       CSD031
     CSR                 ENDSR
      *================================================================                       CSD031
     O*
     O/COPY WNCPYSRC,SD0181ROPG
     O*
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA OVRC
OVRDBF FILE(GPICTYL0) TOFILE(GPICTRYL0)                                                       CGP001
