     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility BoE Validation')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPVAL1- Transactions  Details Validation                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD044880           Date 15Jan18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Transaction Details in screen format
     D NwFCIPScnFmt  E DS                  EXTNAME(LEFCEXPD)
 
      ** Transaction Details OK indicators
     D OKFlags       E DS                  EXTNAME(LEEFCIPX0)
 
      ** Valid Transaction Details layout
     D NwFCIPFilFmt  E DS                  EXTNAME(LEVFCIPX0)
 
     D/COPY QWINDSRC,LEFCIPDTA
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      **parameter field
 
     D PActn           S              1
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +----start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRINIT
      *
      **
     C                   IF        LEUROX  = *Blanks
     C                   EVAL      Idx             = Idx + 1
     C**********         EVAL      MsgIdArr  (Idx) = 'BYM0117'                              MD044880
     C                   EVAL      MsgIdArr  (Idx) = '5049092'                              MD044880
     C                   EVAL      MsgDtaArr (Idx) = 'LEUROX'
     C                   EVAL      FldNameArr(Idx) = 'LEUROX'
     C                   EVAL      Returncode      = 'Error'
 
     C                   ELSE
 
     C                   IF        LEUROX <> 'Y' and
     C                             LEUROX <> 'N'
      *
     C                   EVAL      Idx             = Idx +1
     C**********         EVAL      MsgIdArr  (Idx) = 'BYM0118'                              MD044880
     C                   EVAL      MsgIdArr  (Idx) = '5049093'                              MD044880
     C                   EVAL      MsgDtaArr (Idx) = 'LEUROX'
     C                   EVAL      FldNameArr(Idx) = 'LEUROX'
     C                   EVAL      Returncode      = 'Error'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    EUROOK
     C                   PARM                    Returncode
     C                   PARM                    WarnGlobal
      *
     C                   IF        Idx = *Zeros
     C                   EVAL      LVCNUM = BYCNUM
     C                   EVAL      LVFACT = BYFACT
     C                   EVAL      LVFCNO = BYFCNO
     C                   EVAL      LVEURO = LEUROX
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRINIT
      *****************************************************************
     C     SRINIT        BEGSR
 
     ** Initialisation
 
     C                   CLEAR                   Idx
     C                   CLEAR                   ReturnCode
 
      ** Default LEUROX to 'N' if not entered
 
     C                   IF        LEUROX = *BLANKS
     C                   EVAL      LEUROX = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      **Inputs
 
     C                   PARM                    PActn
     C                   PARM                    DATA
     C                   PARM                    NwFCIPScnFmt
 
      ** Transaction Details OK inds
     C                   PARM                    OKFlags
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Data Structures
     C                   PARM                    NwFCIPFilFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
