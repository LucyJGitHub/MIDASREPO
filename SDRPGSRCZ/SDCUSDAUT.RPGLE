     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details authorisation')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSDAUT - Customer Details Authorisation                   *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *             for Customer Details.                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 260405             Date 04Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030956           Date 09Oct14               *
      *                 CFT050             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15138           Date 25Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG14969B          Date 15Oct07               *
      *                 BUG14969A          Date 09Oct07               *
      *                 BUG14969           Date 09Oct07               *
      *                 BUG14924           Date 28Sep07               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD028             Date 22Aug05               *
      *                 BUG7186            Date 16May05               *
      *                 BUG7018            Date 05May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6506            Date 05Apr05               *
      *                 BUG6314            Date 05Apr05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD023             Date 18Nov04               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5407            Date 14Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3362            Date 28Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  260405 - BRT Participation Date of Birth field is missing.   *
      *           Upgrade fix 235425. Recompile over changed SDCBRTPD.*
      *         - Applied for MD055446.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15138 - IBEI is not updated when CSW207 is off            *
      *  BUG14969B - Commitment control error on SDSWSHL0 (Reopen)    *
      *  BUG14969A - Customer details error after update (Reopen)     *
      *  BUG14969 - Cannot authorise amendments to Customer details   *
      *             SWIFT additional fields.                          *
      *  BUG14924 - Mismatch parameter for Customer Details update    *
      *             during standing data authorization                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  BUG7186- SRDelete does not commit data                       *
      *  BUG7018- Fields not displayed at authorisation               *
      *           TEMPFIX hooks removed and bugfix 6506 applied       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6506- SDCUSDAUT module has wrong hook names               *
      *  BUG6314- Shadowing FSA window details                        *
      *           Amend /COPY SDCUSDF001, SDCUSDD001, SDCUSDD002,     *
      *           SDCUSDAC02, SDCUSDAC03, SDCUSDAC05                  *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5407 - Database error upon authorising a customer         *
      *            amendment via Standing Data Authorisation Menu     *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3362 - TI changes not reflection on Menu XSDA.            *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     FSDCBRTL0  IF   E           K DISK    INFSR(*PSSR)
     FSDPBDSL0  IF   E           K DISK    INFSR(*PSSR)
     FSDTICSL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3362
     FSDCSSWL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG14969

     FSDCDSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBG:SDCDSHD0)
     FSDCDSHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:SDCDSHD1)
      ** Midas SD Customer Details Shadow File

     FSDCBSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCBRTD0:SDCBSHD0)
     FSDCBSHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCBRTD0:SDCBSHD1)
      ** Midas SD BRT Customer Details Shadow File

     FSDPBSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDPBDSD0:SDPBSHD0)
     FSDPBSHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDPBDSD0:SDPBSHD1)
      ** Midas SD Private Banking Customer Details File

     FSDTDSHL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG3362
     F                                     RENAME(SDTICSD0:SDTICSH0)                         BUG3362
     FSDTDSHL1  UF A E           K DISK    INFSR(*PSSR)                                      BUG3362
     F                                     RENAME(SDTICSD0:SDTICSH1)                         BUG3362
      ** Midas TI Customer Details Shadow File                                               BUG3362
      *                                                                                      BUG3362
     F***SDSWSHL0  IF   E           K DISK    INFSR(*PSSR)                        BUG14969 BUG14969B
     FSDSWSHL0  UF   E           K DISK    INFSR(*PSSR) COMMIT                             BUG14969B
     F                                     RENAME(SDSWSHD0:SDSWSHD0)                        BUG14969
     F***SDSWSHL1  UF   E           K DISK    INFSR(*PSSR)                        BUG14969 BUG14969B
     FSDSWSHL1  IF   E           K DISK    INFSR(*PSSR)                                    BUG14969B
     F                                     RENAME(SDSWSHD0:SDSWSHD1)                        BUG14969
      ** Midas Customer Extention SWIFT Details Shadow file                                 BUG14969
                                                                                            BUG14969
     FSDAULGL2  IF   E           K DISK    INFSR(*PSSR)
     FSDAULGL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD3)
      ** Midas SD Authorisation Log - by Function

     F/COPY WNCPYSRC,SDCUSDF001
     F*/COPY**WNCPYSRC,SDCUSDC001*****                                                TEMPFIXBUG7018

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short Data Structure

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR Midas Modules Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * DATA STRUCTURE FOR Midas SAR Details

     D @1DCUST       E DS                  EXTNAME(SDCUSTPD)
      * Stored Customer details file format fields
     D @1DCBRT       E DS                  EXTNAME(SDCBRTPD)
      * Stored BRT Customer Details file format fields
     D @1DPBDS       E DS                  EXTNAME(SDPBDSPD)
      * Stored Private banking details file format fields
     D @1DTICS       E DS                  EXTNAME(SDTICSPD)                                 BUG3362
      * Stored Trade Innovation Customer Details file fields                                 BUG3362
     D @1DSWCS       E DS                  EXTNAME(SDCSSWPD)                                BUG14969
      * Stored Customer Extension SWIFT Details file fields                                 BUG14969
      **Current*Customer*-*SWIFT*Details**in*File*Format******                     BUG14924 BUG14969
     D*ValidSwft*    E DS                  EXTNAME(SDVSWSDPD)                      BUG14924 BUG14969
     D**********                           PREFIX(V_)                              BUG14924 BUG14969

     D #1DCUST       E DS                  EXTNAME(SDCUSTPD) PREFIX(#)
      * Stored Customer shadow file format fields
     D #1DCBRT       E DS                  EXTNAME(SDCBRTPD) PREFIX(#)
      * Stored BRT Customer shadow file format fields
     D #1DPBDS       E DS                  EXTNAME(SDPBDSPD) PREFIX(#)
      * Stored Private banking Customer shadow file format fields
     D #1DTICS       E DS                  EXTNAME(SDTICSPD) PREFIX(#)                       BUG3362
      * Stored Trade Innovation Customer Details shadow file format fields                   BUG3362
     D #1DSWCS       E DS                  EXTNAME(SDCSSWPD) PREFIX(#)                      BUG14969
      * Stored Customer Extension SWIFT Details shadow file format fields                   BUG14969

      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1

     D UBA             DS          5000
      **  1st Record Format
     D  MAINUBA                            LIKE(@1DCUST)
     D  EXT1UBA                            LIKE(@1DCBRT)
     D  EXT2UBA                            LIKE(@1DPBDS)
     D  EXT3UBA                            LIKE(@1DTICS)                                     BUG3362
     D  EXT4UBA                            LIKE(@1DSWCS)                                    BUG14969
     D/COPY WNCPYSRC,SDCUSDD001

     D UPA             DS          5000
      **  2nd Record Format
     D  MAINUPA                            LIKE(@1DCUST)
     D  EXT1UPA                            LIKE(@1DCBRT)
     D  EXT2UPA                            LIKE(@1DPBDS)
     D  EXT3UPA                            LIKE(@1DTICS)                                     BUG3362
     D  EXT4UPA                            LIKE(@1DSWCS)                                    BUG14969
     D/COPY WNCPYSRC,SDCUSDD002

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ***Override*SDCDSHL0,SDCBSHL0*&*SDPBSHL0.****************************                  BUG3362
      ***Override*SDCDSHL0,SDCBSHL0,SDPBSHL0*and*SDTDSHL0.*****************         BUG3362 BUG14969
      ** Override SDCDSHL0,SDCBSHL0,SDPBSHL0,SDTDSHL0, and SDSWSHL0                         BUG14969
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)
     D CMD1            S              1    DIM(50) CTDATA PERRCD(50)
     D CMD2            S              1    DIM(50) CTDATA PERRCD(50)
     D CMD3            S              1    DIM(50) CTDATA PERRCD(50)                         BUG3362
     D CMD4            S              1    DIM(50) CTDATA PERRCD(50)                        BUG14969

     D CSD012          S              1A
     D SVALKK          C                   CONST('AuthReqCustomerMaint')
     D FUNCD           C                   CONST('CUSTOMER DETAILS')
     D @RUN            S              1
     D CPY2@           S             80
                                                                                              CLE025
     D CLE025          S              1                                                       CLE025
     D CFX001          S              1                                                       CFX001
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PMODE           S              1                                                       CLE025
     D CSD028          S              1                                                       CSD028
     D PTransType      S              4                                                       CSD028
     D CSW207          S              1A                                                   BUG14969A
     D*/COPY*WNCPYSRC,SDCUSDC002******                                                TEMPFIXBUG7018

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Access record from authorisation log
     C     KAULG         CHAIN     SDAULGL2                           80
      *
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   MOVE      FUNCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access record from master file
     C                   MOVEL     PKEY          @CUCUST           6
     C*****              MOVEL     PKEY          @BRCNUM           6 0                        CSD027
     C*****              MOVEL     PKEY          @PBCNUM           6 0                        CSD027
     C                   MOVEL     PKEY          @BRCNUM           6                          CSD027
     C                   MOVEL     PKEY          @PBCNUM           6                          CSD027
     C                   MOVEL     PKEY          @TCCUST           6                         BUG3362
     C                   MOVEL     PKEY          @SWCUST           6                        BUG14969

     C     @CUCUST       CHAIN     SDCUSTL0                           81
      *
     C                   IF        *IN81 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @CUCUST       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       MAINUBA
     C                   MOVEL     @1DCUST       MAINUBA
     C                   ENDIF

     C     S01383        IFEQ      'Y'

     C     @BRCNUM       CHAIN     SDCBRTL0                           82
      *
     C                   IF        *IN82 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCBRTPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     @BRCNUM       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT1UBA
     C                   MOVEL     @1DCBRT       EXT1UBA
     C                   ENDIF

     C                   ENDIF

     C     BGN4ST        IFEQ      'Y'

     C     @PBCNUM       CHAIN     SDPBDSL0                           83
      *
     C                   IF        *IN83 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDPBDSPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     @PBCNUM       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT2UBA
     C                   MOVEL     @1DPBDS       EXT2UBA
     C                   ENDIF

     C                   ENDIF
      *                                                                                      BUG3362
      ** Access record from TI Customer Details File                                         BUG3362
      *                                                                                      BUG3362
     C     @TCCUST       CHAIN     SDTICSL1                           79                     BUG3362
      *                                                                                      BUG3362
     C                   IF        *IN79 = '1' AND ALACTN = 'A'                              BUG3362
     C     BBTICS        IFEQ      'Y'                                                       BUG3362
     C     *LOCK         IN        LDA                                                       BUG3362
     C                   MOVEL     'SDTICSPD'    DBFILE                                      BUG3362
     C                   MOVEL     '008'         DBASE                                       BUG3362
     C                   MOVEL     @TCCUST       DBKEY                                       BUG3362
     C                   OUT       LDA                                                       BUG3362
     C                   EXSR      *PSSR                                                     BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ELSE                                                                BUG3362
     C                   MOVEL     *BLANKS       EXT3UBA                                     BUG3362
     C                   MOVEL     @1DTICS       EXT3UBA                                     BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
      * Access record from Customer Extension SWIFT Details File                            BUG14969
                                                                                            BUG14969
     C**********         IF        CSW207 = 'Y'                                   BUG14969A BUG15138
     C     @SWCUST       CHAIN     SDCSSWL1                                                 BUG14969
                                                                                            BUG14969
     C**********         IF        NOT %FOUND AND ALACTN = 'A'                     BUG14969 BUG15138
     C******LOCK         IN        LDA                                             BUG14969 BUG15138
     C**********         MOVEL     'SDCSSWPD'    DBFILE                            BUG14969 BUG15138
     C**********         MOVEL     '008'         DBASE                             BUG14969 BUG15138
     C**********         MOVEL     @SWCUST       DBKEY                             BUG14969 BUG15138
     C**********         OUT       LDA                                             BUG14969 BUG15138
     C**********         EXSR      *PSSR                                           BUG14969 BUG15138
      **********                                                                   BUG14969 BUG15138
     C**********         ELSE                                                      BUG14969 BUG15138
     C                   IF        %FOUND(SDCSSWL1)                                         BUG15138
     C                   MOVEL     *BLANKS       EXT4UBA                                    BUG14969
     C                   MOVEL     @1DSWCS       EXT4UBA                                    BUG14969
     C                   ENDIF                                                              BUG14969
     C**********         ENDIF                                                    BUG14969A BUG15138

      ** Access record from shadow Customer file
     C     @CUCUST       CHAIN     SDCDSHL0                           84
      *
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       MAINUPA
     C                   MOVEL     @1DCUST       MAINUPA
     C                   ELSE
     C                   MOVEL     *BLANKS       MAINUBA
     C                   MOVEL     @1DCUST       MAINUBA
     C                   ENDIF

     C     @BRCNUM       CHAIN     SDCBSHL0                           85
      *
     C                   IF        *IN85 = '1'
     C                   CLEAR                   @1DCBRT
     C                   MOVEL     @1DCBRT       EXT1UBA
     C                   MOVEL     @1DCBRT       EXT1UPA
      *
     C                   ELSE
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       EXT1UPA
     C                   MOVEL     @1DCBRT       EXT1UPA
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT1UBA
     C                   MOVEL     @1DCBRT       EXT1UBA
     C                   ENDIF

     C                   ENDIF

     C     @PBCNUM       CHAIN     SDPBSHL0                           86
      *
     C                   IF        *IN86 = '1'
     C                   CLEAR                   @1DPBDS
     C                   MOVEL     @1DPBDS       EXT2UBA
     C                   MOVEL     @1DPBDS       EXT2UPA
      *
     C                   ELSE
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       EXT2UPA
     C                   MOVEL     @1DPBDS       EXT2UPA
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT2UBA
     C                   MOVEL     @1DPBDS       EXT2UBA
     C                   ENDIF

     C                   ENDIF
      *                                                                                      BUG3362
      ** Access record from shadow Trade Innovation Customer Details file                    BUG3362
      *                                                                                      BUG3362
     C     @TCCUST       CHAIN     SDTDSHL0                           78                     BUG3362
     C                   IF        *IN78 = '1'                                               BUG3362
     C                   CLEAR                   @1DTICS                                     BUG3362
     C                   MOVEL     @1DTICS       EXT3UBA                                     BUG3362
     C                   MOVEL     @1DTICS       EXT3UPA                                     BUG3362
      *                                                                                      BUG3362
     C                   ELSE                                                                BUG3362
     C                   IF        ALACTN = 'A'                                              BUG3362
     C                   MOVEL     *BLANKS       EXT3UPA                                     BUG3362
     C                   MOVEL     @1DTICS       EXT3UPA                                     BUG3362
     C                   ELSE                                                                BUG3362
     C                   MOVEL     *BLANKS       EXT3UBA                                     BUG3362
     C                   MOVEL     @1DTICS       EXT3UBA                                     BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
                                                                                            BUG14969
      * Access record from Shadow Customer Extension SWIFT Details File                     BUG14969
                                                                                            BUG14969
     C**********         IF        CSW207 = 'Y'                                   BUG14969A BUG15138
     C*****@SWCUST       CHAIN     SDSWSHL0                                       BUG14969 BUG14969B
     C     @SWCUST       CHAIN     SDSWSHL1                                                BUG14969B
                                                                                            BUG14969
     C                   IF        NOT %FOUND                                               BUG14969
     C     *LOCK         IN        LDA                                                      BUG14969
     C                   CLEAR                   @1DSWCS                                    BUG14969
     C                   MOVEL     @1DSWCS       EXT4UBA                                    BUG14969
     C                   MOVEL     @1DSWCS       EXT4UBA                                    BUG14969
                                                                                            BUG14969
     C                   ELSE                                                               BUG14969
     C                   IF        ALACTN = 'A'                                             BUG14969
     C                   MOVEL     *BLANKS       EXT4UPA                                    BUG14969
     C                   MOVEL     @1DSWCS       EXT4UPA                                    BUG14969
     C                   ELSE                                                               BUG14969
     C                   MOVEL     *BLANKS       EXT4UBA                                    BUG14969
     C                   MOVEL     @1DSWCS       EXT4UBA                                    BUG14969
     C                   ENDIF                                                              BUG14969
     C                   ENDIF                                                              BUG14969
     C**********         ENDIF                                                    BUG14969A BUG15138
     C**********/COPY WNCPYSRC,SDCUSDC002***                                         TEMPFIX BUG6506
     C/COPY WNCPYSRC,SDCUSDAC02                                                              BUG6506

      ** Call program SDAUTHCMP to display differences

     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'SDCUSTPD'    FILE             10
     C                   PARM                    UBA
     C                   PARM                    UPA

     C                   PARM                    PKEY
     C                   PARM                    PACTN
      ** Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1

      ** Exit program if Enquire or F3 or F12
     C                   IF        PACTN = 'E' OR @INKC = '1' OR @INKL = '1'
     C                   MOVEL     RETCODE       ERRMSG
     C                   EXSR      SREnd
     C                   ENDIF

      ** Authorise Requested
     C                   IF        @INKI = '1'
     C                   EXSR      SRUpdate
     C                   EXSR      SRDelete
     C                   ENDIF

      ** Delete Requested
     C                   IF        @INKJ = '1'
     C                   EXSR      SRDelete
     C                   ENDIF
      *
      ** End program
     C                   EXSR      SREnd
      /EJECT
      *****************************************************************
      * SRDelete - Delete Authorisation request from Log file and     *
      *            Shadow file.                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRDelete      BEGSR

      ** Delete record from Audit Log
     C     KAULG         CHAIN     SDAULGL3                           87
      *
     C                   IF        *IN87 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   MOVE      FUNCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
     C                   DELETE    SDAULGL3
     C                   ENDIF

      ** Delete record from Shadow file
     C     @CUCUST       CHAIN     SDCDSHL1                           88
      *
     C                   IF        *IN88 = '0'
     C                   DELETE    SDCDSHL1
     C                   ENDIF

      ** Delete record from BRT Customer Shadow file if S01383 is ON

     C     S01383        IFEQ      'Y'

     C     @BRCNUM       CHAIN     SDCBSHL1                           89
      *
     C                   IF        *IN89 = '0'
     C                   DELETE    SDCBSHD1
     C                   ENDIF

     C                   ENDIF

      ** Delete record from Private Banking Customer Shadow file
      ** If BGN4St is ON

     C     BGN4ST        IFEQ      'Y'

     C     @PBCNUM       CHAIN     SDPBSHL1                           90
      *
     C                   IF        *IN90 = '0'
     C                   DELETE    SDPBSHD1
     C                   ENDIF

     C                   ENDIF
      *                                                                                      BUG3362
      ** Delete record from TI Customer Details shadow file                                  BUG3362
      *                                                                                      BUG3362
     C     @TCCUST       CHAIN     SDTDSHL1                           70                     BUG3362
      *                                                                                      BUG3362
     C                   IF        *IN70 = '0'                                               BUG3362
     C                   DELETE    SDTICSH1                                                  BUG3362
     C                   ENDIF                                                               BUG3362
      ** Delete record from Customer Extension SWIFT Details shadow file                    BUG14969
                                                                                            BUG14969
     C**********         IF        CSW207 = 'Y'                                   BUG14969A BUG15138
     C*****@SWCUST       CHAIN     SDSWSHL1                                       BUG14969 BUG14969B
     C     @SWCUST       CHAIN     SDSWSHL0                                                BUG14969B
     C                   IF        %FOUND                                                   BUG14969
     C**********         DELETE    SDSWSHD1                                       BUG14969 BUG14969B
     C                   DELETE    SDSWSHD0                                                BUG14969B
     C                   ENDIF                                                              BUG14969
     C**********         ENDIF                                                    BUG14969A BUG15138
                                                                                            BUG14969

     C*****/COPY*WNCPYSRC,SDCUSDC003**                                                       BUG6506
     C/COPY WNCPYSRC,SDCUSDAC03                                                              BUG6506

     C                   COMMIT                                                              BUG7186
                                                                                             BUG7186
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRUpdate - Update master file with shadow file details        *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRUpdate      BEGSR

      ** Hold shadow record image for the 3 customer master files
     C     @CUCUST       CHAIN     SDCDSHL0                           84
     C                   IF        *IN84 = '0'
     C                   MOVEL     @1DCUST       #1DCUST
     C                   ENDIF

     C     S01383        IFEQ      'Y'

     C     @BRCNUM       CHAIN     SDCBSHL0                           85
     C                   IF        *IN85 = '0'
     C                   MOVEL     @1DCBRT       #1DCBRT
     C                   ENDIF
     C                   ENDIF

     C     BGN4ST        IFEQ      'Y'

     C     @PBCNUM       CHAIN     SDPBSHL0                           86
     C                   IF        *IN86 = '0'
     C                   MOVEL     @1DPBDS       #1DPBDS
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3362
      ** If record exist on TI file for the customer, i.e. if TI flag is Y                   BUG3362
      *                                                                                      BUG3362
      *    TIFLAG        IFEQ 'Y'                                                            BUG3362
     C     @TCCUST       CHAIN     SDTDSHL0                           71                     BUG3362
     C                   IF        *IN71 ='0'                                                BUG3362
     C                   MOVEL     @1DTICS       #1DTICS                                     BUG3362
     C                   ELSE                                                                BUG5407
      *                                                                                      BUG5407
      **  If record not found, zeroise numeric field in #1DTICS to avoid                     BUG5407
      **  decimal data error.                                                                BUG5407
      *                                                                                      BUG5407
     C                   Z-ADD     0             #TCLCD                                      BUG5407
     C                   ENDIF                                                               BUG3362
      *                  ENDIF                                                               BUG3362

      ** Hold shadow image from Customer Extn SWIFT Details shadow file                     BUG14969
                                                                                            BUG14969
     C**********         IF        CSW207 = 'Y'                                   BUG14969A BUG15138
     C*****@SWCUST       CHAIN     SDSWSHL1                                       BUG14969 BUG14969B
     C     @SWCUST       CHAIN     SDSWSHL0                                                BUG14969B
     C                   IF        %FOUND                                                   BUG14969
     C                   MOVEL     @1DSWCS       #1DSWCS                                    BUG14969
     C                   ENDIF                                                              BUG14969
     C**********         ENDIF                                                    BUG14969A BUG15138
                                                                                            BUG14969
     C     @CUCUST       CHAIN     SDCUSTL0                           81

 B1  C     *IN81         IFEQ      *ON
     C     ALACTN        ANDNE     'I'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     @CUCUST       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR

 X1  C                   ELSE
                                                                                              CSD023
     C                   if        ALACTN='C' or ALACTN='R'                                   CSD023
     C                   eval      #bbtylc=ALACTN                                             CSD023
     C                   endif                                                                CSD023
                                                                                              CSD023
     C                   MOVEL     PACTN         AUTHMD
      *                                                                                       CSD028
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   EVAL      PTransType = 'AUTH'                                        CSD028
     C                   ENDIF                                                                CSD028

      ** Update Master files

     C                   CALLB     'SDCUSDUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    #1DCUST
     C                   PARM                    #1DCBRT
     C                   PARM                    #1DPBDS
     C                   PARM                    #1DTICS                                     BUG3362
     C*****              PARM                    ValidSwft                         BUG14924 BUG14969
     C                   PARM                    #1DSWCS                                    BUG14969
      ** Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      ** Authorisation Mode
     C                   PARM                    AUTHMD            1
     C                   PARM                    V_DDGCUS         10                         222373
     C                   PARM                    S01383
     C                   PARM                    CSW024            1
     C                   PARM                    CGP001            1                         222373
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
     C                   PARM                    PTransType                                   CSD028
     C                   PARM                    DACTN                                        CSD028
     C                   PARM                    CTI006            1                        MD030956
      *
     C/COPY WNCPYSRC,SDCUSDAC05                                                              BUG6314
      ** IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      ** UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
 B2  C                   IF        @RTCD <> *BLANK
     C                   ROLBK
      *
 B3  C                   IF        @RTCD =  '*ERROR '
     C                   EXSR      *PSSR
 E3  C                   ENDIF
      *
     C                   EXSR      SREND
      *
 X2  C                   ELSE
     C                   COMMIT
 E2  C                   ENDIF
     C
 E1  C                   ENDIF

     C*****/COPY*WNCPYSRC,SDCUSDC004*                                                        BUG6506
     C/COPY WNCPYSRC,SDCUSDAC04                                                              BUG6506

     C                   ENDSR
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : None                                               *
      *****************************************************************
     C     SREnd         BEGSR

      ** Terminate program

     C                   EVAL      *INLR = *ON

      ** Exit program

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    :                                                   *
      *****************************************************************
     C     *INZSR        BEGSR

      * Override SDCDSHL0
     C                   Z-ADD     50            CMDLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    CMDLEN

      * Override SDCBSHL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD1
     C                   PARM                    CMDLEN

      * Override SDPBSHL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD2
     C                   PARM                    CMDLEN
      * Override SDTDSHL0                                                                    BUG3362
     C                   CALL      'QCMDEXC'                                                 BUG3362
     C                   PARM                    CMD3                                        BUG3362
     C                   PARM                    CMDLEN                                      BUG3362
      **Override*SDSWSHL0                                                         BUG14969 BUG14969B
      * Override SDSWSHL1                                                                  BUG14969B
     C**********         IF        CSW207 = 'Y'                                   BUG14969A BUG15138
     C                   CALL      'QCMDEXC'                                                BUG14969
     C                   PARM                    CMD4                                       BUG14969
     C                   PARM                    CMDLEN                                     BUG14969
     C**********         ENDIF                                                    BUG14969A BUG15138

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@

      ** Define Keylist
     C     KAULG         KLIST
     C                   KFLD                    @FUNC            21
     C                   KFLD                    PKEY
      *
     C                   MOVEL     FUNCD         @FUNC

      ** Receive entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    RETCODE           7
     C**********         PARM                    PKEY             20                          CGL029
     C                   PARM                    PKEY             26                          CGL029
     C                   PARM                    PACTN             1
     C                   PARM                    DACTN             1                          CSD028
     C                   PARM                    ERRMSG            7
     C                   PARM                    @INKC

      ** Define LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SDCUSDAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA

      ** Access SAR details file to determine if CSD012
      ** (Standing Data Authorisation) is on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSD012'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD012
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF

      ** If CSD012 is ON, Check if Customer Details Authorisation is ON
 B1  C     CSD012        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
      *
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     '007'         DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SDCUSDAUT'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Customer Details Authorisation is On set to Authorise
     C     SVAL11        IFEQ      'Y'
     C                   MOVE      'Y'           AUTHRQ
     C                   ELSE
     C                   MOVE      'N'           AUTHRQ
     C                   ENDIF
      *
 E1  C                   ENDIF

      ** Access SAR details file to determine if S01383
      ** (Base Rate Tax) is on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   ENDIF

      ** Access SAR details file to determine if CSW024
      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW024'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW024
     C                   ELSE
     C                   MOVEL     'N'           CSW024
     C                   ENDIF
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY  = 'CLE025'                                          CLE025
     C                   EVAL      DBASE  = 008                                               CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CFX001
      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
                                                                                              CFX001
     C                   CALLB     'AOSARDR0'                                                 CFX001
     C                   PARM      *BLANKS       PRTCD                                        CFX001
     C                   PARM      '*VERIFY'     POPTN                                        CFX001
     C                   PARM      'CFX001'      PSARD                                        CFX001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFX001
                                                                                              CFX001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFX001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFX001
     C                   EVAL      DBKEY  = 'CFX001'                                          CFX001
     C                   EVAL      DBASE  = 009                                               CFX001
     C                   EXSR      *PSSR                                                      CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C                   IF        PRTCD = *BLANKS                                            CFX001
     C                   EVAL      CFX001 = 'Y'                                               CFX001
     C                   ELSE                                                                 CFX001
     C                   EVAL      CFX001 = 'N'                                               CFX001
     C                   ENDIF                                                                CFX001

      ** Check if enhancement CSD028 (KYC) is on                                              CSD028
      *                                                                                       CSD028
     C                   CALLB     'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       PRTCD                                        CSD028
     C                   PARM      '*VERIFY'     POPTN                                        CSD028
     C                   PARM      'CSD028'      PSARD                                        CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
      *                                                                                       CSD028
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD028
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
     C                   EVAL      DBKEY  = 'CSD028'                                          CSD028
     C                   EVAL      DBASE  = 912                                               CSD028
     C                   EXSR      *PSSR                                                      CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   IF        PRTCD = *BLANKS                                            CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   ELSE                                                                 CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   ENDIF                                                                CSD028
      *
      ** Access Modules details
      ** (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      *                                                                                    BUG14969A
      ** Check if SWIFT 2007 is installed                                                  BUG14969A
      *                                                                                    BUG14969A
     C                   CALL      'SWIF2007'                                              BUG14969A
     C                   PARM      *BLANKS       PRtCd                                     BUG14969A
                                                                                           BUG14969A
     C                   IF        PRtCd   = 'CSW2007'                                     BUG14969A
     C                   EVAL      CSW207 = 'Y'                                            BUG14969A
     C                   ELSE                                                              BUG14969A
     C                   EVAL      CSW207 = 'N'                                            BUG14969A
     C                   ENDIF                                                             BUG14969A
                                                                                           BUG14969A
     C**********/COPY*WNCPYSRC,SDCUSDC001**                                          TEMPFIX BUG6506
     C/COPY WNCPYSRC,SDCUSDAC01                                                              BUG6506

     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
** CMD
OVRDBF FILE(SDCDSHL0) TOFILE(SDCDSHL0) SHARE(*NO)
** CMD1
OVRDBF FILE(SDCBSHL0) TOFILE(SDCBSHL0) SHARE(*NO)
** CMD2
OVRDBF FILE(SDPBSHL0) TOFILE(SDPBSHL0) SHARE(*NO)
** CMD3                                                                                      BUG3362
OVRDBF FILE(SDTDSHL0) TOFILE(SDTDSHL0) SHARE(*NO)                                            BUG3362
** CMD4                                                                                     BUG14969
OVRDBF FILE(SDSWSHL1) TOFILE(SDSWSHL1) SHARE(*NO)                                 BUG14969 BUG14969B
