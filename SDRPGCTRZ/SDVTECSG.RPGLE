     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust PUMA II dtl-Economical Sector ClsFld')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTECSG - Midas SD Customer PUMA II Details - Economical    *
      *             Sector Class Field                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for SAR details

     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** External DS for Internal Table

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

     D PRetCode        S              7A
     D POption         S              7A
     D PKeyFld         S              3A
     D PField          S             24A
     D PEcsg           S              3A

     D PZAlignOk       S              1A                                              LUC139
     D PZField         S             16A                                              LUC139
     D PZADec          S              1P 0                                            LUC139
     D PZADig          S              2P 0                                            LUC139

     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Index for arrays of error message ids etc

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

     C                   EVAL      RetCodeIn = *BLANK

     C                   MOVE      *BLANKS       FldNamXAr
     C                   MOVE      *BLANKS       MsgIdXAr
     C                   MOVE      *BLANK        MsgDtaXAr

     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0

     C                   IF        %SUBST(PEcsg:1:1) = '?'
     C                   EVAL      PField  = '?'
     C                   ELSE
     C                   EVAL      PField  = PEcsg
     C                   ENDIF

     C                   If        PECsg = *Blanks                                       LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                 LUC139
     C                   EVAL      Idx = Idx + 1                                         LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTECSG'                            LUC139
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1108'                            LUC139
     C                   EVAL      DDTEcsgOk = 'N'                                       LUC139
     C                   ELSE                                                            LUC139

     C                   CALLB     'ZALIGN'                                              LUC139
     C                   PARM      *BLANK        PZAlignOK                               LUC139
     C                   PARM      PEcsg         PZField                                 LUC139
     C                   PARM      *ZEROS        PZADec                                  LUC139
     C                   PARM      3             PZADig                                  LUC139
                                                                                         LUC139
      ** Check if the Return code and process                                            LUC139
                                                                                         LUC139
     C                   IF        PZAlignOk <> 'Y'                                      LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                 LUC139
     C                   EVAL      Idx = Idx + 1                                         LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTECSG'                            LUC139
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1108'                            LUC139
     C                   EVAL      DDTEcsgOk = 'N'                                       LUC139
     C                   ELSE                                                            LUC139

      ** Call SD Value List validation module

     C                   CALL      'AOFXTBR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM      'BBI'         PKeyFld
     C                   PARM                    PField
     C     IRFXTB        PARM      IRFXTB        DSFDY

      ** Check if the Return code and process

     C                   IF        PRetCode <> *Blanks
     C                   EVAL      RetCodeIn =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTECSG'
     C                   EVAL      MsgIDXAr(Idx)  = 'ITS1128'
     C                   EVAL      DDTEcsgOk = 'N'                                       LUC139
     C                   ELSE
     C                   MOVEL     PField        PEcsg
     C                   ENDIF
     C                   ENDIF                                                          LUC139
     C                   ENDIF                                                          LUC139

      ** Return

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return Code

     C                   PARM                    RetCodeIn
     C                   PARM                    PEcsg

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTEcsgOk         1                          LUC139

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
