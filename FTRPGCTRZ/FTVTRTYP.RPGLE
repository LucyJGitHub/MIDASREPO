     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP Transaction Type')                *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVTRTYP - Validate IP Transaction Type                      *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      ** Incoming Payments Extended Narrative incoming transaction
      ** - screen format
      *
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)
      *
      ** Incoming Payments Margin info error indicators
      *
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)
      *
      ** Incoming Payments for file update - file format
      *
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External DS for Retail Transaction Types Details
      *
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      *
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
     D KRtty           S              5A
     D KNwrk           S              6A
      *
     D PMode           S              6A
     D DDTTCD          S              3A
     D I2INTTCD        S              3A
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
     C                   EVAL      IPRTTY = DDRTTY
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
     C                   IF        DDTTCD = *BLANKS AND CFT014 = 'Y'
     C                             AND DDRTTY <> *BLANKS
     C                   EVAL      KRtty = DDRTTY
     C                   EVAL      KNwrk ='*FT'
      *
     C                   CALL      'AONTTIR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      KRtty         PRtty
     C                   PARM      KNwrk         PNwrk
     C     SDNTTI        PARM      SDNTTI        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*NRF'
      *
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   IF        NINTTI <> *BLANKS
     C                   MOVEL     NINTTI        I2INTTCD
     C                   MOVEL     NINTTI        DDTTCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDRTTY <> *BLANKS
      *
      ** If Transaction code and transaction type has to be linked
      *
     C                   IF        CFT014 = 'Y'
      *
     C                   CALL      'AONTTIR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C     DDRTTY        PARM      DDRTTY        PRtty
     C                   PARM      DDTTCD        PTtcd
     C                   PARM      *BLANKS       DSFDY
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NOSEL'
     C                   EVAL      OKRTTY = 'N'
     C                   EVAL      MsgIdXAr(1) = 'FTM3264'
     C                   EVAL      FldNamXAr(1) = 'DDRTTY'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C     DDRTTY        PARM      DDRTTY        PRtty
     C     SDRETR        PARM      SDRETR        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NOSEL'
     C                   EVAL      OKRTTY = 'N'
     C                   EVAL      MsgIdXAr(1) = 'FTM5055'
     C                   EVAL      FldNamXAr(1) = 'DDRTTY'
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
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Extended Narratives incoming transaction
      ** - screen format
      *
     C                   PARM                    NwIP6AScnFmt
      *
      ** Incoming Payments Transaction Code from screen 2 level 2 for
      ** defaulting value of Retail Transaction Type
      *
     C                   PARM                    DDTTCD
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
      *
     C                   PARM                    PMode
      *
      ** OUTPUT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Margin info error indicators
      *
     C                   PARM                    FTEIPY5
      *
      ** Incoming Payments for file update - file format
      *
     C                   PARM                    NwIPFilFmt
      *
      ** Extension Valid File Value for Transaction code
      *
     C                   PARM                    I2INTTCD
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
      ** Key List for file AONTTIR0
      *
     C     KTransTyp     KLIST
     C                   KFLD                    KRtty
     C                   KFLD                    KNwrk
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
(c) Misys International Banking Systems Ltd. 2008
