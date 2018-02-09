     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Restrictions/Narrative')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Restrictions/Narrative        *
      *                                                               *
      *  SDVNAR -Validate Restrictions/Narrative                      *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Fiduciary Deposit Details amendments must  *
      *    not be applied to this source.                             *
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
     D DDNAR1          S             40A
     D DDNAR2          S             40A
     D DDNAR3          S             40A
     D DDNAR4          S             40A
     D DDNAR1OK        S              1A
     D DDNAR2OK        S              1A
     D DDNAR3OK        S              1A
     D DDNAR4OK        S              1A
 
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
      ** Validate Restrictions/Narrative,
     C                   IF        DDNAR1 = *BLANKS AND
     C                             DDNAR2 <>*BLANKS AND
     C                             DDNAR3 <>*BLANKS AND
     C                             DDNAR4 <>*BLANKS OR
 
     C                             DDNAR1 = *BLANKS AND
     C                             DDNAR2 <>*BLANKS AND
     C                             DDNAR3 <>*BLANKS AND
     C                             DDNAR4 = *BLANKS OR
 
     C                             DDNAR1 = *BLANKS AND
     C                             DDNAR2 <>*BLANKS AND
     C                             DDNAR3 = *BLANKS AND
     C                             DDNAR4 <>*BLANKS OR
 
     C                             DDNAR1 = *BLANKS AND
     C                             DDNAR2 <>*BLANKS AND
     C                             DDNAR3 = *BLANKS AND
     C                             DDNAR4 = *BLANKS OR
 
     C                             DDNAR1 = *BLANKS AND
     C                             DDNAR2 = *BLANKS AND
     C                             DDNAR3 <>*BLANKS AND
     C                             DDNAR4 <>*BLANKS OR
 
     C                             DDNAR1 = *BLANKS AND
     C                             DDNAR2 = *BLANKS AND
     C                             DDNAR3 <>*BLANKS AND
     C                             DDNAR4 = *BLANKS OR
 
     C                             DDNAR1 = *BLANKS AND
     C                             DDNAR2 = *BLANKS AND
     C                             DDNAR3 = *BLANKS AND
     C                             DDNAR4 <>*BLANKS
 
     C                   EVAL      DDNAR1OK = 'N'
     C                   EVAL      DDNAR2OK = 'N'
     C                   EVAL      DDNAR3OK = 'N'
     C                   EVAL      DDNAR4OK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNAR1   '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR8629'
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
      ** Restrictions/Narrative Fields 1/2/3/4
     C                   PARM                    DDNAR1
     C                   PARM                    DDNAR2
     C                   PARM                    DDNAR3
     C                   PARM                    DDNAR4
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Restrictions/Narrative - OK
     C                   PARM                    DDNAR1OK
     C                   PARM                    DDNAR2OK
     C                   PARM                    DDNAR3OK
     C                   PARM                    DDNAR4OK
 
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
