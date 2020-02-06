     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rates Valid Tax Conv Rate Margin Pt')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVTCMP - SD Spot Rates Validate Tax Conversion Rate Margin  *
      *            Points                                             *
      *                                                               *
      *  Function:  This module validates the Tax Conversion Rate     *
      *             Margin Points on the Spot Rates Detail screen     *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23931           Date 11May08               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23931 - Int earned upto threshold figure incorrect on CCY *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *  ===========================================                  *
      *                                                               *
      *  LR  - Last record indicator (program termination)            *
      *  U7  - DB error processing indicator                          *
      *  U8  - DB error processing indicator                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  SRVTaxCMrPt - Validate Tax Conversion Rate Margin Points     *
      *  *INZSR - Program initialization routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                BUG23931
      ** External DS for Bank Details                                                       BUG23931
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG23931
      ** First DS for Access Programs, Short Data Structure                                 BUG23931
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for calling ZALIGN
      *
     D  PZAlignOk      S              1A
     D  PZField        S             16A
     D  PZADec         S              1P 0
     D  PZADig         S              2P 0
      *
     D  DDTCMPOK       S              1A
     D  DDMDIN         S              1A
     D  DDSPRT         S             14A
     D  DDTCMP         S             10A
     D  DDCYCD         S              3A                                                    BUG23931
      *
      ** Work variables
      *
     D  WRun           S              1A
     D  Idx            S              3P 0
     D  WIdx           S              3P 0                                                  BUG23931
     D  WTaxMPnt       S              9P 7
     D  WTaxMPntChk    S             10A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialize fields
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIdXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WIdx = *ZEROS                                            BUG23931
     C                   EVAL      WFldNmXAr = *BLANKS                                      BUG23931
     C                   EVAL      WMsgIDXAr = *BLANKS                                      BUG23931
     C                   EVAL      WMsgDtXAr = *BLANKS                                      BUG23931
      *
      ** Validate Tax Conversion Rate Margin Points
      *
     C                   EXSR      SRVTaxCMrPt
      *
      ** If Error
      *
     C                   IF        DDTCMPOK = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTaxCMrPt - Validate Tax Conversion Rate Margin Points     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVTaxCMrPt   BEGSR
      *
     C                   MOVE      DDTCMP        WTaxMPntChk
      *
     C                   IF        DDTCMP = *BLANKS
     C                   MOVE      *ZEROS        WTaxMPntChk
     C                   ENDIF
      *                                                                                     BUG23931
     C                   IF        WTaxMPntChk <> *ZEROS                                    BUG23931
     C                             AND DDCYCD = BJCYCD                                      BUG23931
     C                   EVAL      WIdx = WIdx + 1                                          BUG23931
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTCMP'                               BUG23931
     C                   EVAL      WMsgIDXAr(WIdx) = 'USR9911'                              BUG23931
     C                   ENDIF                                                              BUG23931
      *
      ** Tax Conversion Rate Margin Points must always be zero
      ** when Multiply/Divide Indicator not equals to 'M'
      *
     C                   IF        DDMDIN <> 'M' AND
     C                             WTaxMPntChk <> *ZEROS
      *
     C                   EVAL      DDTCMPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCMP'
     C                   EVAL      MsgIDXAr(Idx) = 'USR9984'
      *
     C                   ENDIF
      *
      ** Check if the Tax Conversion Rate Margin Points, if entered,
      ** is Valid
      *
     C                   IF        DDTCMP <> *BLANKS AND
     C                             DDMDIN = 'M'
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM      DDTCMP        PZField
     C                   PARM      7             PZADec
     C                   PARM      2             PZADig
      *
     C                   IF        PZAlignOk = 'N'
      *
     C                   EVAL      DDTCMPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCMP'
     C                   EVAL      MsgIDXAr(Idx) = 'USR9982'
      *
     C                   ELSE
      *
     C                   MOVE      PZField       WTaxMPnt
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *ZEROS        WTaxMPnt
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCYCD                                     BUG23931
     C                   PARM                    DDTCMP
     C                   PARM                    DDMDIN
     C                   PARM                    DDSPRT
      *
      ** Outputs
      *
     C                   PARM                    WTaxMPnt
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                  BUG23931
     C                   PARM                    WMsgIDXAr                                  BUG23931
     C                   PARM                    WMsgDtXAr                                  BUG23931
     C                   PARM                    DDTCMPOK
      *                                                                                     BUG23931
      ** ACCESS BANK DETAILS                                                                BUG23931
      *                                                                                     BUG23931
     C                   CALL      'AOBANKR0'                                               BUG23931
     C                   PARM      *BLANKS       @RTCD             7                        BUG23931
     C                   PARM      '*FIRST '     @OPTN             7                        BUG23931
     C     SDBANK        PARM      SDBANK        DSFDY                                      BUG23931
      *                                                                                     BUG23931
      * DATABASE ERROR                                                                      BUG23931
      *                                                                                     BUG23931
     C     @RTCD         IFNE      *BLANKS                                                  BUG23931
     C                   MOVEL     'SDBANKPD'    DBFILE                                     BUG23931
     C                   MOVEL     '001'         DBASE                                      BUG23931
     C                   MOVEL     @OPTN         DBKEY                                      BUG23931
     C                   EXSR      *PSSR                                                    BUG23931
     C                   END                                                                BUG23931
      *                                                                                     BUG23931
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
