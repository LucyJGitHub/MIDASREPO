     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Bank Of England Extra A/C Data validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bank Of England                                      *
      *                                                               *
      *  BYAMADW0VL - Bank Of England Extra Customer Data validation  *
      *                                                               *
      *  Function:  This module  validates the fields entered via     *
      *             the front office, screen input and repair pgms.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. LLN022             Date 24Jan05               *
      *  Prev Amend No. LLN020             Date 15Jul02               *
      *                 LLN018  *CREATE    Date 17Apr01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  LLN020 - Upgrade BOE to Midas Release 4.                     *
      *           Rename fields to avoid conflict with CARS.          *
      *  LLN018 - Upgrade BoE to APIs and addition of 2 new fields    *
      *           on ICD.
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. SRSETUP -   Move fields to valid file                  *
      *     2. *PSSR   -   Database Error Handling                    *
      *     3. END     -   Leave program                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *---------------------------------------------------------------*
      *---------------------------------------------------------------*
      *****************************************************************
      *
      ** Files needed for field validation
      *
      *
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
     D @EI             S              1    DIM(11)
 
      *** Datastructure to define input parameter DATA
      /COPY QWINDSRC,GLAMADDTA
 
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs, Short data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs, Long data structure.
      *
 
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADX0)
 
      ** New Deal in Screen Format (#S)
     D NwAcScnFmt    E DS                  EXTNAME(GLAMEXPD)
     D                                     PREFIX(#S)
 
      ** Error indicators (OK#S)
     D OkFlags       E DS                  EXTNAME(GLEAMADX0)
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for Trade Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Trade Details
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for Trade Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  LLN022
      ** External ds for bank details                                                         LLN022
 
      **   Declared variables
      **   ==================
      **
 
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D TITLE           S              7
 
      ** Define *entry parameters
 
 
 
     D Idx             S              3P 0                                      Index error array
     D WIdx            S              3P 0                                      Index warning array
 
      ** parameter fields                                                                     LLN022
 
     D PRtCd           S              7                                                       LLN022
     D POptn           S              7                                                       LLN022
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1            Action Code
     C                   PARM                    DATA                           Data from deal
     C                   PARM                    NwAcScnFmt                     New deal screen form
     C                   PARM                    OKFlags                        Field OK Flags
     C                   PARM                    FldNameArr                     Errors fields
     C                   PARM                    MsgIDArr                         ""
     C                   PARM                    MsgDtaArr                        ""
     C                   PARM                    Idx                            Error array index
     C                   PARM                    WFldNamArr                     Warnings fields
     C                   PARM                    WMsgIDArr                        ""
     C                   PARM                    WMsgDtaArr                       ""
     C                   PARM                    WIdx                           Warning array index
     C                   PARM                    NwAcFilFmt                     New deal file format
      *
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
     C                   EXSR      INIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALIDATE THE SCREEN
      *****************************************************************
      *
     C                   MOVE      *BLANKS       VALID             1
      *
      *
      *----------------------------------------------------------------
      **  Validate Netting Indicator
      *
      * If entered, must be a UK resident.
     C     #SNETI        IFEQ      'Y'
     C     ULISOC        ANDNE     'GB'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SNETI'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'NETI'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0033'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    NETBALOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
      **    Valid values are 'Y' or 'N' OR BLANK
     C     #SNETI        IFNE      'Y'
     C     #SNETI        ANDNE     'N'
     C     #SNETI        ANDNE     ' '
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SNETI'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'NETI'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0032'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    NETBALOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Deposit Type if entered
 
     C     #SDPTP        IFNE      *BLANKS
 
      **   Entry only allowed for retail sterling accounts
     C**   ULATYP        IFNE      'R'                                          LLN020
     C**   ULCCY         ORNE      ULCYCD                                       LLN020
     C     BYATYP        IFNE      'R'                                          LLN020
     C     BYCCY         ORNE      ULCYCD                                       LLN020
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SDPTP'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'DPTP'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0035'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DEPTYPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
      **   Deposit type may be 'T' or 'S' or 'I'                          LLN013
     C     #SDPTP        IFNE      'T'
     C     #SDPTP        ANDNE     'S'
     C     #SDPTP        ANDNE     'I'                                      N013
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SDPTP'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'DPTP'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0034'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DEPTYPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate SAYE/Sharesave notice days if entered
      **   Entry only allowed if deposit type is 'S'
      *
     C     #SSNOD        IFNE      *BLANKS
     C     #SDPTP        ANDNE     'S'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SDPTP'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'SNOD'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0036'
     C                   EVAL      ReturnCode = 'Error'
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SHARNOTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
      **   Notice days must be in the range 0 - 999
     C**********         MOVE      #SSNOD        ULSNOD            3 0                        LLN022
     C                   EVALR     #SSNOD = %TRIM(#SSNOD)                                     LLN022
     C                   IF        %CHECK('0123456789':%TRIM(#SSNOD)) > 0                     LLN022
     C*****ULSNOD        IFLT      0                                                          LLN022
     C*****ULSNOD        ORGT      999                                                        LLN022
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SSNOD'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'SNOD'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0037'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SHARNOTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Loan type if entered
     C     #SLNTP        IFNE      *BLANKS
 
      **   Entry is not allowed if deposit type entry
     C     #SDPTP        IFNE      *BLANK
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SLNTP'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'LNTP'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0038'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LOANTYPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
      **   Loan type 3 is not allowed for non-retail accounts
     C     #SLNTP        IFEQ      '3'
     C***  ULATYP        ANDNE     'R'                                          LLN020
     C     BYATYP        ANDNE     'R'                                          LLN020
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SLNTP'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'LNTP'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0040'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LOANTYPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
      **   Valid loan type values: 1, 2, 3, 4, 5, 6, or 9
     C     #SLNTP        IFNE      '1'
     C     #SLNTP        ANDNE     '2'
     C     #SLNTP        ANDNE     '3'
     C     #SLNTP        ANDNE     '4'
     C     #SLNTP        ANDNE     '5'
     C     #SLNTP        ANDNE     '6'
     C     #SLNTP        ANDNE     '9'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SLNTP'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'LNTP'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0039'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LOANTYPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
     C                   ENDIF
 
 
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Loan maturity date if entered
     C     #SMDAT        IFNE      *BLANKS
 
      *  Must be a valid date format DDMMYY or MMDDYY
     C                   MOVEL     #SMDAT        ZDATEA            6
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
     C     ErrorFlag     IFEQ      'Y'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SMDAT'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'MDAT'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0041'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LOANMATOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ELSE
     C                   Z-ADD     ZDAYNO        ULDAYNO           5 0
     C                   ENDIF
     C                   ENDIF
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Loan Limit if entered
     C     #SLLIM        IFNE      *BLANKS
 
      **   Validate using ZALIGN
     C                   MOVEL(P)  #SLLIM        ZFIELD           16
     C                   MOVE      0             ZADEC             1 0
     C                   MOVE      13            ZADIG             2 0
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZRTN              1
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C     ZRTN          IFNE      'Y'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SLLIM'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'LLIM'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0042'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LOANLIMOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ELSE
 
     C                   MOVE      ZFIELD        ULLLIM           16
     C                   ENDIF
     C                   ENDIF
      *----------------------------------------------------------------
      *----------------------------------------------------------------
     C                   IF        Idx = 0
     C                   EXSR      SRSETUP
     C                   ENDIF
      *
 
     C                   EXSR      END
 
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUP - Set up fields that are needed on the Valid file     *
      *           record.                                             *
      *                                                               *
      *****************************************************************
     C     SRSETUP       BEGSR
      *
     C***                MOVE      ULBRCD        LVBRCD                         LLN020
     C***                MOVE      ULCNUM        LVCNUM                         LLN020
     C***                MOVE      ULCCY         LVCCY                          LLN020
     C***                MOVE      ULACOD        LVACOD                         LLN020
     C***                MOVE      ULACSQ        LVACSQ                         LLN020
     C                   MOVE      BYBRCD        LVBRCD                         LLN020
     C                   MOVE      BYCNUM        LVCNUM                         LLN020
     C                   MOVE      BYCCY         LVCCY                          LLN020
     C                   MOVE      BYACOD        LVACOD                         LLN020
     C                   MOVE      BYACSQ        LVACSQ                         LLN020
     C                   MOVE      #SNETI        LVNETI
     C                   MOVE      #SDPTP        LVDPTP
     C                   MOVE      #SSNOD        LVSNOD
     C                   MOVE      #SLNTP        LVLNTP
     C                   MOVE      ULDAYNO       LVMDAT
     C                   MOVE      ULLLIM        LVLLIM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT  - Initial Sub Routine.                                  *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ** *PSSR SR **
      *
      **  Get sterling currency code
     C                   CALL      'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     01            DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVE      'SDTRADPD'    DBFILE
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   EXSR      *PSSR
     C                   END
     C                   MOVEL     BLCYCD        ULCYCD            3
 
      ** Get customer details
     C***                MOVE(P)   ULCNUM        @CNUM                          LLN020
     C                   MOVE(P)   BYCNUM        @CNUM                          LLN020
     C                   CALL      'AOCUSTR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CNUM            10
     C                   PARM      *BLANK        @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get ISO code of country of location
     C                   MOVE      BBCOLC        @CNCD             2
     C                   CALL      'AOCTRYR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         MOVE      A4ISOC        ULISOC            2                          LLN022
     C                   MOVE      BBCOLC        ULISOC            2                          LLN022
 
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
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END   - End Program, no errors                               *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR                                                              **
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT                                                                                  LLN022
      *****************************************************************                       LLN022
      * *INZSR - INITIAL PROCESSING                                   *                       LLN022
      *****************************************************************                       LLN022
     C     *INZSR        BEGSR                                                                LLN022
      *                                                                                       LLN022
      ** Access Bank Details                                                                  LLN022
      *                                                                                       LLN022
     C                   CALL      'AOBANKR0'                                                 LLN022
     C                   PARM      *Blanks       PRtcd                                        LLN022
     C                   PARM      '*FIRST  '    POptn                                        LLN022
     C     SDBANK        PARM      SDBANK        DSFDY                                        LLN022
      *                                                                                       LLN022
      * Database Error                                                                        LLN022
      *                                                                                       LLN022
     C                   IF        PRtcd <> *Blanks                                           LLN022
     C                   EVAL      DBKEY = POptn                                              LLN022
     C                   EVAL      DBFILE = 'SDBANKPD'                                        LLN022
     C                   EVAL      DBASE = 900                                                LLN022
     C                   EXSR      *PSSR                                                      LLN022
     C                   ENDIF                                                                LLN022
                                                                                              LLN022
     C                   ENDSR                                                                LLN022
      *                                                                                       LLN022
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
