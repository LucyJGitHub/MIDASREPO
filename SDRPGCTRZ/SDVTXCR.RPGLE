     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rates Valid Tax Conv Rate')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVTXCR - SD Spot Rates Validate Tax Conversion Rate         *
      *                                                               *
      *  Function:  This module validates the Tax Conversion Rate     *
      *             on the Spot Rates Detail screen                   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
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
      *  SRVTaxCRate - Validate Tax Conversion Rate                   *
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
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
     D  DDTXCROK       S              1A
     D  DDTXCR         S             14A
     D  WTaxCRat       S             13P 8
     D  NewSPRT        S             13P 8
     D  DDSPRT         S             14A
     D  DDSPRTOK       S              1A
      *
      ** Work variables
      *
     D  WRun           S              1A
     D  Idx            S              3P 0
     D  WIdx           S              3P 0
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
     C                   EVAL      WIdx = *ZEROS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
      ** Validate Tax Conversion Rate Margin Points
      *
     C                   EXSR      SRVTaxCRate
      *
      ** If Error
      *
     C                   IF        DDTXCROK = 'N'
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
      *  SRVTaxCRate - Validate Tax Conversion Rate                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVTaxCRate   BEGSR
      *
      ** Check if the Tax Conversion Rate, if entered, is valid
      *
     C                   IF        DDTXCR <> *BLANKS
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM      DDTXCR        PZField
     C                   PARM      8             PZADec
     C                   PARM      5             PZADig
      *
      * If not in nnnnn.nnnnnnnn format then error
     C                   IF        PZAlignOk = 'N'
      *
     C                   EVAL      DDTXCROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTXCR'
     C                   EVAL      MsgIDXAr(Idx) = '5047554'
      *
     C                   ELSE
      *
     C                   MOVE      PZField       WTaxCrat
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *ZEROS        WTaxCrat
      *
     C                   ENDIF
      *
     C                   IF        (DDSPRTOK = 'Y' OR DDSPRTOK = 'W') AND
     C                             DDTXCROK = 'Y' AND WTaxCrat = *zeros
     C                   Eval      DDTXCR = DDSPRT
     C                   Eval      WTaxCrat = NewSPRT
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
     C                   PARM                    DDTXCR
     C                   PARM                    DDSPRT
     C                   PARM                    NewSPRT
     C                   PARM                    DDSPRTOK
      *
      ** Outputs
      *
     C                   PARM                    WTaxCRat
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTXCROK
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
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
(c) Finastra International Limited 2015
