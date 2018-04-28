     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Creation Date')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVCRDT1 - Validate Creation Date                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D DDCRDT          S              8
     D DDACTN          S              1
     D RunDat          S              5  0
     D Format          S              1
     D NACRDT          S              8
     D DDOKCRDT        S              1
 
     D WDateDD         S              2A
     D WDateMM         S              2A
     D WDateYY         S              2A
     D WDateYYYY       S              4A
     D DateIn6         S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
     D DateIn5         S              5P 0
     D DayOut8         S              8S 0
 
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
     C                   EXSR      SRVCRDT
 
      ** If an error was found, set the return code appropriately
     C                   IF        DDOKCRDT = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCRDT - Validate Creation Date                              *
      *                                                               *
      *****************************************************************
 
     C     SRVCRDT       BEGSR
 
      ** Check if date contains all numeric characters
     C                   TESTN                   DDCRDT               25  26
 
      ** If creation date contains all numeric characters
     C                   IF        *IN25 = *ON
 
      ** Convert creation date to 6 long date
     C                   EVAL      WDateYY = %SubSt(DDCRDT:7:2)
     C                   EVAL      WDateYYYY = %SubSt(DDCRDT:5:4)
 
     C                   IF        Format = 'D'
     C                   EVAL      WDateDD = %SubSt(DDCRDT:1:2)
     C                   EVAL      WDateMM = %SubSt(DDCRDT:3:2)
     C                   EVAL      DateIn6 = WDateDD + WDateMM + WDateYY
     C                   ELSE
     C                   EVAL      WDateMM = %SubSt(DDCRDT:1:2)
     C                   EVAL      WDateDD = %SubSt(DDCRDT:3:2)
     C                   EVAL      DateIn6 = WDateMM + WDateDD + WDateYY
     C                   ENDIF
 
      ** Convert 6 long date to Midas day number
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn6
     C                   PARM                    DayNoOut
     C                   PARM                    Format
     C                   PARM                    ErrorFlag
 
     C                   IF        ErrorFlag = 'N'
 
      ** Creation Date must be lower or equal to run date
     C                   IF        DayNoOut > RunDat
     C                   EVAL      DDOKCRDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0289'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      NACRDT = WDateYYYY + WDateMM + WDateDD
     C                   ENDIF
 
      ** Creation Date must be a valid date
     C                   ELSE
     C                   EVAL      DDOKCRDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0290'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ELSE
      ** Creation Date must be a valid date
     C                   IF        *IN26 = *OFF
     C                   EVAL      DDOKCRDT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0290'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
 
      ** Default date is run date
      ** if non-account holder is new (Insert)
     C                   ELSE
 
     C                   IF        DDACTN = 'I'
      ** Convert Midas Run Day Number to YYYYMMDD format
     C                   CALLB     'ZDATE9'
     C                   PARM      RunDat        DateIn5
     C                   PARM                    DayOut8
     C                   PARM                    ErrorFlag
 
     C                   MOVE      DayOut8       NACRDT
 
     C                   EVAL      WDateDD = %SubSt(NACRDT:7:2)
     C                   EVAL      WDateMM = %SubSt(NACRDT:5:2)
     C                   EVAL      WDateYYYY = %SubSt(NACRDT:1:4)
 
     C                   IF        Format = 'D'
     C                   EVAL      DDCRDT = WDateDD + WDateMM + WDateYYYY
     C                   ELSE
     C                   EVAL      DDCRDT = WDateMM + WDateDD + WDateYYYY
     C                   ENDIF
     C                   ENDIF
 
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
      ** Creation Date
     C                   PARM                    DDCRDT
      ** Action Code
     C                   PARM                    DDACTN
      ** Run Day Number
     C                   PARM                    RunDat
      ** Date Format
     C                   PARM                    Format
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Creation Date in YYYYMMDD
     C                   PARM                    NACRDT
      ** Creation Date - OK
     C                   PARM                    DDOKCRDT
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
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *Blanks
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
(c) Misys International Banking Systems Ltd. 2013
