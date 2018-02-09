     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP Transaction Type')                *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOTRTYP - Validate OP Transaction Type                     *
      *                                                               *
      *  Component of: FTOPAY1SN                                      *
      *                FTOPAY2SN                                      *
      *                FTOPAYRPR                                      *
      *                FTOPAYCTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 CER059             Date 19Jul10               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
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
      *
      ** Outgoing Payments Transaction type - screen format
      *
     D TranInFiftA   E DS                  EXTNAME(FTOPY7APD)
      *
      ** Valid Payments layout
      *
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
      *
      ** Flags to indicate whether transaction fields are valid
      *
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY5PD)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External DS for Retail Transaction Types Details
      *
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      *
      ** External DS for Network Transaction Identifier File
      *
     D SDNTTI        E DS                  EXTNAME(SDNTTIPD)
      ** Short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D PRtty           S              5A
     D PNwrk           S              6A
      *
     D CFT014          S              1A
     D PSard           S              6A
     D POptn           S              7A
     D PTtcd           S             10A
      *
     D RespMode        S              1A
     D STRTC           S              3A
     D O2TTCD          S              3A
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
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Validate Transaction type
      *
     C                   EXSR      SRTrty
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKRTTY = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
      *
      ** Move value to valid file
      *
     C                   EVAL      OTRTTY = SRTTY
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrty - Transaction Type validation subroutine              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTrty        BEGSR
      *
      ** Default Transaction type code from transaction type
      *
     C                   IF        STRTC = *BLANKS AND CFT014 = 'Y'
     C                             AND SRTTY  <> *BLANKS
      *
     C                   CALL      'AONTTIR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      SRTTY         PRtty
     C                   PARM      '*FT'         PNwrk
     C     SDNTTI        PARM      SDNTTI        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*NRF'
      *
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   IF        NINTTI <> *BLANKS
     C                   MOVEL     NINTTI        O2TTCD
     C                   MOVEL     NINTTI        STRTC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        SRTTY  <> *BLANKS
      *
      ** If Transaction code and transaction type has to be linked
      *
     C                   IF        CFT014 = 'Y'
      *
     C                   CALL      'AONTTIR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C     SRTTY         PARM      SRTTY         PRtty
     C                   PARM      STRTC         PTtcd
     C                   PARM      *BLANKS       DSFDY
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NOSEL'
     C                   EVAL      OKRTTY = 'N'
     C                   EVAL      MsgIdXAr(1) = 'FTM3264'
     C                   EVAL      FldNamXAr(1) = 'SRTTY'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C     SRTTY         PARM      SRTTY         PRtty
     C     SDRETR        PARM      SDRETR        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NOSEL'
     C                   EVAL      OKRTTY = 'N'
     C                   EVAL      MsgIdXAr(1) = 'FTM5055'
     C                   EVAL      FldNamXAr(1) = 'SRTTY'
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
     C                   PARM                    RetCodeIn
      *
      ** Outgoing Payments Transaction type - Screen format
      *
     C                   PARM                    TranInFiftA
      *
      ** Outgoing Payments Transaction Code from screen 2 level 2 for
      ** defaulting value of Retail Transaction Type
      *
     C                   PARM                    STRTC
      *
     C                   PARM                    RespMode
      *
      ** OUTPUT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Outgoing Payments Margin info error indicators
      *
     C                   PARM                    OKFlagsDS
      *
      ** Outgoing Payments for file update - file format
      *
     C                   PARM                    ValidPmnt
      *
      ** Extension Valid File Value for Transaction code
      *
     C                   PARM                    O2TTCD
      *
      ** Check the switchable feature CFT014
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT014'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CFT014 = 'Y'
     C                   ELSE
      *
     C                   IF        PRtcd <> '*NRF'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '*VERIFY'
     C                   ELSE
     C                   EVAL      CFT014 = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
** CPY@
(c) Finastra International Limited 2008
