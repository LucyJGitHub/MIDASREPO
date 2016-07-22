     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE item Two Oclock Validation')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVTWOCLK - Midas GL JE Item Two O'clock Validation          *
      *                                                               *
      *  Function:  This module will validate the Debit/Credit        *
      *             indicator, Value Date and Amount entered.         *
      *                                                               *
      ** +---------------------------------------------------------+ **
      *                                                               *
      *  Component of: GLBITPVAL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD039509           Date 13Jul16               *
      *  Prev Amend No. MD039309           Date 08Jun16               *
      *                 MD035554           Date 25May16               *
      *                 MD033630           Date 11May16               *
      *                 MD027587           Date 19Jun14               *
      *                 MD000091           Date 08May13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
/*    *                 BUG10792           Date 07Mar06               *
      *                 CRE023  *CREATE    Date 29Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039509 - Able to insert a Reversal without a prior insert  *
      *             of an Outward Clearing Check. Included the        *
      *             checking of amount for today's reversal           *
      *  MD039309 - Unable to Edit/Delete CRE023 Credit Journal Entry *
      *             Reversed some of the MD033630 fixes that were     *
      *             affected by the changes in MD035554 regarding the *
      *             updating of files during insert/accept            *
      *  MD035554 - 2o'clock/ABC compatibility                        *
      *  MD033630 - Credit Entries are not being validated on AMEND   *
      *             and DELETE. Debit Entries amount need not be      *
      *             validated on DELETE.                              *
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
/*    *  BUG10792- File sharing problems                              *
      *  CRE023 - 2 O'Clock Flag Upgrade to MidasPlus.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRINIT - Initialisation subroutine                            *
      * SRDbtCdt - Validation of Debit/Credit Indicator               *
      * SRValDte - Validation of the Value Date                       *
      * SRAmt  - Validation of amount                                 *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FREMEMLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     PREFIX(S_)
      *
      ** Midas RE Shadow balances
      *
     FRETTYPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** Midas Outward Clearing Transaction types
      *
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** Midas Journal Entry posting
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------

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

     D P_TrnScnFmt   E DS                  EXTNAME(GLBITPPD)
     D P_TrnFilFmt   E DS                  EXTNAME(GLVBITPPD)
     D                                     PREFIX(G)
     D P_TrnOkFlg    E DS                  EXTNAME(GLEBITPPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D P_RtnCode       S             10
     D P_BJRDNB        S              5  0
     D P_Idx           S              3  0
     D P_WIdx          S              3  0

     D K_BTBINB        S                   LIKE(BTBINB)
     D K_BTBTNB        S                   LIKE(BTBTNB)

     D WCMPAMT         S             15  0

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
     D CAP207          S              1                                                     MD039309
      ** Account balance Check                                                              MD039309
                                                                                            MD039309
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD039309
      ** Externally described DS for SAR details                                            MD039309
                                                                                            MD039309
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD039309
      ** DS for access programs - short data structure                                      MD039309
                                                                                            MD039309
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

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

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   IF        GB2ACTY = 'R'
      *
     C                   EXSR      SRInit
      *
      ** Continue the validation if transaction type is an out clearing
     C                   IF        GOCLR = 'Y'
     C                             OR GRCLT = 'Y'
     C                             OR GRCLP = 'Y'
      *
     C                   EXSR      SRDbtCdt
     C                   IF        (GRCLP = 'Y')
     C                             AND (P_Idx = 0)
     C                   EXSR      SRValDte
     C                   ENDIF
     C                   IF        GRCLT = 'Y'
     C                             And DDACTN <> 'D'                                        MD033630
     C                             OR GRCLP = 'Y'
     C                             And DDACTN <> 'D'                                        MD033630
     C                             Or GOCLR = 'Y' And DDACTN <> 'I'                         MD033630
     C                   IF        DDVLDTOK = 'Y'
     C                   EXSR      SRAmt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRINIT - Initialize Subroutine                                *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Open all files
      *
     C                   OPEN      REMEMLL0
     C                   OPEN      RETTYPL0
     C                   OPEN      GLJENPL1
      *
     C     GB2TRTY       CHAIN     RETTYPL0
     C                   IF        NOT(%FOUND)
     C                   EVAL      GOCLR = *BLANK
     C                   EVAL      GRCLT = *BLANK
     C                   EVAL      GRCLP = *BLANK
     C                   GOTO      ENDINIT                                      BUG10792
     C*******************LEAVESR                                                BUG10792
     C                   ENDIF
      *
     C     GB2RACN       CHAIN     REMEMLL0
      *
     C                   IF        DDACTN = 'A'
     C                   EVAL      K_BTBTNB = GB2BTNB
     C                   EVAL      K_BTBINB = GB2BINB
     C     K_GLJEN       CHAIN     GLJENPL1
     C                   ENDIF
      *
     C     ENDINIT       TAG                                                    BUG10792
     C                   CLOSE     REMEMLL0
     C                   CLOSE     RETTYPL0
     C                   CLOSE     GLJENPL1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRDbtCdt - Validation of Debit/Credit Indicator               *
      *                                                               *
      *****************************************************************
      *
     C     SRDbtCdt      BEGSR
      *
      ** Validate only if user has entered a valid transaction type.
      *
     C                   IF        DDTRTYOK = 'Y'
      *
      ** Must be credit for outward clearing items
      *
     C                   IF        (GOCLR = 'Y') AND (DDDCIN <> 'C')
     C                   EVAL      DDDCINOK         = 'N'
     C                   EVAL      P_Idx            =  P_Idx + 1
     C                   EVAL      FldNameArr(P_Idx) = 'DDDCIN'
     C                   EVAL      MsgIdArr(P_Idx)  = 'SGX0035'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Must be debit for Reverse Today's Outward Clearing Items
      *
     C                   IF        (GRCLT = 'Y') AND (DDDCIN <> 'D')
     C                   EVAL      DDDCINOK         = 'N'
     C                   EVAL      P_Idx            =  P_Idx + 1
     C                   EVAL      FldNameArr(P_Idx) = 'DDDCIN'
     C                   EVAL      MsgIdArr(P_Idx)  = 'SGX0035'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Must be debit for Reverse Previous Outward Clearing Items
      *
     C                   IF        (GRCLP = 'Y') AND (DDDCIN <> 'D')
     C                   EVAL      DDDCINOK         = 'N'
     C                   EVAL      P_Idx            =  P_Idx + 1
     C                   EVAL      FldNameArr(P_Idx) = 'DDDCIN'
     C                   EVAL      MsgIdArr(P_Idx)  = 'SGX0035'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRValDte - Validation of the Value Date                       *
      *                                                               *
      *****************************************************************
      *
     C     SRValDte      BEGSR
      *
      ** Validation is executed only if the user has entered a valid
      ** transaction type and value date.
      *
     C                   IF        (DDTRTYOK = 'Y') AND
     C                             (DDVLDTOK = 'Y')
      *
      ** If a retail item with a Reverse Previous Outward Clearing
      ** transaction has a forward value date, flag as error.
      *
     C                   IF        (GB2VLDT > P_BJRDNB)
     C                   EVAL      DDVLDTOK         = 'N'
     C                   EVAL      P_Idx            = P_Idx + 1
     C                   EVAL      FldNameArr(P_Idx) = 'DDVLDT'
     C                   EVAL      MsgIdArr(P_Idx)  = 'SGX0037'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRAmt - Validation of amount                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAmt         BEGSR
      *
      ** Validation is executed only if the user has entered a valid
      ** amount.
      *
     C                   IF        DDPTAMOK = 'Y'
      *
      ***Do*not*validate*Today's*Outward*clearing*transactions*if******                     MD039509
      ***their*value*date*has*not*been*reached*yet.********************                     MD039509
      *
     C**********         IF        (GRCLT = 'Y') AND                                        MD039509
     C**********                   (GB2VLDT > P_BJRDNB)                                     MD039509
     C**********         LEAVESR                                                            MD039509
     C**********         ENDIF                                                              MD039509
      *
      ** A record of the account must exist on REMEMLPD and its
      ** record ID must be 'L'
      *
     C                   IF        (NOT (%FOUND(REMEMLL0))) OR
     C                              S_GRECI <> 'L'
     C                   EVAL      DDPTAMOK          = 'N'
     C                   EVAL      P_Idx             = P_Idx + 1
     C                   EVAL      FldNameArr(P_Idx) = 'DDPTAM'
     C                   EVAL      MsgIdArr(P_Idx)   = 'SGX0039'
     C**********         EVAL      MsgDtaArr(P_Idx)  = GB2CUST + GB2CYCD                    MD000091
     C**********                                       + GB2ACCD + GB2ACSN                  MD000091
     C                   EVAL      BLen = %Len(%Trim(GB2CUST))                              MD000091
     C                   EVAL      MsgDtaArr(P_Idx) = LenStr +%TRIM(GB2CUST)                MD000091
     C                   EVAL      BLen = %Len(%Trim(GB2CYCD))                              MD000091
     C                   EVAL      MsgDtaArr(P_Idx) = %TRIM(MsgDtaArr(P_Idx))               MD000091
     C                                            + LenStr +%TRIM(GB2CYCD)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(GB2ACCD))                              MD000091
     C                   EVAL      MsgDtaArr(P_Idx) = %TRIM(MsgDtaArr(P_Idx))               MD000091
     C                                            + LenStr +%TRIM(GB2ACCD)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(GB2ACSN))                              MD000091
     C                   EVAL      MsgDtaArr(P_Idx) = %TRIM(MsgDtaArr(P_Idx))               MD000091
     C                                            + LenStr +%TRIM(GB2ACSN)                  MD000091
     C                   LEAVESR
     C                   ENDIF
      *
      ** If amend, then add the posting amount in GLJENPPD to the
      ** posting amount on the Outward Clearing File to get the
      ** comparison amount.
      *
     C                   IF        DDACTN = 'A'
      *
     C                   IF        GRCLT = 'Y'
     C                   EVAL      WCMPAMT = S_GTAMT + BTPTAM
     C                   ENDIF
      *
     C                   IF        GRCLP = 'Y'
     C                   EVAL      WCMPAMT = S_GPAMT + BTPTAM
     C                   ENDIF
      *
     C                   If        GOCLR = 'Y'                                              MD033630
     C                             And CAP207 = 'N'                                         MD039309
     C                   Eval      WCMPAMT = BTPTAM - S_GTAMT                               MD033630
     C                   EndIf                                                              MD033630
      *                                                                                     MD033630
     C                   ELSE
      *
      ** If not amending an existing amount, set the comparison
      ** amount to the posting amount stored on the Outward Clearing
      ** file.
      *
     C                   IF        GRCLP = 'Y'
     C                   EVAL      WCMPAMT = S_GPAMT
     C                   ELSE
     C                   EVAL      WCMPAMT = S_GTAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The entered amount must not be greater than the comparison
      ** amount.
      *
     C                   IF        GB2PTAM > WCMPAMT
     C                             And GOCLR <> 'Y'                                         MD033630
     C                             Or GB2PTAM > WCMPAMT And GOCLR = 'Y' And                 MD033630
     C                                DDACTN = 'D'                                          MD033630
     C                                And GB2VLDT > P_BJRDNB                                MD035554
     C                                And CAP207 = 'N'                                      MD039309
     C                             Or GB2PTAM < WCMPAMT And GOCLR = 'Y' And                 MD033630
     C                                DDACTN = 'A'                                          MD033630
     C                                And CAP207 = 'N'                                      MD039309
     C                   EVAL      DDPTAMOK = 'N'
     C                   EVAL      P_Idx             = P_Idx + 1
     C                   EVAL      FldNameArr(P_Idx) = 'DDPTAM'
     C                   EVAL      MsgIdArr(P_Idx)   = 'SGX0038'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    P_RtnCode
     C                   PARM                    P_TrnScnFmt
     C                   PARM                    P_TrnFilFmt
     C                   PARM                    P_BJRDNB
      *
      ** Output parms
      *
     C                   PARM                    P_TrnOkFlg
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    P_Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    P_WIdx
      *
     C     K_GLJEN       KLIST
     C                   KFLD                    K_BTBTNB
     C                   KFLD                    K_BTBINB
      *                                                                                     MD039309
      ** Check for Account Balance Check Flag                                               MD039309
      *                                                                                     MD039309
     C                   EVAL      CAP207 = 'N'                                             MD039309
     C                   CALLB     'AOSARDR0'                                               MD039309
     C                   PARM      *BLANKS       @RTCD                                      MD039309
     C                   PARM      '*VERIFY'     @OPTN                                      MD039309
     C                   PARM      'CAP207'      @SARD                                      MD039309
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD039309
      *                                                                                     MD039309
      ** An NRF (No Record Found) return code is valid.  Issue database error               MD039309
      ** only for error return codes.                                                       MD039309
      *                                                                                     MD039309
     C                   IF        (@RTCD <> *BLANKS) AND                                   MD039309
     C                             (@RTCD <> '*NRF   ')                                     MD039309
     C                   EVAL      DBKEY = 'CAP207'                                         MD039309
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD039309
     C                   EVAL      DBASE = 11                                               MD039309
     C                   EXSR      *PSSR                                                    MD039309
     C                   ENDIF                                                              MD039309
      *                                                                                     MD039309
     C                   IF        @RTCD = *BLANK                                           MD039309
     C                   EVAL      CAP207 = 'Y'                                             MD039309
     C                   ENDIF                                                              MD039309
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *inu7 = *ON
     C                   EVAL      *inu8 = *ON
     C                   EVAL      *INLR = *ON

     C                   IF        RunBefore <> 'Y'

     C                   EVAL      RunBefore = 'Y'
      *
      ** Load the APDUMP fields
      *
     C     *LOCK         IN        APDUMP                               88
      *
      ** If there is an error in reading the APDUMP data area, it
      ** probably doesn't exist, so call the procedure which creates it
      ** and try again.
      *
     C                   IF        *in88

     C                   CLEAR                   PSSRRetCde
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PSSRRetCde       10

     C     *LOCK         IN        APDUMP

     C                   ENDIF

     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      P_RtnCode = '*ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
