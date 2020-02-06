     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Issuing Date')
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVIDAT01 - Validate Issuing Date                            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
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
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Country Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D @RUN            S              1A
     D DDTINO          S             25A
     D*DDISDT          S              6A                                                      232543
     D DDISDT          S              8A                                                      232543
     D DDOKISDT        S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D WDaynoOut       S              5P 0
     D ErrorFlag       S              1A
     D WDateOut        S              8A                                                      232543
     D WDate1          S              4A                                                      232543
     D WDate2          S              6A                                                      232543
     D WDay            S              2A                                                      232543
     D WNDay           S              2S 0                                                    232543
     D WMonth          S              2A                                                      232543
     D WNMonth         S              2S 0                                                    232543
     D WYear           S              4A                                                      232543
     D WYrNum          S              4S 0                                                    232543
     D WNYear          S              2S 0                                                    232543
     D WCentury        S              2S 0                                                    232543
     D WrkYear         S              5S 0                                                    232543
     D WLeapYear       S              5S 0                                                    232543
     D WRemLeapY       S              1S 0                                                    232543
     D WDayMon         S              4A                                                      232543
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
     C                   EVAL      WDaynoOut = *Zeros
     C                   EVAL      DaynoOut = *Zeros
     C                   EVAL      ErrorFlag = *Blanks
     C                   EVAL      WDateOut = *Blanks                                    232543
 
      ** Validation
 
     C                   EXSR      SRVISDT
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKISDT = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVISDT - Validate Issuing Date                               *
      *                                                               *
      *****************************************************************
 
     C     SRVISDT       BEGSR
 
      ** If TIN is entered, Issuing Date is mandatory
 
     C                   IF        DDTINO <> *Blanks  AND
     C                             DDISDT =  *Blanks
     C                   EVAL      DDOKISDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4765'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Issuing Date should be numeric.
 
     C                   IF        DDISDT <> *Blanks
     C                   EVAL      WIdx = %Check('0123456789':DDISDT)
 
     C                   IF        WIdx <> 0
     C                   EVAL      DDOKISDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)
     C                   MOVEL     'USR4766'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Issuing Date must be in correct format
 
     C                   IF        DDISDT <> *Blanks
                                                                                              232543
      ** Split date into day, month and year; then convert to numeric                         232543
                                                                                              232543
     C                   MOVE      DDISDT        WDate1                                       232543
     C                   MOVEL     WDate1        WMonth                                       232543
     C                   MOVE      WDate1        WDay                                         232543
                                                                                              232543
     C                   MOVEL     DDISDT        WYear                                        232543
     C                   MOVEL     WYear         WCentury                                     232543
     C                   MOVE      WDay          WNDay                                        232543
     C                   MOVE      WMonth        WNMonth                                      232543
                                                                                              232543
     C                   IF        BJDFIN = 'M'                                               232543
     C                   MOVEL     WMonth        WDayMon                                      232543
     C                   MOVE      WDay          WDayMon                                      232543
     C                   ELSE                                                                 232543
     C                   MOVEL     WDay          WDayMon                                      232543
     C                   MOVE      WMonth        WDayMon                                      232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   MOVE      WYear         WNYear                                       232543
                                                                                              232543
     C                   MOVEL     WDayMon       WDate2                                       232543
     C                   MOVE      WNYear        WDate2                                       232543
                                                                                              232543
      ** Validate of values outside of range                                                  232543
                                                                                              232543
     C                   IF        WNDay   >  31  OR                                          232543
     C                             WNDay   <=  0  OR                                          232543
     C                             WNMonth >  12  OR                                          232543
     C                             WNMonth <=  0  OR                                          232543
     C                             WCentury < 19  OR                                          232543
     C                             WCentury > 20                                              232543
     C                   EVAL      DDOKISDT = 'N'                                             232543
     C                   ADD       1             Idx                                          232543
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)                               232543
als  C                   MOVEL     'USR4766'     MsgIDXAr(Idx)                                232543
     C                   GOTO      ENDVAL                                                     232543
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Validate day for 30-day month                                                        232543
                                                                                              232543
     C                   IF        WNMonth = 4  OR                                            232543
     C                             WNMonth = 6  OR                                            232543
     C                             WNMonth = 9  OR                                            232543
     C                             WNMonth = 11                                               232543
     C                   IF        WNDay > 30                                                 232543
     C                   EVAL      DDOKISDT = 'N'                                             232543
     C                   ADD       1             Idx                                          232543
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)                               232543
als  C                   MOVEL     'USR4766'     MsgIDXAr(Idx)                                232543
     C                   GOTO      ENDVAL                                                     232543
     C                   ENDIF                                                                232543
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Validate the leap year                                                               232543
                                                                                              232543
     C                   EVAL      WrkYear = WNYear + 28                                      232543
     C     WrkYear       DIV       4             WLeapYear                                    232543
     C                   MVR                     WRemLeapY                                    232543
                                                                                              232543
     C                   IF        WNMonth = 2                                                232543
     C                   IF        WRemLeapY >  0  AND                                        232543
     C                             WNDay     > 28  OR                                         232543
     C                             WRemLeapY =  0  AND                                        232543
     C                             WNDay     > 29                                             232543
     C                   EVAL      DDOKISDT = 'N'                                             232543
     C                   ADD       1             Idx                                          232543
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)                               232543
als  C                   MOVEL     'USR4766'     MsgIDXAr(Idx)                                232543
     C                   GOTO      ENDVAL                                                     232543
     C                   ENDIF                                                                232543
     C                   ENDIF                                                                232543
 
     C                   CALLB     'ZDATE1'
     C**********         PARM      DDISDT        DateIn                                       232543
     C                   PARM      WDate2        DateIn                                       232543
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DDOKISDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4766'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Issuing Date must be earlier than rundate
 
     C                   MOVE      WYear         WYrNum                                       232543
     C                   IF        WYrNum >= 1972                                             232543
     C                   IF        DDISDT <> *Blanks  AND
     C**********                   DaynoOut >= BJRDNB                                         232543
     C                             DaynoOut > BJRDNB                                          232543
     C                   EVAL      DDOKISDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDISDT'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4758'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF                                                                232543
 
     C                   EVAL      WDaynoOut = DaynoOut
     C                   EVAL      WDateOut =  DDISDT                                         232543
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Tax Identification Number
     C                   PARM                    DDTINO
 
      ** Issuing Date
     C                   PARM                    DDISDT
 
      ** OUTPUTS
      ** Issuing Date in Midas Day Number
     C**********         PARM                    WDaynoOut                                    232543
     C                   PARM                    WDateOut                                     232543
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Date - OK
     C                   PARM                    DDOKISDT
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2004
