     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Significant Date')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVSIDT01 - Midas SD Validate Significant Date               *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26250           Date 30Sep09               *
      *                 BUG23780           Date 24Apr09               *
      *                 BUG23892           Date 05May09               *
      *                 BUG22912           Date 17Feb09               *
      *                 BUG22559           Date 11Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26250 - Customer Details By Country of Tax Maintenance    *
      *             Error. All cert. fields for all status should be  *
      *             optional.                                         *
      *  BUG23780 - No Validation on Cust Det Country of Tax          *
      *  BUG23892 - Certificate details should be mandatory if EU tax *
      *             status is 'S' and optional if it is 'T'           *
      *  BUG22912 - Threshold processing should be used if Exemption  *
      *             Certificate held                                  *
      *  BUG22559 - CUSD Country of Taxes date fields are populating  *
      *             after validation                                  *
      *  CER048 - German Features - Taxes                             *
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
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_XARRYS
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
      *
      ** New Details in Screen Format
      *
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
      *
      ** New Details in File Format
      *
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)
      *
      ** Screen Error Indicator
      *
     D OkFlags       E DS                  EXTNAME(SDECCTXPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D BJDFIN          S              1A
     D BJRDNB          S              5P 0
     D WTmpDat         S                   LIKE(BJRDNB)
     D WSIdt           S              6A
      *
      ** Array index
      *
     D Idx             S              3P 0
      *
     D PCalledF        S              1A
      *
     D ZDayno          S              5P 0
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
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      ** MAIN PROCEDURE                                               *
      *****************************************************************
      *
      ** Initialization
      *
     C                   RESET                   RetCodeOut
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      WSIdt = *BLANKS
     C                   EVAL      WTmpDat = *ZEROS                                         BUG22559
      *
     C                   IF        PCalledF = 'A'
     C                   MOVE      DDCADT        WSIdt
     C                   ELSEIF    PCalledF = 'V'
     C                   MOVE      DDCVDT        WSIdt
      *
     C                   ENDIF
      *
      ** Validation
      *
     C                   EXSR      SRVSidt
      *
     C                   IF        PCalledF = 'A'
     C                   IF        OKCADT = 'N'
     C                   EVAL      RetCodeOut = 'Error'
     C                   ELSE
     C                   EVAL      OKCADT = 'Y'
     C                   EVAL      CTCADT = WTmpDat
     C                   ENDIF
      *
     C                   ELSEIF    PCalledF = 'V'
     C                   IF        OKCVDT = 'N'
     C                   EVAL      RetCodeOut = 'Error'
     C                   ELSE
     C                   EVAL      OKCVDT = 'Y'
     C                   EVAL      CTCVDT = WTmpDat
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSidt - Subroutine to Validate Significant Date            *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVSidt       BEGSR
      *
     C**********         IF        WSIdt = *BLANKS AND DDETXS = 'S'                         BUG22912
     C**********         EVAL      Idx = Idx + 1                                            BUG22912
     C**********         IF        PCalledF = 'A'                                           BUG22912
     C**********         EVAL      OKCADT = 'N'                                             BUG22912
     C**********         EVAL      FldNamXAr(Idx) = 'DDCADT'                                BUG22912
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8293'                                BUG22912
      **********                                                                            BUG22912
     C**********         ELSEIF    PCalledF = 'V'                                           BUG22912
     C**********         EVAL      OKCVDT = 'N'                                             BUG22912
     C**********         EVAL      FldNamXAr(Idx) = 'DDCVDT'                                BUG22912
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8295'                                BUG22912
     C**********         ENDIF                                                              BUG22912
     C**********         LEAVESR                                                            BUG22912
      **********                                                                            BUG22912
     C**********         ELSEIF    WSIdt <> *BLANKS AND DDETXS <> 'S'                       BUG22912
     C**********         IF        WSIdt <> *BLANKS AND DDETXS <> 'T'              BUG22912 BUG26250
     C**********                   AND DDETXS <> 'S'                               BUG23892 BUG26250
     C**********         EVAL      Idx = Idx + 1                                            BUG26250
     C**********         IF        PCalledF = 'A'                                           BUG26250
     C**********         EVAL      OKCADT = 'N'                                             BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDCADT'                                BUG26250
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8294'                                BUG26250
      *
     C**********         ELSEIF    PCalledF = 'V'                                           BUG26250
     C**********         EVAL      OKCVDT = 'N'                                             BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDCVDT'                                BUG26250
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8296'                                BUG26250
     C**********         ENDIF                                                              BUG26250
     C**********         LEAVESR                                                            BUG26250
      *                                                                                     BUG23892
     C**********         ELSEIF    WSIdt = *BLANKS AND DDETXS = 'S'                BUG23892 BUG26250
      *                                                                                     BUG23892
     C**********         EVAL      Idx = Idx + 1                                   BUG23892 BUG26250
     C**********         IF        PCalledF = 'A'                                  BUG23892 BUG26250
     C**********         EVAL      OKCADT = 'N'                                    BUG23892 BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDCADT'                       BUG23892 BUG26250
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8293'                       BUG23892 BUG26250
      *                                                                                     BUG23892
     C**********         ELSEIF    PCalledF = 'V'                                  BUG23892 BUG26250
     C**********         EVAL      OKCVDT = 'N'                                    BUG23892 BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDCVDT'                       BUG23892 BUG26250
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8295'                       BUG23892 BUG26250
     C**********         ENDIF                                                     BUG23892 BUG26250
     C**********         LEAVESR                                                   BUG23892 BUG26250
      *                                                                                     BUG23892
      *                                                                                     BUG23780
      ** Validate that the Approval Date needs to be entered if a                           BUG23780
      ** Certificate Type has been entered                                                  BUG23780
      *                                                                                     BUG23780
     C**********         ELSEIF    WSIdt = *BLANKS AND DDCRTP <> *BLANKS           BUG23780 BUG26250
     C                   IF        WSIdt = *BLANKS AND DDCRTP <> *BLANKS                    BUG26250
      *                                                                                     BUG23780
     C                   IF        OKCRTP = 'Y'                                             BUG23780
     C                   EVAL      Idx = Idx + 1                                            BUG23780
     C                   IF        PCalledF = 'A'                                           BUG23780
     C                   EVAL      OKCADT = 'N'                                             BUG23780
     C                   EVAL      FldNamXAr(Idx) = 'DDCADT'                                BUG23780
     C                   EVAL      MsgIdXAr(Idx) = 'USR9930'                                BUG23780
      *                                                                                     BUG23780
     C                   ELSEIF    PCalledF = 'V'                                           BUG23780
     C                   EVAL      OKCVDT = 'N'                                             BUG23780
     C                   EVAL      FldNamXAr(Idx) = 'DDCVDT'                                BUG23780
     C                   EVAL      MsgIdXAr(Idx) = 'USR9931'                                BUG23780
     C                   ENDIF                                                              BUG23780
     C                   ENDIF                                                              BUG23780
     C                   LEAVESR                                                            BUG23780
      *
      ** Validate that the Approval Date only contains numbers
      *
     C**********         ELSEIF    WSIdt <> *BLANKS AND DDETXS = 'S'                        BUG22912
     C**********         ELSEIF    WSIdt <> *BLANKS AND DDETXS = 'T'               BUG22912 BUG23892
     C                   ELSEIF    WSIdt <> *BLANKS                                         BUG23892
     C                   TESTN                   WSIdt                9798
      *
     C                   IF        *IN97 = *ON Or *IN98 = *ON
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    WSIdt
     C                   PARM                    BJDFIN
     C                   PARM                    ZDayno
     C                   ENDIF
      *
      ** Error if Approval date is not numeric or is an invalid date
      *
     C                   IF        *IN97 = *OFF AND *IN98 = *OFF
     C                             Or RetCodeOut = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   IF        PCalledF = 'A'
     C                   EVAL      OKCADT = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDCADT'
     C****************** EVAL      MsgIdXAr(Idx) = 'USR9008'                                  CER059
     C                   EVAL      MsgIdXAr(Idx) = 'USR9017'                                  CER059
      *
     C                   ELSEIF    PCalledF = 'V'
     C                   EVAL      OKCVDT = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDCVDT'
     C                   EVAL      MsgIdXAr(Idx) = 'USR8297'
     C                   ENDIF
      *
     C                   IF        BJDFIN = 'D'
     C                   EVAL      MsgDtaXAr(Idx) = 'DDMMYY'
     C                   ELSE
     C                   EVAL      MsgDtaXAr(Idx) = 'MMDDYY'
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WTmpDat = ZDayno
      *
      ** Date must not be greater than current date
      *
     C                   IF        WTmpDat > BJRDNB
     C                   EVAL      Idx = Idx + 1
     C                   IF        PCalledF = 'A'
     C                   EVAL      OKCADT = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDCADT'
     C****************** EVAL      MsgIdXAr(Idx) = 'USR9009'                                  CER059
     C                   EVAL      MsgIdXAr(Idx) = 'USR9018'                                  CER059
      *
     C                   ELSEIF    PCalledF = 'V'
     C                   EVAL      OKCVDT = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDCVDT'
     C                   EVAL      MsgIdXAr(Idx) = 'USR8298'
     C                   ENDIF
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial routine                                     *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    PCalledF
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OkFlags
     C                   PARM                    NwDlFilFmt
      *
     C                   ENDSR
     ******************************************************************
      /EJECT
     ******************************************************************
**  CPY@
(c) Finastra International Limited 2008
