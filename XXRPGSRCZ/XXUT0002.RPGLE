     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Initial DEALSDC Extract to DEALSCX0')                  *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***UTIL02**-*Initial*DEALSDC*Extract*to*DEALSCX0*****************                       LUC109
      *  XXUT0002 - Initial DEALSDC Extract to DEALSCX0               *                       LUC109
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
      *  Last Amend No. LUC109             Date 25Jan17               *
      *  Prev Amend No. LUC109             Date 22Sep16               *
      *                 MUI009             Date 16Feb04               *
      *                 MMI043 *Create     Date 16Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109  -R306 Netting flag not available in Loans            *
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
     FDEALSDC   IF   E           K DISK    INFSR(*PSSR)
     FDEALSCY0  UF A E           K DISK    INFSR(*PSSR)
     F***UTIL02AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXXUT0002AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - PF/DEALSDC    File I/O                                 *
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
      *  #READ  - Read DEALSDC File                                   *
      *  #PROC  - Process DEALSDC Record                             *
      *  #CRTCX - Create DEALSCX0 Record                              *
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
     C     *LIKE         DEFINE    *INLR         DLCRED
     C     *LIKE         DEFINE    MCAPV         WAMT
      *
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
      * Read all Deals on DEALSDC File
      *
     C                   READ      DEALSDC                                20
      *
      *
     C     *IN20         DOWEQ     *OFF                                         Until eof
      *
     C     RECI          IFEQ      'D'
     C                   EXSR      #PROC
     C                   ENDIF
      *
     C     RECI          IFEQ      'M'
     C     RECI          OREQ      'N'
     C     MDAT          IFGT      MPEMB
     C                   EXSR      #PROC
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      DEALSDC                                20
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #PROC  -  Process DEALSDC Record                             *
      *                                                               *
      *  Called By: #READ                                             *
      *  Calls:     #BSPL                                             *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      * Read DEALSCX0 File - if record not found, create it.
      *
     C     DLNO          CHAIN     DEALSCY0                           20
     C   20              EXSR      #CRTCX
     C   20DLNO          CHAIN     DEALSCY0                           20
      *
      * Increment MTD Working Days by 1.
      *
     C                   Z-ADD     0             MMTDY
      *
      * Check Deal Type.
      *
     C                   MOVE      *OFF          DLCRED
     C     DTYP          IFEQ      'IT'
     C     DTYP          OREQ      'TD'
     C     DTYP          OREQ      'CI'
     C     DTYP          OREQ      'CD'
     C                   MOVE      *ON           DLCRED
     C                   ENDIF
      *
      * DR/CR Interest Rate MTD
      *
     C                   Z-ADD     *ZERO         MCAVX
     C                   Z-ADD     *ZERO         MDAVX
      *
      * DR/CR Interest Rate Mthly Average
      *
     C                   Z-ADD     0             MCAVR
     C                   Z-ADD     0             MDAVR
      *
      * Interest on DR/CR Bals at end of previous mth
      *
     C                   Z-ADD     AITC          WAMT
     C                   ADD       AIAP          WAMT
     C                   ADD       AIPD          WAMT
     C     DLCRED        IFEQ      *ON
     C                   Z-ADD     WAMT          MCAPV
     C                   ELSE
     C                   Z-ADD     WAMT          MDAPV
     C                   END
      *
      * Interst on DR/CR Balances accrued this month
      *
     C                   Z-ADD     0             MCACM
     C                   Z-ADD     0             MDACM
      *
      * DR/CR Accounting Balance MTD
      *
     C                   Z-ADD     0             MCALX
     C                   Z-ADD     0             MDALX
      *
      * DR/CR Accounting Balance Mthly Average
      *
     C                   Z-ADD     0             MCALB
     C                   Z-ADD     0             MDALB
      *
      * DR/CR Available Balance MTD
      *
     C                   Z-ADD     0             MCACX
     C                   Z-ADD     0             MDACX
      *
      * DR/CR Available Balance Mthly Average
      *
     C                   Z-ADD     0             MCACB
     C                   Z-ADD     0             MDACB
      *
      * Total Interest until Maturity Date not yet paid
      *
     C                   Z-ADD     0             MTOTI
      *
      * DR/CR Interest Movements at end of last quarter
      *
     C     DLCRED        IFEQ      *ON
     C                   Z-ADD     IPRD          MQCIX
     C                   ELSE
     C                   Z-ADD     IPRD          MQDIX
     C                   END
      *
      * DR/CR Interest Movements this quarter
      *
     C                   Z-ADD     0             MQCIM
     C                   Z-ADD     0             MQDIM
      *
      * Update Record on DEALSCX0
      *
     C                   UPDATE    DEALCFX0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #CRTCX -  Create DEALSCX0 Record                             *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #CRTCX        BEGSR
      *
     C                   CLEAR                   DEALCFX0
     C                   MOVE      DLNO          MDLNO
      *
     C                   WRITE     DEALCFX0
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
     C                   MOVEL     'UTIL02'      DBPGM                          Set program id
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
