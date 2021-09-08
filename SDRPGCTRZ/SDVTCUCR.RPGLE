     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust PUMA II dtl-Cust CR Number Fld Val')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTCUCR - Customer CR Number Validation                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
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

     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PCucr           S             13A

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
     C                   EVAL      PZField   = *BLANK

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr

     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0

     C                   IF        PCUCR <> *BLANKS

      ** Validation
      ** Check if numeric

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZAlignOK
     C                   PARM      PCUCR         PZField
     C                   PARM      *ZEROS        PZADec
     C                   PARM      13            PZADig

      ** Check if the Return code and process

     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCUCR'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1112'
     C                   EVAL      DDTCucrOk = 'N'                                         LUC139
     C                   ENDIF
                                                                                           LUC139
      * If numeric, positions 12 and 13 must be valid control digits                       LUC139
      * based over the value entered in the first 11 posiions.                             LUC139
                                                                                           LUC139
     C                   CALL      'SDCRVAL'                                               LUC139
     C                   PARM                    PCUCR                                     LUC139
     C                   PARM                    RetCode           1                       LUC139
                                                                                           LUC139
     C                   If        RetCode <> *Blanks                                      LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                   LUC139
     C                   EVAL      Idx = Idx + 1                                           LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTCUCR'                              LUC139
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1140'                              LUC139
     C                   EVAL      DDTCucrOk = 'N'                                         LUC139
     C                   Endif                                                             LUC139
                                                                                           LUC139
     C                   ENDIF
                                                                                           LUC139
     C                   If        PCucr = *Blanks                                         LUC139
     C                             Or PCucr = *Zeros                                       LUC139
     C                   If        PEcsg = '245' or                                        LUC139
     C                             PEcsg = '300' or                                        LUC139
     C                             PEcsg = '301' or                                        LUC139
     C                             PEcsg = '724' or                                        LUC139
     C                             PEcsg = '729' or                                        LUC139
     C                             PEcsg = '791'                                           LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                   LUC139
     C                   EVAL      Idx = Idx + 1                                           LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTCUCR'                              LUC139
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1139'                              LUC139
     C                   EVAL      DDTCucrOk = 'N'                                         LUC139
     C                   Endif                                                             LUC139
     C                   Endif                                                             LUC139

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

      ** Inputs
      ** Return Code

     C                   PARM                    RetCodeIn
     C                   PARM                    PCucr
     C                   PARM                    PEcsg             3            LUC139

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCucrOk         1            LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
