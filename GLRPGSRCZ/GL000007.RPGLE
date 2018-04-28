     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Initialization Program for CFT044')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000007 - Midas GL Initialization Program for CFT044        *
      *                                                               *
      *  (C) Copyright Misys Banking Systems Limited 2010             *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CFT044  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CFT044 - Portuguese IBAN                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * GENIBAN - Generate IBAN by calling AOIBANR6                   *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *****************************************************************
      *
     FACCNTAB   UF   E             DISK    INFSR(*PSSR)
      **  Main account details
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * External DS for Branch Details
 
     DACNT             DS           491
     D #CNUM                   2      7
     D #CCY                    8     10
     D #ACOD                  11     20
     D #ACSQ                  21     22
     D #BRCA                  29     31
     D #ATYP                  32     32
     D #ACNO                 196    205
     D #IBAN                 455    488
     D #IBSQ                 489    491
      *
      ** Data structure for AOIBANR9
      *
 
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
 
     D @RUN            S              1
     D @RTCD           S              7
     D @OPTN           S              7
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C     1             SETLL     ACCNTAB
     C                   READ      ACCNTAB
     C                   DOW       NOT %EOF(ACCNTAB)
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    BRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     BRCA          DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Only process if account is a retail account
      *
     C                   IF        ATYP = 'R' AND RECI = 'D' AND
     C                             A8GENM = '5' AND IBAN = *BLANKS
 
     C                   MOVE      CNUM          #CNUM
     C                   MOVE      CCY           #CCY
     C                   MOVE      ACOD          #ACOD
     C                   MOVE      ACSQ          #ACSQ
     C                   MOVE      BRCA          #BRCA
     C                   MOVE      ATYP          #ATYP
     C                   MOVE      ACNO          #ACNO
     C                   MOVE      IBAN          #IBAN
     C                   MOVE      IBSEQN        #IBSQ
 
     C                   EXSR      GENIBAN
      *
     C                   MOVE      #IBAN         IBAN
 
     C                   UPDATE    ACCNTABF
 
     C                   ENDIF
 
     C                   READ      ACCNTAB
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GENIBAN - Generate IBAN by calling AOIBANR6                   *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     GENIBAN       BEGSR
 
     C                   CALL      'AOIBANR6'
     C                   PARM      *BLANKS       @RTCD
     C     ACNT          PARM      ACNT          DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     ACNT          DBKEY
     C                   MOVEL     'AOIBANR6'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
 
     C                   MOVE      'Y'           @RUN
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
