     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer PUMA II - Residenza Code Valdnt')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTRESI - Residenza Code Validation                         *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 22Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER008  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER008 - Base Italian Features Upgrade to MidasPlus          *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

     D DSFDY         E DS                  Extname(DSFDY)
     D SDVALD        E DS                  Extname(SDVALDPD)
      ** DS for access programs

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Index for arrays of error message ids etc

     D Prtcd           S              7A
     D Poptn           S              7A
     D Pkey            S              6A
     D PResFld         S             10A
     D PCntyLoc        S              2A
     D DDTA004         S              1A
      ** Fields used for parameter list

     D Iprompt         S              1N

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

     C                   Move      *BLANK        RetCodeIn
     C                   Move      *BLANK        FldNamXAr
     C                   Move      *BLANK        MsgIDXAr
     C                   Move      *BLANK        MsgDtaXAr
     C                   Z-add     0             Idx
     C                   Z-add     0             WIdx

     C                   Select

     C                   When      DDTA004 = *BLANK

     C                   Return

     C                   When      DDTA004 = '?'

     C                   Eval      IPrompt = *ON

     C                   Other

     C                   Eval      IPrompt = *Off

     C                   Endsl

      ** Validation
      ** Call SD Value List validation module

     C                   Call      'AOVALDR0'
     C                   Parm      *BLANKS       Prtcd
     C                   Parm      '*KEY'        Poptn
     C                   Parm      'A004'        Pkey
     C                   Parm      DDTA004       PResFld
     C     SDVALD        Parm      SDVALD        DSFDY

     C                   If        Prtcd <> *BLANKS
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDTA004   '
     C                   Eval      MsgIdXAr(Idx) = 'SDE5004'
     C                   Eval      DDTA004Ok = 'N'                                        LUC139
     C                   Endif

     C                   If        IPrompt = *On
     C                   Eval      DDTA004 = T00ELE
     C                   Endif

      ** Check if the country location and residenza code match

     C                   If        PCntyLoc <> 'IT'
     C                             And DDTA004 <> '2'
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDTA004   '
     C                   Eval      MsgIdXAr(Idx) = 'SDE5047'
     C                   Eval      DDTA004Ok = 'N'                                        LUC139
     C                   Endif

      ** Return

     C     Emain         Tag

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

     C     *Entry        Plist

     C                   Parm                    RetCodeIn

     C                   Parm                    PCntyLoc
     C                   Parm                    DDTA004

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDTA004Ok         1                          LUC139

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      /COPY ZACPYSRC,DBFIELDS

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
