     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Cheque Numbers')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Cheques and Cards details     *
      *                                 Validation                    *
      *                                                               *
      *  SDVCQF - Validate Cheque Numbers                             *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Cheques and Cards details amendments must not be    *
      *    applied to this source.                                    *
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
 
      ** Work Variables
     D CNUMN           S             10P 0
     D CNUMA           S             10A
     D DDCQFX          S             10A
     D DDCQTX          S             10A
     D DDCQQX          S              3A
     D DDCQIX          S              6A
     D FldNme1         S             10A
     D FldNme2         S             10A
     D DDCQFXOK        S              1A
     D DDCQTXOK        S              1A
 
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
 
      ** Validate Cheques Number 1
      ** Validate Cheque numbers
     C     DDCQFX        IFNE      *BLANKS
     C                   MOVE      DDCQFX        CNUMN
     C                   MOVE      CNUMN         CNUMA
     C     DDCQFX        IFNE      CNUMA
     C                   EVAL      DDCQFXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1124'
     C                   ENDIF
     C                   ENDIF
 
      ** 'To' Cheque number MUST be numeric.
     C     DDCQTX        IFNE      *BLANKS
     C                   MOVE      DDCQTX        CNUMN
     C                   MOVE      CNUMN         CNUMA
     C     DDCQTX        IFNE      CNUMA
     C                   EVAL      DDCQTXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1125'
     C                   ENDIF
     C                   ENDIF
      ** Mandatory entry
 
     C     DDCQFX        IFEQ      *BLANKS
     C     DDCQTX        IFEQ      *BLANKS
     C     DDCQQX        IFNE      *BLANKS
     C     DDCQIX        ORNE      *BLANKS
     C                   EVAL      DDCQFXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1107'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDCQFXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1107'
     C                   ENDIF
     C                   ELSE
     C     DDCQTX        IFEQ      *BLANKS
     C                   EVAL      DDCQTXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1107'
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
      ** Cheque Number From
     C                   PARM                    DDCQFX
      ** Cheque Number To
     C                   PARM                    DDCQTX
      ** Quantity
     C                   PARM                    DDCQQX
      ** Cheque Number Issue Date
     C                   PARM                    DDCQIX
      ** Field Name 1
     C                   PARM                    FldNme1
      ** Field Name 2
     C                   PARM                    FldNme2
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Cheque Number from - OK
     C                   PARM                    DDCQFXOK
      ** Cheque Number to - OK
     C                   PARM                    DDCQTXOK
 
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
