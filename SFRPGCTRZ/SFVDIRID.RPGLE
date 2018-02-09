     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Directory  ID and Directory Address')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function Module - User Maintenamce  *
      *          and Menu Items Validation                            *
      *                                                               *
      *  SFVDIRID  - Validate Directory ID & Directory Address        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, User Maintenance + Menu Items amendments must not be*
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 18May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
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
     C                   Z-ADD     0             WIdx
 
      *
      ** VALIDATION
 
      *
      ** Validate Directory ID & Directory Address
      *
      ** AS/400 DIRECTORY ID AND ADDRESS IF ENTERED, MUST BE BOTH BE
      ** ENTERED AND BOTH BE VALID
      **
     C     DDDIRID       IFNE      *BLANKS
     C     DDDIRAD       ANDEQ     *BLANKS
     C                   EVAL      DDDIRIDOK = 'N'
     C                   EVAL      DDDIRADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDIRID'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0473'
     C                   ENDIF
      **
     C     DDDIRID       IFEQ      *BLANKS
     C     DDDIRAD       ANDNE     *BLANKS
     C                   EVAL      DDDIRIDOK = 'N'
     C                   EVAL      DDDIRADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDIRID'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0473'
     C                   ENDIF
      **
     C     DDDIRID       IFNE      *BLANKS
     C     DDDIRAD       ANDNE     *BLANKS
     C                   MOVE      DDUSER1       SMUSR1           50
      *
     C                   CALL      'SFC0030'
     C                   PARM                    DDACTN
     C                   PARM                    ERRCD             1
     C                   PARM                    DDUSRP
     C                   PARM                    SMUSR1
     C                   PARM                    DDDIRID
     C                   PARM                    DDDIRAD
      *
     C     ERRCD         IFEQ      '1'
     C                   EVAL      DDDIRIDOK = 'N'
     C                   EVAL      DDDIRADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDIRID'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0474'
     C                   ENDIF
      **
     C     ERRCD         IFEQ      '2'
     C                   EVAL      DDDIRIDOK = 'N'
     C                   EVAL      DDDIRADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDIRID'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0475'
     C                   ENDIF
      **
     C     ERRCD         IFEQ      '3'
     C                   EVAL      DDDIRIDOK = 'N'
     C                   EVAL      DDDIRADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDIRID'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0476'
     C                   ENDIF
      **
     C     ERRCD         IFEQ      '4'
     C                   EVAL      DDDIRIDOK = 'N'
     C                   EVAL      DDDIRADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDIRID'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0477'
     C                   ENDIF
      **
     C                   ENDIF
      **
 
 
 
      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
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
      ** Field(s) requiring validation
     C                   PARM                    DDDIRID           8
     C                   PARM                    DDDIRAD           8
     C                   PARM                    DDACTN            1
     C                   PARM                    DDUSRP           10
     C                   PARM                    DDUSER1          25
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Directory ID - OK
     C                   PARM                    DDDIRIDOK         1
      ** Directory Address - OK
     C                   PARM                    DDDIRADOK         1
      *
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
**  CPY@
(c) Finastra International Limited 2006
