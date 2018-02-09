     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate Value Date')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVVDAT01 - Validate Value Date                              *
      *                                                               *
      *  Function:  This module checks the validity of the value      *
      *             date on an FF trade.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 23Mar01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Callb error                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error handling                                        *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Instrument types data structure
     D INTYP         E DS                  EXTNAME(INTYPD)
 
      ** Market centres data structure
     D MARKT         E DS                  EXTNAME(MARKTD) PREFIX(P)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Value date
     D SVALD           S              6A
 
      ** Trade date
     D STRSD           S              6A
 
      ** Market centre
     D SMRKT           S              2A
 
      ** Month
     D PMTHN           S              2S 0
 
      ** Year
     D PYRNO           S                   LIKE(PMTHN)
 
      ** Transaction date
     D PTRSD           S              5P 0
 
      ** Local currency code
     D BJLCCY          S              3A
 
      ** Value date
     D PVALD           S              5S 0
 
      ** Holiday flag
     D ZIND            S              1
 
      ** Work variable
     D WSETD           S              5S 0
 
      ** OK Flag for trade date
     D OKTRSD          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      *
      ** Reset Location Code and Holiday Indicator
      *
     C                   EVAL      ZLOC = *blanks
     C                   EVAL      ZIND = *blanks
      *
      ** IF Value Date is blank AND Trade Date is not in error,
      ** set equal to Trade Date + 2 working days for OTC
      ** or to Trade Date + 1 working Value Date for non-OTC
      *
     C     SVALD         IFEQ      *BLANK
     C     OKTRSD        ANDEQ     'Y'
     C                   Z-ADD     PTRSD         ZDAYNO
     C                   EVAL      ZCCY = ISCY
 
     C     ISTI          IFEQ      'Y'
     C                   Z-ADD     2             ZNRDYS
     C                   ELSE
     C                   Z-ADD     1             ZNRDYS
     C                   ENDIF
      *
      ** Calculate working days forward
      *
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO            5 0          Midas day number
     C                   PARM                    ZNRDYS            2 0          Nber of days forward
     C                   PARM                    ZDYNBR            5 0          Working day nber
     C                   PARM                    ZCCY              3            Currency
     C                   PARM                    ZLOC              3            Location
 
     C     *IN99         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      ZDYNBR        ZDAYNO
      *
      ** Convert Midas Date into DDMMYY
      *
     C                   CALLB     'ZDATE2'                             99
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN            1            Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
 
     C     *IN99         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      ZDATE         SVALD
     C                   Z-ADD     ZDAYNO        PVALD
 
     C                   ELSE
      *
      ** Validate Value Date Format
      *
     C                   CALLB     'ZDATE1'                             99
     C                   PARM                    SVALD
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       ErrorFlag         1
 
     C     *IN99         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Invalid format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0417'
     C                   MOVEL     'Error'       ReturnCode
     C                   MOVE      'N'           ErrorFlag
 
     C                   ELSE
 
     C                   Z-ADD     ZDAYNO        PVALD
      *
      ** Value Date must not be before Trade Date
      *
     C     PVALD         IFLT      PTRSD
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1172'
     C                   MOVEL     'Error'       ReturnCode
 
     C                   ELSE
 
     C     SMRKT         IFNE      *BLANK
     C                   MOVE      PMKLC         ZCCY
 
     C                   Z-ADD     PMTHN         FFMTH
     C                   Z-ADD     PYRNO         FFYR
     C                   MOVE      PMKLC         FFCCY1
     C                   MOVE      PMLOC         FFLOC
     C                   MOVE      ISCY          FFCCY2
     C                   MOVE      OTHC          FFCCY3
      *
      ** Calculate the Final Transaction Date
      *
     C                   CALLB     'FFDATE'                             99
     C                   PARM                    ReturnCode
     C                   PARM                    PDAY              5 0
     C                   PARM                    FTDF
     C                   PARM                    FFMTH             2 0
     C                   PARM                    FFYR              2 0
     C                   PARM                    FFCCY1            3
     C                   PARM                    FFLOC             3
     C                   PARM                    FFCCY2            3
     C                   PARM                    FFCCY3            3
     C                   PARM                    BJDFIN
 
     C     *IN99         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     PDAY          WSETD
 
     C                   ELSE
     C                   Z-ADD     FTDT          WSETD
     C                   MOVE      BJLCCY        ZCCY
 
     C                   ENDIF
      *
      ** Check if date is a holiday
      *
     C                   Z-ADD     PVALD         ZDAYNO
     C                   CALLB     'ZCHKH'                              99
     C                   PARM                    ZDAYNO                         Date Input
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location Code
     C                   PARM                    ZIND                           Holiday Indicator
 
     C     *IN99         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     ZIND          IFEQ      'H'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1166'
     C                   MOVEL     'Error'       ReturnCode
     C                   ENDIF
 
     C     ZIND          IFNE      'H'
     C     PVALD         ANDGT     WSETD
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1167'
     C                   MOVEL     'Error'       ReturnCode
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
 
      ** Value date (6A, from transaction)
     C                   PARM                    SVALD
 
      ** Trade date (6A, from transaction)
     C                   PARM                    STRSD
 
      ** Market centre  (2A, from transaction)
     C                   PARM                    SMRKT
 
      ** Month (2,0S, derived from transaction data)
     C                   PARM                    PMTHN
 
      ** Year (2,0S, derived from transaction data)
     C                   PARM                    PYRNO
 
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    PTRSD
 
      ** Instrument types format (DS, from INTYPD)
     C                   PARM                    INTYP
 
      ** Market centres format (DS, from MARKTD)
     C                   PARM                    MARKT
 
      ** Run date format (1A, from SDBANKPD)
     C                   PARM                    BJDFIN
 
      ** Local currency code (3A, from SDBANKPD)
     C                   PARM                    BJLCCY
 
      ** Midas OK flag for Trade Date
     C                   PARM                    OKTRSD
 
      ** Value date in Midas day number format (5,0P)
     C                   PARM                    PVALD
 
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      **--------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
