     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Prime A/c Holder for Tax Group Check')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVPHOG01 - Midas SD Prime A/c Holder Group Check            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
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
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG15110           Date 24Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543  *CREATE    Date 30Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15110 -  Only one Joint A/c Member can have a Prime A/c   *
      *              Holder for Tax field  equal to 'Y'               *
      *  232543 - Fix to CGL031                                       *
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
     D PAPAHO          S              1A   DIM(100)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDJANO          S              6A
     D OKPAHO          S              1A
 
      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
 
      ** Working Variables
     D Ix              S              3P 0
     D WPAHOIx         S              3P 0
     D WI              S              3P 0
     D WOKPAHO         S              1A
 
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
 
     C                   EXSR      SRVPAHO
 
     C                   IF        OKPAHO <> 'Y'
     C                   EVAL      PRetCode  = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPAHO - Validates the Prime A/c Holder.                    *
      *                                                               *
      *****************************************************************
     C     SRVPAHO       BEGSR
 
      ** Search for duplicate 'Y's.
 
     C                   EVAL      WOKPAHO = 'Y'
 
     C                   FOR       WPAHOIx = 1 TO %ELEM(PAPAHO) - 1
 
     C                   IF        PAPAHO(WPAHOIx) = 'Y'
 
     C                   EVAL      WI = %LOOKUP('Y':PAPAHO:WPAHOIx + 1)
 
     C                   IF        WI <> *ZERO
 
      ** Mark duplicate elements.
 
     C                   EVAL      PAPAHO(WPAHOIx) = '*'
     C                   EVAL      PAPAHO(WI) = '*'
     C                   EVAL      WOKPAHO = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
      ** Check if a Prime A/c Holder for Tax exists in the database.
 
     C                   IF        WOKPAHO = 'Y'
     C                   EXSR      SRGetDbY
     C                   ENDIF
 
     C                   IF        WOKPAHO = 'N'
 
      ** Only one Joint A/c Member can have a Prime A/c Holder for Tax field
      ** equal to 'Y'.
 
     C                   EVAL      OKPAHO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDPAHO'
     C**********         EVAL      MsgIDXAr(Ix) = 'SDM0135'                                 BUG15110
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0138'                                 BUG15110
     C                   ENDIF
 
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
 
     C                   DOW       NOT %EOF(SDJACCL1)
 
      ** If the Joint A/c Member read does not exist in those that were marked
      ** as changed, check if its Prime A/c Holder for Tax field is equal to 'Y'.
 
     C                   IF        (JCCUST <> *BLANKS AND
     C                             %LOOKUP(JCCUST:PACUST:1) = *ZERO) OR
     C                             (JCNAHO <> *BLANKS AND
     C                             %LOOKUP(JCNAHO:PANAHO:1) = *ZERO)
 
     C                   IF        JCPAHO = 'Y'
 
     C                   EVAL      WI = %LOOKUP('Y':PAPAHO:1)
 
     C                   IF        WI <> *ZERO
     C                   EVAL      PAPAHO(WI) = '*'
     C                   EVAL      WOKPAHO = 'N'
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
 
      ** Prime A/c Holder Array
     C                   PARM                    PAPAHO
 
      ** Output Parameters **
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** OK - Prime A/c Holder for Tax Purposes
     C                   PARM                    OKPAHO
 
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
(c) Finastra International Limited 2005
