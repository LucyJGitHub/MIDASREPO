     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account BOE Conversion')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADCVT1- GL Account BOE Conversion: File to Screen        *
      *                                                               *
      *  Function:  This module convert the details of the extension  *
      *             file BYACCTX0 to screen format.                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D AcctExFilFmt  E DS                  EXTNAME(BYACCTX0)
      ** Account Details File Extension
 
     D AcctExScnFmt  E DS                  EXTNAME(GLAMEXPD)
      ** Account Details Screen Extension
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External ds for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First ds for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
 
     D PRetCodeIn      S             10
     D PCust           S              6
     D PCurcy          S              3
     D PAcctCde        S             10
     D PAcctSeq        S              2
     D PBranch         S              3
     D PRtCd           S              7
     D POptn           S              7
     D PZField         S             16
     D PZADec          S              1  0
     D PZDayNo         S              5  0
     D PZDate          S              6  0
     D PZADate         S              7
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialization
      *
     C                   EXSR      SRINIT
      *
      ** Set screen fields
      *
     C                   EXSR      SRSETFLD
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSETFLD - Set screen fields
      *****************************************************************
     C     SRSETFLD      BEGSR
      *
      ** nettable balance
      *
     C                   EVAL      NETI   = LNETI
      *
      ** deposite type
      *
     C                   EVAL      DPTP   = LDPTP
      *
      ** loan type
      *
     C                   EVAL      LNTP   = LLNTP
      *
      ** SAYE/sharesave notice days
      *
     C                   IF        LSNOD = *Zeros
     C                   EVAL      SNOD  = *Blanks
     C                   ELSE
     C                   EVAL      SNOD = %TRIM(%EDITC(LSNOD:'Z'))
     C                   ENDIF
      *
      ** loan maturity date
      *
     C                   IF        LMDAT  = *Zeros
     C                   EVAL      MDAT   = *Blanks
     C                   ELSE
     C                   EVAL      PZDayNo = LMDAT
     C                   EXSR      ZDATE2
     C                   MOVE      PZDate        MDAT
     C                   ENDIF
      *
      ** loan limit
      *
     C                   IF        LLLIM = *Zeros
     C                   EVAL      LLIM  = *Blanks
     C                   ELSE
     C                   EVAL      PZField = *Blanks
     C                   MOVE      LLLIM         PZField
     C                   EXSR      ZEDIT
     C                   MOVE      PZField       LLIM
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Format a date for output                             *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate
     C                   PARM                    PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZEDIT - Edit an unsigned field                                *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM      0             PZADec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Initialization
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C                   CLEAR                   AcctExScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return code
      *
     C                   PARM                    PRetCodeIn
      *
      ** Customer
      *
     C                   PARM                    PCust
      *
      ** Currency
      *
     C                   PARM                    PCurcy
      *
      ** Account Code
      *
     C                   PARM                    PAcctCde
      *
      ** Account Sequence
      *
     C                   PARM                    PAcctSeq
      *
      ** Branch
      *
     C                   PARM                    PBranch
      *
      ** BYACCTX0 Extension File Format
      *
     C                   PARM                    AcctExFilFmt
      *
      ** GLAMEXPD Extension Screen Format
      *
     C                   PARM                    AcctExScnFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'GLAMADCVT1'
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
