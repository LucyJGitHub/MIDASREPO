     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate LEI code validation')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVLEIC - Validate LEI Code                                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022862           Date 17Oct13               *
      *                 MD022509           Date 23Sep13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022862 - LEI Code not accepted eventhough consists of first*
      *             18 uppercase character and last 2 numbers.        *
      *  MD022509 - LEI field accepts lower case characters           *
      *  CFT050 - SWIFTRef Directories upload                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Valid Alpha Numeric Codes
     D***AlpNumChar      S              1    DIM(62) CTDATA PERRCD(62)                      MD022509
     D AlpNumChar      S              1    DIM(36) CTDATA PERRCD(36)                        MD022509
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D DDLEIC          S             20A
     D OKDDLEIC        S              1A
     D WAlpNum         S             18A
     D WWrk            S              1A
     D WNum            S              1A
     D I               S              3S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
 
     C                   EVAL      OKDDLEIC = 'Y'
      *
      ** Validation
      *
     C                   EXSR      SRLEIC
      *
      ** If an error was found, set the return code appropriately
      *
     C     OKDDLEIC      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      *  RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRLEIC - Validate LEI Code
      *****************************************************************
     C     SRLEIC        BEGSR
 
     C                   IF        DDLEIC <> *BLANKS
      ** Check WAlpNum for alphanumeric codes and no embedded blanks
     C                   Z-ADD     1             I
     C                   EVAL      WAlpNum = %SUBST(DDLEIC:1:18)
     C                   DOW       I <= 18
     C                   EVAL      WWrk = %SUBST(WAlpNum:I:1)
     C                   If        %LOOKUP(WWrk:AlpNumChar) = 0
     C                   EVAL      OKDDLEIC = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'DDLEIC'      FldNamXAr(Idx)
     C                   MOVEL     '5046094'     MsgIDXAr(Idx)
     C                   GOTO      ENDLEIC
     C                   ENDIF
     C                   EVAL      I = I + 1
     C                   ENDDO
 
      ** Check Last 2 digit if numeric
     C                   EVAL      WNum = %SUBST(DDLEIC:19:1)
     C                   IF        %CHECK('0123456789':WNum) <> 0
     C                   EVAL      OKDDLEIC = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'DDLEIC'      FldNamXAr(Idx)
     C                   MOVEL     '5046094'     MsgIDXAr(Idx)
     C                   GOTO      ENDLEIC
     C                   ENDIF
 
     C                   EVAL      WNum = %SUBST(DDLEIC:20:1)
     C                   IF        %CHECK('0123456789':WNum) <> 0
     C                   EVAL      OKDDLEIC = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'DDLEIC'      FldNamXAr(Idx)
     C                   MOVEL     '5046094'     MsgIDXAr(Idx)
     C                   GOTO      ENDLEIC
     C                   ENDIF
 
     C                   ENDIF
 
     C     ENDLEIC       ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** LEI Code
     C                   PARM                    DDLEIC
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Other parms
      *
      ** LEI Code - OK
     C                   PARM                    OKDDLEIC
      *
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
      ** Copyright must be defined for compile time array definition                      MD022862
**  CPY@
(c) Finastra International Limited 2013
**  AlpNumChar
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
