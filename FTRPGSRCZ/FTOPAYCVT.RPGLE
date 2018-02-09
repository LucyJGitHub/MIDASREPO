     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing pmnts cnv file to screen format')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYCVT - Outgoing Payments Conversion:                    *
      *              File to Screen Format                            *
      *                                                               *
      *  Function:  This module converts the fields of an Outgoing    *
      *             payment from their format as on file to a         *
      *             screen format.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039986           Date 10Aug16               *
      *                 MD024011           Date 10Aug16               *
      *                 AR1090283          Date 10Aug16               *
      *                 CFT157             Date 29Aug14               *
      *                 AR1080200          Date 24Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 BUG18401           Date 29Apr08               *
      *                 BUG17019A          Date 31Mar08               *
      *                 BUG17718           Date 07Apr08               *
      *                 BUG17019           Date 19Mar08               *
      *                 250600             Date 07Oct07               *
      *                 249709             Date 14Aug07               *
      *                 BUG14156           Date 25Jun07               *
      *                 BUG14157           Date 19Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 240077             Date 30May06               *
      *                 BUG6864            Date 13Dec05               *
      *                 BUG7455            Date 03Jun05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAP084             Date 14Jan04               *
      *                 219241             Date 01Jul03               *
      *                 212647             Date 09Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 195220             Date 21Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      *                 190845             Date 12Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
