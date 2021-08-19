     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Daily DEALSDD Extract to DEALSDX0')                    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***MMM005**-*Daily*DEALSDD*Extract*to*DEALSDX0*******************                       LUC109
      *  XX000005 - Daily DEALSDD Extract to DEALSDX0                 *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *                                                               *
      ***CALLED*BY**GLCM043*-*HOR*FILES*CREATION***********************                       LUC109
      *  CALLED BY XXC000043 - HOR FILES CREATION                     *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev Amend No. MUI009             Date 16Feb04               *
      *                 167412 (2)         Date 19Nov99               *
      *                 167330             Date 28Oct99               *
      *                 167412             Date 25Oct99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043   *Create   DATE 16Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  167412 - Additional amendment: Store prev amounts later      *
      *  167330 - Always report face value instead of discount amount.*
      *           This is incorporated with 167412, by replacing      *
      *           PUPR in original with FVAL.                         *
      *  167412 - Change the way monthly averages are calculated:     *
      *           include non-working days and do not count days      *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FDEALSDD   IF   E           K DISK    INFSR(*PSSR)
     FDEALSDY0  UF A E           K DISK    INFSR(*PSSR)
     F***MMM005AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000005AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - PF/DEALSDD    File I/O                                 *
      *   88 - General chain indicator                                *
      *                                                               *
      *                                                               *
      *  89       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #READ  - Read DEALSDC File                                   *
      *  #PROC  - Process DEALSDD Record                             *
      *  #CRTDX - Create DEALSDX0 Record                              *
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
     C     *LIKE         DEFINE    MDAPV         WAMT
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
      *                                                                   167412
      ** Initialise variables for averaging subroutines                   167412
      *                                                                   167412
      *                                                                   167412
     C                   EXSR      AVINIT                                                      16741
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
      * Read all Deals on DEALSDD File
      *
     C                   READ      DEALSDD                                20
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
     C                   ELSE                                                                  16741
     C                   EXSR      #DELET                                                      16741
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      DEALSDD                                20
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #PROC  -  Process DEALSDD Record                             *
      *                                                               *
      *  Called By: #READ                                             *
      *  Calls:     #BSPL                                             *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      * Read DEALSDX0 File - if record not found, create it.
      *
     C     DLNO          CHAIN     DEALSDY0                           20
     C   20              EXSR      #CRTDX
     C   20DLNO          CHAIN     DEALSDY0                           20
      *
      * Increment MTD Working Days by 1.
      *
      * ... first day of month processing only
     C     MFSTM         IFEQ      'Y'
     C                   Z-ADD     0             MMTDY
     C                   ENDIF
      *
     C                   ADD       1             MMTDY
      *                                                                   167412
      ** Store value and maturity dates for averaging procedure.          167412
      *                                                                   167412
     C                   Z-ADD     VDAT          @VDAT                                         16741
     C                   Z-ADD     MDAT          @MDAT                                         16741
      *                                                                   167412
      ** All values are debit for this program.                           167412
     C                   MOVE      *OFF          DLCRED                                        16741
      *
      * DR/CR Interest Rate MTD
      *
     C                   Z-ADD     MCAVX         CUMCRX                                        16741
     C                   Z-ADD     MDAVX         CUMDRX                                        16741
     C                   Z-ADD     INTR          XAMNT                                         16741
     C                   MOVE      DLCRED        WDRCR                                         16741
     C                   Z-ADD     MINTRX        XAMNTX                                        16741
     C                   MOVE      MDRCRX        WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMCR         MCAVX                                         16741
     C                   Z-ADD     CUMDR         MDAVX                                         16741
     C                   Z-ADD     AVECR         MCAVR                                         16741
     C                   Z-ADD     AVEDR         MDAVR                                         16741
     C                   Z-ADD     INTR          MINTRX                                        16741
      **************                                                      167412
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MCAVX                           167412
     C**************       Z-ADD*ZERO     MDAVX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C**************       ADD  INTR      MDAVX                           167412
      **************                                                      167412
      **DR/CR*Interest Rate Mthly Average                                 167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MCAVX     DIV  MMTDY     MCAVR                           167412
     C***********MDAVX     DIV  MMTDY     MDAVR                           167412
     C**************       ENDIF                                          167412
      *
      * Interest on DR/CR Bals at end of previous mth
      *
      * ... first day of month processing only
     C     MFSTM         IFEQ      'Y'
     C                   ADD       MCACM         MCAPV
     C                   ADD       MDACM         MDAPV
     C                   Z-ADD     0             MCACM
     C                   Z-ADD     0             MDACM
     C                   END
      *
      * Interst on DR/CR Balances accrued this month
      *
     C                   Z-ADD     AITC          WAMT
     C                   ADD       AIAP          WAMT
     C                   ADD       AIPD          WAMT
     C     WAMT          SUB       MDAPV         MDACM
      *
      * DR/CR Accounting Balance MTD
      *
     C                   Z-ADD     MCALX         CUMCRX                                        16741
     C                   Z-ADD     MDALX         CUMDRX                                        16741
     C                   Z-ADD     FVAL          XAMNT                                         16741
     C                   MOVE      DLCRED        WDRCR                                         16741
     C                   Z-ADD     MFVALX        XAMNTX                                        16741
     C                   MOVE      MDRCRX        WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMCR         MCALX                                         16741
     C                   Z-ADD     CUMDR         MDALX                                         16741
     C                   Z-ADD     AVECR         MCALB                                         16741
     C                   Z-ADD     AVEDR         MDALB                                         16741
     C*********************Z-ADDFVAL      MFVALX                          167412
     C*********************MOVE DLCRED    MDRCRX                          167412
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MCALX                           167412
     C**************       Z-ADD*ZERO     MDALX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C**************       ADD  PUPR      MDALX                           167412
      **************                                                      167412
      **DR/CR*Accounting Balance Mthly Average                            167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MCALX     DIV  MMTDY     MCALB                           167412
     C***********MDALX     DIV  MMTDY     MDALB                           167412
     C**************       ENDIF                                          167412
      *
      * DR/CR Available Balance MTD
      *
     C                   Z-ADD     MCACX         CUMCRX                                        16741
     C                   Z-ADD     MDACX         CUMDRX                                        16741
     C                   Z-ADD     FVAL          XAMNT                                         16741
     C                   MOVE      DLCRED        WDRCR                                         16741
     C                   Z-ADD     MFVALX        XAMNTX                                        16741
     C                   MOVE      MDRCRX        WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMCR         MCACX                                         16741
     C                   Z-ADD     CUMDR         MDACX                                         16741
     C                   Z-ADD     AVECR         MCACB                                         16741
     C                   Z-ADD     AVEDR         MDACB                                         16741
      *                                                                   167412
      ** Store previous amounts                                           167412
     C                   Z-ADD     FVAL          MFVALX                                        16741
     C                   MOVE      DLCRED        MDRCRX                                        16741
     C**...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C*************        Z-ADD*ZERO     MCACX                           167412
     C*************        Z-ADD*ZERO     MDACX                           167412
     C*************        ENDIF                                          167412
     C*************                                                       167412
     C*************        ADD  PUPR      MDACX                           167412
     C*************                                                       167412
     C**DR/CR*Available Balance Mthly Average                             167412
     C*************                                                       167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MCACX     DIV  MMTDY     MCACB                           167412
     C***********MDACX     DIV  MMTDY     MDACB                           167412
     C*************        ENDIF                                          167412
      *
      * Total Interest until Maturity Date not yet paid
      *
      * ... ignore deals without a maturity date
     C     MDAT          IFNE      0
      * ... find total interest for deal
     C                   Z-ADD     FVAL          ZDLAMT
     C                   Z-ADD     INTR          ZDLRAT
     C                   Z-ADD     VDAT          ZCBSDT
     C                   Z-ADD     MDAT          ZCBEDT
     C                   MOVE      ICBS          ZCBCBS
     C                   EXSR      ZDLINT
      * ... subtract interest paid to date
     C     ZDLOUT        SUB       IPRD          MTOTI
      *
     C                   ENDIF
      *
      * DR/CR Interest Movements at end of last quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MQCIM         MQCIX
     C                   ADD       MQDIM         MQDIX
     C                   Z-ADD     0             MQCIM
     C                   Z-ADD     0             MQDIM
     C                   END
      *
      * DR/CR Interest Movements this quarter
      *
     C     IPRD          SUB       MQDIX         MQDIM
      *
      * Update Record on DEALSDX0
      *
     C                   UPDATE    DEALDFX0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *                                                                   167412
      ** Averaging subroutines:                                           167412
      *
      ***/C*PY*WNCPYSRC,AVEMTH1****************************************                       LUC109
      /COPY WNCPYSRC,AVEMTHI1                                                                 LUC109
      *
      *****************************************************************   167412
      *                                                               *   167412
      *  #DELET -  Delete DEALSDX0 Record                             *   167412
      *                                                               *   167412
      *  Called By: #READ                                             *   167412
      *  Calls:                                                       *   167412
      *                                                               *   167412
      *****************************************************************   167412
      *                                                                   167412
     C     #DELET        BEGSR                                                                 16741
      *                                                                   167412
     C     DLNO          CHAIN     DEALSDY0                           20                       16741
     C  N20              DELETE    DEALDFX0                                                    16741
      *                                                                   167412
     C                   ENDSR                                                                 16741
      *****************************************************************
      *                                                               *
      *  #CRTDX -  Create DEALSDX0 Record                             *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #CRTDX        BEGSR
      *
     C                   CLEAR                   DEALDFX0
     C                   MOVE      DLNO          MDLNO
      *
     C                   WRITE     DEALDFX0
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
     C     *IN89         IFEQ      *ON                                          Database error
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
     C                   MOVEL     'MMM005'      DBPGM                          Set program id
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN89                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
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
