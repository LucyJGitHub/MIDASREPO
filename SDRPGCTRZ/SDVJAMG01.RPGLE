     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Holder Group Check')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVJAMG01 - Midas SD Joint Account Holder Group Check        *
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
      *  Prev Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL031 - Taxation of Savings Income                          *
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
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDACTN          S              1A
     D OKCUST          S              1A
     D OKNAHO          S              1A
 
      ** Working Variables
     D Ix              S              3P 0
     D WCustIx         S              3P 0
     D WNAHoIx         S              3P 0
     D WI              S              3P 0
     D WOKCust         S              1A
     D WOKNAHo         S              1A
 
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
 
      ** Validate Customer Number.
 
     C                   EXSR      SRVCust
 
      ** Validate Non-a/c Holder.
 
     C                   EXSR      SRVNAHo
 
     C                   IF        OKCUST <> 'Y' OR
     C                             OKNAHO <> 'Y'
     C                   EVAL      PRetCode  = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCust - Validates the Customer Number.                     *
      *                                                               *
      *****************************************************************
     C     SRVCust       BEGSR
 
      ** Search for duplicate entries.
 
     C                   EVAL      WOKCust = 'Y'
 
     C                   FOR       WCustIx = 1 TO %ELEM(PACUST) - 1
 
     C                   IF        PACUST(WCustIx) <> *BLANKS
     C                   EVAL      WI = %LOOKUP(PACUST(WCustIx):
     C                                  PACUST:WCustIx + 1)
 
     C                   IF        WI <> *ZERO
 
      ** Mark duplicate elements.
 
     C                   EVAL      PACUST(WCustIx) = '*ERROR'
     C                   EVAL      PACUST(WI) = '*ERROR'
     C                   EVAL      WOKCust = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   IF        WOKCust = 'N'
 
      ** Customer Numbers must be unique in this Joint Account.
 
     C                   EVAL      OKCUST = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0115'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNAHo - Validates the Non-account Holder.                  *
      *                                                               *
      *****************************************************************
     C     SRVNAHo       BEGSR
 
      ** Search for duplicate entries.
 
     C                   EVAL      WOKNAHo = 'Y'
 
     C                   FOR       WNAHoIx = 1 TO %ELEM(PANAHO) - 1
 
     C                   IF        PANAHO(WNAHoIx) <> *BLANKS
     C                   EVAL      WI = %LOOKUP(PANAHO(WNAHoIx):
     C                                  PANAHO:WNAHoIx + 1)
 
     C                   IF        WI <> *ZERO
 
      ** Mark duplicate elements.
 
     C                   EVAL      PANAHO(WNAHoIx) = '*ERROR'
     C                   EVAL      PANAHO(WI) = '*ERROR'
     C                   EVAL      WOKNAHo = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   IF        WOKNAHo = 'N'
 
      ** Non-account Holders must be unique in this Joint Account.
 
     C                   EVAL      OKNAHO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDNAHO'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0117'
     C                   ENDIF
 
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
 
      ** Action Code
     C                   PARM                    PDACTN
 
      ** Customer Number Array
     C                   PARM                    PACUST
 
      ** Non-a/c Holder Array
     C                   PARM                    PANAHO
 
      ** Output Parameters **
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** OK - Customer Number
     C                   PARM                    OKCUST
 
      ** OK - Non-a/c Holder
     C                   PARM                    OKNAHO
 
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
(c) Finastra International Limited 2004
