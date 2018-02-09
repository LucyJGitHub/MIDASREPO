     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Validate Expiry Date')    *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVEXDT - SD Additional Customer Validate Expiry Date        *
      *                                                               *
      *  Function:  This module validates the Expiry Date on the      *
      *             new Additional Customer Details screen            *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVExDat - Validate Expiry Date                              *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for Country Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
      *
     D WRUN            S              1A
     D DDEXDT          S              8A
     D OKEXDT          S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D WDaynoOut       S              5P 0
     D ErrorFlag       S              1A
     D WDateOut        S              8A
     D WDate1          S              4A
     D WDate2          S              6A
     D WDay            S              2A
     D WNDay           S              2S 0
     D WMonth          S              2A
     D WNMonth         S              2S 0
     D WYear           S              4A
     D WYrNum          S              4S 0
     D WNYear          S              2S 0
     D WCentury        S              2S 0
     D WrkYear         S              5S 0
     D WLeapYear       S              5S 0
     D WRemLeapY       S              1S 0
     D WDayMon         S              4A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      WDaynoOut = *ZEROS
     C                   EVAL      DaynoOut = *ZEROS
     C                   EVAL      ErrorFlag = *BLANKS
     C                   EVAL      WDateOut = *BLANKS
      *
      ** Validate Expiry Date
      *
     C                   EXSR      SRVExDat
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKEXDT   = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVExDat - Validate Expiry Date                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVExDat      BEGSR
      *
      ** Expiry Date should be numeric
      *
     C                   IF        DDEXDT <> *BLANKS
     C                   EVAL      WIdx = %Check('0123456789':DDEXDT)
      *
     C                   IF        WIdx <> 0
      *
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Expiry Date must be in correct format
      *
     C                   IF        DDEXDT <> *Blanks
      *
      ** Split date into day, month and year; then convert to numeric
      *
     C                   MOVE      DDEXDT        WDate1
     C                   MOVEL     WDate1        WMonth
     C                   MOVE      WDate1        WDay
      *
     C                   MOVEL     DDEXDT        WYear
     C                   MOVEL     WYear         WCentury
     C                   MOVE      WDay          WNDay
     C                   MOVE      WMonth        WNMonth
      *
     C                   IF        BJDFIN = 'M'
      *
     C                   MOVEL     WMonth        WDayMon
     C                   MOVE      WDay          WDayMon
     C                   ELSE
     C                   MOVEL     WDay          WDayMon
     C                   MOVE      WMonth        WDayMon
      *
     C                   ENDIF
      *
     C                   MOVE      WYear         WNYear
      *
     C                   MOVEL     WDayMon       WDate2
     C                   MOVE      WNYear        WDate2
      *
      ** Validate of values outside of range
      *
     C                   IF        WNDay > 31  OR
     C                             WNDay <= 0  OR
     C                             WNMonth > 12 OR
     C                             WNMonth <= 0 OR
     C                             WCentury < 19 OR
     C                             WCentury > 20
      *
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'
     C                   LEAVESR
      *
     C                   ENDIF
      *
      ** Validate day for 30-day month
      *
     C                   IF        WNMonth = 4  OR
     C                             WNMonth = 6  OR
     C                             WNMonth = 9  OR
     C                             WNMonth = 11
      *
     C                   IF        WNDay > 30
      *
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate the leap year
      *
     C                   EVAL      WrkYear = WNYear + 28
     C     WrkYear       DIV       4             WLeapYear
     C                   MVR                     WRemLeapY
      *
     C                   IF        WNMonth = 2
      *
     C                   IF        WRemLeapY >  0  AND
     C                             WNDay > 28  OR
     C                             WRemLeapY =  0  AND
     C                             WNDay > 29
      *
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALLB     'ZDATE1'
      *
     C                   PARM      WDate2        DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
      *
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Expiry Date must be after the Rundate
      *
     C                   MOVE      WYear         WYrNum
     C                   IF        WYrNum >= 1972
      *
     C                   IF        DDEXDT <> *Blanks  AND
     C                             DaynoOut < BJRDNB
      *
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C                   EVAL      MsgIDXAr(Idx) = 'USR5919'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      WDaynoOut = DaynoOut
     C                   EVAL      WDateOut = DDEXDT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Expiry Date
      *
     C                   PARM                    DDEXDT
      *
      ** OUTPUTS
      *
      ** Expiry Date in Midas Day Number
      *
     C                   PARM                    WDaynoOut
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Expiry Date - OK
      *
     C                   PARM                    OKEXDT
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Program, module and procedure names for database error
      ** processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
