     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Initial Setup of CLOANCX0 File')                       *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***UTIL04**-*Initial*Setup*of*CLOANCX0*File**********************                       LUC109
      *  XXUT0004 - Initial Setup of CLOANCX0 File                    *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE BOTTOM*
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             TO BE RUN DURING INPUT CYCLE                      *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev Amend No. MUI009             Date 16Feb04               *
      *                 MMI043 *Create     Date 12Jan99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FCLOANCL   IF   E           K DISK    INFSR(*PSSR)
     FLEFEED    IF   E           K DISK    INFSR(*PSSR)
     FCLOANCY0  UF A E           K DISK    INFSR(*PSSR)
     F***LEM008AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000008AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - PF/CLOANCL    File I/O                                 *
      *   88 - General chain indicator                                *
      *                                                               *
      *                                                               *
      *  U7+U8    Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #READ  - Read CLOANCL File                                   *
      *  #PROC  - Process CLOANCL Record                             *
      *  #CRTCX - Create CLOANCX0 Record                              *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
     D***/C*PY*ZSRSRC,ZDATE9Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D DSFACL          DS
     D  WFACL                  1      5  0
     D  FTYP                   1      3  0
     D  FSEQ                   4      5  0
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
      ** Data structure for subroutine ZCBDYS                                                 LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT1                 1      8  0                                                    LUC109
     D  ZZYYA                  1      4  0                                                    LUC109
     D  ZZMMA                  5      6  0                                                    LUC109
     D  ZZDDA                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT2                 1      8  0                                                    LUC109
     D  ZZYYB                  1      4  0                                                    LUC109
     D  ZZMMB                  5      6  0                                                    LUC109
     D  ZZDDB                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      #READ                                        Main process
      *
     C                   EXSR      #TERM                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      * Careful cause this indicator is used in date routines
      *
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      *OFF          *IN98
     C                   ELSE
     C                   MOVE      *ON           *IN98
     C                   END
      *
      ** Data definition
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LIKE         DEFINE    MDCMM         WCOMM
     C     *LIKE         DEFINE    MDCMM         WCHGS
     C     *LIKE         DEFINE    MDCMM         WAMT
      *
      ** Key List Definitions
      *
     C     KYFEED        KLIST
     C                   KFLD                    KYBRCA            3
     C**********         KFLD                    KYCNUM            6 0                        LUC109
     C                   KFLD                    KYCNUM            6                          LUC109
     C                   KFLD                    KYFACL            5 0
     C**********         KFLD                    KYLOAN            6 0                        LUC109
     C                   KFLD                    KYLOAN            6                          LUC109
      *
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN88
      *
     C                   READ      SDBANKPD                               88
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               88
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVEL     'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #READ  -  Read File                                          *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S200                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #READ         BEGSR
      *
      * Read CLOANCL File
      *
     C                   READ      CLOANCL                                20
      *
      *
     C     *IN20         DOWEQ     *OFF                                         Until eof
      *
     C     RECI          IFEQ      'M'
     C     RECI          OREQ      'D'
     C     MDAT          IFGE      BJRDNB
     C                   EXSR      #PROC
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      CLOANCL                                20
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #PROC  -  Process CLOANCL Record                             *
      *                                                               *
      *  Called By: #READ                                             *
      *  Calls:     #BSPL                                             *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      * Read CLOANCX0 File - if record not found, create it.
      *
     C     LNRF          CHAIN     CLOANCY0                           20
     C   20              EXSR      #CRTCX
     C   20LNRF          CHAIN     CLOANCY0                           20
      *
      * Increment MTD Working Days by 1.
      *
     C                   Z-ADD     0             MMTDY
      *
      * DR Interest Rate MTD
      *
     C                   Z-ADD     *ZERO         MDAVX
      *
      * DR Interest Rate Mthly Average
      *
     C                   Z-ADD     0             MDAVR
      *
      * Interest on DR Bals at end of previous mth
      *
     C                   Z-ADD     AITC          WAMT
     C                   ADD       AIAP          WAMT
     C                   ADD       AIPD          WAMT
     C                   Z-ADD     WAMT          MDAPV
      *
      * Interest on DR Balances accrued this month
      *
     C                   Z-ADD     0             MDACM
      *
      * DR Accounting Balance MTD
      *
     C                   Z-ADD     *ZERO         MDALX
      *
      * DR Accounting Balance Mthly Average
      *
     C                   Z-ADD     0             MDALB
      *
      * DR Available Balance MTD
      *
     C                   Z-ADD     *ZERO         MDACX
      *
      * DR Available Balance Mthly Average
      *
     C                   Z-ADD     0             MDACB
      *
      * Total Interest until Maturity Date not yet paid
      *
     C                   Z-ADD     0             MTOTI
      *
      * DR Interest Movements at end of last quarter
      *
     C                   Z-ADD     IPRD          MQDIX
      *
      * DR Interest Movements this quarter
      *
     C                   Z-ADD     0             MQDIM
      *
      * Quarterly Maximum DR Accounting Balance
      *
     C                   Z-ADD     0             MQXAB
      *
      * Quarterly Minimum DR Available Balance
      *
     C                   Z-ADD     0             MQMAV
     C                   Z-ADD     0             MPQMA
      *
      * Quarterly Maximum DR Available Balance
      *
     C                   Z-ADD     0             MQXAV
     C                   Z-ADD     0             MPQXA
      *
      * Get Charges and Commission for this Loan.
      *
     C                   EXSR      #CHCM
      *
      * Charges/Commission DR at end of previous month.
      *
     C                   Z-ADD     WCHGS         MDGPV
     C                   Z-ADD     WCOMM         MDCPV
      *
      * Charges/Commission DR this month
      *
     C                   Z-ADD     0             MDCGM
     C                   Z-ADD     0             MDCMM
      *
      * Update Record on CLOANCX0
      *
     C                   UPDATE    CLOANFX0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #CRTCX -  Create CLOANCX0 Record                             *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #CRTCX        BEGSR
      *
     C                   CLEAR                   CLOANFX0
     C                   MOVE      LNRF          MLNRF
     C                   MOVE      '0'           MCONS
     C                   MOVE      '0'           MCRTP
      *
     C                   WRITE     CLOANFX0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #CHCM  -  Calculate Charges and Commission for this loan.    *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #CHCM         BEGSR
      *
     C                   Z-ADD     0             WCOMM
     C                   Z-ADD     0             WCHGS
     C                   MOVE      BRCA          KYBRCA
     C                   MOVE      CNUM          KYCNUM
     C                   MOVE      WFACL         KYFACL
     C                   MOVE      LNRF          KYLOAN
      *
     C     KYFEED        SETLL     LEFEED
     C     KYFEED        READE     LEFEED                                 90
      *
     C     *IN90         DOWEQ     *OFF
      *
     C     FEPIND        IFEQ      'P'
     C                   ADD       FEADBP        WCOMM
     C                   ELSE
     C                   ADD       FEADBP        WCHGS
     C                   ENDIF
      *
     C     KYFEED        READE     LEFEED                                 90
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
      *
     C     *INU7         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
      *
     C                   WRITE     HEADAU                                       Report header
      *
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C                   MOVEL     'UTIL04'      DBPGM                          Set program id
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *INU7                          Database error
     C                   MOVE      *ON           *INU8                          Database error
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #TERM                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***/C*PY*ZSRSRC,ZCBDYSZ1                                                                LUC109
     C/COPY ZSRSRC,XCBDYSZ1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDLINTZ1                                                                LUC109
     C/COPY ZSRSRC,ZDLINTZ1LE                                                                 LUC109
     C***/C*PY*ZSRSRC,ZDATE9Z3                                                         MUI009 LUC109
     C***/C*PY*ZSRSRC,ZDAT10Z2                                                                LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                          MUI009 LUC109
      ***
**  CPY@
(c) Finastra International Limited 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
**   @YD  - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
00366007310109601461
**   @MD  - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
