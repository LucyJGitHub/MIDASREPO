      *****************************************************************
/*STD *  RPGBASEMOD                                                   *                       227171
/*EXI *  TEXT('Midas DL OIS deals interest file maintenance')         *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1647 - OIS Deal Details File Maintenance                   *
      *                                                               *
      *  Function:  This program maintains the new OIS Deal Details   *
      *             Fiel(PF/DLDOISPD) and updates the effective       *
      *             interest rate on PF/Dealsdg, for all deals for    *
      *             which one or both sides are OIS's.                *
      *                                                               *
      *  Called By: DLC1647 - OIS Deal Details File Maintenance       *
      *                       Control                                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 08Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 227171             Date 01Mar06               *
      *                 221119             Date 01Mar06               *
      *                 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 18Apr05               *
      *                 CAS008             Date 16Jun04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 217684             Date 12May03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209202             Date 01Oct02               *
      *                 209068             Date 11Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  CPK025 - add /COPY ZFEB29Z1LE.                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  227171 - Applied fix 217509 to this program.                 *
      *         - Incorrect STANDARD records are created for back-    *
      *           valued deals.  Caused by fix 221119.                *
      *  221119 - Interest accruals calculated even if it is a holiday*
      *           in the deal currency. Fix is to check if rundate is *
      *           holiday in deal currency.                           *
      *         - Records not generated for OIS deal if local currency*
      *           is a holiday and deal currency is not. Fix is to    *
      *           consider holidays.                                  *
      *           Applied fixes 217720 and 218799.                    *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1647 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  209202 - Set on TDNSI/UDNSI if TEINR/UEINR set up on a GUESS *
      *           record as DL0280 will not do this.                  *
      *  209068 - Extend length of field WINTND to 14,9 to allow for  *
      *           large rates and/or long term backvaluation.         *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
      /EJECT
     FDEALSDG   UF   E           K DISK
      ** Interest rate agreements/Interest rate swaps file
      *
     FDLDOISL1  UF A E           K DISK
      ** OIS Interest rate LF
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  70 - EoF on DEALSDG                                          *
      *  71 - CHAIN to DLDOISPD                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROC - Detail Processing                                   *
      *  SRBRAT - Access Base rate Details                            *
      *  SRGUES - Creates Guess record                                *
      *  SRBACK - Back Valued Deals                                   *
      *  SRHPRO - Holidays processing                                 *                       221119
      *  SRBINT - Calculate Compounding Rate for a Back Valued        *
      *           Deals                                               *
      *  SRSTAN - Standard Processing                                 *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D*COPY ZSRSRC,ZHOLE                                                                      220859
     D ZHL1            S              1    DIM(366)                                           220859
      *                                                                                       220859
      * Arrays to split holiday fields into 1-bit elements                                    220859
      *                                                                                       220859
      ** Array for holiday checking
     D*COPY*ZSRSRC,ZDATE9Z1                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** Dummy record format for Deal Details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** Dummy record format for Base Rate Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Dummy record format for Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  204923
      ** Dummy record format for Currency Details                                             204923
      *                                                                                       204923
     D*COPY ZSRSRC,ZHOLI                                                                      220859
     D ZHOLDS          DS                                                                     220859
      *                                                                                       220859
      * Data structure defined over holiday file fields                                       220859
      *                                                                                       220859
     D  DGCYCD                 1      3                                                       220859
     D  DGLCCD                 4      6                                                       220859
     D  DGYRNB                 7     10  0                                                    220859
     D  DGJDNB                11     13P 0                                                    220859
     D  DGDDNB                14     16P 0                                                    220859
     D  ZDS1                  17    202                                                       220859
     D  ZDS2                 203    382                                                       220859
     D  ZHL                   17    382                                                       220859
     D                                     DIM(366)                                           220859
      *                                                                                       220859
      *                                                                                       220859
     D ZVARS           DS                                                                     220859
      *                                                                                       220859
      * Data structure to define variables used in holiday sub-routines                       220859
      *                                                                                       220859
     D  ZIND                   1      1                                                       220859
     D  ZINDX                  2      4  0                                                    220859
     D  ZDAYNO                 5      7P 0                                                    220859
     D  ZDYNBR                 8     10P 0                                                    220859
     D  ZNRDYS                11     12  0                                                    220859
     D  @ZWRDY                13     14  0                                                    220859
      *                                                                                       220859
     D  ZCCY                  15     17                                                       220859
     D  ZLOC                  18     20                                                       220859
     D  @ZWRKI                15     20                                                       220859
      *                                                                                       220859
     D  ZSCCY                 21     23                                                       220859
     D  ZSLOC                 24     26                                                       220859
     D  ZSWEXX                27     30  0                                                    220859
     D  ZSJAN                 31     33P 0                                                    220859
     D  ZSDCM                 34     36P 0                                                    220859
     D  RTNCD                 37     43                                                       220859
     D  @ZWRKO                21     43                                                       220859
      *                                                                                       220859
     D  ZOPTN                 44     50                                                       220859
     D  ZZCCY                 51     53                                                       220859
     D  ZZLOC                 54     56                                                       220859
     D  ZZDYNO                57     59P 0                                                    220859
     D  ZSRTN                 60     66                                                       220859
      ** Data structure for holiday checking
     D*COPY*ZSRSRC,ZDATE9Z2                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D*COPY*ZSRSRC,ZINTDYZ1                                                                   CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CPK025
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** second DS for access programs, long Data Structure
      *
      /EJECT
      ****************************************************************
      *                M A I N   P R O C E S S I N G                 *
      ****************************************************************
      *
      ** Read file to find OIS's.
      *
     C                   READ      DEALSDG                                70
      *
     C     *IN70         DOWEQ     '0'
      *                                                                                       204923
      ** Access Currency Details                                                              204923
      *                                                                                       204923
     C                   CALL      'AOCURRR0'                                                 204923
     C                   PARM      *BLANKS       PRTCD                                        204923
     C                   PARM      '*KEY   '     POPTN                                        204923
     C                   PARM      UCUCY         PCURR             3                          204923
     C     SDCURR        PARM      SDCURR        DSSDY                                        204923
      *                                                                                       204923
     C     PRTCD         IFNE      *BLANKS                                                    204923
     C     *LOCK         IN        LDA                                                        204923
     C                   MOVEL     'SDCURRPD'    DBFILE                                       204923
     C                   Z-ADD     8             DBASE                                        204923
     C                   MOVEL     PCURR         DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *
      ** Set up Our/Their Side Indicator.
      *
     C                   MOVE(P)   *BLANKS       WOTIN             5
      *
      ** Our Side only is an OIS
      *
     C     UICFR         IFEQ      'O'
     C     RECI          ANDEQ     'D'
     C                   MOVEL     'OUR'         WOTIN
     C                   MOVE      'O'           WOTCD
     C                   EXSR      SRPROC
     C                   ENDIF
      *
      ** Their Side only is an OIS
      *
     C     TICFR         IFEQ      'O'
     C     RECI          ANDEQ     'D'
     C                   MOVE      'THEIR'       WOTIN
     C                   MOVE      'T'           WOTCD
     C                   EXSR      SRPROC
     C                   ENDIF
      *
     C     W#UPDT        IFEQ      'Y'                                                        227171
     C                   UPDATE    DEALSDGF
     C                   ENDIF                                                                227171
      *                                                                                       227171
     C                   READ      DEALSDG                                70
      *
     C                   ENDDO
      *
      ** Termination Processing
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      *         E N D   O F   M A I N   P R O C E S S I N G           *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC   - Detail Processing                                 *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *  Calls     : SRBRAT, SRGUES, SRBACK, SRSTAN                   *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** See if Deal is a New Deal (i.e. no record found on extension)
      *
     C                   MOVE      DLNO          KDLNO             6 0
     C                   MOVE      WOTCD         KOTCD
     C                   MOVE      'N'           W#CMPD            1                          227171
      *
     C     KEY1          CHAIN     DLDOISL1                           71
      *
      ** New Deals:
      *
     C     *IN71         IFEQ      '1'
      *
      ** Set up Base rate for Deal Currency
      *
     C                   EXSR      SRBRAT
      *
     C                   MOVE      'Y'           WFIRST                                       221119
     C                   SELECT
      *
      ** Create a GUESS record for todays Deals
      *
     C     VDAT          WHENEQ    BJRDNB
     C                   EXSR      SRGUES
     C                   EXSR      SRHPRO                                                     221119
      *
      ** Deal has been back-valued
      *
     C     VDAT          WHENLT    BJRDNB
     C                   MOVE      'Y'           W#CMPD                                       227171
     C                   EXSR      SRBACK
     C                   EXSR      SRHPRO                                                     221119
      *                                                                                       221119
      ** Check if value date falls on a holiday                                               221119
      *                                                                                       221119
     C                   OTHER                                                                221119
     C                   EXSR      SRHPRO                                                     221119
      *
     C                   ENDSL
      *
      ** Not New Deals:
      *
     C                   ELSE
      *
     C                   MOVE      'N'           WFIRST                                       221119
      *                                                                                       221119
      ** Check if today is a holiday in the deal currency. If so, do                          221119
      ** note generate a record on this date.                                                 221119
      *                                                                                       221119
     C     WOTCD         IFEQ      'O'                                                        221119
     C                   MOVE      UCUCY         @CCY                                         221119
     C                   ELSE                                                                 221119
     C                   MOVE      TCUCY         @CCY                                         221119
     C                   ENDIF                                                                221119
      *                                                                                       221119
     C                   CALLB     'ZCHKH'                                                    221119
     C                   PARM      BJRDNB        @DATE                                        221119
     C                   PARM                    @CCY                                         221119
     C                   PARM      *BLANKS       @LOC                                         221119
     C                   PARM                    @WZIND                                       221119
      *                                                                                       221119
     C     @WZIND        IFEQ      'W'                                                        221119
      *                                                                                       227171
      ** If most recent record is for Maturity Date, then do not                              227171
      ** generate a new record and bypass update to DEALSDG.                                  227171
      *                                                                                       227171
     C                   MOVE      'N'           W#UPDT            1                          227171
     C     L1BSDT        IFNE      MDAT                                                       227171
     C                   MOVE      'Y'           W#UPDT                                       227171
      ** If record read is a 'Settlement' record
      *
     C     L1RTYP        IFEQ      'SETTLE'
      *
     C     BJRDNB        IFNE      L1BSDT
     C                   EXSR      SRSTAN
     C                   EXSR      SRHPRO                                                     221119
     C                   ENDIF
      *
     C                   ELSE
     C                   EXSR      SRSTAN
     C                   EXSR      SRHPRO                                                     221119
     C                   ENDIF
      *
     C                   ENDIF                                                                227171
      *                                                                                       227171
     C                   ENDIF                                                                221119
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRAT   - Access Base rate Details                          *
      *                                                               *
      *  Called By : SRPROC                                           *
      *                                                               *
      *  Calls     : AOBSRTR0                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRBRAT        BEGSR
      *
      ** Set up Currency and Base rate depending on Our/Their
      *
     C     WOTIN         IFEQ      'OUR'
     C                   MOVEL     UBRTT         PBRTT             2
     C                   MOVE      UCUCY         PCUCY             3
     C                   ELSE
     C                   MOVEL     TBRTT         PBRTT
     C                   MOVE      TCUCY         PCUCY
     C                   ENDIF
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRTRN
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PCUCY
     C                   PARM                    PBRTT
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTRN         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     PCUCY         WKEY              5
     C                   MOVE      PBRTT         WKEY
     C                   MOVEL     WKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUES   - Creates Guess record                              *
      *                                                               *
      *  Called By : SRPROC                                           *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRGUES        BEGSR
      *
     C                   MOVEL     BRCA          L1BRCA
     C                   Z-ADD     DLNO          L1DLNO
     C                   MOVEL(P)  'GUESS'       L1RTYP
      *                                                                                       221119
     C     WHDAY         IFEQ      'Y'                                                        221119
     C                   Z-ADD     VDAT          L1BSDT                                       221119
     C                   ELSE                                                                 221119
     C                   Z-ADD     BJRDNB        L1BSDT
     C                   ENDIF                                                                221119
      *                                                                                       221119
     C                   Z-ADD     0             L1CLRT
     C                   Z-ADD     1             L1CPRT
     C                   Z-ADD     1             L1APDY
     C                   Z-ADD     0             L1AMNT
      *
     C     BJRDNB        IFGT      BAVDRC
     C                   Z-ADD     BANBRT        L1BSRT
     C                   Z-ADD     BANBRT        L1INRT
     C                   ELSE
     C                   Z-ADD     BACBSR        L1BSRT
     C                   Z-ADD     BACBSR        L1INRT
     C                   ENDIF
      *
      ** Apply a spread to the rates for the GUESS record, if required.
      *
     C     WOTIN         IFEQ      'OUR'
      *
     C     USPIN         IFEQ      'A'
     C     L1BSRT        ADD       URTSP         L1BSRT
     C                   ENDIF
     C     USPIN         IFEQ      'S'
     C     L1BSRT        SUB       URTSP         L1BSRT
     C                   ENDIF
     C     USPIN         IFEQ      'P'
     C     L1BSRT        MULT      URTSP         WCNT             12 9
     C     WCNT          DIV       100           WCNT
     C     L1BSRT        ADD       WCNT          L1BSRT
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TSPIN         IFEQ      'A'
     C     L1BSRT        ADD       TRTSP         L1BSRT
     C                   ENDIF
     C     TSPIN         IFEQ      'S'
     C     L1BSRT        SUB       TRTSP         L1BSRT
     C                   ENDIF
     C     TSPIN         IFEQ      'P'
     C     L1BSRT        MULT      TRTSP         WCNT
     C     WCNT          DIV       100           WCNT
     C     L1BSRT        ADD       WCNT          L1BSRT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   Z-ADD     L1BSRT        L1INRT
      *
     C     WOTIN         IFEQ      'OUR'
     C                   Z-ADD     L1INRT        UEINR
     C                   BITON     '0'           UDNSI                                        209202
     C                   MOVE      'O'           L1OTCD
     C                   Z-ADD     UPAMT         L1PRIN
     C                   ELSE
     C                   Z-ADD     L1INRT        TEINR
     C                   BITON     '0'           TDNSI                                        209202
     C                   MOVE      'T'           L1OTCD
     C                   Z-ADD     TPAMT         L1PRIN
     C                   ENDIF
      *
     C                   WRITE     DLDOISD0
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBACK   - Back Valued Deals                                 *
      *                                                               *
      *  Called By : SRPROC                                           *
      *                                                               *
      *  Calls     : SRBINT, DL1649, *PSSR                            *
      *                                                               *
      *****************************************************************
      *
     C     SRBACK        BEGSR
      *
     C                   MOVE(P)   'COMPOUND'    L1RTYP
     C                   MOVE      BRCA          L1BRCA
     C                   Z-ADD     DLNO          L1DLNO
     C                   Z-ADD     0             L1BSRT
     C                   Z-ADD     0             L1CLRT
     C                   Z-ADD     0             L1INRT
     C                   Z-ADD     1             L1APDY
     C                   Z-ADD     0             L1AMNT
     C                   Z-ADD     0             WNODAY            5 0
     C                   Z-ADD     0             WRATE            12 9
     C**********           Z-ADD0         WINTND 129                                          209068
     C                   Z-ADD     0             WINTND           14 9                        209068
      *
     C     WOTIN         IFEQ      'OUR'
     C                   MOVEL     'O'           L1OTCD
     C                   Z-ADD     UPAMT         L1PRIN
     C                   Z-ADD     UEINR         L1INRT
     C                   MOVE      UCUCY         WCCY              3
     C                   ELSE
     C                   MOVEL     'T'           L1OTCD
     C                   Z-ADD     TPAMT         L1PRIN
     C                   Z-ADD     TEINR         L1INRT
     C                   MOVE      TCUCY         WCCY
     C                   ENDIF
      *
      ** Find Compounding Interest Rate.
      *
     C                   EXSR      SRBINT
      *
      ** Write COMPOUND record to DLDOISPD.
      *
     C                   WRITE     DLDOISD0
      *
      ** Call DL1649 to return an Interest Rate and write a settlement
      ** record to DLDOISPD
      *
     C                   CALL      'DL1649'
     C                   PARM      L1OTCD        POTCD             1
     C                   PARM      L1DLNO        PDLNO             6 0
     C                   PARM                    POINR            11 7
     C                   PARM      *BLANKS       PRTCD             1
     C                   PARM                    PHDAY                                        221119
     C                   PARM                    PDATE                                        221119
      *
     C                   MOVE      'N'           PHDAY                                        221119
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1649'      DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A6FXDY        IFEQ      0                                                          204923
     C     WOTIN         IFEQ      'OUR'
     C                   Z-ADD     POINR         UEINR
     C                   ELSE
     C                   Z-ADD     POINR         TEINR
     C                   ENDIF
     C                   ENDIF                                                                204923
      *
     C                   ENDSR
      *
      /EJECT                                                                                  221119
      *****************************************************************                       221119
      *                                                               *                       221119
      *  SRHPRO   - Holiday processing.                               *                       221119
      *                                                               *                       221119
      *  Called By : SRPROC                                           *                       221119
      *                                                               *                       221119
      *  Calls     : SRGUES                                           *                       221119
      *                                                               *                       221119
      *****************************************************************                       221119
      *                                                                                       221119
     C     SRHPRO        BEGSR                                                                221119
      *                                                                                       221119
      ** Check if value date falls on a holiday in local currency but not                     221119
      ** in deal currency. If so, generate GUESS record.                                      221119
      *                                                                                       221119
     C     WOTCD         IFEQ      'O'                                                        221119
     C                   MOVE      UCUCY         @CCY              3                          221119
     C                   ELSE                                                                 221119
     C                   MOVE      TCUCY         @CCY                                         221119
     C                   ENDIF                                                                221119
      *                                                                                       221119
     C     WFIRST        IFEQ      'Y'                                                        221119
     C                   CALLB     'ZCHKH'                                                    221119
     C                   PARM      VDAT          @DATE             5 0                        221119
     C                   PARM                    @CCY              3                          221119
     C                   PARM      *BLANKS       @LOC              3                          221119
     C                   PARM                    @WZIND            1                          221119
      *                                                                                       221119
     C     @WZIND        IFEQ      'W'                                                        221119
     C     VDAT          ANDLT     BJDNWD                                                     221119
     C     VDAT          ANDGT     BJRDNB                                                     221119
     C     @WZIND        OREQ      'H'                                                        221119
     C     VDAT          ANDLT     BJDNWD                                                     221119
     C     VDAT          ANDGT     BJRDNB                                                     221119
     C                   MOVE      'Y'           WHDAY             1                          221119
     C                   EXSR      SRGUES                                                     221119
     C                   MOVE      'N'           WHDAY             1                          221119
     C                   ENDIF                                                                221119
     C                   ENDIF                                                                221119
      *                                                                                       221119
      ** Check for other holidays before next working day. If a working                       221119
      ** day is found for the deal currency, generate STANDARD record.                        221119
      *                                                                                       221119
     C     WFIRST        IFEQ      'Y'                                                        221119
     C     W#CMPD        ANDEQ     'N'                                                        227171
     C                   Z-ADD     VDAT          WDAYS             5 0                        221119
     C                   ELSE                                                                 221119
     C                   Z-ADD     BJRDNB        WDAYS                                        221119
     C                   ENDIF                                                                221119
      *                                                                                       221119
     C                   ADD       1             WDAYS                                        221119
     C     WDAYS         DOWLT     BJDNWD                                                     221119
     C                   CALLB     'ZCHKH'                                                    221119
     C                   PARM      WDAYS         @DATE             5 0                        221119
     C                   PARM                    @CCY              3                          221119
     C                   PARM      *BLANKS       @LOC              3                          221119
     C                   PARM                    @WZIND            1                          221119
     C     @WZIND        IFEQ      'W'                                                        221119
     C                   MOVE      'Y'           PHDAY                                        221119
     C                   Z-ADD     WDAYS         PDATE             5 0                        221119
     C                   EXSR      SRSTAN                                                     221119
     C                   ENDIF                                                                221119
     C                   ADD       1             WDAYS                                        221119
     C                   ENDDO                                                                221119
      *                                                                                       221119
     C                   MOVE      'N'           WFIRST                                       221119
      *                                                                                       221119
     C                   ENDSR                                                                221119
      *                                                                                       221119
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBINT   - Calculate Compounding Rate for a Back Valued      *
      *             Deals                                             *
      *                                                               *
      *  Called By : SRBACK                                           *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRBINT        BEGSR
      *
      ** Get previous working day
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      WCCY          ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
      *
     C                   EXSR      ZBKDT
      *
      ** Set Date of COMPOUND record to previous working day
      *
     C                   Z-ADD     ZDYNBR        L1BSDT
      *
      ** Calculate no. of days between previous working day
      ** and Value Date
      *
     C     ZDYNBR        SUB       VDAT          WNODAY
      *                                                                                       CIR013
     C     WOTIN         IFEQ      'OUR'                                                      CIR013
     C     UICBS         ANDEQ     9                                                          CIR013
     C     WOTIN         ORNE      'OUR'                                                      CIR013
     C     TICBS         ANDEQ     9                                                          CIR013
      *                                                                                       CIR013
      * Convert start date to YYYYMMDD format                                                 CIR013
     C                   Z-ADD     VDAT          @@DAYN            5 0                        CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATA                                       CIR013
      *                                                                                       CIR013
      * Convert end date to YYYYMMDD format                                                   CIR013
     C                   Z-ADD     L1BSDT        @@DAYN                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATB                                       CIR013
      *                                                                                       CIR013
      * Check for the existence of any February 29th within the dates                         CIR013
     C                   EXSR      #FEB29                                                     CIR013
     C                   ENDIF                                                                CIR013
      *
      ** Multiply the Interest rate by the number of days calculated
      ** above. Then divide by ICBS * 100.
      *
     C     WOTIN         IFEQ      'OUR'
     C     UEINR         MULT      WNODAY        WINTND
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WINTND        DIV(H)    36500         WRATE
     C                   ENDIF
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WINTND        DIV(H)    36000         WRATE
     C                   ENDIF
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WINTND        DIV(H)    36600         WRATE
     C                   ENDIF
     C                   ELSE
     C     TEINR         MULT      WNODAY        WINTND
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WINTND        DIV(H)    36500         WRATE
     C                   ENDIF
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WINTND        DIV(H)    36000         WRATE
     C                   ENDIF
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WINTND        DIV(H)    36600         WRATE
     C                   ENDIF
     C                   ENDIF
      *
      ** Add 1 to calculate the COMPOUNDING Interest Rate.
      *
     C     WRATE         ADD       1             L1CPRT
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSTAN   - Standard Processing                               *
      *                                                               *
      *  Called By : SRPROC                                           *
      *                                                               *
      *  Calls     : DL1649, *PSSR, DL1665                            *
      *                                                               *
      *****************************************************************
      *
     C     SRSTAN        BEGSR
      *
      ** Call DL1649 to return an Interest Rate and write a settlement
      ** record to DLDOISPD
      *
     C                   CALL      'DL1649'
     C                   PARM      L1OTCD        POTCD
     C                   PARM      L1DLNO        PDLNO
     C                   PARM      *ZERO         POINR
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PHDAY                                        221119
     C                   PARM                    PDATE                                        221119
      *
     C                   MOVE      'N'           PHDAY                                        221119
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1649'      DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If this record should really be a settlement record change it
      *
     C                   MOVEL     'N'           WSETIN            1
      *
     C     WOTIN         IFEQ      'OUR'
     C     BJRDNB        IFEQ      UNIPD
     C     BJRDNB        OREQ      MDAT
     C                   MOVEL     'Y'           WSETIN
     C                   ENDIF
     C                   ENDIF
      *
     C     WOTIN         IFEQ      'THEIR'
     C     BJRDNB        IFEQ      TNIPD
     C     BJRDNB        OREQ      MDAT
     C                   MOVEL     'Y'           WSETIN
     C                   ENDIF
     C                   ENDIF
      *
     C     WSETIN        IFEQ      'Y'
      *
     C                   MOVEL(P)  'SETTLE'      WTYP              8
      *
      ** Call DL1665 to calculate a Base Amount of Interest due
      *
     C     WOTIN         IFEQ      'OUR'
     C                   Z-ADD     USLIP         PFRDT
     C                   ELSE
     C                   Z-ADD     TSLIP         PFRDT
     C                   ENDIF
      *
     C                   CALL      'DL1665'
     C                   PARM      DLNO          PDLNO
     C                   PARM      L1OTCD        POTCD
     C                   PARM                    PFRDT             5 0
     C                   PARM      BJRDNB        PTODT             5 0
     C                   PARM      *ZEROS        PAINT            13 0
     C                   PARM      *BLANKS       PRTCD
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1665'      DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Add Accrued Interest Adjusted Posted and Not Posted
      *
     C     WOTIN         IFEQ      'OUR'
     C     PAINT         ADD       UAIAN         WOINT            13 0
     C     WOINT         ADD       UAIAP         WOINT
     C                   ELSE
     C     PAINT         ADD       TAIAN         WTINT            13 0
     C     WTINT         ADD       TAIAP         WTINT
     C                   ENDIF
      *
      ** Apply tax if required on Our Side
      *
     C     WOTIN         IFEQ      'OUR'
     C     TAXR          ANDNE     0
     C     TAXI          ANDEQ     'Y'
     C     WOINT         MULT(H)   TAXR          WTAX             15 0
     C     WOINT         SUB       WTAX          WOINT
     C                   ENDIF
      *
     C     WOTIN         IFEQ      'OUR'
     C                   MOVE      'O'           WOTCD             1
     C                   ELSE
     C                   MOVE      'T'           WOTCD
     C                   ENDIF
      *
     C     KEY1          SETLL     DLDOISL1
     C                   READ      DLDOISL1                               70
     C                   MOVEL(P)  WTYP          L1RTYP
      *
     C     WOTIN         IFEQ      'OUR'
     C                   MOVE      WOINT         L1AMNT
     C                   ELSE
     C                   MOVE      WTINT         L1AMNT
     C                   ENDIF
      *
      ** SETTLE records are also GUESS records for a succeeding        t
      ** interest period, so the compounding rate field must be set
      ** to 1.0.
      *
     C                   Z-ADD     1             L1CPRT
      *
     C                   UPDATE    DLDOISD0
      *
     C                   ENDIF
      *
     C     A6FXDY        IFEQ      0                                                          204923
     C     WOTIN         IFEQ      'OUR'
     C                   MOVE      POINR         UEINR
     C                   ELSE
     C                   MOVE      POINR         TEINR
     C                   ENDIF
     C                   ENDIF                                                                204923
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR   - Subroutine to do Program Initialisation.          *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *  Calls     : AODEALR0, *PSSR, AOBANKR0                        *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *                                                                                       221119
     C                   MOVE      'N'           PHDAY             1                          221119
     C                   MOVE      'N'           WHDAY             1                          221119
     C                   MOVE      'N'           WFIRST            1                          221119
      *
      ** Set up copyright parameter and LDA
      *
     C                   MOVEA     CPY@          CPY2@            80
     C     *DTAARA       DEFINE                  LDA
      *
      ** Initialise LDA field fields
      *
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'DL1647'      DBPGM
     C                   Z-ADD     0             DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
     C     KEY1          KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KOTCD             1
      *
      ** Call access program to obtain Hong Kong Tax Rate
      *
     C**********           CALL 'AODEALR0'                                                    CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG    '    PRTRN             7
     C                   PARM      '*FIRST  '    POPTN             7
     C********** SDDEAL    PARM SDDEAL    DSFDY                                               CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTRN         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Call access program to obtain bank details
      ** Database error processing carried out internally
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    PRTRN
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Data base error in file (file)
      *
     C     PRTRN         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CIR004
      ** is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTRN             7
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CIR004'      PSARD             6
      *
     C     PRTRN         IFNE      *BLANKS
     C     PRTRN         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'CIR004'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTRN         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR004            1
     C                   ELSE
     C                   MOVE      'N'           CIR004
     C                   ENDIF
      *
      ** Divide the HK Tax rate by 100 to give working Tax Rate field
      *
     C     BNHKTR        DIV       100           TAXR              5 4
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called By : SRBRAT, SRBACK, SRSTAN, *INZSR                   *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
     C*COPY ZSRSRC,ZBKDT                                                                      220859
     C     ZBKDT         BEGSR                                                                220859
      *                                                                                       220859
      * Standard sub-routine to calculate up to 99 working days back                          220859
      * from a given start date.                                                              220859
      * NB. Must be used in conjunction with ZACCH.                                           220859
      *                                                                                       220859
      * NB: If required no. of working days back is zero, then:-                              220859
      *       if input date is a working day, then result is input date                       220859
      *       else result is first working day before input date.                             220859
      *                                                                                       220859
      *     If required no. of working days back is one, then:-                               220859
      *       if input date is a working day, then result is previous                         220859
      *       working day                                                                     220859
      *       else result is first working day before input date.                             220859
      *                                                                                       220859
      * Thus, if input date is a holiday, then zero and one working day                       220859
      * back will return the same result.                                                     220859
      *                                                                                       220859
      **                                                                                      220859
      *Define input parameters                                                                220859
      **                                                                                      220859
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0                        220859
     C                   MOVE      ZCCY          ZCCY              3                          220859
     C                   MOVE      ZLOC          ZLOC              3                          220859
     C                   Z-ADD     ZNRDYS        ZNRDYS            2 0                        220859
      **                                                                                      220859
      *Define Output parameters                                                               220859
      **                                                                                      220859
     C                   Z-ADD     0             ZDYNBR            5 0                        220859
      *                                                                                       220859
      * Move input date to output date                                                        220859
      *                                                                                       220859
     C                   Z-ADD     ZDAYNO        ZDYNBR                                       220859
      *                                                                                       220859
      * Get holiday record                                                                    220859
      *                                                                                       220859
     C                   MOVE      '*SETGT '     ZOPTN                                        220859
      *                                                                                       220859
     C                   EXSR      ZACCH                                                      220859
      *                                                                                       220859
      * If no record was found, subtract no. of days back from input                          220859
      * date and then try to find record again.                                               220859
      *                                                                                       220859
     C     RTNCD         IFEQ      '*NRF   '                                    IF 1          220859
      *                                                                                       220859
      * Set up new input day number to get record                                             220859
      *                                                                                       220859
     C     ZDAYNO        SUB       ZNRDYS        ZDAYNO                                       220859
      *                                                                                       220859
     C                   MOVE      '*PREV  '     ZOPTN                                        220859
      *                                                                                       220859
     C                   EXSR      ZACCH                                                      220859
      *                                                                                       220859
      * Move input date back again; is still in output date field.                            220859
      *                                                                                       220859
     C                   Z-ADD     ZDYNBR        ZDAYNO                                       220859
      *                                                                                       220859
      * If still no record found, then just subtract no. of working                           220859
      * days back required from input date to get output date.                                220859
      *                                                                                       220859
     C     RTNCD         IFEQ      '*NRF   '                                     IF 2         220859
      *                                                                                       220859
     C     ZDAYNO        SUB       ZNRDYS        ZDYNBR                                       220859
      *                                                                                       220859
     C                   ELSE                                                    ELSE 2       220859
      *                                                                                       220859
      * Otherwise, need to step back through the year and count the                           220859
      * working days until we get to the value required. Subtracting                          220859
      * 31st. Dec date from input date and subtracting one gives no.                          220859
      * of working days in this year (@ZWRDY).                                                220859
      *                                                                                       220859
     C     ZDAYNO        SUB       DGDDNB        @ZWRDY                                       220859
     C                   SUB       1             @ZWRDY                                       220859
      *                                                                                       220859
      * Need to count working days in previous year; subtract no. in                          220859
      * this year to give no. left to find; find position of 31st. Dec                        220859
      * for previous year. Subtract no. of working days in this year                          220859
      * from output date.                                                                     220859
      *                                                                                       220859
     C     ZNRDYS        SUB       @ZWRDY        ZNRDYS                                       220859
     C     ZDYNBR        SUB       @ZWRDY        ZDYNBR                                       220859
      *                                                                                       220859
     C     DGDDNB        SUB       DGJDNB        ZINDX                                        220859
     C                   ADD       2             ZINDX                                        220859
      *                                                                                       220859
     C                   EXSR      ZCNTDY                                                     220859
      *                                                                                       220859
     C                   END                                                     FI 2         220859
      *                                                                                       220859
     C                   ELSE                                                   ELSE 1        220859
      *                                                                                       220859
      * Otherwise, we have a record and so need to count working days                         220859
      * Subtract 1st. Jan from input date and add 1 to give day in year                       220859
      * index.                                                                                220859
      *                                                                                       220859
     C     ZDAYNO        SUB       DGJDNB        ZINDX                                        220859
     C                   ADD       1             ZINDX                                        220859
      *                                                                                       220859
     C                   EXSR      ZCNTDY                                                     220859
      *                                                                                       220859
     C                   END                                                    FI 1          220859
      *                                                                                       220859
     C                   ENDSR                                                                220859
      *                                                                                       220859
      *****************************************************************                       220859
      *                                                                                       220859
     C     ZCNTDY        BEGSR                                                                220859
      *                                                                                       220859
      * Since the following code would be duplicated in the main                              220859
      * sub-routine, it is put in a separate one for clarity.                                 220859
      *                                                                                       220859
      * If no. of working days required is zero and input date is a                           220859
      * holiday, then change required no. of days to one.                                     220859
      *                                                                                       220859
     C     ZNRDYS        IFEQ      0                                                          220859
     C     ZHL(ZINDX)    ANDEQ     'X'                                                        220859
     C                   ADD       1             ZNRDYS                                       220859
     C                   END                                                                  220859
      *                                                                                       220859
      * While we still need to find a working day, continue processing.                       220859
      *                                                                                       220859
     C     ZNRDYS        DOWGT     0                                            DOW 1         220859
      *                                                                                       220859
      * Subtract one from day in year index and output date                                   220859
      *                                                                                       220859
     C                   SUB       1             ZINDX                                        220859
     C                   SUB       1             ZDYNBR                                       220859
      *                                                                                       220859
      * If output date is beyond stored 1st. Jan date, then need to                           220859
      * get prev holiday record with new parameters: output date is new                       220859
      * input date; no. of days back is current no. of days left to                           220859
      * find.                                                                                 220859
      *                                                                                       220859
     C     ZDYNBR        IFLT      DGJDNB                                        IF 1         220859
      *                                                                                       220859
     C                   Z-ADD     ZDYNBR        ZDAYNO                                       220859
      *                                                                                       220859
     C                   MOVE      '*SETGT '     ZOPTN                                        220859
      *                                                                                       220859
     C                   EXSR      ZACCH                                                      220859
      *                                                                                       220859
      * If no record was found, then subtract no. of days left to find                        220859
      * from output date and add 1 to give required result and change                         220859
      * no. left to find to zero to terminate loop.                                           220859
      * Change day in year index to one to avoid errors.                                      220859
      *                                                                                       220859
     C     RTNCD         IFEQ      '*NRF   '                                      IF 2        220859
      *                                                                                       220859
     C                   SUB       ZNRDYS        ZDYNBR                                       220859
     C                   ADD       1             ZDYNBR                                       220859
     C                   Z-ADD     0             ZNRDYS                                       220859
     C                   Z-ADD     1             ZINDX                                        220859
      *                                                                                       220859
     C                   ELSE                                                     ELSE 2      220859
      *                                                                                       220859
      * Otherwise, reset day in year value.                                                   220859
      *                                                                                       220859
     C     ZDAYNO        SUB       DGJDNB        ZINDX                                        220859
     C                   ADD       1             ZINDX                                        220859
      *                                                                                       220859
     C                   END                                                      FI 2        220859
      *                                                                                       220859
     C                   END                                                     FI 1         220859
      *                                                                                       220859
      * If holiday index value is ' ' then need to find one day less                          220859
      *                                                                                       220859
     C     ZHL(ZINDX)    IFEQ      ' '                                           IF 1         220859
     C                   SUB       1             ZNRDYS                                       220859
     C                   END                                                     FI 1         220859
      *                                                                                       220859
     C                   END                                                    ENW 1         220859
      *                                                                                       220859
     C                   ENDSR                                                                220859
      /EJECT
     C*COPY ZSRSRC,ZACCH                                                                      220859
     C     ZACCH         BEGSR                                                                220859
      *                                                                                       220859
      * This standard sub-routine is to be used in conjunction with                           220859
      * the holiday standard sub-routines. Its function is to                                 220859
      * determine if the access program AOHOLS0 needs to be called and                        220859
      * sets up the holiday record appropriately. It is common to all                         220859
      * the new holiday sub-routines, but should only be included in                          220859
      * a program once, using /COPY.                                                          220859
      *                                                                                       220859
      *                                                                                       220859
      * If stored parameters from last call are not within the same                           220859
      * bounds - ie. same ccy/location and date is within 1st. Jan &                          220859
      * 31st. Dec of current holiday record - continue processing.                            220859
      *                                                                                       220859
      **                                                                                      220859
      *Define input parameters                                                                220859
      **                                                                                      220859
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0                        220859
     C                   MOVE      ZCCY          ZCCY              3                          220859
     C                   MOVE      ZLOC          ZLOC              3                          220859
     C                   MOVE      ZOPTN         ZOPTN             7                          220859
     C*                                                                                       220859
     C     ZOPTN         IFEQ      '*FREE  '                                      IF 2        220859
     C*                                                                                       220859
     C                   CALL      'AOHOLS0'                                                  220859
     C                   PARM      *BLANK        RTNCD                                        220859
     C                   PARM                    ZOPTN                                        220859
     C                   PARM      ZCCY          ZZCCY                                        220859
     C                   PARM      ZLOC          ZZLOC                                        220859
     C                   PARM      ZDAYNO        ZZDYNO                                       220859
     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B 220859
     C*                                                                                       220859
     C                   ELSE                                                                 220859
     C*                                                                                       220859
     C     ZCCY          IFNE      ZSCCY                                        IF 1          220859
     C     ZLOC          ORNE      ZSLOC                                         OR           220859
     C     ZDAYNO        ORLT      ZSJAN                                         OR           220859
     C     ZDAYNO        ORGT      ZSDCM                                         OR           220859
      *                                                                                       220859
      * Get appropriate holiday record                                                        220859
      *                                                                                       220859
     C                   CALL      'AOHOLS0'                                                  220859
     C                   PARM      *BLANK        RTNCD                                        220859
     C                   PARM                    ZOPTN                                        220859
     C                   PARM      ZCCY          ZZCCY                                        220859
     C                   PARM      ZLOC          ZZLOC                                        220859
     C                   PARM      ZDAYNO        ZZDYNO            5 0                        220859
     C     ZHOLDS        PARM      ZHOLDS        DSSDY                                      B 220859
      *                                                                                       220859
      * If no record was found, assume all days in year are working                           220859
      * days.                                                                                 220859
      *                                                                                       220859
     C     RTNCD         IFEQ      '*NRF   '                                      IF 2        220859
      *                                                                                       220859
     C                   MOVE      *ALL' '       ZHL                                          220859
      *                                                                                       220859
      * Save 1st. Jan/31st. Dec dates as input date as we cannot say                          220859
      * anything about this year in future calls.                                             220859
      *                                                                                       220859
     C                   Z-ADD     ZDAYNO        ZSJAN                                        220859
     C                   Z-ADD     ZDAYNO        ZSDCM                                        220859
      *                                                                                       220859
     C                   ELSE                                                     ELSE 2      220859
      *                                                                                       220859
      * Save 1st. Jan/31st. Dec for future calls                                              220859
      *                                                                                       220859
     C                   Z-ADD     DGJDNB        ZSJAN                                        220859
     C                   Z-ADD     DGDDNB        ZSDCM                                        220859
      *                                                                                       220859
      * Left adjust the holiday array over FEB 29th if the                                    220859
      * holiday record is not for a leap year.                                                220859
      *                                                                                       220859
     C                   MOVE      DGYRNB        Z@YR              4 0                        220859
     C     Z@YR          DIV       4             Z@WK1             4 0                        220859
     C                   MVR                     Z@WK2             4 0                        220859
     C*                                                                                       220859
     C     Z@WK2         IFNE      0                                                          220859
     C*                                                                                       220859
     C                   MOVEA     ZHL           ZHL1                                         220859
     C                   MOVEA     ZHL1(61)      ZHL(60)                                      220859
     C*                                                                                       220859
     C                   END                                                                  220859
     C*                                                                                       220859
     C                   END                                                      FI 2        220859
      *                                                                                       220859
      * Save currency and location for future calls. Need to save                             220859
      * return code as well.                                                                  220859
      *                                                                                       220859
     C                   MOVE      ZCCY          ZSCCY                                        220859
     C                   MOVE      ZLOC          ZSLOC                                        220859
     C                   MOVE      RTNCD         ZSRTN                                        220859
      *                                                                                       220859
     C                   ELSE                                                   ELSE 1        220859
      *                                                                                       220859
      * Move saved return code back again as there may have been no                           220859
      * record found last time.                                                               220859
      *                                                                                       220859
     C                   Z-ADD     ZSJAN         DGJDNB                                       220859
     C                   Z-ADD     ZSDCM         DGDDNB                                       220859
     C                   MOVE      ZSRTN         RTNCD                                        220859
      *                                                                                       220859
     C                   END                                                    FI 1          220859
      *                                                                                       220859
     C                   END                                                                  220859
      *                                                                                       220859
     C                   ENDSR                                                                220859
      /EJECT
     C*COPY*ZSRSRC,ZDATE9Z3                                                                   CIR013
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZFEB29                                                                     CIR013
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CIR013
      /EJECT                                                                                  CIR013
**  CPY@
(c) Finastra International Limited 2001
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CIR013
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CIR013
00000000310005900090001200015100181002120024300273003040033400365
