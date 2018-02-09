     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Agent Percentage')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Agent Percentage              *
      *                                                               *
      *  SDVAGNP - Validate Agent Percentage                          *
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
     D ZAlignOK        S              1A
     D ZFIELD          S             16A
     D ZFIELD1         S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D DDAGNP          S              6A
     D DDAGNT          S             10A
     D DDAGNPOK        S              1A
     D FDAGNP          S              5P 3
 
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
 
      ** VALIDATION
 
      ** Validate Agent percentage
 
     C                   IF        DDAGNP <> *BLANKS
 
     C                   EVAL      ZFIELD = *BLANKS
     C                   EVAL      ZFIELD = DDAGNP
     C                   Z-ADD     3             ZADEC
     C                   Z-ADD     2             ZADIG
      ** Call the ZALIGN MODULE with four parms,
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   IF        ZAlignOK = 'N' OR ZFIELD = *zeros
     C                   EVAL      DDAGNPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDAGNP   '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR8626'
 
      ** Invalid
 
     C                   ELSE
      * Save the value of the zalign field
     C                   MOVE      ZFIELD        ZFIELD1
      ** Edit the field for output
     C                   CALLB     'ZEDIT'
      ** Alpha field containing numeric value to be edited
     C                   PARM                    ZFIELD1
      ** Number of decimal position
     C                   PARM                    ZADEC
 
     C                   MOVE      ZFIELD1       DDAGNP
 
     C                   ENDIF
 
     C                   ENDIF
      ** Check if Agent is equal to Blanks & Agent percentage not equal to
      ** Blanks
     C                   IF        DDAGNT = *BLANKS AND
     C                             DDAGNP <> *BLANKS
     C                   EVAL      DDAGNPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDAGNP     '
     C                   EVAL      MsgIdXAr(Idx) = 'USR8624'
      *
     C                   ELSE
      *
      ** Check if Agent is not equal to Blanks & Agent percentage equal to
      *  Blanks
 
     C                   IF        DDAGNT <> *BLANKS AND
     C                             DDAGNP  = *BLANKS
     C                   EVAL      DDAGNPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDAGNP     '
     C                   EVAL      MsgIdXAr(Idx) = 'USR8625'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      ZFIELD        FDAGNP
 
      ** RETURN
 
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
      ** Field(s) requiring validation
      ** Agent percentage
     C                   PARM                    DDAGNP
      ** Agent
     C                   PARM                    DDAGNT
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Agent Percentage - OK
 
     C                   PARM                    DDAGNPOK
      ** Return value for Agent percentage
     C                   PARM                    FDAGNP
 
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
