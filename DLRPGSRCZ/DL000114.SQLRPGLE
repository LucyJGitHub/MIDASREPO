     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas DL Recompute Accrd Interest Adj for FLID = Y')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000114 - Recompute Accrued Interest Adjustment not Posted  *
      *             for Deals with First/Last Day Interest set to Y   *
      *                                                               *
      *  Function:  This program will be called after the ARR Calcu-  *
      *             lator Batch Processing. It will read all dealing  *
      *             transactions which uses a backward-looking rate.  *
      *             If the First/Last Day Interest is set to Y, it    *
      *             will recompute the deal's one day interest using  *
      *             the rate returned from the calculator.            *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058673  *CREATE  Date 10Sep21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058673 - Only benchmark rate is applied on deal on day1 of *
      *             its valuation. For deal with FLID = Y, recompute  *
      *             the one day interest using rate returned from the *
      *             calculator and saved it to AIAN fieldin DEALSDC.  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      * *INZSR        - Program Initialisation routine                *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************

      ** ARR Calculator Returned Rates Extract File
     FDLLIBEL0  IF   E           K DISK    INFSR(*PSSR)

      ** Deals File
     FMMDELULL  UF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDCF)
     F                                     PREFIX(DL_)
     F                                     COMMIT

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structure for Backward-Looking Rate
     D TransBLRT     E DS                  EXTNAME(SDBJEXPD)

      ** Constants declaration
     D NO_ERROR        C                   CONST(0)
     D NO_RECORD       C                   CONST(100)

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A

      ** Work Variables
     D WRUN            S              1A
     D WCOMPUTE        S              1A
     D WDLNO           S                   LIKE(DL_DLNO)
     D WINTR           S                   LIKE(DL_INTR)
     D WAIAN           S                   LIKE(DL_AIAN)
     D KDLNO           S                   LIKE(LDLNRF)
     D KVDAT           S                   LIKE(LDVDAT)
     D KINDT           S                   LIKE(LDINDT)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING

      ** Start commitment control
     C/exec SQL
     C+ set option COMMIT = *CHG
     C/end-exec

      ** Select dealing transactions with First/Last Day Interest = Y
     C/exec SQL
     C+ declare TransBLRTCursor insensitive scroll cursor for
     C+ select * from SDBJEXPD
     C+ where TRMODI = 'DL' and TRADDI = 'Y'
     C/end-exec

     C/exec SQL
     C+ open TransBLRTCursor
     C/end-exec

      ** Read next record
     C/exec SQL
     C+ fetch next from TransBLRTCursor into :TransBLRT
     C/end-exec

     C                   DOW       SQLCOD <> NO_RECORD

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access deal record in Main File
     C                   MOVEL     TRTRAN        WDLNO
     C     WDLNO         CHAIN     MMDELULL

     C                   IF        NOT %FOUND(MMDELULL)
     C                   EVAL      DBFILE = 'DEALSDC'
     C                   EVAL      DBKEY  = TRTRAN
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        %FOUND(MMDELULL)

      ** Determine the deal's rate at value date from the
      ** ARR Calculator Rate Etxract File
     C                   EVAL      WCOMPUTE = 'N'
     C                   EVAL      KDLNO = TRTRAN
     C                   EVAL      KVDAT = DL_VDAT
     C                   EVAL      KINDT = *HIVAL

      ** Get the last rate for calculation method CCR or SAVG
     C                   IF        TRCALM = 'CCR' or TRCALM = 'SAVG'
     C     KEY1          SETGT     DLLIBEL0
     C     KEY2          READPE    DLLIBEL0
     C                   IF        NOT %EOF(DLLIBEL0) and
     C                             LDVDAT = DL_VDAT
     C                   EVAL      WCOMPUTE = 'Y'
     C                   EVAL      WINTR = LDCART
     C                   ENDIF
     C                   ENDIF

      ** Get the rate for deal's value date for calc method NCCR or SARR
     C                   IF        TRCALM = 'NCCR' or TRCALM = 'SARR'
     C     KEY2          CHAIN     DLLIBEL0
     C                   IF        %FOUND(DLLIBEL0) and
     C                             LDVDAT = DL_VDAT
     C                   EVAL      WCOMPUTE = 'Y'
     C                   EVAL      WINTR = LDCART
     C                   ENDIF
     C                   ENDIF

     C                   IF        WCOMPUTE = 'Y'
     C                   EXSR      CAL1DY
     C                   EVAL      DL_AIAN = WAIAN
     C                   UPDATE    DEALSDCF
     C                   ENDIF

     C                   ENDIF

      ** Read next record
     C/exec SQL
     C+ fetch next from TransBLRTCursor into :TransBLRT
     C/end-exec
     C                   ENDDO

      ** Close cursor
     C/exec SQL
     C+ close TransBLRTCursor
     C/end-exec

      ** Commit Changes
     C                   COMMIT

      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN

      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * CAL1DY - Calculate Deal's One Day Interest                   *
      *                                                              *
     C****************************************************************
     C     CAL1DY        BEGSR

      ** START DATE = VALUE DATE, END DATE = MATURITY DATE
     C                   Z-ADD     DL_VDAT       @@BEG
     C                   Z-ADD     DL_MDAT       @@END

      ** PRINCIPAL, RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C     DL_PCPL       IFLT      *ZERO
     C                   Z-SUB     DL_PCPL       @@AMT            15 0
     C                   ELSE
     C                   Z-ADD     DL_PCPL       @@AMT            15 0
     C                   END
     C                   ADD       DL_RTSP       WINTR
     C                   Z-ADD     WINTR         @@RATE           11 7
     C                   MOVEL     DL_ICBS       @@CALC            1
     C                   MOVEL     DL_JRDFC      @@RDFC            1

      ** CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0

     C                   Z-SUB     @@INTR        WAIAN

      ** CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE + 1
     C                   ADD       1             @@END
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM                    @@INTR           15 0

     C                   ADD       @@INTR        WAIAN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'DL000114'

      ** Key Lists for ARR Calculator Returned Rates Extract File
     C     KEY1          KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KVDAT
     C                   KFLD                    KINDT

     C     KEY2          KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KVDAT

      ** Get the Bank details via access program
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
