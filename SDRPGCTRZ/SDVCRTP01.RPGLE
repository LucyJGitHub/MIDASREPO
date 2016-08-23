     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Certificate Type')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCRTP01 - Validate Certificate Type                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26250           Date 30Sep09               *
      *                 BUG23780           Date 24Apr09               *
      *                 BUG23892           Date 06May09               *
      *                 BUG22912           Date 17Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26250 - Customer Details By Country of Tax Maintenance    *
      *             Error. All cert. fields for all status should be  *
      *             optional.                                         *
      *  BUG23780 - No Validation on Cust Det Country of Tax          *
      *  BUG23892 - Certificate details should be mandatory if EU tax *
      *             status is 'S' and optional if it is 'T'           *
      *  BUG22912 - Threshold processing should be used if Exemption  *
      *             Certificate held                                  *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Exemption Certificate Types Retrieve Index
      *
     FSDECTYL0  IF   E           K DISK
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
      ** Array index
      *
     D Idx             S              3P 0
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
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZEROS
      *
      ** Validation
      *
     C                   EXSR      SRVCrtp
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCRTP = 'N'
     C                   EVAL      RetCodeOut = 'Error'
      *
     C                   ELSE
     C                   EVAL      CTCRTP = DDCRTP
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
      *  SRVCrtp - Subroutine to validate Certificate Type            *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVCrtp       BEGSR
      *
     C**********         IF        DDCRTP = *BLANKS AND DDETXS = 'S'                        BUG22912
     C**********         EVAL      OKCRTP = 'N'                                             BUG22912
     C**********         EVAL      Idx = Idx + 1                                            BUG22912
     C**********         EVAL      FldNamXAr(Idx) = 'DDCRTP'                                BUG22912
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8290'                                BUG22912
      *
     C**********         ELSEIF    DDCRTP <> *BLANKS AND DDETXS <> 'S'                      BUG22912
     C**********         IF        DDCRTP <> *BLANKS AND DDETXS <> 'T'             BUG22912 BUG26250
     C**********                   AND DDETXS <> 'S'                               BUG23892 BUG26250
     C**********         EVAL      OKCRTP = 'N'                                             BUG26250
     C**********         EVAL      Idx = Idx + 1                                            BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDCRTP'                                BUG26250
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8291'                                BUG26250
      *
     C**********         ELSEIF    DDETXS = 'S' AND DDCRTP = *BLANKS               BUG23892 BUG26250
      *                                                                                     BUG23892
     C**********         EVAL      OKCRTP = 'N'                                    BUG23892 BUG26250
     C**********         EVAL      Idx = Idx + 1                                   BUG23892 BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDCRTP'                       BUG23892 BUG26250
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8290'                       BUG23892 BUG26250
      *                                                                                     BUG23892
     C**********         ELSEIF    DDETXS = 'S'                                             BUG22912
     C**********         ELSEIF    DDETXS = 'S' AND DDCRTP <> *BLANKS              BUG22912 BUG23892
     C**********         ELSEIF    DDCRTP <> *BLANKS                               BUG23892 BUG23780
     C**********         ELSEIF    DDETXS = 'T' AND DDCRTP <> *BLANKS              BUG23780 BUG26250
      *                                                                                     BUG26250
      ** Send error message if Cert. type is invalid. If left blank, ignore, as             BUG26250
      ** all of the status are optional.                                                    BUG26250
      *                                                                                     BUG26250
     C                   IF        DDCRTP <> *BLANKS                                        BUG26250
     C     DDCRTP        CHAIN     SDECTYL0
      *
     C                   IF        %FOUND(SDECTYL0)
     C                   EVAL      OKCRTP = 'Y'
      *
     C                   ELSE
     C                   EVAL      OKCRTP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRTP'
     C                   EVAL      MsgIdXAr(Idx) = 'USR8292'
      *
     C                   ENDIF
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
(c) Misys International Banking Systems Ltd. 2008
