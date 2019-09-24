     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Daily CLOANCL Extract to CLOANCX0')                    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***LEM008**-*Daily*CLOANCL*Extract*to*CLOANCX0*******************                       LUC109
      *  XX000008 - Daily CLOANCL Extract to CLOANCX0                 *                       LUC109
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
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109CC1          Date 12Sep19               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev Amend No. MUI009             Date 16Feb04               *
      *                 182380             Date 21Aug00               *
      *                 174481             Date 24Mar00               *
      *                 167337 (Reopen)    Date 11Feb00               *
      *                 167412             Date 19Nov99               *
      *                 167470             Date 18Nov99               *
      *                 167337             Date 10Nov99               *
      *                 167412             Date 25Oct99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043   *CREATE   DATE 16DEC98               *
      *                                    DATE                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109CC1 - Fix calculation of MDACM Dr Accrual Mth to Dte.  *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  182380 - Amend Error Fix 167470 to check for Amendment Type  *
      *           'RE' rather than 'RT'.
      *  174481 - Record with field C5385 (Amount of credit postings  *
      *           of the quarter) set to 0 while field C5446 (Number  *
      *           of credit posting of the quarter) is meaningful.    *
      *  167337 - Reopen. C0361 and C0362 still wrong and should have *
      *           outstanding balance for deal based transactions.    *
      *  167412 (2) Additional amendment: store WCPAM1 later in pgm   *
      *  167470 - Rec w/ fld C0053 (Last Entry Date) in the current   *
      *           qtr) while both flds C5383 (Amt of DR postings of   *
      *           the qtr) and C5385 (Amt of CR postings of the qtr)  *
      *           are set to 0.                                       *
      *  167337 - Quarterly max and min calculated incorrectly        *
      *  167412 - Change the way monthly averages are calculated:     *
      *           include non-working days and do not count days      *
      *           when transaction is inactive.                       *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FCLOANCL   IF   E           K DISK    INFSR(*PSSR)
     FLEFEED    IF   E           K DISK    INFSR(*PSSR)
     FXACTN5    IF   E           K DISK    INFSR(*PSSR)                         167470
     FCLOANCY0  UF A E           K DISK    INFSR(*PSSR)
     F***LEM008AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000008AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   07 - PF/XACTN5DK   File I/O                                 *   167470
      *   20 - PF/CLOANCL    File I/O                                 *
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
      *  #READ  - Read CLOANCL File                                   *
      *  #PROC  - Process CLOANCL Record                             *
      *  #CRTCX - Create CLOANCX0 Record                              *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D SVALKK          C                   CONST('HOR_NY_Amendments')                      LUC109CC1
      **  Data Structure for AOSVALR0 string                                               LUC109CC1
     DSVAL1            DS           200                                                    LUC109CC1
     DSVAL11                   1      1                                                    LUC109CC1
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
      *
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
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
      *
     IXACTN5DF                                                                  167470
     I              RECI                        RECI$1                          167470
     I              LNRF                        LNRF$1                          167470
     I              VDAT                        VDAT$1                          167470
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
      ** Data structure for subroutine ZCBDYS                                                 LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                         MUI009 LUC109
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
     C                   KFLD                    KYCNUM            6 0
     C                   KFLD                    KYFACL            5 0
     C                   KFLD                    KYLOAN            6 0
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
      ** All values are debit for this program.                           167412
     C     *LIKE         DEFINE    *INLR         DLCRED
     C                   MOVE      *OFF          DLCRED                                        16741
      *                                                                   167412
     C                   EXSR      AVINIT                                                      16741
      *
     C                   CALL      'AOSVALR0'                                              LUC109CC1
     C                   PARM                    @RTCD             7                       LUC109CC1
     C                   PARM      SVALKK        SVALK1           20                       LUC109CC1
     C                   PARM      *BLANKS       SVAL1           200                       LUC109CC1
     C                   PARM                    SVALK2           20                       LUC109CC1
     C                   PARM                    SVAL2           200                       LUC109CC1
     C                   PARM                    SVALK3           20                       LUC109CC1
     C                   PARM                    SVAL3           200                       LUC109CC1
     C                   PARM                    SVALK4           20                       LUC109CC1
     C                   PARM                    SVAL4           200                       LUC109CC1
     C                   PARM                    SVALK5           20                       LUC109CC1
     C                   PARM                    SVAL5           200                       LUC109CC1
     C                   PARM                    SVALK6           20                       LUC109CC1
     C                   PARM                    SVAL6           200                       LUC109CC1
     C                   PARM                    SVALK7           20                       LUC109CC1
     C                   PARM                    SVAL7           200                       LUC109CC1
     C                   PARM                    SVALK8           20                       LUC109CC1
     C                   PARM                    SVAL8           200                       LUC109CC1
     C                   PARM                    SVALK9           20                       LUC109CC1
     C                   PARM                    SVAL9           200                       LUC109CC1
     C                   PARM                    SVALK0           20                       LUC109CC1
     C                   PARM                    SVAL10          200                       LUC109CC1
      *                                                                                    LUC109CC1
      ** If Set to use NY Amendments                                                       LUC109CC1
     C     SVAL11        IFEQ      'Y'                                                     LUC109CC1
     C                   MOVE      'Y'           NY_Amend          1                       LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   MOVE      'N'           NY_AMend                                  LUC109CC1
     C                   ENDIF                                                             LUC109CC1
                                                                                           LUC109CC1
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
     C     RECI          IFEQ      'D'
     C                   EXSR      #PROC
     C                   ENDIF
      *
     C     RECI          IFEQ      'M'
     C     MDAT          IFGT      MPEMB
     C                   EXSR      #PROC
     C                   ELSE                                                                  16741
     C                   EXSR      #DELET                                                      16741
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
      ** Get amount for accumulation                                      167412
     C     CPAM          SUB       PSAM          WCPAM1           13 0                         16741
      *                                                                   167412
      *
      * DR Interest Rate MTD
      *
     C                   Z-ADD     0             CUMCRX                                        16741
     C                   Z-ADD     MDAVX         CUMDRX                                        16741
     C                   Z-ADD     INTR          XAMNT                                         16741
     C                   MOVE      DLCRED        WDRCR                                         16741
     C                   Z-ADD     MINTRX        XAMNTX                                        16741
     C                   MOVE      *OFF          WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMDR         MDAVX                                         16741
     C                   Z-ADD     AVEDR         MDAVR                                         16741
     C                   Z-ADD     INTR          MINTRX                                        16741
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MDAVX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C**************       ADD  INTR      MDAVX                           167412
      **************                                                      167412
      **DR*Interest*Rate Mthly Average                                    167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MDAVX     DIV  MMTDY     MDAVR                           167412
     C**************       ENDIF                                          167412
      *
      * Interest on DR Bals at end of previous mth
      *
      * ... first day of month processing only
     C     MFSTM         IFEQ      'Y'
     C                   ADD       MDACM         MDAPV
     C                   END
      *
      * Interest on DR Balances accrued this month
      *
     C                   IF        NY_Amend =  'N'                                         LUC109CC1
     C                   Z-ADD     AITC          WAMT
     C                   ADD       AIAP          WAMT
     C                   ADD       AIPD          WAMT
     C                   ELSE                                                              LUC109CC1
     C                   EVAL      WAMT = AIPD                                             LUC109CC1
      * ... discounted loans                                                               LUC109CC1
     C                   IF        PTYP=63 OR PTYP=65                                      LUC109CC1
     C                   EVAL      WAMT =  TOTI -AIPD                                      LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *
     C     WAMT          SUB       MDAPV         MDACM
      *
      * DR Accounting Balance MTD
      *
     C                   Z-ADD     0             CUMCRX                                        16741
     C                   Z-ADD     MDALX         CUMDRX                                        16741
     C                   Z-ADD     WCPAM1        XAMNT                                         16741
     C                   MOVE      DLCRED        WDRCR                                         16741
     C                   Z-ADD     MCPAMX        XAMNTX                                        16741
     C                   MOVE      *OFF          WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMDR         MDALX                                         16741
     C                   Z-ADD     AVEDR         MDALB                                         16741
     C*********************Z-ADDWCPAM1    MCPAMX                          167412
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MDALX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C***********CPAM      SUB  PSAM      WCPAM1 130                      167412
     C**************       ADD  WCPAM1    MDALX                           167412
      **************                                                      167412
      **DR*Accounting Balance Mthly Average                               167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MDALX     DIV  MMTDY     MDALB                           167412
     C**************       ENDIF                                          167412
      *
      * DR Available Balance MTD
      *
     C                   Z-ADD     MDACX         CUMDRX                                        16741
     C                   Z-ADD     WCPAM1        XAMNT                                         16741
     C                   MOVE      DLCRED        WDRCR                                         16741
     C                   Z-ADD     MCPAMX        XAMNTX                                        16741
     C                   MOVE      *OFF          WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMDR         MDACX                                         16741
     C                   Z-ADD     AVEDR         MDACB                                         16741
      *                                                                   167412
      * Store amount for next run.                                        167412
     C                   Z-ADD     WCPAM1        MCPAMX                                        16741
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MDACX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C***********CPAM      SUB  PSAM      WCPAM2 130                      167412
     C**************       ADD  WCPAM2    MDACX                           167412
      **************                                                      167412
      **DR*Available Balance Mthly Average                                167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MDACX     DIV  MMTDY     MDACB                           167412
     C**************       ENDIF                                          167412
      *
      * Total Interest until Maturity Date not yet paid
      *
      * ... ignore deals without a maturity date
     C     MDAT          IFNE      0
      * ... find total interest for deal
     C                   Z-ADD     WCPAM1        ZDLAMT
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
      * DR Interest Movements at end of last quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MQDIM         MQDIX
     C                   END
      *
      * DR Interest Movements this quarter
      *
     C     IPRD          SUB       MQDIX         MQDIM
      *
      * Quarterly Maximum DR Accounting Balance
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   Z-ADD     0             MQXAB
     C                   END
      * ... note that field is stored as -ve
     C                   Z-SUB     MQXAB         WAMT
     C     WCPAM1        IFGT      WAMT
     C                   Z-SUB     WCPAM1        MQXAB
     C                   ENDIF
      *
      * Quarterly Minimum DR Available Balance
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   Z-ADD     MQMAV         MPQMA
     C                   END
      *
     C*********************Z-ADDWCPAM1    MQMAV                           167337
     C***********          Z-SUBMQMAV     WAMT                     167337 167337
     C***********WCPAM1    IFLT WAMT                               167337 167337
     C                   Z-SUB     WCPAM1        MQMAV                                         16733
     C***********          ENDIF                                   167337 167337
      *
      * Quarterly Maximum DR Available Balance
      *
      * ... first day of quarter processing only                          167337
     C     MFSTQ         IFEQ      'Y'                                                         16733
     C                   Z-ADD     MQXAV         MPQXA                                         16733
     C                   END                                                                   16733
      *                                                                   167337
     C*********************Z-ADD0         MPQXA                           167337
     C*********************Z-ADD0         MQXAV                           167337
     C***********          Z-SUBMQXAV     WAMT                     167337 167337
     C***********WCPAM1    IFGT WAMT                               167337 167337
     C                   Z-SUB     WCPAM1        MQXAV                                         16733
     C***********          ENDIF                                   167337 167337
      *
      * Get Charges and Commission for this Loan.
      *
     C                   EXSR      #CHCM
      *
      * Charges/Commission DR at end of previous month.
      *
     C     MFSTM         IFEQ      'Y'
     C                   ADD       MDCGM         MDGPV
     C                   ADD       MDCMM         MDCPV
     C                   ENDIF
      *
      * Charges/Commission DR this month
      *
     C     WCHGS         SUB       MDGPV         MDCGM
     C     WCOMM         SUB       MDCPV         MDCMM
      *                                                                   167470
      * Accumulate Amt/No. of CR Postings this Quarter                    167470
      *                                                                   167470
     C     LNRF          CHAIN     XACTN5                             07                       16747
     C     *IN07         IFEQ      '0'                                                         16747
      *                                                                   167470
      * ... first day of quarter processing only                          167470
      *                                                                   167470
     C     MFSTQ         IFEQ      'Y'                                                         16747
     C                   Z-ADD     0             MACPQ                                         16747
     C                   Z-ADD     0             MNCPQ                                         16747
     C                   END                                                                   16747
      *                                                                   167470
     C***********AMTP      IFEQ 'RT'                                167470182380
     C     AMTP          IFEQ      'RE'                                                        18238
     C     PRAM          ANDNE     0                                                           17448
     C                   ADD       PRAM          MACPQ                                         16747
     C                   ADD       1             MNCPQ                                         16747
     C                   ENDIF                                                                 16747
      *                                                                   167470
     C     AMTP          IFEQ      'MA'                                                        16747
     C     PRAM          ANDNE     0                                                           17448
     C                   Z-ADD     PRAM          MACPQ                                         16747
     C                   ADD       1             MNCPQ                                         16747
     C                   ENDIF                                                                 16747
      *                                                                   167470
     C                   ENDIF                                                                 16747
      *
      * Update Record on CLOANCX0
      *
     C                   UPDATE    CLOANFX0
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
      *  #DELET -  Delete CLOANCX0 Record                             *   167412
      *                                                               *   167412
      *  Called By: #READ                                             *   167412
      *  Calls:                                                       *   167412
      *                                                               *   167412
      *****************************************************************   167412
      *                                                                   167412
     C     #DELET        BEGSR                                                                 16741
      *                                                                   167412
     C     LNRF          CHAIN     CLOANCY0                           20
     C  N20              DELETE    CLOANFX0                                                    16741
      *                                                                   167412
     C                   ENDSR                                                                 16741
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
     C                   MOVEL     'LEM008'      DBPGM                          Set program id
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
(c) Misys International Banking Systems Ltd. 2016
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