/*    *                 179994             Date 14Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 24May00               *
      *                 CFT007             Date 16Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 22Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039986 - Additional codes to upgrade AR1090283.            *
      *  MD024011 - Pb when job name is QZDASSINIT                    *
      *           - Applied for MD-39986.                             *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  AR1080200 - In Charge details 2 tab, charges on the left and *
      *              right hand side of the screen is incorrect       *
      *            - Partially applied fix 222568                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.(Recompiled)    *
      *  BUG18401 - During amend of newly inserted transactions,      *
      *             expanding the field details caused errors         *
      *  BUG17019A - Some Charge Code amounts change values after     *
      *             authorisation.                                    *
      *  BUG17718 - Reverse fix 249709 since bug14157 is present      *
      *  BUG17019 - Some Charge Code amounts change values after      *
      *             authorisation.                                    *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  249709 - FT OPAY SWIFT Charge converted incorrectly          *
      *  BUG14156 - Amend decimal places in Charge Amount             *
      *  BUG14157 - Error in SWIFT Standard Charge Conv.              *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  240077 - Correct codes of BUG6864 making sure that proper    *
      *           fields are reset to blanks.                         *
      *  BUG6864- If charge is zero then make screen field blank      *
      *           to be consistent with code field                    *
      *  BUG7455 - If BJDFIN = 'M', display format of Settle and Pay   *
      *           value date are not correct once defaulted during    *
      *           enquiry.  No need to check BJDFIN as fields SLDTD1  *
      *           and PVDTD1 are already in correct screen format     *
      *           whether BJDFIN is 'D' or 'M'.                       *
      *           Applied fix 221127.                                 *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  212647 - Charges are not shown correctly on the screen.      *
      *  195220 - Expand field details.                               *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  190845 - Set up fields for Message Unique Reference and      *
      *           Part Number                                         *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
/*    *  179994 - Access FT ICD and not FO ICD                        *
      *  175479 - FONTIS: Dealer's reference field                    *
      *  CFT007 - Recompile - BIC Database Plus Integration           *
      *  CFT004 - Recompile, IBAN - International Bank Account Number *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      *****************************************************************
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
 
      * Payment Status
     D/COPY WNCPYSRC,FTH00457
     D*@STSA****       S             24    DIM(5) CTDATA PERRCD(1)                            CFT157
     D @STSA           S             24    DIM(6) CTDATA PERRCD(1)                            CFT157
     D/COPY WNCPYSRC,FTH00458
 
      * Payment details in file format
     D PmntFilFmt    E DS                  EXTNAME(OTPAYDD)
                                                                                CFT014
      ** Payment detail extension in file format                                CFT014
     D PmntFilFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
 
      * Payment details in screen formats
     D PmtScnFmt1    E DS                  EXTNAME(FTOPY1PD)
     D PmtScnFm1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D PmtScnFmt2    E DS                  EXTNAME(FTOPY2PD)
     D PmtScnFmt3    E DS                  EXTNAME(FTOPY3PD)
     D PmtScnFmt4    E DS                  EXTNAME(FTOPY4PD)
     D PmtScnFmt5    E DS                  EXTNAME(FTOPY5PD)                    CFT014
     D PmtScnFmt6    E DS                  EXTNAME(FTOPY6PD)                    CFT014
     D PmtScnFmt7    E DS                  EXTNAME(FTOPY7PD)                    CFT014
     D PmtScnFmtA    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D PmtScnFmtC    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D*SDFODA****    E DS                  EXTNAME(SDFODAPD)                    179994
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    179994
      ** EXTERNAL DS FOR FUNDS TRANSFER ICD DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D XLCD          E                     EXTFLD(LCD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
      ** External DS for Midas Message Management ICD                                         219241
                                                                                              219241
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *                                                                                       CER030
     D PmtScnFmt7A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
     D PmtScnFmt7B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
 
     D P8FT            DS           128                                                       195220
      *                                                                                       195220
      ** Currency                                                                             195220
     D  W8CCY                  1      3                                                       195220
      *                                                                                       195220
      ** Settlement Type                                                                      195220
     D  W8STMT                 4      5                                                       195220
      *                                                                                       195220
      ** Mandatory Text - convert BIC identifiers                                             195220
     D  W8MTXT                 6      6                                                       195220
      *                                                                                       195220
      ** Message Tag                                                                          195220
     D  W8MTAG                 7     11                                                       195220
      *                                                                                       195220
      ** Construct of data in field                                                           195220
     D  W8TYPE                12     12                                                       195220
      *                                                                                       195220
      ** Number of Lines available                                                            195220
     D  W8NLIN                13     14  0                                                    195220
      *                                                                                       195220
      ** Network and Message Type                                                             195220
     D  W8NWRK                15     20                                                       195220
     D  W8MTPY                21     23                                                       195220
      *                                                                                       195220
      ** Calling Program                                                                      195220
     D  W8CPGM                24     33                                                       195220
      *                                                                                       195220
      ** Action *PRINT/*ENQ/*MSG GEN                                                          195220
     D  W8ACT                 34     41                                                       195220
      *                                                                                       195220
      ** Critical Reporting - Database error if 'Y'.                                          195220
      ** If no BIC directory and BIC entered, no error.                                       195220
     D  W8CRIT                42     42                                                       195220
      *                                                                                       195220
      ** Force Midas Address - where possible                                                 195220
     D  W8MADD                43     43                                                       195220
      *                                                                                       195220
      ** If Retail, get first address from account                                            195220
     D  W8RTAD                44     44                                                       195220
      *                                                                                       195220
      ** Alternative Address                                                                  195220
     D  W8ALTN                45     45                                                       195220
      *                                                                                       195220
      ** Address Type                                                                         195220
     D  W8ADTP                46     46                                                       195220
      *                                                                                       195220
      ** DS for Redefining Address Fields                                                     195220
     D                 DS                                                                     195220
     D  WADDRSS                1    175                                                       195220
     D  WADCHK1                1     35                                                       195220
     D  WADCHK2               36     70                                                       195220
     D  WADCHK3               71    105                                                       195220
     D  WADCHK4              106    140                                                       195220
     D  WADCHK5              141    175                                                       195220
      *                                                                                       195220
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D  @@SXP1                 1      1  0
     D  @@SXP2                 2      2  0
 
     D*
     D                 DS
     D**  Data structures for re-definition of screen fields
     D* Sender's Correspondent
     D  SendCorr               1     15
     D  SNOS                   1      2
     D*
     D                 DS
     D**  Ordering Bank
     D  OrdrngBank             1     12
     D  ORNS                   1      2
     D  ORRT                   1     10
     D*
     D*
     D* Parameters for AOCCYCV0                                                 CFT009
     D D#DTA           DS           256                                         CFT009
     D  D#FCCY                 1      3                                         CFT009
     D  D#FAMT                 4     11P 0                                      CFT009
     D  D#TCCY                12     14                                         CFT009
     D  D#TAMT                15     22P 0                                      CFT009
     D  D#IMDIN               23     23                                         CFT009
     D  D#IRATE               24     36P 8                                      CFT009
     D  D#OMDIN               23     23                                         CFT009
     D  D#ORATE               24     36P 8                                      CFT009
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Msg Unique Reference                                                                  190845
     D SHMSGR          S              8  0                                                    190845
     D                                                                                        190845
      * Part Number                                                                           190845
     D SHPART          S              3  0                                                    190845
      *                                                                                       190845
     D C#ACTN          S              8                                         CFT009
     D C#RTCD          S              7                                         CFT009
     D PRTCD           S              7                                                       219241
     D POPTN           S              7                                                       219241
     D PSard           S              6                                                       CER030
     D CER031          S              1                                                       CER030
     D CER030          S              1                                                       CER030
     D CFT003          S              1                                                       CER030
     D CGL013          S              1                                                       CER030
 
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
                                                                                              CSW209
     D CSW209          S              1A                                                      CSW209
                                                                                              CSW209
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** SET OUTPUT SCREEN FIELDS
      *
     C                   EXSR      SETFLD
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT                                                                                  195220
      *****************************************************************                       195220
      *                                                               *                       195220
      *  SREXPGM - Call expansion program FT0315                      *                       195220
      *                                                               *                       195220
      *****************************************************************                       195220
      *                                                                                       195220
     C     SREXPGM       BEGSR                                                                195220
      *                                                                                       195220
      ** Call expansion program.                                                              195220
      *                                                                                       195220
     C                   CALL      'FT0315'                             9090                  195220
     C                   PARM      *BLANKS       P8RTN             7                          195220
     C                   PARM                    P8FT                                         195220
     C                   PARM                    P8LINS          256                          195220
     C                   PARM                    P8RPT           256                          195220
     C                   PARM                    P8MSG           256                          195220
     C                   PARM                    P8SCR           256                          195220
      *                                                                                       195220
      ** Check if database error occurred.                                                    195220
      *                                                                                       195220
     C     *IN90         IFEQ      '1'                                                        195220
     C     P8RTN         ORNE      *BLANKS                                                    195220
     C                   MOVEL     '*CALL'       DBKEY                                        195220
     C                   MOVEL     'FT0315  '    DBFILE                                       195220
     C                   Z-ADD     5             DBASE                                        195220
     C                   EXSR      *PSSR                                                      195220
     C                   ENDIF                                                                195220
      *                                                                                       195220
     C                   ENDSR                                                                195220
      *                                                                                       195220
      *****************************************************************                       195220
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
     C*
     C**  Payment Reference
     C                   MOVE      PREF          SPREF
     C*
     C**  Booking branch code.
     C     BRCA          IFNE      *BLANKS
     C                   MOVE      BRCA          SBRCA
     C                   END
     C*
     C**  Originating Branch
     C                   MOVE      ORBR          SORBR
     C*
     C**  Payment type.
     C                   MOVE      PYTP          SPYTP
     C*
     C**  Payment sub-type.
     C                   MOVE      PYST          SPYST
     C*
     C**  Settlement type.
     C                   MOVE      STMT          SSTTP
     C/COPY WNCPYSRC,FTOPAYNC01
     C*
     C**  Swift Priority.
     C     SWPC          IFEQ      0
     C                   MOVE      *BLANK        SSWPC
     C                   END
     C*
     C     SWPC          IFEQ      1
     C                   MOVE      'U'           SSWPC
     C                   END
     C*
     C     SWPC          IFEQ      2
     C                   MOVE      'N'           SSWPC
     C                   END
     C*
     C**  Destination
     C     DSTT          IFEQ      'G'
     C     @MBIN         ANDEQ     'N'
     C                   MOVEL     DST1          DSTNM            15
     C                   MOVEL     DSTNM         SDST1
     C                   ELSE
     C                   MOVE      DST1          SDST1
     C                   END
     C                   MOVE      DST2          SDST2
     C                   MOVE      DST3          SDST3
     C                   MOVE      DST4          SDST4
      *                                                                                       195220
     C/COPY WNCPYSRC,FTH00642
     C     SACTION       IFEQ      'E'                                                        195220
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *                                                                                       195220
     C                   CLEAR                   P8FT                                         195220
     C                   MOVEL     *BLANKS       W8STMT                                       195220
     C                   MOVEL     PCCY          W8CCY                                        195220
     C                   MOVEL     PSPROCPGM     W8CPGM                                       195220
     C                   MOVEL     '*ENQ  '      W8ACT                                        195220
     C                   Z-ADD     4             W8NLIN                                       195220
      *                                                                                       195220
     C                   MOVEL     DSTT          W8TYPE                                       195220
     C                   MOVEL     *BLANKS       P8LINS                                       195220
     C                   MOVEL     *BLANKS       WADDRSS                                      195220
     C                   MOVEL     DST1          WADCHK1                                      195220
     C                   MOVEL     DST2          WADCHK2                                      195220
     C                   MOVEL     DST3          WADCHK3                                      195220
     C                   MOVEL     DST4          WADCHK4                                      195220
     C                   MOVEL     *Blanks       WADCHK5                                      195220
     C                   MOVEL     WADDRSS       P8LINS                                       195220
      *                                                                                       195220
     C                   EXSR      SREXPGM                                                    195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       SDST1                                        195220
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      SDST2                                        195220
     C     35            SUBST     P8SCR:71      SDST3                                        195220
     C     35            SUBST     P8SCR:106     SDST4                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
     C/COPY WNCPYSRC,FTH00643
     C*
     C**  MT100 Customer.
     C     ODMT          IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       SODMT
     C                   ELSE
     C                   MOVEL     *BLANKS       SODMT
     C                   MOVEL     ODMT          SODMT
     C                   END
     C*
     C**  Ordering Customer.
     C                   MOVE      *BLANK        SORBT             1
     C                   MOVE      *BLANK        SORCT             1
     C                   MOVEL     *BLANKS       ORCFLD
     C                   MOVEL     'MT202'       ORCFLD           35
      *
     C*
     C     ORCT          IFEQ      'P'
     C     @MBIN         ANDEQ     'N'
     C**********         MOVEL     ORC1          ORCNM            12                          CFT032
     C                   MOVEL     ORC1          ORCNM            13                          CFT032
     C                   MOVEL     ORCNM         SORC1
     C                   ELSE
     C                   MOVE      ORC1          SORC1
     C                   END
     C*
     C     SORC1         IFEQ      ORCFLD
     C                   MOVE      OPORB1        SORC2
     C                   MOVE      OPORB2        SORC3
     C                   MOVE      OPORB3        SORC4
     C                   MOVE      OPORB4        SORC5                                        CFT032
     C                   ELSE
     C                   MOVE      ORC2          SORC2
     C                   MOVE      ORC3          SORC3
     C                   MOVE      ORC4          SORC4
     C                   MOVE      ORC5          SORC5                                        CFT032
     C                   END
      *                                                                                       195220
     C/COPY WNCPYSRC,FTH00644
     C     SACTION       IFEQ      'E'                                                        195220
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *                                                                                       195220
     C                   CLEAR                   P8FT                                         195220
     C                   MOVEL     *BLANKS       W8STMT                                       195220
     C                   MOVEL     SMCY          W8CCY                                        195220
     C                   MOVEL     PSPROCPGM     W8CPGM                                       195220
     C                   MOVEL     '*ENQ  '      W8ACT                                        195220
     C**********         Z-ADD     4             W8NLIN                                195220 CFT032
     C                   Z-ADD     5             W8NLIN                                       CFT032
      *                                                                                       195220
     C                   MOVEL     ORCT          W8TYPE                                       195220
     C                   MOVEL     *BLANKS       P8LINS                                       195220
     C                   MOVEL     *BLANKS       WADDRSS                                      195220
     C                   MOVEL     ORC1          WADCHK1                                      195220
     C                   MOVEL     ORC2          WADCHK2                                      195220
     C                   MOVEL     ORC3          WADCHK3                                      195220
     C                   MOVEL     ORC4          WADCHK4                                      195220
     C**********         MOVEL     *Blanks       WADCHK5                               195220 CFT032
     C                   MOVEL     ORC5          WADCHK5                                      CFT032
     C                   MOVEL     WADDRSS       P8LINS                                       195220
      *                                                                                       195220
     C                   EXSR      SREXPGM                                                    195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       SORC1                                        195220
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      SORC2                                        195220
     C     35            SUBST     P8SCR:71      SORC3                                        195220
     C     35            SUBST     P8SCR:106     SORC4                                        195220
     C                   Eval      SORC5 = %Subst(P8SCR:141:35)                               CFT032
      *                                                                                       195220
     C                   ENDIF                                                                195220
     C/COPY WNCPYSRC,FTH00645
     C*
     C**  Sender's Correspondent
     C                   MOVE      *BLANKS       SendCorr
     C     SNCT          IFEQ      'N'
     C                   MOVEL     SNCO          SNOS
     C                   MOVEL     SendCorr      SSNCO
     C                   ELSE
     C     SNCT          IFEQ      'R'
     C                   MOVE      SNCO          SSNCO
     C                   END
     C                   END
     C*
     C**  Ordering Bank.
     C                   MOVE      *BLANKS       OrdrngBank
     C     ORBT          IFEQ      'N'
     C                   MOVEL     ORBK          ORNS
     C                   MOVEL     OrdrngBank    SORBK
     C                   ELSE
     C     ORBT          IFEQ      'R'
     C                   MOVEL     ORBK          ORRT
     C                   MOVEL     OrdrngBank    SORBK
     C                   ELSE
     C     ORBT          IFEQ      'P'
     C                   MOVE      ORBK          SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      ORBB          SORBB
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C**  Send MT202
     C                   MOVE      SNMT          SSNMT
     C*
     C**  Notified Delivery Currency/amount.
     C                   MOVE      NDCY          SNDCY
     C*
     C** If currency not blank format amount based on ccy decimal places.
     C     SNDCY         IFNE      *BLANKS
     C                   MOVE      SNDCY         @AJCD             3
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Format amount
     C                   Z-ADD     NDAM          @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SNDAM
     C                   END
     C*
     C**  Settlement Currency/amount.
     C                   MOVE      SMCY          SSMCY
     C*
     C** If currency not blank format amount based on ccy decimal places.
     C     SSMCY         IFNE      *BLANKS
     C                   MOVE      SSMCY         @AJCD             3
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Format amount
     C                   Z-ADD     SMAM          @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SSMAM
     C                   END
     C*
     C**  Settlement Value Date
     C*****BJDFIN        IFEQ      'D'                                                       BUG7455
     C                   MOVE      SLDTD1        SPYDT
     C*****              ELSE                                                                BUG7455
     C*****              MOVE      SLDTD3        SPYDT                                       BUG7455
     C*****              END                                                                 BUG7455
     C*
     C**  Pay Currency/amount.
     C                   MOVE      PCCY          SPCCY
     C*
     C** If currency not blank format amount based on ccy decimal places.
     C     SPCCY         IFNE      *BLANKS
     C                   MOVE      SPCCY         @AJCD             3
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
                                                                                CFT014
      ** Save pay currency decimal places                                       CFT014
                                                                                CFT014
     C                   Z-Add     A6NBDP        WPayDec           1 0          CFT014
     C*
     C**  Format amount
     C                   Z-ADD     PYAM          @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SPYAM
     C                   END
     C*
     C**  Settlement Value Date
     C*****BJDFIN        IFEQ      'D'                                                       BUG7455
     C                   MOVE      PVDTD1        SPYVD
     C*****              ELSE                                                                BUG7455
     C*****              MOVE      PVDTD3        SPYVD                                       BUG7455
     C*****              END                                                                 BUG7455
                                                                                CFT014
      ** Instructed currency/amount will only be shown if CEU006 or CFT014      CFT014
      ** is installed.                                                          CFT014
                                                                                CFT014
     C                   If        (@CEU006 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C*
     C**  Pay Delivery Currency/amount.
     C                   MOVE      PDCY          SPDCY
     C*
     C** If currency not blank format amount based on ccy decimal places.
     C     SPDCY         IFNE      *BLANKS
     C                   MOVE      SPDCY         @AJCD             3
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Format amount
     C                   Z-ADD     PDAM          @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SPDAM
     C                   END
     C                   EndIf                                                  CFT014
     C*
     C**  Rate.
     C*
     C**  Format rate
     C                   MOVE      RATE          @@AMTW
     C                   Z-ADD     8             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SRATE
     C*
     C**  Overide Indicator.
     C                   MOVE      OVRD          SOVRD
     C*
     C**  Add/Deduct Indicator.
     C                   MOVE      ADDC          SADDC
     C*
     C**  Book code.
     C                   MOVE      BOKC          SBOKC
     C*
     C**  Profit Centre
     C                   MOVE      PRFC          SPRFC
     C*
     C**  Regular Pay Indicator.
     C                   MOVE      RPAY          SRPAY
     C*
     C**  Interest Payment Frequency.
     C                   MOVE      PAYF          SPAYF
     C*
     C**  Interest Payment Day in Month.
     C     DYIM          IFEQ      0
     C                   MOVE      *BLANK        SDYIM
     C                   ELSE
     C                   MOVE      DYIM          SDYIM
     C                   END
     C*
     C**  Next Interest Payment Date.
     C     NPDTD1        IFNE      0
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      NPDTD1        SNDAT
     C                   ELSE
     C                   MOVE      NPDTD3        SNDAT
     C                   END
     C*
     C                   ELSE
     C                   MOVE      *BLANKS       SNDAT
     C                   END
 
     C**  Final Payment Date
     C     FDATD1        IFNE      0
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      FDATD1        SFIND
     C                   ELSE
     C                   MOVE      FDATD3        SFIND
     C                   END
     C*
     C                   ELSE
     C                   MOVE      *BLANKS       SFIND
     C                   END
 
     C**  Transfer Comission tariff
     C                   MOVEL     TRCT          STRCT
     C*
     C**  Charges to Debit of Account
     C                   MOVEL     *BLANKS       SCDRO
      *
     C     CDRT          IFNE      *BLANKS
     C     *LIKE         DEFINE    SCDRO         A#0012
     C                   MOVEL     CDRO          A#0012
      *
     C                   SELECT
     C     CDRT          WHENEQ    'N'
     C     2             SUBST(P)  A#0012:1      SCDRO
     C     CDRT          WHENEQ    'R'
     C     10            SUBST(P)  A#0012:1      SCDRO
     C     CDRT          WHENEQ    'P'
     C                   MOVEL     CDRO          SCDRO
     C                   ENDSL
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       SCDRO
     C                   END
     C*
     C**  Charges to Debit of Branch
     C                   MOVEL     CDBR          SCDBR
      *                                                                                       CFT120
      ** Charges to Debit of Currency                                                         CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     OPCDRC        SCDRC                                        CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT157
      ** Stop User                                                                            CFT157
      *                                                                                       CFT157
     C                   IF        CFT157 = 'Y'                                               CFT157
     C                   MOVEL     SUSR          SSUSR                                        CFT157
     C                   ENDIF                                                                CFT157
     C*
      **  Receivers Correspondent
     C                   MOVEL     RCO1          SRCO1
     C                   MOVEL     RCO2          SRCO2
     C                   MOVEL     RCO3          SRCO3
     C                   MOVEL     RCO4          SRCO4
     C                   MOVEL     RCO5          SRCO5
      *                                                                                       195220
     C/COPY WNCPYSRC,FTH00646
     C     SACTION       IFEQ      'E'                                                        195220
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *                                                                                       195220
     C                   CLEAR                   P8FT                                         195220
     C                   MOVEL     *BLANKS       W8STMT                                       195220
     C                   MOVEL     PSPROCPGM     W8CPGM                                       195220
     C                   MOVEL     '*ENQ  '      W8ACT                                        195220
     C                   Z-ADD     5             W8NLIN                                       195220
      *                                                                                       195220
     C                   MOVEL     RCRT          W8TYPE                                       195220
     C                   MOVEL     *BLANKS       P8LINS                                       195220
     C                   MOVEL     *BLANKS       WADDRSS                                      195220
     C                   MOVEL     RCO1          WADCHK1                                      195220
     C                   MOVEL     RCO2          WADCHK2                                      195220
     C                   MOVEL     RCO3          WADCHK3                                      195220
     C                   MOVEL     RCO4          WADCHK4                                      195220
     C                   MOVEL     RCO5          WADCHK5                                      195220
     C                   MOVEL     WADDRSS       P8LINS                                       195220
      *                                                                                       195220
     C                   EXSR      SREXPGM                                                    195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       SRCO1                                        195220
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      SRCO2                                        195220
     C     35            SUBST     P8SCR:71      SRCO3                                        195220
     C     35            SUBST     P8SCR:106     SRCO4                                        195220
     C     35            SUBST     P8SCR:141     SRCO5                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
     C/COPY WNCPYSRC,FTH00647
     C*
      **  Account with Institution
     C                   MOVEL     ACB1          SACB1
     C                   MOVEL     ACB2          SACB2
     C                   MOVEL     ACB3          SACB3
     C                   MOVEL     ACB4          SACB4
     C                   MOVEL     ACB5          SACB5
      *                                                                                       195220
     C/COPY WNCPYSRC,FTH00648
     C     SACTION       IFEQ      'E'                                                        195220
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *                                                                                       195220
     C                   CLEAR                   P8FT                                         195220
     C                   MOVEL     *BLANKS       W8STMT                                       195220
     C                   MOVEL     PSPROCPGM     W8CPGM                                       195220
     C                   MOVEL     '*ENQ  '      W8ACT                                        195220
     C                   Z-ADD     5             W8NLIN                                       195220
      *                                                                                       195220
     C                   MOVEL     ACBT          W8TYPE                                       195220
     C                   MOVEL     *BLANKS       P8LINS                                       195220
     C                   MOVEL     *BLANKS       WADDRSS                                      195220
     C                   MOVEL     ACB1          WADCHK1                                      195220
     C                   MOVEL     ACB2          WADCHK2                                      195220
     C                   MOVEL     ACB3          WADCHK3                                      195220
     C                   MOVEL     ACB4          WADCHK4                                      195220
     C                   MOVEL     ACB5          WADCHK5                                      195220
     C                   MOVEL     WADDRSS       P8LINS                                       195220
      *                                                                                       195220
     C                   EXSR      SREXPGM                                                    195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       SACB1                                        195220
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      SACB2                                        195220
     C     35            SUBST     P8SCR:71      SACB3                                        195220
     C     35            SUBST     P8SCR:106     SACB4                                        195220
     C     35            SUBST     P8SCR:141     SACB5                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
     C/COPY WNCPYSRC,FTH00649
     C*
      **  Beneficiary
     C                   MOVEL     BNC1          SBNC1
     C                   MOVEL     BNC2          SBNC2
     C                   MOVEL     BNC3          SBNC3
     C                   MOVEL     BNC4          SBNC4
     C                   MOVEL     BNC5          SBNC5
      *                                                                                       195220
     C/COPY WNCPYSRC,FTH00650
     C     SACTION       IFEQ      'E'                                                        195220
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *                                                                                       195220
     C                   CLEAR                   P8FT                                         195220
     C                   MOVEL     *BLANKS       W8STMT                                       195220
     C                   MOVEL     PSPROCPGM     W8CPGM                                       195220
     C                   MOVEL     '*ENQ  '      W8ACT                                        195220
     C                   Z-ADD     5             W8NLIN                                       195220
      *                                                                                       195220
     C                   MOVEL     BNCT          W8TYPE                                       195220
     C                   MOVEL     *BLANKS       P8LINS                                       195220
     C                   MOVEL     *BLANKS       WADDRSS                                      195220
     C                   MOVEL     BNC1          WADCHK1                                      195220
     C                   MOVEL     BNC2          WADCHK2                                      195220
     C                   MOVEL     BNC3          WADCHK3                                      195220
     C                   MOVEL     BNC4          WADCHK4                                      195220
     C                   MOVEL     BNC5          WADCHK5                                      195220
     C                   MOVEL     WADDRSS       P8LINS                                       195220
      *                                                                                       195220
     C                   EXSR      SREXPGM                                                    195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       SBNC1                                        195220
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      SBNC2                                        195220
     C     35            SUBST     P8SCR:71      SBNC3                                        195220
     C     35            SUBST     P8SCR:106     SBNC4                                        195220
     C     35            SUBST     P8SCR:141     SBNC5                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
     C/COPY WNCPYSRC,FTH00651
     C*
      **  Details of Payment
     C                   MOVEL     DTP1          SDTP1
     C                   MOVEL     DTP2          SDTP2
     C                   MOVEL     DTP3          SDTP3
     C                   MOVEL     DTP4          SDTP4
     C*
      **  Sender to Receiver information
     C                   MOVEL     BBI1          SBBI1
     C                   MOVEL     BBI2          SBBI2
     C                   MOVEL     BBI3          SBBI3
     C                   MOVEL     BBI4          SBBI4
     C                   MOVEL     BBI5          SBBI5
     C                   MOVEL     BBI6          SBBI6
     C*
     C**  Intermediary Bank.
     C                   MOVEL     INB1          SINB1
     C                   MOVEL     INB2          SINB2
     C                   MOVEL     INB3          SINB3
     C                   MOVEL     INB4          SINB4
     C                   MOVEL     INB5          SINB5
      *                                                                                       195220
     C/COPY WNCPYSRC,FTH00652
     C     SACTION       IFEQ      'E'                                                        195220
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *                                                                                       195220
     C                   CLEAR                   P8FT                                         195220
     C                   MOVEL     *BLANKS       W8STMT                                       195220
     C                   MOVEL     PSPROCPGM     W8CPGM                                       195220
     C                   MOVEL     '*ENQ  '      W8ACT                                        195220
     C                   Z-ADD     5             W8NLIN                                       195220
      *                                                                                       195220
     C                   MOVEL     INBT          W8TYPE                                       195220
     C                   MOVEL     *BLANKS       P8LINS                                       195220
     C                   MOVEL     *BLANKS       WADDRSS                                      195220
     C                   MOVEL     INB1          WADCHK1                                      195220
     C                   MOVEL     INB2          WADCHK2                                      195220
     C                   MOVEL     INB3          WADCHK3                                      195220
     C                   MOVEL     INB4          WADCHK4                                      195220
     C                   MOVEL     INB5          WADCHK5                                      195220
     C                   MOVEL     WADDRSS       P8LINS                                       195220
      *                                                                                       195220
     C                   EXSR      SREXPGM                                                    195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       SINB1                                        195220
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      SINB2                                        195220
     C     35            SUBST     P8SCR:71      SINB3                                        195220
     C     35            SUBST     P8SCR:106     SINB4                                        195220
     C     35            SUBST     P8SCR:141     SINB5                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
     C/COPY WNCPYSRC,FTH00653
     C*
     C**  Central Bank Reference.
     C     DNBC          IFNE      0
     C                   MOVEL     DNBC          SDNBC
     C                   ELSE
     C                   MOVEL     *BLANKS       SDNBC
     C                   END
                                                                                CFT014
      ** Get currency's number of decimal places                                CFT014
                                                                                CFT014
     C***********        If        BTCHCY = 'C'                                 CFT014 187056
     C***********        If        SADDC = 'A'                                  CFT014 187056
     C***********        Eval      WCURCY = SSMCY                               CFT014 187056
     C***********        Else                                                   CFT014 187056
     C***********        Eval      WCURCY = SPCCY                               CFT014 187056
     C***********        EndIf                                                  CFT014 187056
      ***********                                                               CFT014 187056
     C***********        Else                                                   CFT014 187056
     C***********        If        BTCHCY = 'L'                                 CFT014 187056
     C***********        Eval      WCURCY = BJLCCY                              CFT014 187056
     C***********        Else                                                   CFT014 187056
     C***********        Eval      WCURCY = BJCYCD                              CFT014 187056
     C***********        EndIf                                                  CFT014 187056
     C***********        EndIf                                                  CFT014 187056
                                                                                187056
     C                   SELECT                                                 187056
     C                   WHEN      BTCHCY = 'B' OR SCDRO <> *BLANKS             187056
     C**********                   AND CFT120 = 'N'                                 CFT120 AR1080200
     C                             AND CFT120 = 'N' AND BTCHCY = 'C'                       AR1080200
     C                   EVAL      WCURCY = BJCYCD                              187056
     C                   WHEN      CFT120 = 'Y' AND SCDRO <> *BLANKS                       AR1080200
     C                             AND BTCHCY = 'C'                                        AR1080200
     C                   EVAL      WCURCY = SCDRC                                          AR1080200
     C                   WHEN      BTCHCY = 'L'                                 187056
     C                   EVAL      WCURCY = BJLCCY                              187056
     C                   WHEN      BTCHCY = 'C' AND SADDC = 'A'                 187056
     C                   EVAL      WCURCY = SSMCY                               187056
     C                   WHEN      BTCHCY = 'F'                                 CFT009
     C                   EVAL      WCURCY = FCHCCY                              CFT009
     C                   OTHER                                                  187056
     C                   EVAL      WCURCY = SPCCY                               187056
     C                   ENDSL                                                  187056
                                                                                CFT014
     C                   Eval      @CCCY = WCURCY                               CFT014
     C                   Eval      SCCYA1 = WCURCY                              CAP084
     C                   Eval      SCCYA2 = WCURCY                              CAP084
     C                   Eval      SCCYA3 = WCURCY                              CAP084
     C                   ExSr      SrACCY                                       CFT014
      *
     C**  Transfer Commission
     C*
     C**  Format amount
     C     DUMA1         IFNE      0
     C                   Z-ADD     DUMA1         @@AMTW
     C                   Z-ADD     DUMA1         @TRCD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @TRCD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C                   Eval      STRCD = *blanks                                           BUG6864
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STRCD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C*
     C**  Telex Charge.
     C*
     C**  Format amount
     C     DUMA2         IFNE      0
     C                   Z-ADD     DUMA2         @@AMTW
     C                   Z-ADD     DUMA2         @TXCD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @TXCD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C***********        Eval      STRCD = *blanks                                    BUG6864 240077
     C                   Eval      STXCD = *blanks                                            240077
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STXCD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C*
     C**  Cheque Charge.
     C*
     C**  Format amount
     C     DUMA3         IFNE      0
     C                   Z-ADD     DUMA3         @@AMTW
     C                   Z-ADD     DUMA3         @CQCD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @CQCD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C***********        Eval      STRCD = *blanks                                    BUG6864 240077
     C                   Eval      SCQCD = *blanks                                            240077
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCQCD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C*
     C**  Costs Abroad.
     C*
     C**  Format amount
     C     DUMA4         IFNE      0
     C                   Z-ADD     DUMA4         @@AMTW
     C                   Z-ADD     DUMA4         @CSTD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @CSTD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C***********        Eval      STRCD = *blanks                                    BUG6864 240077
     C                   Eval      SCSTD = *blanks                                            240077
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCSTD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C*
     C**  Swift Priority Charge.
     C*
     C**  Format amount
     C     DUMA5         IFNE      0
     C                   Z-ADD     DUMA5         @@AMTW
     C                   Z-ADD     DUMA5         @SPCD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @SPCD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C***********        Eval      STRCD = *blanks                                    BUG6864 240077
     C                   Eval      SSPCD = *blanks                                            240077
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SSPCD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C*
     C**  Miscellaneous Charge.
     C*
     C**  Format amount
     C     DUMA6         IFNE      0
     C                   Z-ADD     DUMA6         @@AMTW
     C                   Z-ADD     DUMA6         @MSCD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @MSCD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C***********        Eval      STRCD = *blanks                                    BUG6864 240077
     C                   Eval      SMSCD = *blanks                                            240077
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SMSCD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C*
     C**  FX Charge/Commission.
     C*
     C**  Format amount
     C     S01494        IFEQ      'Y'
     C     OPDUM7        IFNE      0
     C                   Z-ADD     OPDUM7        @@AMTW
     C                   Z-ADD     OPDUM7        @CHCD                          CFT014
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   Z-ADD     *ZERO         @CHCD                                        212647
     C                   ENDIF                                                                212647
     C                   If        @@AMTW = *Zeros                                           BUG6864
     C***********        Eval      STRCD = *blanks                                    BUG6864 240077
     C                   Eval      SCHCD = *blanks                                            240077
     C                   Else                                                                BUG6864
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCHCD
     C                   EndIf                                                               BUG6864
     C**********         END                                                                  212647
     C                   END
     C*                                                                                     BUG17019
     C**  Swift Standard Charge.                                                            BUG17019
     C*                                                                                     BUG17019
     C**  Format amount                                                                     BUG17019
     C                   Z-ADD     SWSCCC        @@AMTW                                     BUG17019
     C                   Z-ADD     SWSCCC        @SSCD                                      BUG17019
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG17019
     C                   EXSR      FMTAMT                                                   BUG17019
     C                   MOVE      @@AMTD        STCD                                       BUG17019
     C                   If        @@AMTW = *Zeros                                          BUG17019
     C                   Eval      STCD = *blanks                                           BUG17019
     C                   Else                                                               BUG17019
     C                   MOVE      @@AMTD        STCD                                       BUG17019
     C                   EndIf                                                              BUG17019
     C*                                                                                     BUG17019
     C**  Miscellaneous 1 Charge.                                                           BUG17019
     C*                                                                                     BUG17019
     C**  Format amount                                                                     BUG17019
     C                   Z-ADD     MISCC1        @@AMTW                                     BUG17019
     C                   Z-ADD     MISCC1        @MI1CD                                     BUG17019
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG17019
     C                   EXSR      FMTAMT                                                   BUG17019
     C                   MOVE      @@AMTD        M1CD                                       BUG17019
     C*                                                                                     BUG17019
     C**  Miscellaneous 2 Charge.                                                           BUG17019
     C*                                                                                     BUG17019
     C**  Format amount                                                                     BUG17019
     C                   Z-ADD     MISCC2        @@AMTW                                     BUG17019
     C                   Z-ADD     MISCC2        @MI2CD                                     BUG17019
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG17019
     C                   EXSR      FMTAMT                                                   BUG17019
     C                   MOVE      @@AMTD        M2CD                                       BUG17019
     C*                                                                                     BUG17019
     C**  Miscellaneous 3 Charge.                                                           BUG17019
     C*                                                                                     BUG17019
     C**  Format amount                                                                     BUG17019
     C                   Z-ADD     MISCC3        @@AMTW                                     BUG17019
     C                   Z-ADD     MISCC3        @MI3CD                                     BUG17019
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG17019
     C                   EXSR      FMTAMT                                                   BUG17019
     C                   MOVE      @@AMTD        M3CD                                       BUG17019
     C*                                                                                     BUG17019
     C**  Miscellaneous 4 Charge.                                                           BUG17019
     C*                                                                                     BUG17019
     C**  Format amount                                                                     BUG17019
     C                   Z-ADD     MISCC4        @@AMTW                                     BUG17019
     C                   Z-ADD     MISCC4        @MI4CD                                     BUG17019
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG17019
     C                   EXSR      FMTAMT                                                   BUG17019
     C                   MOVE      @@AMTD        M4CD                                       BUG17019
     C*                                                                                     BUG17019
     C**  Miscellaneous 5 Charge.                                                           BUG17019
     C*                                                                                     BUG17019
     C**  Format Amount                                                                     BUG17019
     C                   Z-ADD     MISCC5        @@AMTW                                     BUG17019
     C                   Z-ADD     MISCC5        @MI5CD                                     BUG17019
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG17019
     C                   EXSR      FMTAMT                                                   BUG17019
     C                   MOVE      @@AMTD        M5CD                                       BUG17019
     C*                                                                                    BUG17019A
     C**  VAT Amounts.                                                                     BUG17019A
     C*                                                                                    BUG17019A
     C**  Format Amount                                                                    BUG17019A
     C                   Z-ADD     OPDUM8        @VATD                                     BUG17019A
     C                   Z-ADD     OPDUM8        @@AMTW                                    BUG17019A
     C                   Z-ADD     A6NBDP        @@QECN                                    BUG17019A
     C                   EXSR      FMTAMT                                                  BUG17019A
     C                   MOVE      @@AMTD        STOTVA                                    BUG17019A
                                                                                CFT014
 
      ** Get currency's number of decimal places                                CFT014
                                                                                CFT014
     C                   If        (SCDRO <> *Blank)                            CFT014
      *                                                                                       CFT120
     C                   If        SCDRC = *Blanks AND CFT120 = 'Y'                           CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C                   Eval      @RCCY = BJCYCD                               CFT014
     C                   Else                                                                 CFT120
     C                   Eval      @RCCY = SCDRC                                              CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   Else                                                   CFT014
     C                   If        SADDC = 'A'                                  CFT014
     C                   Eval      @RCCY = SSMCY                                CFT014
     C                   Else                                                   CFT014
     C                   Eval      @RCCY = SPCCY                                CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CAP084
     C                   Eval      SCCYB1 = @RCCY                               CAP084
     C                   Eval      SCCYB2 = @RCCY                               CAP084
     C                   Eval      SCCYB3 = @RCCY                               CAP084
     C                   Eval      @CCCY = SCCYB1                               CAP084
     C                   Eval      WCURCY = SCCYB1                                          BUG14156
     C                   ExSr      SrACCY                                       CAP084
                                                                                CFT014
      **  Transfer Commission                                                   CFT014
                                                                                CFT014
     C     TRCM          IFNE      0                                            CFT014
     C                   Z-ADD     TRCM          @TRCM                          CFT014
     C                   Z-ADD     TRCM          @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        STRCM                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @TRCM                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        STRCM                          CAP084       BUG6864
     C                   Eval      STRCM = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      **  Telex Charge.                                                         CFT014
                                                                                CFT014
     C     TXCH          IFNE      0                                            CFT014
     C                   Z-ADD     TXCH          @TXCH                          CFT014
     C                   Z-ADD     TXCH          @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        STXCH                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @TXCH                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        STXCH                          CAP084       BUG6864
     C                   Eval      STXCH = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      **  Cheque Charge.                                                        CFT014
                                                                                CFT014
     C     CQCH          IFNE      0                                            CFT014
     C                   Z-ADD     CQCH          @CQCH                          CFT014
     C                   Z-ADD     CQCH          @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SCQCH                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @CQCH                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        SCQCH                          CAP084       BUG6864
     C                   Eval      SCQCH = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      **  Costs Abroad.                                                         CFT014
                                                                                CFT014
     C     CSTA          IFNE      0                                            CFT014
     C                   Z-ADD     CSTA          @CSTA                          CFT014
     C                   Z-ADD     CSTA          @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SCSTA                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @CSTA                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        SCSTA                          CAP084       BUG6864
     C                   Eval      SCSTA = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      **  Swift Priority Charge.                                                CFT014
                                                                                CFT014
     C     SPCH          IFNE      0                                            CFT014
     C                   Z-ADD     SPCH          @SPCH                          CFT014
     C                   Z-ADD     SPCH          @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SSPCH                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @SPCH                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        SSPCH                          CAP084       BUG6864
     C                   Eval      SSPCH = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      **  Miscellaneous Charge.                                                 CFT014
                                                                                CFT014
     C     MSCH          IFNE      0                                            CFT014
     C                   Z-ADD     MSCH          @MSCH                          CFT014
     C                   Z-ADD     MSCH          @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SMSCH                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @MSCH                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        SMSCH                          CAP084       BUG6864
     C                   Eval      SMSCH = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      **  FX Charge/Commission.                                                 CFT014
                                                                                CFT014
     C     S01494        IFEQ      'Y'                                          CFT014
     C     OPCHCM        IFNE      0                                            CFT014
     C                   Z-ADD     OPCHCM        @CHCM                          CFT014
     C                   Z-ADD     OPCHCM        @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SCHCM                          CAP084
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @CHCM                                        212647
     C**********         Z-ADD     *ZERO         @@AMTW                         CAP084       BUG6864
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084       BUG6864
     C**********         EXSR      FMTAMT                                       CAP084       BUG6864
     C**********         MOVE      @@AMTD        SCHCM                          CAP084       BUG6864
     C                   Eval      SCHCM = *blanks                                           BUG6864
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
                                                                                CAP084
      **  Reload Currency details                                               CAP084
                                                                                CAP084
     C                   Eval      @CCCY = WCURCY                               CAP084
     C                   ExSr      SrACCY                                       CAP084
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
      *                                                                         CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   EVAL      SPDSET = FXSRSC                              CFT009
     C                   EVAL      SOFCD = OTPDOF                               CFT009
     C                   EVAL      TRCDE = TFCCCD                               CFT009
     C                   EVAL      TXCDE = TLXCDE                               CFT009
     C                   EVAL      CQCDE = CHQCHC                               CFT009
     C                   EVAL      CACDE = CACHCD                               CFT009
     C                   EVAL      SPCDE = SPRCCD                               CFT009
     C                   EVAL      MSCDE = MSCHC                                CFT009
     C                   EVAL      FXCDE = FXCACC                               CFT009
     C                   EVAL      STCDE = SSTCCD                               CFT009
     C                   EVAL      M1CDE = MSCHC1                               CFT009
     C                   EVAL      M2CDE = MSCHC2                               CFT009
     C                   EVAL      M3CDE = MSCHC3                               CFT009
     C                   EVAL      M4CDE = MSCHC4                               CFT009
     C                   EVAL      M5CDE = MSCHC5                               CFT009
                                                                                CFT009
     C**********         Z-ADD     SWSCCC        @@AMTW                         CFT009      BUG17019
     C**********         Z-ADD     SWSCCC        @SSCD                          CFT009      BUG17019
     C**********         Z-ADD     A6NBDP        @@QECN                         CFT009      BUG17019
     C**********         EXSR      FMTAMT                                       CFT009      BUG17019
     C**********         MOVE      @@AMTD        STCD                           CFT009      BUG17019
     C**********         If        @@AMTW = *Zeros                                  BUG6864 BUG17019
     C**********         Eval      STCH = *blanks                                   BUG6864 BUG14157
     C**********         Eval      STCD = *blanks                                  BUG14157 BUG17019
     C**********         Else                                                       BUG6864 BUG17019
     C**********         MOVE      @@AMTD        STCH                                CAP084 BUG14157
     C**********         MOVE      @@AMTD        STCD                              BUG14157 BUG17019
     C**********         EndIf                                                      BUG6864 BUG17019
     C*****SWSCHG*****   IFNE      0                                                 249709 BUG17718
     C                   Z-ADD     SWSCHG        @@AMTW                                     BUG14157
     C                   Z-ADD     SWSCHG        @SSCH                          CFT009
     C**********         Z-ADD     SWSCHG        @@AMTW                              249709 BUG17718
     C**********         Z-ADD     A6NBDP        @@QECN                              249709 BUG17718
     C**********         EXSR      FMTAMT                                            249709 BUG17718
     C**********         MOVE      @@AMTD        STCH                                249709 BUG17718
     C**********         ELSE                                                        249709 BUG17718
     C**********         Z-ADD     *ZERO         @SSCH                               249709 BUG17718
     C**********         Eval      STCH  = *blanks                                   249709 BUG17718
     C**********         ENDIF                                                       249709 BUG17718
     C                   Z-ADD     A6NBDP        @@QECN                                     BUG14157
     C                   EXSR      FMTAMT                                                   BUG14157
     C                   If        @@AMTW = *Zeros                                          BUG14157
     C                   Eval      STCH = *blanks                                           BUG14157
     C                   Else                                                               BUG14157
     C                   MOVE      @@AMTD        STCH                                       BUG14157
     C                   EndIf                                                              BUG14157
                                                                                            BUG14157
     C*********          Z-ADD     MISCC1        @@AMTW                         CFT009      BUG17019
     C*********          Z-ADD     MISCC1        @MI1CD                         CFT009      BUG17019
     C*********          Z-ADD     A6NBDP        @@QECN                         CFT009      BUG17019
     C*********          EXSR      FMTAMT                                       CFT009      BUG17019
     C*********          MOVE      @@AMTD        M1CD                           CFT009      BUG17019
     C                   Z-ADD     MISC01        @M1CH                          CFT009
     C                   If        MISC01 = *Zeros                                           BUG6864
     C                   Eval      SMISC1 = *blanks                                          BUG6864
     C                   Else                                                                BUG6864
     C                   Z-ADD     MISC01        @@AMTW                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SMISC1                         CAP084
     C                   EndIf                                                               BUG6864
     C*********          Z-ADD     MISCC2        @@AMTW                         CFT009      BUG17019
     C*********          Z-ADD     MISCC2        @MI2CD                         CFT009      BUG17019
     C*********          Z-ADD     A6NBDP        @@QECN                         CFT009      BUG17019
     C*********          EXSR      FMTAMT                                       CFT009      BUG17019
     C*********          MOVE      @@AMTD        M2CD                           CFT009      BUG17019
     C                   Z-ADD     MISC02        @M2CH                          CFT009
     C                   If        MISC02 = *Zeros                                           BUG6864
     C                   Eval      SMISC2 = *blanks                                          BUG6864
     C                   Else                                                                BUG6864
     C                   Z-ADD     MISC02        @@AMTW                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SMISC2                         CAP084
     C                   EndIf                                                               BUG6864
     C*********          Z-ADD     MISCC3        @@AMTW                         CFT009      BUG17019
     C*********          Z-ADD     MISCC3        @MI3CD                         CFT009      BUG17019
     C*********          Z-ADD     A6NBDP        @@QECN                         CFT009      BUG17019
     C*********          EXSR      FMTAMT                                       CFT009      BUG17019
     C*********          MOVE      @@AMTD        M3CD                           CFT009      BUG17019
     C                   Z-ADD     MISC03        @M3CH                          CFT009
     C                   If        MISC03 = *Zeros                                           BUG6864
     C                   Eval      SMISC3 = *blanks                                          BUG6864
     C                   Else                                                                BUG6864
     C                   Z-ADD     MISC03        @@AMTW                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SMISC3                         CAP084
     C                   EndIf                                                               BUG6864
     C*********          Z-ADD     MISCC4        @@AMTW                         CFT009      BUG17019
     C*********          Z-ADD     MISCC4        @MI4CD                         CFT009      BUG17019
     C*********          Z-ADD     A6NBDP        @@QECN                         CFT009      BUG17019
     C*********          EXSR      FMTAMT                                       CFT009      BUG17019
     C*********          MOVE      @@AMTD        M4CD                           CFT009      BUG17019
     C                   Z-ADD     MISC04        @M4CH                          CFT009
     C                   If        MISC04 = *Zeros                                           BUG6864
     C                   Eval      SMISC4 = *blanks                                          BUG6864
     C                   Else                                                                BUG6864
     C                   Z-ADD     MISC04        @@AMTW                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SMISC4                         CAP084
     C                   EndIf                                                               BUG6864
     C**********         Z-ADD     MISCC5        @@AMTW                         CFT009      BUG17019
     C**********         Z-ADD     MISCC5        @MI5CD                         CFT009      BUG17019
     C**********         Z-ADD     A6NBDP        @@QECN                         CFT009      BUG17019
     C**********         EXSR      FMTAMT                                       CFT009      BUG17019
     C**********         MOVE      @@AMTD        M5CD                           CFT009      BUG17019
     C                   Z-ADD     MISC05        @M5CH                          CFT009
     C                   If        MISC05 = *Zeros                                           BUG6864
     C                   Eval      SMISC5 = *blanks                                          BUG6864
     C                   Else                                                                BUG6864
     C                   Z-ADD     MISC05        @@AMTW                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        SMISC5                         CAP084
     C                   EndIf                                                               BUG6864
      *                                                                         CFT009
      ** V.A.T. amounts                                                         CFT009
      *                                                                         CFT009
     C**********         Z-ADD     OPDUM8        @VATD                          CFT009     BUG17019A
     C**********         Z-ADD     OPDUM8        @@AMTW                         CAP084     BUG17019A
     C**********         Z-ADD     A6NBDP        @@QECN                         CAP084     BUG17019A
     C**********         EXSR      FMTAMT                                       CAP084     BUG17019A
     C**********         MOVE      @@AMTD        STOTVA                         CAP084     BUG17019A
     C                   Z-ADD     OPVATT        @VATT                          CFT009
     C                   Z-ADD     OPVATT        @@AMTW                         CAP084
     C                   Z-ADD     A6NBDP        @@QECN                         CAP084
     C                   EXSR      FMTAMT                                       CAP084
     C                   MOVE      @@AMTD        STOTVB                         CAP084
     C                   ENDIF                                                  CFT009
 
     C*
     C**  V.A.T. flags
     C                   MOVEL     OPVAT1        SVAT1
     C                   MOVEL     OPVAT2        SVAT2
     C                   MOVEL     OPVAT3        SVAT3
     C                   MOVEL     OPVAT4        SVAT4
     C                   MOVEL     OPVAT5        SVAT5
     C                   MOVEL     OPVAT6        SVAT6
     C                   MOVEL     OPVAT7        SVAT7
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      VAT9 = VMIC1                                 CFT009
     C                   EVAL      VAT10 = VMIC2                                CFT009
     C                   EVAL      VAT11 = VMIC3                                CFT009
     C                   EVAL      VAT12 = VMIC4                                CFT009
     C                   EVAL      VAT13 = VMIC5                                CFT009
     C                   EVAL      VAT14 = VTSWSC                               CFT009
     C                   ENDIF                                                  CFT009
     C*
     C**  Related Pay Reference.
     C                   MOVEL     RLPR          SRLPR
     C*
     C**  CHAPS Code.
     C     CHAP          IFNE      0
     C                   MOVEL     CHAP          SCHAP
     C                   END
     C*
     C**  Set up FX margin fields if feature on.
     C     BGN0ST        IFEQ      'Y'
 
     C**  FX Margin Points.
     C*
     C**  Format amount
     C**  - Execute FMTAMT to format the points, using 2 decimal places
     C**    and adjusting the file figure to have only implied decimal
     C**    places.
     C     FXMP          IFNE      0
     C     FXMP          MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SFXMP
     C                   ENDIF
     C*
     C**  Margin P/S Indicator.
     C     MBSI          IFEQ      'S'
     C                   MOVE      'P'           SMBSI
     C                   ENDIF
     C     MBSI          IFEQ      'B'
     C                   MOVE      'S'           SMBSI
     C                   ENDIF
     C*
     C**  Margin Sign.
     C                   MOVEL     MSIG          SMSIG
     C*
     C                   END
 
     C* Set up STATUS FLAG for display.
     ** Authorised
     C     RECI          IFEQ      'D'
     C     AUIN          IFEQ      'Y'
     C                   MOVE      @STSA(2)      PmntStatus
     C                   ELSE
     C                   MOVE      *BLANK        PmntStatus
     C                   END
     C                   ELSE
     ** Matured
     C     RECI          IFEQ      'M'
     C                   MOVE      @STSA(4)      PmntStatus
     C                   ELSE
     ** Deleted
     C     RECI          IFEQ      'C'
     C/COPY WNCPYSRC,FTH00459
      *                                                                                       CFT157
     C     CHTP          ANDNE     'S'                                                        CFT157
      *                                                                                       CFT157
     C                   MOVE      @STSA(5)      PmntStatus
     C                   ELSE
     C/COPY WNCPYSRC,FTH00460
      *                                                                                       CFT157
     C     RECI          IFEQ      'C'                                                        CFT157
     C     CHTP          ANDEQ     'S'                                                        CFT157
     C     CFT157        ANDEQ     'Y'                                                        CFT157
     C                   MOVE      @STSA(6)      PmntStatus                                   CFT157
     C                   ELSE                                                                 CFT157
      *                                                                                       CFT157
     C                   MOVE      *BLANK        PmntStatus
     C/COPY WNCPYSRC,FTH00461
      *                                                                                       CFT157
     C                   Endif                                                                CFT157
      *                                                                                       CFT157
     C                   END
     C                   END
     C                   END
      *
      **  Details of Charges
      *   (Default to BEN if blank, but don't if no second-level details
      *    have been entered)
     C     DTCH          IFNE      *BLANKS
     C                   MOVEL     DTCH          SDTCH
     C                   ELSE
 
     C                   if        PmtScnFmt2 <> *blanks OR PmtScnFmt3
     C                             <> *blanks OR PmtScnFmt4 <> *blanks
 
      ** If CFT014 is installed, retrieve the default value from the                          219241
      ** Message Management ICD                                                               219241
                                                                                              219241
     C                   IF        @CFT014 = 'Y'                                              219241
     C                   EVAL      SDTCH = ENDCHG                                             219241
     C                   ELSE                                                                 219241
     C                   MOVEL     'BEN'         SDTCH
     C/COPY WNCPYSRC,FTOPAYNC03
     C                   ENDIF                                                                219241
 
     C                   endif
 
     C                   ENDIF
     C*                                                                         175479
     C**  Deal Reference                                                        175476
     C                   MOVE      FDLR          SFDLR                          175479
                                                                                CFT014
      ** Format MT103 screen fields when CFT014 enhancement is setup.           CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
                                                                                CFT014
      ** Original Exchange Rate                                                 CFT014
                                                                                CFT014
     C                   If        OPOEXR  <> *Zero                             CFT014
     C                   Move      OPOEXR        @@AMTW                         CFT014
     C                   Z-Add     8             @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SOEXR                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Bank Operation Code                                                    CFT014
                                                                                CFT014
     C                   Movel     OPBOCD        SBOCD                          CFT014
                                                                                CFT014
      ** Transaction Type Code                                                  CFT014
                                                                                CFT014
     C                   Movel     OPTTCD        STRTC                          CFT014
                                                                                CFT014
      ** Third Reimbursement Institutions                                       CFT014
                                                                                CFT014
     C                   Movel     OPTRI1        STRI1                          CFT014
     C                   Movel     OPTRI2        STRI2                          CFT014
     C                   Movel     OPTRI3        STRI3                          CFT014
     C                   Movel     OPTRI4        STRI4                          CFT014
     C                   Movel     OPTRI5        STRI5                          CFT014
                                                                                CFT014
      ** Instruction Codes                                                      CFT014
                                                                                CFT014
     C                   Movel     OPICD1        SICD1                          CFT014
     C                   Movel     OPICD2        SICD2                          CFT014
     C                   Movel     OPICD3        SICD3                          CFT014
     C                   Movel     OPICD4        SICD4                          CFT014
     C                   Movel     OPICD5        SICD5                          CFT014
                                                                                CFT014
      ** Regulatory Reporting                                                   CFT014
                                                                                CFT014
     C                   Movel     OPRRP1        SRRP1                          CFT014
     C                   Movel     OPRRP2        SRRP2                          CFT014
     C                   Movel     OPRRP3        SRRP3                          CFT014
                                                                                CFT014
      ** Receiver's Charges Remitted (in Pay Currency)                          CFT014
                                                                                CFT014
     C                   If        OPRCRM <> *Zero                              CFT014
     C                   Z-Add     OPRCRM        @@AMTW                         CFT014
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     WPayDec       @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SRCRM                          CFT014
     C**********         EndIf                                                         CFT014 212647
                                                                                CFT014
      ** Sender's Charges 1                                                     CFT014
                                                                                CFT014
     C                   Movel     OPSCC1        SSCC1                          CFT014
     C                   If        OPSCC1 <> *Blank                             CFT014
     C                   Move      OPSCC1        WCURCY            3            CFT014
     C                   Z-Add     1             WERNB             5 0          CFT014
     C                   ExSr      SrACCY                                       CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        (OPSCH1 <> *Zero) Or                         CFT014
     C                             (OPSCH1 = *Zero) And (OPSCLE = 1) Or         CFT014
     C                             (OPSCH1 = *Zero) And (OPSCLE > 1)            CFT014
     C                   If        OPSCH1 = *Zero                               CFT014
     C                   Z-Add     *Zero         @@AMTW                         CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     OPSCH1        @@AMTW                         CFT014
     C                   EndIf                                                  CFT014
     C                   Z-Add     A6NBDP        @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SSCH1                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Sender's Charges 2                                                     CFT014
                                                                                CFT014
     C                   Movel     OPSCC2        SSCC2                          CFT014
     C                   If        OPSCC2 <> *Blank                             CFT014
     C                   Move      OPSCC2        WCURCY                         CFT014
     C                   Z-Add     2             WERNB                          CFT014
     C                   ExSr      SrACCY                                       CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        (OPSCH2 <> *Zero) Or                         CFT014
     C                             (OPSCH2 = *Zero) And (OPSCLE = 2) Or         CFT014
     C                             (OPSCH2 = *Zero) And (OPSCLE > 2)            CFT014
     C                   If        OPSCH2 = *Zero                               CFT014
     C                   Z-Add     *Zero         @@AMTW                         CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     OPSCH2        @@AMTW                         CFT014
     C                   EndIf                                                  CFT014
     C                   Z-Add     A6NBDP        @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SSCH2                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Sender's Charges 3                                                     CFT014
                                                                                CFT014
     C                   Movel     OPSCC3        SSCC3                          CFT014
     C                   If        OPSCC3 <> *Blank                             CFT014
     C                   Move      OPSCC3        WCURCY                         CFT014
     C                   Z-Add     3             WERNB                          CFT014
     C                   ExSr      SrACCY                                       CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        (OPSCH3 <> *Zero) Or                         CFT014
     C                             (OPSCH3 = *Zero) And (OPSCLE = 3) Or         CFT014
     C                             (OPSCH3 = *Zero) And (OPSCLE > 3)            CFT014
     C                   If        OPSCH3 = *Zero                               CFT014
     C                   Z-Add     *Zero         @@AMTW                         CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     OPSCH3        @@AMTW                         CFT014
     C                   EndIf                                                  CFT014
     C                   Z-Add     A6NBDP        @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SSCH3                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Sender's Charges 4                                                     CFT014
                                                                                CFT014
     C                   Movel     OPSCC4        SSCC4                          CFT014
     C                   If        OPSCC4 <> *Blank                             CFT014
     C                   Move      OPSCC4        WCURCY                         CFT014
     C                   Z-Add     4             WERNB                          CFT014
     C                   ExSr      SrACCY                                       CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        (OPSCH4 <> *Zero) Or                         CFT014
     C                             (OPSCH4 = *Zero) And (OPSCLE = 4) Or         CFT014
     C                             (OPSCH4 = *Zero) And (OPSCLE > 4)            CFT014
     C                   If        OPSCH4 = *Zero                               CFT014
     C                   Z-Add     *Zero         @@AMTW                         CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     OPSCH4        @@AMTW                         CFT014
     C                   EndIf                                                  CFT014
     C                   Z-Add     A6NBDP        @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SSCH4                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Sender's Charges 5                                                     CFT014
                                                                                CFT014
     C                   Movel     OPSCC5        SSCC5                          CFT014
     C                   If        OPSCC5 <> *Blank                             CFT014
     C                   Move      OPSCC5        WCURCY                         CFT014
     C                   Z-Add     5             WERNB                          CFT014
     C                   ExSr      SrACCY                                       CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        (OPSCH5 <> *Zero) Or                         CFT014
     C                             (OPSCH5 = *Zero) And (OPSCLE = 5)            CFT014
     C                   If        OPSCH5 = *Zero                               CFT014
     C                   Z-Add     *Zero         @@AMTW                         CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     OPSCH5        @@AMTW                         CFT014
     C                   EndIf                                                  CFT014
     C                   Z-Add     A6NBDP        @@QECN                         CFT014
     C                   ExSr      FMTAMT                                       CFT014
     C                   Move      @@AMTD        SSCH5                          CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
      *
     C* Msg Unique Reference                                                                  190845
     C                   Eval      SHMSGR = OPMSGR                                            190845
     C*                                                                                       190845
     C* Part Number                                                                           190845
     C                   Eval      SHPART = OPKPRT                                            190845
     C*                                                                                       190845
      * Format Reference Rate                                                   CDL049
     C     CDL049        IFEQ      'Y'                                          CDL049
     C                   MOVE      OPRRAT        @@AMTW                         CDL049
     C                   Z-ADD     8             @@QECN                         CDL049
     C                   EXSR      FMTAMT                                       CDL049
     C                   MOVE      @@AMTD        SRRAT                          CDL049
     C                   ENDIF                                                  CDL049
      *                                                                         CDL049
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      SNWRK  = OPNWRK                                            CSW209
     C                   EVAL      SMTPY  = OPMTPY                                            CSW209
     C                   EVAL      SVALF  = OPVALF                                            CSW209
     C                   EVAL      SOMVLF = OPOMVF                                            CSW209
     C                   EVAL      SOCVLF = OPOCVF                                            CSW209
     C                   EVAL      SCOC1  = OPCOC1                                            CSW209
     C                   EVAL      SCOC2  = OPCOC2                                            CSW209
     C                   EVAL      SCOC3  = OPCOC3                                            CSW209
     C                   EVAL      SCOC4  = OPCOC4                                            CSW209
     C                   EVAL      SCOC5  = OPCOC5                                            CSW209
     C                   EVAL      SCOB1  = OPCOB1                                            CSW209
     C                   EVAL      SCOB2  = OPCOB2                                            CSW209
     C                   EVAL      SCOB3  = OPCOB3                                            CSW209
     C                   EVAL      SCOB4  = OPCOB4                                            CSW209
     C                   EVAL      SCOB5  = OPCOB5                                            CSW209
     C                   EVAL      SCIB1  = OPCIB1                                            CSW209
     C                   EVAL      SCIB2  = OPCIB2                                            CSW209
     C                   EVAL      SCIB3  = OPCIB3                                            CSW209
     C                   EVAL      SCIB4  = OPCIB4                                            CSW209
     C                   EVAL      SCIB5  = OPCIB5                                            CSW209
     C                   EVAL      SCAB1  = OPCAB1                                            CSW209
     C                   EVAL      SCAB2  = OPCAB2                                            CSW209
     C                   EVAL      SCAB3  = OPCAB3                                            CSW209
     C                   EVAL      SCAB4  = OPCAB4                                            CSW209
     C                   EVAL      SCAB5  = OPCAB5                                            CSW209
     C                   EVAL      SCBC1  = OPCBC1                                            CSW209
     C                   EVAL      SCBC2  = OPCBC2                                            CSW209
     C                   EVAL      SCBC3  = OPCBC3                                            CSW209
     C                   EVAL      SCBC4  = OPCBC4                                            CSW209
     C                   EVAL      SCBC5  = OPCBC5                                            CSW209
     C                   EVAL      SCDP1  = OPCDP1                                            CSW209
     C                   EVAL      SCDP2  = OPCDP2                                            CSW209
     C                   EVAL      SCDP3  = OPCDP3                                            CSW209
     C                   EVAL      SCDP4  = OPCDP4                                            CSW209
     C                   EVAL      SCBB1  = OPCBB1                                            CSW209
     C                   EVAL      SCBB2  = OPCBB2                                            CSW209
     C                   EVAL      SCBB3  = OPCBB3                                            CSW209
     C                   EVAL      SCBB4  = OPCBB4                                            CSW209
     C                   EVAL      SCBB5  = OPCBB5                                            CSW209
     C                   EVAL      SCBB6  = OPCBB6                                            CSW209
     C                   EVAL      SCICY  = OPCICY                                            CSW209
                                                                                              CSW209
      ** Format amount based on currency decimal places                                       CSW209
     C                   IF        SCICY <> *Blanks                                           CSW209
     C                   EVAL      @AJCD = SCICY                                              CSW209
                                                                                              CSW209
     C                   CALLB     'AOCURRR0'                                                 CSW209
     C                   PARM      *Blanks       @RTCD                                        CSW209
     C                   PARM      '*KEY   '     @OPTN                                        CSW209
     C                   PARM                    @AJCD                                        CSW209
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW209
      *                                                                                       CSW209
      **  Format amount                                                                       CSW209
     C                   EVAL      @@AMTW = OPCIAM                                            CSW209
     C                   EVAL      @@QECN = A6NBDP                                            CSW209
     C                   EXSR      FMTAMT                                                     CSW209
     C                   MOVE      @@AMTD        SCIAM                                        CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   EVAL      SOCBB1 = OPOCB1                                            CSW209
     C                   EVAL      SOCBB2 = OPOCB2                                            CSW209
     C                   EVAL      SOCBB3 = OPOCB3                                            CSW209
     C                   EVAL      SOCBB4 = OPOCB4                                            CSW209
     C                   EVAL      SOCBB5 = OPOCB5                                            CSW209
     C                   EVAL      SOCBB6 = OPOCB6                                            CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CER030
     C                   IF        CER031 = 'Y'                                               CER030
     C                   EVAL      SEXT1 = OPEXT1                                             CER030
     C                   EVAL      SEXT2 = OPEXT2                                             CER030
     C                   EVAL      SEXT3 = OPEXT3                                             CER030
     C                   EVAL      SEXT4 = OPEXT4                                             CER030
     C                   EVAL      SEXT5 = OPEXT5                                             CER030
     C                   EVAL      SEXT6 = OPEXT6                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   EVAL      SRTTY = OPRTTY                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER031 = 'Y' AND CFT003 = 'Y'                              CER030
     C                   EVAL      SEXC1 = OPEXC1                                             CER030
     C                   EVAL      SEXC2 = OPEXC2                                             CER030
     C                   EVAL      SEXC3 = OPEXC3                                             CER030
     C                   EVAL      SEXC4 = OPEXC4                                             CER030
     C                   EVAL      SEXC5 = OPEXC5                                             CER030
     C                   EVAL      SEXC6 = OPEXC6                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrACCY                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrACCY     - Access Currency details                       *         CFT014
      *                                                               *         CFT014
      * Called By: SETFLD subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * AOCURRR0   - Access Object to get currency details            *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrACCY        BegSr                                                  CFT014
                                                                                CFT014
     C                   CallB     'AOCURRR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      WCURCY        @AJCD                          CFT014
     C     SDCURR        Parm      SDCURR        DSSDY                          CFT014
                                                                                CFT014
      ** Error found on call                                                    CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blank                              CFT014
     C                   Movel     'AOCURRR0'    DBFILE                         CFT014
     C                   Z-Add     WERNB         DBASE                          CFT014
     C                   Movel     WCURCY        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     *Zero         DBASE                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCLRAT - SCALE RATE                                           *
      *****************************************************************
     C     SCLRAT        BEGSR
      *
     C                   CALLB     'ZA1150'
     C                   PARM                    @@SXP1            1 0
     C                   PARM                    @@SXP2            1 0
     C                   PARM                    @@INRT           13 8
     C                   PARM                    @@FCMD            1
     C                   PARM      *ZEROS        @@SCRT           13 8
     C                   PARM      *ZEROS        @@ISRT           13 8
     C                   PARM      *ZEROS        @@ERCD            1 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN DEAL FORMAT)
      *
     C                   MOVEL     SACTION       ##ACTN            1
     C                   MOVEL     *BLANK        PmtScnFmt1
     C                   MOVEL     *BLANK        PmtScnFmt2
     C                   MOVEL     *BLANK        PmtScnFmt3
     C                   MOVEL     *BLANK        PmtScnFmt4
     C                   MOVEL     *BLANK        PmtScnFm1b                     CFT014
     C                   MOVEL     *BLANK        PmtScnFmt5                     CFT014
     C                   MOVEL     *BLANK        PmtScnFmt6                     CFT014
     C                   MOVEL     *BLANK        PmtScnFmt7                     CFT014
     C                   MOVEL     *BLANKS       PmtScnFmt7A                                  CER030
     C                   MOVEL     *BLANKS       PmtScnFmt7B                                  CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     *BLANK        PmtScnFmtA                                   CSW209
     C                   MOVEL     *BLANK        PmtScnFmtC                                   CSW209
     C                   ENDIF                                                                CSW209
     C                   MOVEL     ##ACTN        SACTION
     C                   MOVEL     *BLANK        PmntStatus
     C/COPY WNCPYSRC,FTH00654
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Payment details in file format
     C                   PARM                    PmntFilFmt
                                                                                CFT014
      ** Payment details extension in file format                               CFT014
                                                                                CFT014
     C                   PARM                    PmntFilFmX                     CFT014
      *
      * Output parameters
      *
      * Payment details in screen format (4 screens)
     C                   PARM                    PmtScnFmt1
     C                   PARM                    PmtScnFm1b                     CFT014
     C                   PARM                    PmtScnFmt2
     C                   PARM                    PmtScnFmt3
     C                   PARM                    PmtScnFmt4
     C                   PARM                    PmtScnFmt5                     CFT014
     C                   PARM                    PmtScnFmt6                     CFT014
     C                   PARM                    PmtScnFmt7                     CFT014
     C                   PARM                    PmtScnFmtA                                   CSW209
     C                   PARM                    PmtScnFmtC                                   CSW209
     C                   PARM                    PmtScnFmt7A                                  CER030
     C                   PARM                    PmtScnFmt7B                                  CER030
     C                   PARM                    SDFTFR                         CFT014
      *
      *  Validation Work Fields
     C                   PARM                    Val@Fields
 
      * Payment Status
     C                   PARM                    PmntStatus       24
      *
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
     C                   PARM                    BtnPressed       10                       AR1090283
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAYCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS FT ICD DETAILS
      *
     C*******************CALL      'AOFODAR0'                                   179994
     C*******************PARM      *BLANKS       @RTCD             7            179994
     C*******************PARM      '*FIRST '     @OPTN             7            179994
     C*****SDFODA        PARM      SDFODA        DSFDY                          179994
     C                   CALL      'AOFTFRR0'                                   179994
     C                   Parm      '*DBERR'      @RTCD                          179994
     C                   Parm      '*FIRST'      @OPTN                          179994
     C     SDFTFR        Parm      SDFTFR        DSFDY                          179994
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C*******************MOVEL     'SDFODAPD'    DBFILE                         179994
     C                   MOVEL     'SDFTFRPD'    DBFILE                         179994
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      *
      ** ACCESS SAR DETAILS FOR Customer Format
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL005'      DBKEY                          ***************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 906 *
     C                   MOVEL     '906'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Fx Charge Commissions (S01494)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01494'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01494'      DBKEY                          ***************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 903 *
     C                   MOVEL     '903'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01494            1
     C                   ELSE
     C                   MOVEL     'N'           S01494
     C                   END
      *                                                                          CDL049
      ** Access SAR details for Additional Reference Rate (CDL049)               CDL049
      *                                                                          CDL049
     C                   CALLB     'AOSARDR0'                                    CDL049
     C                   PARM      *BLANKS       @RTCD                           CDL049
     C                   PARM      '*VERIFY'     @OPTN                           CDL049
     C                   PARM      'CDL049'      @SARD                           CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                           CDL049
      *                                                                          CDL049
      * DATABASE ERROR                                                           CDL049
      *                                                                          CDL049
     C     @RTCD         IFNE      *BLANKS                                       CDL049
     C     @RTCD         ANDNE     '*NRF   '                                     CDL049
     C                   MOVEL     'CDL049'      DBKEY                           CDL049
     C                   MOVEL     'SCSARDPD'    DBFILE                          CDL049
     C                   MOVEL     '905'         DBASE                           CDL049
     C                   EXSR      *PSSR                                         CDL049
     C                   END                                                     CDL049
     C*                                                                          CDL049
     C     @RTCD         IFEQ      *BLANK                                        CDL049
     C                   MOVEL     'Y'           CDL049            1             CDL049
     C                   ELSE                                                    CDL049
     C                   MOVEL     'N'           CDL049                          CDL049
     C                   END                                                     CDL049
     C/COPY WNCPYSRC,FTH00655
                                                                                              219241
      ** Get Message Management Details if CFT014 is installed                                219241
                                                                                              219241
     C                   IF        @CFT014 = 'Y'                                              219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       PRTCD                                        219241
     C                   PARM      '*FIRST'      POPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        PRTCD <> *BLANKS                                           219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 907                                                219241
     C                   EVAL      DBKEY = POPTN                                              219241
     C                   EXSR      *PSSR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
      *                                                                                     BUG18401
     C                   CALLB     'ZACRTVJOBA'                         90                  BUG18401
     C                   PARM                    PSJobName                                  BUG18401
     C                   PARM                    PSUser                                     BUG18401
     C                   PARM                    PSJobNo                                    BUG18401
     C                   PARM                    JobType           5                        BUG18401
      *                                                                                     BUG18401
     C     *IN90         IFEQ      '1'                                                      BUG18401
     C                   MOVEL     '*ERROR'      RetCodeIn                                  BUG18401
     C                   MOVEL     'FTOPAYCVT'   Dbpgm                                      BUG18401
     C                   MOVEL     'ZACRTVJOBA'  Dbfile                                     BUG18401
     C                   MOVEL     '009'         Dbase                                      BUG18401
     C                   MOVEL     '*CALL'       Dbkey                                      BUG18401
     C                   EXSR      *PSSR                                                    BUG18401
     C                   ENDIF                                                              BUG18401
      *
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD                                        CSW209
                                                                                              CSW209
     C                   IF        PRTCD = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Check if 'CER031' is switched 'ON'                                                   CER030
      *                                                                                       CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> '*NRF '                                           CER030
      *                                                                                       CER030
     C                   MOVEL     'CER031'      DBKEY                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '908'         DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if 'CER030' is switched 'ON'                                                   CER030
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> '*NRF '                                           CER030
      *                                                                                       CER030
     C                   MOVEL     'CER030'      DBKEY                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '909'         DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if 'CFT003' is switched 'ON'                                                   CER030
      *                                                                                       CER030
     C                   EVAL      CFT003 = 'N'                                               CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CFT003'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CFT003 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> '*NRF '                                           CER030
      *                                                                                       CER030
     C                   MOVEL     'CFT003'      DBKEY                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '910'         DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if 'CGL013' is switched 'ON'                                                   CER030
      *                                                                                       CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> '*NRF '                                           CER030
      *                                                                                       CER030
     C                   MOVEL     'CGL013'      DBKEY                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '911'         DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      *                                                                                       CFT120
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD <> '*NRF '                                           CFT120
      *                                                                                       CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   MOVEL     '912'         DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C/COPY WNCPYSRC,FTOPAYNC02
                                                                                              CFT157
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   PARM      *BLANKS       @RTCD                                        CFT157
     C                   PARM      '*VERIFY'     @OPTN                                        CFT157
     C                   PARM      'CFT157'      @SARD                                        CFT157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT157
      *                                                                                       CFT157
      * DATABASE ERROR                                                                        CFT157
      *                                                                                       CFT157
     C     @RTCD         IFNE      *BLANKS                                                    CFT157
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT157
     C                   MOVEL     'CFT157'      DBKEY                                        CFT157
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT157
     C                   MOVEL     '943'         DBASE                                        CFT157
     C                   EXSR      *PSSR                                                      CFT157
     C                   END                                                                  CFT157
     C     @RTCD         IFEQ      *BLANK                                                     CFT157
     C                   MOVEL     'Y'           CFT157            1                          CFT157
     C                   ELSE                                                                 CFT157
     C                   MOVEL     'N'           CFT157                                       CFT157
     C                   END                                                                  CFT157
     C*                                                                                       CFT157
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** TEXT FOR PAYMENT STATUS
COMPLETE
AUTHORIZED
REQUIRES REAUTHORIZATION
MATURED
DELETED
STOPPED                                                                                       CFT157
     X/COPY WNCPYSRC,FTH00462
