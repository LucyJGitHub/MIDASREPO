     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Prime A/c Holder for Tax Group Check')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVPHTG01 - Midas SD Prime A/c Holder for Tax Group Check    *
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
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 251156             Date 09Nov07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233197             Date 25Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  251156 - Create new error message ID and description for     *
      *           more descriptive error message created by SC233197. *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  233197 - One of the Prime A/c Holder for Tax members must    *
      *           be 'Y'                                              *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Customer Number Array
     D PACUST          S              6A   DIM(100)
 
      ** Non-a/c Holder Array
     D PANAHO          S             10A   DIM(100)
 
      ** Prime A/c Holder for Tax Array
     D PAPAHT          S              1A   DIM(100)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDJANO          S              6A
     D OKPAHT          S              1A
 
      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
 
      ** Working Variables
     D Ix              S              3P 0
     D WPAHTIx         S              3P 0
     D WI              S              3P 0
     D WOKPAHT         S              1A
     D WPAHTset        S              1A                                                      233197
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise relevant variables.
 
     C                   EVAL      PRetCode  = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Ix = *ZERO
 
      ** Validate Prime A/c Holder for Tax.
 
     C                   EXSR      SRVPAHT
 
     C                   IF        OKPAHT <> 'Y'
     C                   EVAL      PRetCode  = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPAHT - Validates the Prime A/c Holder for Tax.            *
      *                                                               *
      *****************************************************************
     C     SRVPAHT       BEGSR
 
      ** Reset PAHT flag                                                                      233197
                                                                                              233197
     C                   EVAL      WPAHTset = 'N'                                             233197
                                                                                              233197
      ** Search for duplicate 'Y's.
 
     C                   EVAL      WOKPAHT = 'Y'
 
     C                   FOR       WPAHTIx = 1 TO %ELEM(PAPAHT) - 1
 
     C                   IF        PAPAHT(WPAHTIx) = 'Y'
 
      ** Set flag if at least one PAHT is 'Y' (mandatory field)                               233197
                                                                                              233197
     C                   EVAL      WPAHTset = 'Y'                                             233197
                                                                                              233197
     C                   EVAL      WI = %LOOKUP('Y':PAPAHT:WPAHTIx + 1)
 
     C                   IF        WI <> *ZERO
 
      ** Mark duplicate elements.
 
     C                   EVAL      PAPAHT(WPAHTIx) = '*'
     C                   EVAL      PAPAHT(WI) = '*'
     C                   EVAL      WOKPAHT = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
      ** Check if a Prime A/c Holder for Tax exists in the database.
 
     C                   IF        WOKPAHT = 'Y'
     C                   EXSR      SRGetDbY
     C                   ENDIF
 
     C                   IF        WOKPAHT = 'N'
 
      ** Only one Joint A/c Member can have a Prime A/c Holder for Tax field
      ** equal to 'Y'.
 
     C                   EVAL      OKPAHT = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDPAHT'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0134'
     C                   ENDIF
 
      ** At least one Prime A/c Holder for Tax field must be 'Y'                              233197
                                                                                              233197
     C                   IF        WPAHTset = 'N'                                             233197
                                                                                              233197
     C                   FOR       WPAHTIx = 1 TO %ELEM(PAPAHT) - 1                           233197
     C                   EVAL      PAPAHT(WPAHTIx) = '*'                                      233197
     C                   ENDFOR                                                               233197
                                                                                              233197
     C                   EVAL      OKPAHT = 'N'                                               233197
     C                   EVAL      Ix = Ix + 1                                                233197
     C                   EVAL      FldNamXAr(Ix) = 'DDPAHT'                                   233197
     C**********         EVAL      MsgIDXAr(Ix) = 'SDM0136'                            233197 251156
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0142'                                   251156
     C                   ENDIF                                                                233197
                                                                                              233197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDbY - Gets the database 'Y'.                            *
      *                                                               *
      *****************************************************************
     C     SRGetDbY      BEGSR
 
     C                   EVAL      KJANo = PDJANO
     C     KJANo         SETLL     SDJACCL1
     C     KJANo         READE     SDJACCL1
 
     C                   DOW       NOT %EOF
 
      ** If the Joint A/c Member read does not exist in those that were marked
      ** as changed, check if its Prime A/c Holder for Tax field is equal to 'Y'.
 
     C                   IF        (JCCUST <> *BLANKS AND
     C                             %LOOKUP(JCCUST:PACUST:1) = *ZERO) OR
     C                             (JCNAHO <> *BLANKS AND
     C                             %LOOKUP(JCNAHO:PANAHO:1) = *ZERO)
 
     C                   IF        JCPAHT = 'Y'
 
      ** Set flag if at least one PAHT is 'Y' (mandatory field)                               233197
                                                                                              233197
     C                   EVAL      WPAHTset = 'Y'                                             233197
                                                                                              233197
     C                   EVAL      WI = %LOOKUP('Y':PAPAHT:1)
 
     C                   IF        WI <> *ZERO
     C                   EVAL      PAPAHT(WI) = '*'
     C                   EVAL      WOKPAHT = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     KJANo         READE     SDJACCL1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters **
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Joint A/c Number
     C                   PARM                    PDJANO
 
      ** Customer Number Array
     C                   PARM                    PACUST
 
      ** Non-a/c Holder Array
     C                   PARM                    PANAHO
 
      ** Prime A/c Holder for Tax Array
     C                   PARM                    PAPAHT
 
      ** Output Parameters **
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** OK - Prime A/c Holder for Tax Purposes
     C                   PARM                    OKPAHT
 
      **---------------------------------------------------------------
      ** Program, module, and procedure names for DB error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   CALLB     'DBERRCTL'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
