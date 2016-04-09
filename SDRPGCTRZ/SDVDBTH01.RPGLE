     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Date of Birth')
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVDBTH01 - Validate Date of Birth                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *  Prev Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     D DDDBTH          S              8A
     D DDOKDATE        S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
     D WDate1          S              4A
     D WDate2          S              6A
     D WDay            S              2A
     D WNDay           S              2S 0
     D WMonth          S              2A
     D WNMonth         S              2S 0
     D WYear           S              4A
     D WNYear          S              2S 0
     D WCentury        S              2S 0
     D WrkYear         S              5S 0
     D WLeapYear       S              5S 0
     D WRemLeapY       S              1S 0
     D WDayMon         S              4A
 
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
 
      ** Validation
 
     C                   EXSR      SRVDATE
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKDATE = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVDATE - Validate Date of Birth                              *
      *                                                               *
      *****************************************************************
 
     C     SRVDATE       BEGSR
 
      ** Date of Birth should be numeric.
 
     C                   IF        DDDBTH <> *Blanks
     C                   EVAL      WIdx = %Check('0123456789':DDDBTH)
 
     C                   IF        WIdx <> 0
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
     C                   MOVEL     'USR4771'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate only if entered
 
     C                   IF        DDDBTH <> *Blanks
 
      ** Split date into day, month and year; then convert to numeric
 
     C                   MOVE      DDDBTH        WDate1
     C                   MOVEL     WDate1        WMonth
     C                   MOVE      WDate1        WDay
 
     C                   MOVEL     DDDBTH        WYear
     C                   MOVEL     WYear         WCentury
     C                   MOVE      WDay          WNDay
     C                   MOVE      WMonth        WNMonth
 
     C                   IF        BJDFIN = 'M'
     C                   MOVEL     WMonth        WDayMon
     C                   MOVE      WDay          WDayMon
     C                   ELSE
     C                   MOVEL     WDay          WDayMon
     C                   MOVE      WMonth        WDayMon
     C                   ENDIF
 
     C                   MOVE      WYear         WNYear
 
     C                   MOVEL     WDayMon       WDate2
     C                   MOVE      WNYear        WDate2
 
      ** Validate of values outside of range
 
     C                   IF        WNDay   >  31  OR
     C                             WNDay   <=  0  OR
     C                             WNMonth >  12  OR
     C                             WNMonth <=  0  OR
     C                             WCentury < 19  OR
     C                             WCentury > 20
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4771'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Validate day for 30-day month
 
     C                   IF        WNMonth = 4  OR
     C                             WNMonth = 6  OR
     C                             WNMonth = 9  OR
     C                             WNMonth = 11
     C                   IF        WNDay > 30
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4771'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Validate the leap year
 
     C                   EVAL      WrkYear = WNYear + 28
     C     WrkYear       DIV       4             WLeapYear
     C                   MVR                     WRemLeapY
 
     C                   IF        WNMonth = 2
     C                   IF        WRemLeapY >  0  AND
     C                             WNDay     > 28  OR
     C                             WRemLeapY =  0  AND
     C                             WNDay     > 29
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4771'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Date of Birth using ZDATE if within Midas day format
 
     C                   IF        WYear >= '1972' and
     C                             WYear <= '2071'
 
     C                   CALLB     'ZDATE1'
     C                   PARM      WDate2        DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4771'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ***Birth*of*Date must be earlier than rundate                                           232543
      ** Birth Date must be earlier than or equal to rundate                                  232543
 
     C**********         IF        DaynoOut >= BJRDNB                                         232543
     C                   IF        DaynoOut > BJRDNB                                          232543
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4772'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WYear > '2071'
     C                   EVAL      DDOKDATE = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4771'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
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
      ** Date of Birth
     C                   PARM                    DDDBTH
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Date of Birth - OK
     C                   PARM                    DDOKDATE
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *Blanks
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
(c) Misys International Banking Systems Ltd. 2004
