     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Statement Frequency')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Statement Frequency  *
      *                                                               *
      *  SDVSTFQ - Validate Statement Frequency                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      * /COPY, Customer Futures and Options Details amendments must   *
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
     D DDSTFQ          S              1A
     D DDSTFQOK        S              1A
 
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
      ** Validate Statement Frequency
      ** Statement frequency if equal blank
     C                   IF        DDSTFQ = *BLANK
     C                   EVAL      DDSTFQ = 'B'
     C                   ELSE
      ** Statement frequency is *ALL values
     C                   IF        DDSTFQ = 'M' OR
     C                             DDSTFQ = 'S' OR
     C                             DDSTFQ = 'T' OR
     C                             DDSTFQ = 'R' OR
     C                             DDSTFQ = 'B' OR
     C                             DDSTFQ = 'L' OR
     C                             DDSTFQ = 'A' OR
     C                             DDSTFQ = 'Q' OR
     C                             DDSTFQ = 'X' OR
     C                             DDSTFQ = 'Y' OR
     C                             DDSTFQ = 'Z' OR
     C                             DDSTFQ = 'D' OR
     C                             DDSTFQ = 'W' OR
     C                             DDSTFQ = 'F' OR
     C                             DDSTFQ = 'P' OR
     C                             DDSTFQ = 'K' OR
     C                             DDSTFQ = 'H' OR
     C                             DDSTFQ = 'G' OR
     C                             DDSTFQ = *BLANK
     C                   ELSE
      ** Send message 'Statement Frequency Invalid'
     C                   EVAL      DDSTFQOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSTFQ    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1183'
 
     C                   ENDIF
 
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
      ** Field(s) requiring validation
     C                   PARM                    DDSTFQ
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Statement Frequency - OK
     C                   PARM                    DDSTFQOK
 
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
