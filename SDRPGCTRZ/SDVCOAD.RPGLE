     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Correspondence Address')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Correspondence       *
      *                                  Address                      *
      *                                                               *
      *  SDVCOAD - Validate Correspondence Address                    *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *   /COPY, Customer Future and options Details amendments must  *
      *        not be applied to this source.                         *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDCOAD          S              1A
     D DDBKIN          S              1A
     D DDCOADOK        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      ** Validation
 
      ** Validate Correspondence Address
      ** Broker Indicator is Yes
     C                   IF        DDBKIN = 'Y'
      ** Correspondence Address is Blank
     C                   IF        DDCOAD =*BLANK
     C                   ELSE
      ** Send message 'Correspond Blank - Broker'
     C                   EVAL      DDCOADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOAD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1196'
     C                   ENDIF
 
     C                   ELSE
      ** Correspondence Address is *ALL values
     C                   IF        DDCOAD = *BLANK OR
     C                              DDCOAD = 'C' OR
     C                              DDCOAD = 'D' OR
     C                              DDCOAD = 'E' OR
     C                              DDCOAD = 'F' OR
     C                              DDCOAD = 'G' OR
     C                              DDCOAD = 'H' OR
     C                              DDCOAD = 'I' OR
     C                              DDCOAD = 'J' OR
     C                              DDCOAD = 'K' OR
     C                              DDCOAD = 'L' OR
     C                              DDCOAD = 'M' OR
     C                              DDCOAD = 'N' OR
     C                              DDCOAD = 'O' OR
     C                              DDCOAD = 'P' OR
     C                              DDCOAD = 'Q' OR
     C                              DDCOAD = 'R' OR
     C                              DDCOAD = 'S' OR
     C                              DDCOAD = 'T' OR
     C                              DDCOAD = 'U' OR
     C                              DDCOAD = 'V' OR
     C                              DDCOAD = 'W' OR
     C                              DDCOAD = 'X' OR
     C                              DDCOAD = 'Y' OR
     C                              DDCOAD = 'Z'
     C                   ELSE
      ** Send message 'Correspond Invalid'
     C                   EVAL      DDCOADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOAD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1197'
 
     C                   ENDIF
      ** EndIf for DDBKIN,
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Correspondence Address,
     C                   PARM                    DDCOAD
      ** Broker Indicator,
     C                   PARM                    DDBKIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Correspondence Address - OK
 
     C                   PARM                    DDCOADOK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
