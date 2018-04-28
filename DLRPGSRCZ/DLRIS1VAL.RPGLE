     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 1 Validate')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRIS1VAL - Midas DL Reporting Information Screen 1 Validate *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD030648           Date 25Nov14               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 CSW213 *CREATE     Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030648 - Invalid SWIFT Characters error in RPIF tab for    *
      *             Clearing Broker fields                            *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** System Values
     D SVAL1           S             20A   INZ('DLSWIFTCtpyNonSWIFT')
     D SVAL2           S             20A   INZ('DLSWIFTCtpySWIFT')
 
      * Named Constant used to determine if a field contains invalid
      * characters for Telex and S.W.I.F.T.
 
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                      abcdefghijklmnopqrstuvwxyz-
     D                                      1234567890 /+-?:().,'''
 
     D Alpha           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ '
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DLRILK        E DS                  EXTNAME(DLRILKPD)
      * RPIF Link file
 
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
      * Fields to validate in screen 1
 
     D DLError1      E DS                  EXTNAME(DLERI1PD)
      * OK Flags for screen 1
 
     D DLVRFileFmt   E DS                  EXTNAME(DLVRPIPD)
      * Valid Deals layout
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
                                                                                              CSW214
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CSW214
      ** External DS for Currency Details                                                     CSW214
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSW214
      ** External DS for SAR Details                                                          CSW214
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSW214
      ** External DS for Long Dummy Data Structure                                            CSW214
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSW214
      ** External DS for Short Dummy Data Structure                                           CSW214
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Field in error
     D FldNamXAr       S             10A
 
      ** Error message ID
     D MsgIDXAr        S                   LIKE(#MsgId)
 
      ** Error message data
     D MsgDtaXAr       S                   LIKE(#MsgData)
 
      ** Field with warning
     D WFldNmXAr       S             10A
 
      ** Warning message ID
     D WMsgIDXAr       S                   LIKE(#MsgId)
 
      ** Warning message data
     D WMsgDtXAr       S                   LIKE(#MsgData)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      *
     D WRETCODE        S             10A
     D WStr            S              5S 0
     D WLen            S              5S 0
     D FVALID          S             10A
     D FVALFLD         S              6A
     D FldErrID        S              7A
     D R1CUS1          S              6A
     D R1CUS2          S              6A
     D R1CUS3          S              6A
     D FLDCHK          S             50A
     D @SCAN1          S              2S 0
     D @SCAN2          S              2S 0
     D @SCAN3          S              2S 0
     D P@Rtcd          S              7A
     D P@Optn          S              7A
     D PCusn           S             10A
     D PKySt           S              7A
     D FVALIDOK        S              1A
     D X               S              2S 0
     D I               S              3S 0
     D WRLCNUM         S             10A
     D CSW214          S              1A                                                      CSW214
     D CMG003          S              1A                                                      CSW214
     D POPTN           S              7A                                                      CSW214
     D PSARD           S              6A                                                      CSW214
     D WCURR           S              3A                                                      CSW214
     D BlankClrBr      S              1A                                                      CSW214
     D WBuyPMRT        S              1A                                                      CSW214
     D WSelPMRT        S              1A                                                      CSW214
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Do Validations in Sequence
 
      *
      ** Validate Trade Repository Identification
      *
     C                   IF        R1TRID <> *BLANKS
      *
     C                   MOVEL     R1TRID        FVALID
     C                   MOVEL     'R1TRID'      FVALFLD
     C                   MOVE      '5046028'     FldErrID
      *
     C                   EXSR      ValidEn
      *
     C                   EVAL      R1TRIDOK = FVALIDOK
 
     C                   IF        R1TRIDOK = ' '
     C                   MOVEL     BBCUST        R1CUS1
     C                   MOVEL     BBCRNM        R1TRNM
     C                   MOVEL     BBCRTN        R1TRTN
     C                   MOVEL     BBCSID        R1TRIS
     C                   MOVEL     R1TRID        CNUM1             1
 
     C                   IF        CNUM1 = '?'
     C                   MOVEL     BBCUST        R1TRID
     C                   ENDIF
 
     C                   IF        R1TRIS = *BLANKS
     C                   EVAL      WFldNmXAr = 'R1TRID'
     C                   EVAL      WMsgIDXAr = '5046029'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DLRIS1Detail <> *BLANKS
     C                             AND WRLCNUM <> RLCNUM
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      SVAL1         P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      SVAL2         P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200
 
     C                   MOVEL     RLCNUM        FVALID
     C                   EXSR      ValidEn
     C                   IF        BBCSID = *BLANKS
     C                   EVAL      R1TRID = P@VL01
     C                   ELSE
     C                   EVAL      R1TRID = P@VL02
     C                   ENDIF
     C                   MOVEL     R1TRID        FVALID
     C                   EXSR      ValidEn
     C                   MOVEL     BBCUST        R1CUS1
     C                   MOVEL     BBCRNM        R1TRNM
     C                   MOVEL     BBCRTN        R1TRTN
     C                   MOVEL     BBCSID        R1TRIS
     C                   EVAL      WRLCNUM = RLCNUM
 
     C                   ELSE
 
     C                   EVAL      R1CUS1 = *BLANKS
     C                   EVAL      R1TRNM = *BLANKS
     C                   EVAL      R1TRTN = *BLANKS
     C                   EVAL      R1TRIS = *BLANKS
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Central Counterparty Clearing House (CCP) ID
      *
     C                   IF        R1CCPI <> *BLANKS
 
     C                   MOVE      R1CCPI        FVALID
     C                   MOVE      'R1CCPI'      FVALFLD
     C                   MOVE      '5046030'     FldErrID
 
     C                   EXSR      ValidEn
 
     C                   EVAL      R1CCPIOK = FVALIDOK
     C                   IF        R1CCPIOK = ' '
     C                   MOVEL     BBCUST        R1CUS2
     C                   MOVEL     BBCRNM        R1CCPN
     C                   MOVEL     BBCRTN        R1CCPC
     C                   MOVEL     BBCSID        R1CCPS
     C                   MOVEL     CSLEIC        R1CCPL
     C                   MOVEL     R1CCPI        CNUM1
 
     C                   IF        CNUM1 = '?'
     C                   MOVEL     BBCUST        R1CCPI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      R1CUS2 = *BLANKS
     C                   EVAL      R1CCPN = *BLANKS
     C                   EVAL      R1CCPC = *BLANKS
     C                   EVAL      R1CCPS = *BLANKS
     C                   EVAL      R1CCPL = *BLANKS
     C                   ENDIF
      *
      ** Validate CCP Account
      *
     C                   IF        R1CCPA <> *BLANKS
 
     C                   EXSR      ResetErrs
 
     C                   IF        R1CCPI = *BLANKS
 
     C                   EVAL      FldNamXAr = 'R1CCPA'
     C                   EVAL      MsgIDXAr  = '5046032'
     C                   EVAL      R1CCPAOK = 'N'
     C                   EXSR      UpDatErrs
 
     C                   ELSE
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1CCPA        FLDCHK
     C                   EXSR      SwSet
 
     C                   IF        *IN99 = '1'
     C                   EVAL      FldNamXAr = 'R1CCPA'
     C                   EVAL      MsgIDXAr  = '5046031'
     C                   EVAL      R1CCPAOK  = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Clearing Exception Party Identification
      *
     C                   IF        R1CEPI <> *BLANKS
 
     C                   EVAL      FVALID   = R1CEPI
     C                   EVAL      FVALFLD  = 'R1CEPI'
     C                   EVAL      FldErrID = '5046033'
 
     C                   EXSR      ValidEn
 
     C                   MOVE      FVALIDOK      R1CEPIOK
 
     C                   IF        R1CEPIOK = ' '
     C                   MOVEL     BBCUST        R1CUS3
     C                   MOVEL     BBCRNM        R1CEPN
     C                   MOVEL     BBCRTN        R1CEPC
     C                   MOVEL     BBCSID        R1CEPS
     C                   MOVEL     CSLEIC        R1CEPL
     C                   MOVEL     R1CEPI        CNUM1
 
     C                   IF        CNUM1 = '?'
     C                   MOVEL     BBCUST        R1CEPI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      R1CUS3 = *BLANKS
     C                   EVAL      R1CEPN = *BLANKS
     C                   EVAL      R1CEPC = *BLANKS
     C                   EVAL      R1CEPS = *BLANKS
     C                   EVAL      R1CEPL = *BLANKS
     C                   ENDIF
      *
      ** Validate Clearing Exception Party Account
      *
     C                   IF        R1CEPA <> *BLANKS
 
     C                   EXSR      ResetErrs
     C                   IF        R1CEPI = *BLANKS
 
     C                   EVAL      FldNamXAr = 'R1CEPA'
     C                   EVAL      MsgIDXAr  = '5046035'
     C                   EVAL      R1CEPAOK  = 'N'
     C                   EXSR      UpDatErrs
 
     C                   ELSE
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1CEPA        FLDCHK
     C                   EXSR      SwSet
 
     C                   IF        *IN99 = '1'
     C                   EVAL      FldNamXAr = 'R1CEPA'
     C                   EVAL      MsgIDXAr  = '5046034'
     C                   EVAL      R1CEPAOK  = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Validate Clearing Broker ID (Client)
      *
     C                   IF        R1CBIC <> *BLANKS
 
     C                   EXSR      ResetErrs
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1CBIC        FLDCHK
     C                   EXSR      SwSet
 
     C                   IF        *IN99 = '1'
     C                   EVAL      FldNamXAr = 'R1CBIC'
     C                   EVAL      MsgIDXAr  = '5046036'
     C                   EVAL      R1CBICOK  = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
 
      *
      ** Validate Clearing Broker ID (CCP)
      *
     C                   IF        R1CBIH <> *BLANKS
 
     C                   EXSR      ResetErrs
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1CBIH        FLDCHK
     C                   EXSR      SwSet
 
     C                   IF        *IN99 = '1'
     C                   EVAL      FldNamXAr = 'R1CBIH'
     C                   EVAL      MsgIDXAr  = '5046037'
     C                   EVAL      R1CBIHOK  = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
                                                                                              CSW214
      ** Validate Clearing Broker                                                             CSW214
                                                                                              CSW214
     C                   EXSR      ChkPMRT                                                    CSW214
     C                   IF        R1CBRI <> *BLANKS                                          CSW214
                                                                                              CSW214
     C                   IF        BlankClrBr = 'Y'                                           CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R1CBRI'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047410'                                      CSW214
     C                   EVAL      R1CBRIOK = 'N'                                             CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FVALID = R1CBRI                                            CSW214
     C                   EVAL      FVALFLD = 'R1CBRI'                                         CSW214
     C                   EVAL      FldErrID = '5047306'                                       CSW214
     C                   EXSR      ValidEn                                                    CSW214
     C                   EVAL      R1CBRIOK = FVALIDOK                                        CSW214
                                                                                              CSW214
     C                   IF        R1CBRIOK = ' '                                             CSW214
     C                   EVAL      R1CBRI = BBCUST                                            CSW214
     C                   EVAL      R1CBNM = BBCRNM                                            CSW214
     C                   EVAL      R1CBTN = BBCRTN                                            CSW214
     C                   EVAL      R1CBSW = BBCSID                                            CSW214
     C                   EVAL      R1CBLC = CSLEIC                                            CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
                                                                                              CSW214
     C                   EVAL      R1CBNM = *BLANKS                                           CSW214
     C                   EVAL      R1CBTN = *BLANKS                                           CSW214
     C                   EVAL      R1CBSW = *BLANKS                                           CSW214
     C                   EVAL      R1CBLC = *BLANKS                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Clearing Broker's Party ID                                                  CSW214
                                                                                              CSW214
     C                   IF        R1CBRA <> *BLANKS                                          CSW214
                                                                                              CSW214
     C                   IF        R1CBRI = *BLANKS                                           CSW214
                                                                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R1CBRA'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047307'                                      CSW214
     C                   EVAL      R1CBRAOK = 'N'                                             CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
                                                                                              CSW214
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1CBRA        FLDCHK                                       CSW214
     C                   EXSR      SwSet                                                      CSW214
                                                                                              CSW214
     C                   IF        *IN99 = '1'                                                CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R1CBRA'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047308'                                      CSW214
     C                   EVAL      R1CBRAOK  = 'N'                                            CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
      *
      ** Validate Cleared Product ID
      *
     C     R1CPID        IFNE      *BLANKS
 
     C                   EXSR      ResetErrs
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1CPID        FLDCHK
     C                   EXSR      SwSet
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'R1CPID'      FldNamXAr
     C                   MOVEL     '5046038'     MsgIDXAr
     C                   MOVE      'N'           R1CPIDOK
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
 
      *
      ** Validate Execution Venue
      *
     C     R1EXVE        IFNE      *BLANKS
     C                   EXSR      VExcVenue
     C                   ENDIF
      *
      ** Validate Underlying Product ID
      *
     C                   IF        R1UPID <> *BLANKS
 
     C     Alpha         CHECK     R1UPID                                 99
     C                   IF        *IN99 = '1'
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R1UPID'
     C                   EVAL      MsgIDXAr  = '5046040'
     C                   EVAL      R1UPIDOK  = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
 
      *
      ** Validate Link Swap Identification
      *
     C                   IF        R1LSID <> *BLANKS
 
     C                   EXSR      ResetErrs
     C                   EVAL      FLDCHK = *BLANKS                                         MD030648
     C                   MOVEL     R1LSID        FLDCHK
     C                   EXSR      SwSet
     C                   IF        *IN99 = '1'
 
     C                   EVAL      FldNamXAr = 'R1LSID'
     C                   EVAL      MsgIDXAr  = '5046052'
     C                   EVAL      R1LSIDOK  = 'N'
     C                   EXSR      UpDatErrs
 
     C                   ELSE
 
     C     '//'          SCAN      R1LSID                                 98
     C                   EVAL      @SCAN1 = %SCAN('/' : %TRIM(R1LSID))
     C                   EVAL      @SCAN2 = %CHECKR (' ' : R1LSID)
     C                   EVAL      @SCAN3 = %SCAN('/' : R1LSID : @SCAN2)
     C                   IF        *IN98 = '1'
     C                             OR @SCAN1 =  1
     C                             OR @SCAN2 = @SCAN3
     C                   EVAL      FldNamXAr = 'R1LSID'
     C                   EVAL      MsgIDXAr  = '5046053'
     C                   EVAL      R1LSIDOK  = 'N'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      *
      ** If no errors set up outstanding fields for valid file
      *
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      ** Return to calling program
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     ValidEn       BEGSR
 
     C                   EXSR      ResetErrs
      *
      ** Check if the value entered is a valid customer
      *
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      FVALID        PCusn
     C                   PARM      *BLANKS       PKySt
     C                   PARM                    DSLDY
 
     C                   IF        P@Rtcd <> *BLANKS
     C                   EVAL      FVALIDOK  = 'N'
     C                   EVAL      FldNamXAr = FVALFLD
     C                   EVAL      MsgIdXAr  = FldErrID
     C                   EXSR      UpDatErrs
 
     C                   ELSE
     C                   EVAL      FVALIDOK = ' '
     C                   EVAL      WStr = %Len(SDCUST) + 1
     C                   EVAL      WLen = %Len(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     SwSet         BEGSR
 
     C                   EVAL      *IN99 = '0'
     C     ISO           CHECK     FLDCHK                                 99
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     VExcVenue     BEGSR
 
     C                   EXSR      ResetErrs
 
      * Validate Execution Venue
 
     C                   CALLB     'SDV0001'
 
     C                   PARM                    R1EXVE
     C                   PARM                    R1EXVEOK
 
     C                   IF        R1EXVEOK = 'N'
     C                   EVAL      FldNamXAr = 'R1EXVE'
     C                   EVAL      MsgIDXAr  = '5046043'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       CSW214
     C/EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
     C     ChkPMRT       BEGSR                                                                CSW214
                                                                                              CSW214
      **  Access Currency Details for transaction Buy Currency                                CSW214
                                                                                              CSW214
     C                   CALLB     'AOCURRR0'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
     C                   PARM      '*KEY    '    POPTN                                        CSW214
     C                   PARM      RLBCCY        WCURR                                        CSW214
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW214
                                                                                              CSW214
      ** Move Precious Metal Ind value to temporary workfield                                 CSW214
                                                                                              CSW214
     C                   IF        PRTCD = *BLANKS                                            CSW214
     C                   EVAL      WBuyPMRT = A6PMRT                                          CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Access Currency Details for transaction Sell Currency                                CSW214
                                                                                              CSW214
     C                   CALLB     'AOCURRR0'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
     C                   PARM      '*KEY    '    POPTN                                        CSW214
     C                   PARM      RLSCCY        WCURR                                        CSW214
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW214
                                                                                              CSW214
      ** Move Precious Metal Ind value to temporary workfield                                 CSW214
                                                                                              CSW214
     C                   IF        PRTCD = *BLANKS                                            CSW214
     C                   EVAL      WSelPMRT = A6PMRT                                          CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** If CMG003 is *ON, Clearing Broker must be blanks if and only if                      CSW214
      ** currency (Buy or Sell) is flagged as precious metal                                  CSW214
                                                                                              CSW214
     C                   EVAL      BlankClrBr = 'N'                                           CSW214
     C                   IF        CMG003 = 'Y'                                               CSW214
     C                   IF        (WBuyPMRT = 'Y' AND WSelPMRT = 'N') OR                     CSW214
     C                             (WBuyPMRT = 'N' AND WSelPMRT = 'Y')                        CSW214
     C                   EVAL      BlankClrBr = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     SetupValid    BEGSR
 
      *
      ** Move validated fields to DLVRPIPD fields
      *
     C                   MOVEL     R1CUS1        RVTRID
     C                   MOVEL     R1CUS2        RVCCPI
     C                   MOVEL     R1CCPA        RVCCPA
     C                   MOVEL     R1CUS3        RVCEPI
     C                   MOVEL     R1CEPA        RVCEPA
     C                   MOVEL     R1CBIC        RVCBCI
     C                   MOVEL     R1CBIH        RVCBPI
     C                   MOVEL     R1CPID        RVPRID
     C                   MOVEL     R1EXVE        RVEXVE
     C                   MOVEL     R1UPID        RVUPID
     C                   MOVEL     R1LSID        RVLSID
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   MOVEL     R1CBRI        RVCBRI                                       CSW214
     C                   MOVEL     R1CBRA        RVCBRA                                       CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    WRETCODE
     C                   PARM                    DLRILK
     C                   PARM                    DLRIS1Detail
     C                   PARM                    DLError1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRFileFmt
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'DLRIS1VAL'   DBPGM
     C                   OUT       LDA
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
                                                                                              CSW214
      ** Check if switchable feature CMG003 is switched on                                    CSW214
                                                                                              CSW214
     C                   CALLB     'AOSARDR0'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
     C                   PARM      '*VERIFY '    POPTN                                        CSW214
     C                   PARM      'CMG003'      PSARD                                        CSW214
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW214
                                                                                              CSW214
     C                   IF        PRTCD = *BLANKS                                            CSW214
     C                   EVAL      CMG003 = 'Y'                                               CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CMG003 = 'N'                                               CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Check if Swift 2014 Changes is installed.                                            CSW214
                                                                                              CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
                                                                                              CSW214
     C                   IF        PRTCD = 'CSW2014'                                          CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErrs - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UpDatErrs - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UpDatErrs     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C     FldNamXAr     IFNE      *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = '1'
     C                   EVAL      FldNameArr(I) = FldNamXAr
     C                   EVAL      MsgIdArr(I)   = MsgIDXAr
     C                   EVAL      MsgDtaArr(I)  = MsgDtaXAr
     C                   END
      *
     C                   Z-ADD     I             Idx
 
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   IF        WFldNmXAr <> *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = '1'
     C                   EVAL      WFldNamArr(I) = WFldNmXAr
     C                   EVAL      WMsgIDArr(I)  = WMsgIDXAr
     C                   EVAL      WMsgDtaArr(I) = WMsgDtXAr
     C                   END
      *
     C                   Z-ADD     I             WIdx
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
