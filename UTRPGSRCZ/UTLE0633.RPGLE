     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
     H FIXNBR(*NOINPUTPACKED)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Triggers recalculation for Facility History')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/UTLE0633 - Program to patch Facility History file      *
      *                                                               *
      *  Function:  This program updates files FACHISA, FACHISH and   *
      *             FACACT. This program runs in two modes according  *
      *             to the parameter being passed into it.            *
      *                                                               *
      *                1. Audit ('A') - passed when checking the      *
      *                      total number of facilities to be         *
      *                      triggered for recalculation.             *
      *                2. Update('U') - passed when updating records  *
      *                      in FACHISA, FACHISH and FACACT.          *
      *                                                               *
      *  Called By: UTCLE0633 - CL program                            *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR806351 *CREATE   Date 03Oct16               *
      *                 XXXXXXXX           Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      *  MD046248 - Finastra Rebranding                               *
      *  AR806351 - PDCLs with type Y/Z and FAMU = N have records in  *
      *             FACHISA. Delete invalid records in file and tag   *
      *             facility for recalculation. (Child: AR806352)     *
      *            - rerun for MD-22057                               *
      *            - additional changes includes removing of PDCL     *
      *              interest repayments                              *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FUTLE0633PDIF   E           K DISK    INFSR(*PSSR)
     FFCLTY1    IF   E           K DISK    INFSR(*PSSR)
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(C1_)
     FMLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:MCLONCLF)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(M1_)
     FHISTR     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(HISTSHMF:HISTSHQF)
     F                                     PREFIX(HP_)
     FMHISR     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(HISTSHPF:MHISTHPF)
     F                                     IGNORE(HISTSHMF:HISTSHQF)
     F                                     PREFIX(MP_)
     FFACHISHL  UF   E           K DISK    INFSR(*PSSR)
     FFACACT    UF A E           K DISK    INFSR(*PSSR)
     FLEHISFL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHIS1F)
     F                                     IGNORE(HISACTF)
     F                                     PREFIX(F1_)
     FHISUPD    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHIS2F)
     F                                     IGNORE(HISACTF)
     F                                     PREFIX(F2_)
     FUTLE0633P2O    E             PRINTER OFLIND(*IN89)
     FUTLE0633P1O    E             PRINTER OFLIND(*IN84)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *   12 -  No Details to Report                                  *
      *   16 -  Update mode                                           *
      *   71 -  Read to HISTR                                         *
      *   72 -  Read to MHISR                                         *
      *   80 -  EOF in FCLTY1                                         *
      *   82 -  Chain to Matured Loan's file 'A' record               *
      *   83 -  EOF in UTLE0633PD                                     *
      *   85 -  EOF in LEHISFL0                                       *
      *   86 -  Chain to facility history header                      *
      *   87 -  Chain to Loan's file 'A' record                       *
      *   88 -  Read to HISUPD                                        *
      *   84 -  Overflow UTLE0633P1                                   *
      *   89 -  Overflow UTLE0633P2                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * InzSR  - Initialization subroutine                            *
      * SRDEC  - Determine decimal places per currency                *
      * SRDISP - Format amounts to be displayed                       *
      * SRFDAT - Format date                                          *
      * ChkPrinInt - Check PDCL principal/interest related payments   *
      * *PSSR  - Error processing                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Rundate data structure.
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data structure for Currency details.
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** General Ledger Details.
 
     D DSGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Bank Details.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Access Program.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** ZDate2 parameters
 
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ARRX            S              5    DIM(9999)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D RecDelete       S              1A   INZ(*blanks)
     D HPRecFound      S              1A   INZ(*blanks)
     D WFAMU           S              1A   INZ(*blanks)
     D WLTYP           S              1A   INZ(*blanks)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   WRITE     HEADER1
     C                   WRITE     HEADER2
      *
      ** Check all LIVE facilities.
      *
     C                   READ      FCLTY1                                 80
      *
     C                   DOW       *IN80 = '0'
      *
     C                   IF        RECI = 'D'
     C                   ADD       1             FACAUD
     C                   MOVE      BRCA          HBRCA             3
     C                   MOVE      'A'           WRCDT             1
     C                   MOVEL     FACT          WFACT             5 0
     C                   MOVE      FCNO          WFACT
      *
      ** Check all facility loan records in history file.
      *
     C     KEY001        SETLL     FACHISAF
     C     KEY001        READE     FACHISAF                               83
      *
     C                   DOW       *IN83 = '0'
      *
      ** Select records with the following criteria:
      ** a. FALOAN should exist on CLOANCL or MCLONCL
      ** b. Processing types could only be 61, 68 or 62?
      ** c. FADATE should be greater than or equal to loan's
      **    start date to avoid selecting a reused loan number
      ** d. Facility reference should match
      *
     C     KEY003        CHAIN     CLOANC                             87
      *
     C                   IF        *IN87 = '0' and
     C                             %SUBST(C1_LTYP:1:1) <> 'X' and
     C                             %SUBST(C1_LTYP:1:1) <> 'Y' and
     C                             %SUBST(C1_LTYP:1:1) <> 'Z'
     C                             OR *IN87 = '0' and
     C                             C1_PTYP <> 61 and C1_PTYP <> 62
     C                             and C1_PTYP <> 68
     C                             OR *IN87 = '0' and
     C                             FADATE < C1_VDAT
     C                             OR *IN87 = '0' and (CNUM <> C1_FCUS or
     C                             FACT <> C1_FTYP or FCNO <> C1_FSEQ)
     C     KEY001        READE     FACHISAF                               83
     C                   ITER
     C                   ENDIF
      *
      ** If loan not found on CLOANCL, check on MCLONCL.
      *
     C                   IF        *IN87 = '1'
     C     KEY003        CHAIN     MLOAN                              82
      *
     C                   IF        *IN82 = '0' and
     C                             %SUBST(M1_LTYP:1:1) <> 'X' and
     C                             %SUBST(M1_LTYP:1:1) <> 'Y' and
     C                             %SUBST(M1_LTYP:1:1) <> 'Z'
     C                             OR *IN87 = '0' and
     C                             M1_PTYP <> 61 and M1_PTYP <> 62
     C                             and M1_PTYP <> 68
     C                             OR *IN82 = '0' and
     C                             FADATE < M1_VDAT
     C                             OR *IN87 = '0' and (CNUM <> M1_FCUS or
     C                             FACT <> M1_FTYP or FCNO <> M1_FSEQ)
     C                             OR *IN82 = '1'
     C     KEY001        READE     FACHISAF                               83
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        *IN87 = '0'
     C                   EVAL      WFAMU = C1_FAMU
     C                   EVAL      WLTYP =  %SUBST(C1_LTYP:1:1)
     C                   ELSE
     C                   EVAL      WFAMU = M1_FAMU
     C                   EVAL      WLTYP =  %SUBST(M1_LTYP:1:1)
     C                   ENDIF
      *
      ** Check that it is a valid record:
      ** a. if it is an interest payment for PDCL(X-Y-Z) then delete
      ** b. if it is a record for PDCL-Y or PDCL-Z with
      **    FAMU = 'N' or ' ' then delete
      *
     C                   EVAL      RecDelete = ' '
     C                   SELECT
     C                   WHEN      (WFAMU = 'N' or WFAMU = ' ') and
     C                             (WLTYP = 'Y' or WLTYP = 'Z')
     C                   EVAL      RecDelete = 'Y'
      *
     C                   WHEN      FAACTN <> 'RE' and FAACTN <> 'MT'
     C     KEY001        READE     FACHISAF                               83
     C                   ITER
      *
     C                   OTHER
     C                   EXSR      ChkPrinInt
     C                   ENDSL
      *
     C                   IF        RecDelete = 'Y'
      *
      ** Setup report details.
      *
     C                   EVAL      WFACER = 'ERROR'
     C                   ADD       1             WRECER
     C                   Z-ADD     FAAAMT        WAMTF            13 0
     C                   MOVE      FAACTN        WACTN             2
     C
      *
      ** Retrieve the record for deletion.
      *
     C                   IF        *IN16 = '1'
     C     KEY002        SETGT     FACHIS1F
     C     KEY002        READPE    FACHIS1F                               85
     C                   DOW       *IN85 = '0'
     C                   IF        F1_FAACTN = WACTN
     C                             and F1_FAAAMT = WAMTF
     C                             and F1_FAGNDT = FAGNDT
     C                             and F1_FATSEQ = FATSEQ
     C                   DELETE    FACHIS1F
     C                   LEAVE
     C                   ENDIF
     C     KEY002        READPE    FACHIS1F                               85
     C                   ENDDO
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      *IN87 = '0'
     C                   IF        C1_FAMU = 'N' or C1_FAMU = ' '
     C                   EVAL      WFLAG = 'NO '
     C                   ELSE
     C                   EVAL      WFLAG = 'ERR'
     C                   ENDIF
     C                   EVAL      WKLTYP = C1_LTYP
     C                   EVAL      WKSUTP = C1_SUTP
      *
     C                   WHEN      *IN82 = '0'
     C                   IF        M1_FAMU = 'N' or M1_FAMU = ' '
     C                   EVAL      WFLAG = 'NO '
     C                   ELSE
     C                   EVAL      WFLAG = 'ERR'
     C                   ENDIF
     C                   EVAL      WKLTYP = M1_LTYP
     C                   EVAL      WKSUTP = M1_SUTP
     C                   ENDSL
      *
     C                   EVAL      ZDAYNO = FADATE
     C                   EXSR      SRFDAT
     C                   EVAL      VDATE = ZADATE
      *
     C                   IF        FALUCY = *BLANKS
     C                   EVAL      VLCCY = FCCY
     C                   ELSE
     C                   EVAL      VLCCY = FALUCY
     C                   ENDIF
      *
     C                   EXSR      SRDEC
     C                   EXSR      SRDISP
      *
     C                   IF        *IN84 = '1'
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   EVAL      *IN84 = '0'
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
      *
      ** Update FACHISH and FACACT to recalculate facility on COB.
      *
     C                   IF        *IN16 = '1'
      *
     C     KEY004        CHAIN     FACHISHF                           86
      *
     C                   IF        *IN86 = '0'
     C                   EVAL      FHRWKR = 'Y'
     C     KEY001        SETLL     FACHIS2F
     C                   READ      FACHIS2F                               88
     C                   EVAL      FHRWDT = F2_FADATE
     C                   EVAL      FHRWTP = 'M'
     C                   UPDATE    FACHISHF
      *
     C     KEY001        CHAIN     FACACTF                            86
      *
     C                   IF        *IN86 = '1'
     C                   EVAL      BRCA = HBRCA
     C                   EVAL      FCCNUM = F2_FACNUM
     C                   EVAL      FCFCTY = F2_FAFCTY
     C                   EVAL      FCDATE = F2_FADATE
     C                   WRITE     FACACTF
     C                   ELSE
     C                   EVAL      FCDATE = F2_FADATE
     C                   UPDATE    FACACTF
     C                   ENDIF
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVE      WFACT         WWFACT            5
     C                   EVAL      DBFILE = 'FACHISH'
     C                   EVAL      DBKEY = HBRCA + CNUM + WWFACT
     C                   EVAL      DBPGM = 'UTLE0633'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   IF        *IN84 = '1'
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   EVAL      *IN84 = '0'
     C                   ENDIF
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     KEY001        READE     FACHISAF                               83
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Accumulate facilities in error.
      *
     C                   IF        WFACER = 'ERROR'
     C                   ADD       1             FACERR
     C                   EVAL      WFACER = *BLANKS
      *
     C                   IF        *IN89 = '1'
     C                   ADD       1             PAGENO
     C                   WRITE     HEADER2
     C                   EVAL      *IN89 = '0'
     C                   ENDIF
      *
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C                   READ      FCLTY1                                 80
     C                   ENDDO
      *
      ** Write Footer.
      *
     C                   IF        FACERR = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   WRITE     TRAILER1
     C                   WRITE     TRAILER2
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkPrinInt - Check if record read is an interest payment      *
      *              or principal payment but no HISTSHP/MHISTHP      *
      *              counterpart.                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ChkPrinInt    BEGSR
      *
     C                   EVAL      HPRecFound = ' '
     C     KEY005        SETLL     HISTR
     C     KEY005        READE     HISTR                                  71
      *
     C                   DOW       *IN71 = '0'
     C                   IF        HP_AMTP = 'RE' or HP_AMTP = 'IN'
     C                             or HP_AMTP = 'MR' or HP_AMTP = 'MA'
     C                   IF        (HP_LCD = FAGNDT and FALUAM <> 0 and
     C                             HP_INTA = FALUAM and HP_INTA <> 0) or
     C                             (HP_LCD = FAGNDT and FAAAMT <> 0 and
     C                             HP_INTA = FAAAMT and HP_INTA <> 0) or
     C                             (HP_LCD = FAGNDT and FALUAM <> 0 and
     C                             HP_PRAM = FALUAM and HP_PRAM <> 0) or
     C                             (HP_LCD = FAGNDT and FAAAMT <> 0 and
     C                             HP_PRAM = FAAAMT and HP_PRAM <> 0)
     C                   EVAL      HPRecFound = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C     KEY005        READE     HISTR                                  71
     C                   ENDDO
      *
     C                   IF        HPRecFound = ' '
     C     KEY006        SETLL     MHISR
     C     KEY006        READE     MHISR                                  72
      *
     C                   DOW       *IN72 = '0'
     C                   IF        MP_AMTP = 'RE' or MP_AMTP = 'IN'
     C                             or MP_AMTP = 'MR' or MP_AMTP = 'MA'
     C                   IF        (MP_LCD = FAGNDT and FALUAM <> 0 and
     C                             MP_INTA = FALUAM and MP_INTA <> 0) or
     C                             (MP_LCD = FAGNDT and FAAAMT <> 0 and
     C                             MP_INTA = FAAAMT and MP_INTA <> 0) or
     C                             (MP_LCD = FAGNDT and FALUAM <> 0 and
     C                             MP_PRAM = FALUAM and MP_PRAM <> 0) or
     C                             (MP_LCD = FAGNDT and FAAAMT <> 0 and
     C                             MP_PRAM = FAAAMT and MP_PRAM <> 0)
     C                   EVAL      HPRecFound = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C     KEY006        READE     MHISR                                  72
     C                   ENDDO
     C                   ENDIF
      *
     C                   IF        HPRecFound = ' '
     C                   EVAL      RecDelete = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEC - Retrieve decimal place                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDEC         BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      VLCCY         PK101             3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = VLCCY
     C                   EVAL      DBPGM = 'UTLE0633'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEA     '0000'        *IN(60)
      *
     C                   IF        A6NBDP = 0
     C                   MOVE      '1'           *IN60
     C                   ENDIF
     C                   IF        A6NBDP = 1
     C                   MOVE      '1'           *IN61
     C                   ENDIF
     C                   IF        A6NBDP = 2
     C                   MOVE      '1'           *IN62
     C                   ENDIF
     C                   IF        A6NBDP = 3
     C                   MOVE      '1'           *IN63
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDISP - Display amount according to decimal place            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDISP        BEGSR
      *
     C                   IF        *IN60 = '1'
     C                   MOVE      WAMTF         VAAMT0
     C                   ENDIF
     C                   IF        *IN61 = '1'
     C                   MOVE      WAMTF         VAAMT1
     C                   ENDIF
     C                   IF        *IN62 = '1'
     C                   MOVE      WAMTF         VAAMT2
     C                   ENDIF
     C                   IF        *IN63 = '1'
     C                   MOVE      WAMTF         VAAMT3
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFDAT - Format Date                                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFDAT        BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *InzSR        BEGSR
      *
      ** Parameter Entry List.
      *
     C     *Entry        PLIST
     C                   PARM                    Mode              1
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check mode is AUDIT or UPDATE.
      *
     C                   IF        Mode = 'U'
     C                             OR Mode = 'u'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
      *
     C     KEY001        KLIST
     C                   KFLD                    HBRCA
     C                   KFLD                    CNUM
     C                   KFLD                    WFACT
      *
     C     KEY002        KLIST
     C                   KFLD                    HBRCA
     C                   KFLD                    CNUM
     C                   KFLD                    WFACT
     C                   KFLD                    FALOAN
     C                   KFLD                    FADATE
      *
     C     KEY003        KLIST
     C                   KFLD                    FALOAN
     C                   KFLD                    WRCDT
      *
     C     KEY004        KLIST
     C                   KFLD                    HBRCA
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
     C     KEY005        KLIST
     C                   KFLD                    C1_BRCA
     C                   KFLD                    C1_CNUM
     C                   KFLD                    C1_LNRF
     C                   KFLD                    FADATE
      *
     C     KEY006        KLIST
     C                   KFLD                    M1_BRCA
     C                   KFLD                    M1_CNUM
     C                   KFLD                    M1_LNRF
     C                   KFLD                    FADATE
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             PAGE              2 0
     C                   Z-ADD     0             PAGENO            2 0
     C                   Z-ADD     0             FACAUD            7 0
     C                   Z-ADD     0             FACERR            7 0
     C                   Z-ADD     0             WRECER            7 0
     C                   MOVE      *BLANKS       WFACER            5
     C                   MOVE      *BLANKS       WFLAG             3
     C                   MOVE      *BLANKS       WKLTYP            2
     C                   MOVE      *BLANKS       WKSUTP            2
     C                   MOVE      *BLANKS       VLCCY             3
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN                                *************
     C                   EVAL      DBPGM = 'UTLE0633'                           * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2016
