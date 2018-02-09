     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid Yield Rates Repair')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATRPR - Invalid Yield Rates Details Repair Function      *
      *                                                               *
      *  Function:  This function allows invalid yield rates details  *
      *             to be 'repaired' and applied to the Midas         *
      *             database.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 228364             Date 13Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 208179             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  228364 - Multiple fields in SDYRATRPR do not highlight       *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  208179 - 24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21  Indicator Used for Accessing Files                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRBrwInv - Browse Invalid Transactions                        *
      * SRRdNBrw - Read Next Browse Subfile Record                    *
      * SRResetErr - Reset Error Fields                               *
      * SRSndErr - Send a Message to Details Screen                   *
      * SRDispIni - Display Initial Screen                            *
      * SRValidate - Validate Input to Details Screen                 *
      * SRRetrieve - Retrieve Yield Rate Transaction                  *
      * SRConvert - Convert Yield Rates into Screen Format            *
      * SRConfirm - Confirm Screen Inputs                             *
      * SRUpdate - Updates Database                                   *
      * SRDelete - Delete Record                                      *
      * SRExitC - Exit Confirmation Screen                            *
      * SRSFKeys - Set Function Key Status on Screen                  *
      * SREnd - End Program                                           *
      * SRCancel - Cancel on Details Screen                           *
      * SRTDtDSubs - Transaction Details Data Substitution            *
      *                                                               *
      * *PSSR - Error Processing                                      *
      * *INZSR - Initial Processing                                   *
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
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSDIYRATL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIYRATD0:SDIYRATX0)
 
     FSDIYRATL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              208179
      ** API Invalid Log File from Support Database                                           208179
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)                                       208179
     F                                     COMMIT                                             208179
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDYRATR001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(ArrayMax3)
 
      ** Maturity Date
     D MatDateArr      S              7    DIM(98)
 
      ** Discount Factor
     D DiscFacArr      S             14    DIM(98)
 
      ** Current Yield Rates in File Format
     D CrYRFilFmt    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(C_)
 
      ** Current Yield Rates in Screen Format
     D CurYRScrn     E DS                  EXTNAME(SDYRATPD)
     D                                     PREFIX(C_)
 
      ** New Yield Rates in File Format
     D NwYRFilFmt    E DS                  EXTNAME(SDVYRATPD)
 
      ** New Yield Rates in Screen Format
     D NewYRScrn     E DS                  EXTNAME(SDYRATPD)
 
      ** Previous Yield Rates in File Format
     D PrvYRFilFmt   E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(P_)
 
      ** Previous Yield Rates in Screen Format
     D PrvYRScrn     E DS                  EXTNAME(SDYRATPD)
     D                                     PREFIX(P_)
 
      ** Error Indicators
     D OKYRFlags     E DS                  EXTNAME(SDEYRATPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Yield Rates Extra Data Layout File
     D ExtData       E DS                  EXTNAME(SDYREXPD)
 
      ** External DS for SAR details                                                          208179
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  208179
                                                                                              208179
      ** 24X7 status data area                                                                208179
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     208179
                                                                                              208179
      ** SD data area                                                                         208179
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     208179
                                                                                              208179
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for SDYRATRTV
     D PRetCodeOut     S             10A
     D PMode           S              6A
     D PRespMode       S              1A   INZ('S')
     D PFOTRID         S             20A
     D PActionOK       S              1A
     D PYLDCOK         S              1A
     D PYCCYOK         S              1A
     D PYICMOK         S              1A
     D PYCFQOK         S              1A
     D PKYCFQ          S              1A
 
      ** Parameters for SDYRATRPB
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PERRUP          S              1A
     D PERRMS          S              7A
     D POPSEL          S              1A
     D PACSEL          S              1A
     D PYLDC           S              5A
     D PYCCY           S              3A
     D PYICM           S              1A
     D PFOTRANSEL      S             20A
     D PTMESTPSEL      S             26Z
 
      ** Parameters for APDTASUBS
     D PReturnCode     S             10A
     D PSubsChar       S              1A
     D PIncData        S           2000A
     D PCurData        S           2000A
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field)
     D PFormat1        S             10A   INZ('SDYRATPD')
     D PField1         S             10A   INZ('#0ACTN')
     D PFldOffset1     S              5P 0
     D PFieldNo        S              5P 0
 
      ** Parameters for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** Enable Key Fields
     D PEKYFD          S              1A
 
      ** Enable F7, F8, F10 and F15 in Command Narrative
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
 
      ** Function Keys - 3,7,8,10,12 and 15
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Index of Errors and Warnings
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Variables used as counters
     D E               S              3P 0
     D F               S              3P 0
 
      ** Screen/Function
     D WScrn           S              1A
 
      ** Other Workfields
     D WIdx_PVAL       S              3P 0
     D PrvN_Warn       S              3P 0
     D WRdNb           S              1A
     D WYLDC           S              5A
     D WYCCY           S              3A
     D WYICM           S              1A
                                                                                              208179
      ** Fields defined for Enhancement CSC011                                                208179
                                                                                              208179
     D CSC011          S              1A                                                      208179
     D KMsgType        S              8A                                                      208179
     D PSard           S              6A                                                      208179
     D KFrntOffID      S                   LIKE(PFOTRANSEL)                                   208179
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   208179
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDYRATR002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDYRATR003
 
      ** Issue rollback to clear any possible updates in window functions
 
     C                   IF        PINKL = *ON
     C                   ROLBK
     C                   ENDIF
 
      /COPY WNCPYSRC,SDYRATR004
 
      ** DO Screen: Browse invalid inputs
 
     C                   IF        WScrn = 'I'
     C                   EXSR      SRBrwInv
     C                   ENDIF
 
      /COPY WNCPYSRC,SDYRATR005
 
      ** Read next browse subfile record
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,SDYRATR006
 
      ** DO WHILE screen
 
     C                   DOW       WScrn = 'A'
     C                   EXSR      SRDispIni
     C                   ENDDO
 
      ** Screen confirmation of input
 
     C     WScrn         IFEQ      'C'
     C                   EXSR      SRConfirm
     C                   ENDIF
 
      /COPY WNCPYSRC,SDYRATR007
 
      ** Do file updates
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,SDYRATR008
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDYRATR009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBrwInv - Browse Invalid Transactions                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SDYRATRPB, SREnd                                       *
      *                                                               *
      *****************************************************************
 
     C     SRBrwInv      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   MOVEL     *BLANKS       WRdNb
 
      ** Build browse subfile
 
     C                   CALLB     'SDYRATRPB'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *BLANKS       PRDSFL
     C                   PARM                    PERRUP
     C                   PARM      *BLANKS       PERRMS
     C                   PARM      *BLANKS       POPSEL
     C                   PARM      *BLANKS       PACSEL
     C                   PARM      *BLANKS       PYLDC
     C                   PARM      *BLANKS       PYCCY
     C                   PARM      *BLANKS       PYICM
     C                   PARM      *BLANKS       PFOTRANSEL
     C                   PARM                    PTMESTPSEL
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
      ** CSC011 indicator                                                                     208179
     C                   PARM                    CSC011                                       208179
 
      ** If error set on external switches
 
     C                   IF        PERRMS <> *BLANKS
     C                   EVAL      *INU6 = *ON
     C                   ENDIF
 
      ** If F3 or F12 taken in browse or error message, end program
 
     C                   IF        PINKC = *ON or PINKL = *ON or
     C                             PERRMS <> *BLANKS
     C                   EXSR      SREnd
     C                   ELSE
 
      ** Read next browse subfile record
 
     C                   EVAL      WRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdNBrw - Read Next Browse Subfile Record                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SDYRATRPB, SREnd, SRRetrieve, SRConvert, SRTDtDSubs,   *
      *        SRSndErr, SRResetErr                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'SDYRATRPB'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM      *BLANKS       PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM                    PERRUP
     C                   PARM      *BLANKS       PERRMS
     C                   PARM      *BLANKS       POPSEL
     C                   PARM      *BLANKS       PACSEL
     C                   PARM      *BLANKS       PYLDC
     C                   PARM      *BLANKS       PYCCY
     C                   PARM      *BLANKS       PYICM
     C                   PARM      *BLANKS       PFOTRANSEL
     C                   PARM                    PTMESTPSEL
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
      ** CSC011 indicator                                                                     208179
     C                   PARM                    CSC011                                       208179
 
      ** If F3 taken within invalid transaction deletion function,
      ** end program
 
     C                   IF        PINKC = *ON
     C                   EXSR      SREnd
     C                   GOTO      ERdNBrw
     C                   ENDIF
 
      ** If an invalid yield rate is read from subfile
 
     C                   IF        POPSEL <> *BLANKS
 
     C                   CLEAR                   NewYRScrn
 
      ** Reset errors fields
 
     C                   EXSR      SRResetErr
 
      ** Retrieve Yield Rates Details
 
     C                   EVAL      #0ACTN = PACSEL
     C                   EVAL      #0YLDC = PYLDC
     C                   EVAL      #0YCCY = PYCCY
     C                   EVAL      #0YICM = PYICM
     C                   EVAL      PFOTRID = PFOTRANSEL
 
      ** Make sure invalid transaction details are passed to 'Retrieve'
      ** module for SPF checking
 
     C     ZAYRATX0      CHAIN     SDIYRATL0                          21
 
      ** Set Retrieve Mode to '*FRONT' (Access using Front Office ID)
      ** If action selected is 'I' or not insert but the Transaction ID is
      ** blank, otherwise set retrieve mode to blank
 
     C                   IF        #0ACTN = 'I'
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   IF        #0YLDC = *BLANKS OR #0YCCY = *BLANKS OR
     C                             #0YICM = *BLANKS
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRRetrieve
 
      ** For the rest of the processing, set Mode of Operation
      ** to '*RPR  ' for the other modules to process transaction
      ** as coming from the repair function
 
     C                   EVAL      PMode = '*RPR  '
 
      ** If Yield Rates Details were retrieved, convert to screen format
 
     C                   IF        (C_FSYLDC <> *BLANKS and
     C                             C_FSYCCY <> *BLANKS and
     C                             C_FSYICM <> *BLANKS) and (#0ACTN <> 'I')
     C                   EXSR      SrConvert
     C                   MOVEL     CrYRFilFmt    NwYRFilFmt
     C                   ENDIF
 
      ** Now overwite the fields on the main details screen with those
      ** on the invalid yield rates file (except for the Midas Transaction
      ** Reference retrieved above using the Front Office Transaction ID).
      ** Access invalid transaction with Timestamp and Front Office Transaction ID.
      ** Transaction Details:
 
     C                   EVAL      WYLDC = #0YLDC
     C                   EVAL      WYCCY = #0YCCY
     C                   EVAL      WYICM = #0YICM
 
     C     ZAYRATX0      CHAIN     SDIYRATL0                          21
 
     C                   IF        (C_FSYLDC <> *BLANKS and
     C                             C_FSYCCY <> *BLANKS and
     C                             C_FSYICM <> *BLANKS) and (#0ACTN <> 'I')
     C                   EVAL      #0YLDC = WYLDC
     C                   EVAL      #0YCCY = WYCCY
     C                   EVAL      #0YICM = WYICM
     C                   ENDIF
 
      ** If Yield Rates Details were retrieved and this is an amendment,
      ** do data substitution if the substitution character is present
 
     C                   IF        (C_FSYLDC <> *BLANKS and
     C                             C_FSYCCY <> *BLANKS and
     C                             C_FSYICM <> *BLANKS) and (#0ACTN = 'A')
     C                             and (GHSUBS <> *BLANKS)
 
     C     GHSUBS        SCAN      NewYRScrn                              21
     C                   IF        *IN21 = *ON
     C                   EXSR      SRTDtDSubs
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Action Code or Transaction Reference are not OK,
      ** blank out Action Code so that the input cannot proceed
 
     C                   IF        PActionOK = 'N' or PYLDCOK = 'N' or
     C                             PYCCYOK = 'N' or PYICMOK = 'N'
     C                   EVAL      #0ACTN = *BLANKS
     C                   ENDIF
 
      ** Send error messages to details screen
 
     C                   EXSR      SRSndErr
     C                   EVAL      WScrn = 'A'
 
      ** No invalid yield rates read from subfile, go to browse screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'I'
     C                   ENDIF
 
     C     ERdNBrw       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRResetErr - Reset Error Fields                               *
      *                                                               *
      * Called By : SRRdNBrw, SRDispIni, SRValidate, SRConfirm,       *
      *             SRUpdate                                          *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRResetErr    BEGSR
 
     C                   RESET                   FldNameAr2
     C                   RESET                   MsgIDAr2
     C                   RESET                   MsgDtaAr2
     C                   RESET                   Idx
 
      ** Reset warning fields
 
     C                   RESET                   WFldNamAr2
     C                   RESET                   WMsgIDAr2
     C                   RESET                   WMsgDtaAr2
     C                   RESET                   WIdx
 
     C                   MOVE      *ALL'Y'       OKYRFlags
     C                   MOVE      *BLANKS       PERRMS
 
      ** Reset warning workfield
 
     C                   EVAL      WIdx_PVAL = *ZERO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send a Message to Details Screen                   *
      *                                                               *
      * Called by: SRRdNBrw                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   Z-ADD     Idx           E
 
      ** If there are fundamental errors in this transaction
      ** identify this fact
 
     C                   IF        PActionOK = 'N' or PYLDCOK = 'N' or
     C                             PYCCYOK = 'N' or PYICMOK = 'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameAr2(E)
     C                   MOVEL     'APM0110'     MsgIDAr2(E)
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     OKYRFlags     @EI
 
      ** Read error messages for transactions
 
     C     ZAYRATD0      SETLL     ZATRNERRD0
     C     ZAYRATD0      READE     ZATRNERRD0                             21
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN21 = *OFF
 
     C                   IF        ABFIELDID >= PFldOffset1
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameAr2(E)
     C                   MOVEL     ABMSGID       MsgIDAr2(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       PFldOffset1   F
     C                   IF        F < 1 or F > ArrayMax3
     C                   EVAL      F = 1
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZAYRATD0      READE     ZATRNERRD0                             21
     C                   ENDDO
 
     C                   MOVEA     @EI           OKYRFlags
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDispIni - Display Initial Screen                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSFKeys, SDYRATDSP, SREnd, SRCancel, SRValidate       *
      *        SRDelete, SRResetErr                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDispIni     BEGSR
 
      ** Save previous screen
 
     C                   EVAL      PrvYRScrn = NewYRScrn
     C                   Z-Add     WIdx_PVAL     PrvN_Warn
 
      ** Set function key narratives and field status
 
     C                   EXSR      SRSFKeys
 
      ** Write/Read Display Screen
 
     C                   CALLB     'SDYRATDSP'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM                    NewYRScrn
     C                   PARM                    MatDateArr
     C                   PARM                    DiscFacArr
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIDAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    OKYRFlags
     C                   PARM                    PEKYFD
     C                   PARM                    WriteOnly
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKG
     C                   PARM      *OFF          PINKH
     C                   PARM      *OFF          PINKJ
     C                   PARM      *OFF          PINKL
     C                   PARM      *OFF          PINKP
 
      ** Reset error fields
 
     C                   EXSR      SRResetErr
 
      ** Process function keys
 
     C     PINKC         CASEQ     *ON           SREnd
     C     PINKL         CASEQ     *ON           SRCancel
     C     PINKJ         CASEQ     *ON           SrDelete
     C                   CAS                     SRValidate
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Input to Details Screen                 *
      *                                                               *
      * Called by: SRDispIni                                          *
      *                                                               *
      * Calls: SDYRATVAL, SRRetrieve, SRResetErr                      *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** Save previous details in file format
 
     C                   MOVEL     NwYRFilFmt    PrvYRFilFmt
 
      ** Prior to validation, initialise error indicators as 'OK'
 
     C                   EXSR      SRResetErr
 
      ** Reset Yield Rates Valid file
 
     C                   CLEAR                   NwYRFilFmt
 
      ** Retrieve Yield Rates Details
 
     C                   EXSR      SRRetrieve
 
      ** If Action Code or Transaction Reference are not OK,
      ** display message
 
     C                   IF        PActionOK = 'N' or PYLDCOK = 'N' or
     C                             PYCCYOK = 'N' or PYICMOK = 'N'
     C                   GOTO      EndVal
     C                   ENDIF
 
      ** Validate Yield Rates Details
 
     C                   IF        (#0ACTN = 'I') OR (#0ACTN = 'A')
     C                   CALLB     'SDYRATVAL'
     C                   PARM                    PRespMode
     C                   PARM                    PMode
     C                   PARM                    NewYRScrn
     C                   PARM                    ExtData
     C                   PARM                    PrvYRFilFmt
     C                   PARM                    OKYRFlags
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIDAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    WIdx
     C                   PARM                    MatDateArr
     C                   PARM                    NwYRFilFmt
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EndVal
     C                   ENDIF
 
      ** If any screen defaulting or reformatting has occurred in validation
      ** or if the number of warnings has changed, re-display the screen
 
     C                   EVAL      WIdx_PVal = WIdx_PVal + WIdx
     C                   IF        NewYRScrn <> PrvYRScrn or
     C                             WIdx_PVal <> PrvN_Warn
     C                   GOTO      EndVal
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKYRFlags
     C                   MOVEL     *BLANK        WFldNamAr2
     C                   MOVEL     *BLANK        WMsgIDAr2
     C                   MOVEL     *BLANK        WMsgDtaAr2
 
      ** Confirm inputs
 
     C                   IF        (%SUBST(NewYRScrn:11) <> *BLANKS) and
     C                             (#0ACTN = P_#0ACTN) and (#0YLDC = P_#0YLDC)
     C                             AND (#0YCCY = P_#0YCCY)
     C                             AND (#0YICM = P_#0YICM)
     C                   EVAL      WScrn = 'C'
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndVal        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve - Retrieve Yield Rate Transaction                  *
      *                                                               *
      * Called by: SRRdNBrw, SRValidate                               *
      *                                                               *
      * Calls: SDYRATRTV                                              *
      *                                                               *
      *****************************************************************
 
     C     SRRetrieve    BEGSR
 
      ** Retrieve transaction
 
     C                   CALLB     'SDYRATRTV'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM                    PMode
     C                   PARM                    PRespMode
     C                   PARM                    #0ACTN
     C                   PARM                    #0YLDC
     C                   PARM                    #0YCCY
     C                   PARM                    #0YICM
     C                   PARM                    #0YCFQ
     C                   PARM                    #0SPDY                                       CAS008
     C                   PARM                    PFOTRID
     C                   PARM                    CrYRFilFmt
     C                   PARM                    PActionOK
     C                   PARM                    PYLDCOK
     C                   PARM                    PYCCYOK
     C                   PARM                    PYICMOK
     C                   PARM                    PYCFQOK
     C                   PARM                    OKSPDY                                       CAS008
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM      'N'           PKYCFQ
 
     C                   EVAL      OKYLDC = PYLDCOK                                           228364
     C                   EVAL      OKYCCY = PYCCYOK                                           228364
     C                   EVAL      OKYICM = PYICMOK                                           228364
     C                   EVAL      OKYCFQ = PYCFQOK                                           228364
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Convert Yield Rates into Screen Format            *
      *                                                               *
      * Called by: SRRdNBrw                                           *
      *                                                               *
      * Calls: SDYRATCVT                                              *
      *                                                               *
      *****************************************************************
 
     C     SRConvert     BEGSR
 
      ** Call program to fill screen fields with data
 
     C                   CALLB     'SDYRATCVT'
     C                   PARM                    PRetCodeOut
     C                   PARM                    CrYRFilFmt
     C                   PARM                    NewYRScrn
     C                   PARM                    MatDateArr
     C                   PARM                    DiscFacArr
 
      ** Update 'Current' transaction with transaction in screen format
 
     C                   EVAL      CurYRScrn = NewYRScrn
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConfirm - Confirm Screen Inputs                             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SDYRATDSP, SREnd, SRCancel, SRExitC, SRResetErr        *
      *                                                               *
      *****************************************************************
 
     C     SRConfirm     BEGSR
 
      ** If transaction is valid output message 'Press enter to accept'
 
     C                   IF        Idx = *ZERO
     C                   MOVEL     '*ANY'        FldNameAr2(1)
     C                   MOVEL     'USR9219'     MsgIDAr2(1)
     C                   ENDIF
 
     C                   CALLB     'SDYRATDSP'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM                    NewYRScrn
     C                   PARM                    MatDateArr
     C                   PARM                    DiscFacArr
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIDAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    OKYRFlags
     C                   PARM      'N'           PEKYFD
     C                   PARM      'Y'           WriteOnly
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKG
     C                   PARM      *OFF          PINKH
     C                   PARM      *OFF          PINKJ
     C                   PARM      *OFF          PINKL
     C                   PARM      *OFF          PINKP
 
      ** Reset error fields
 
     C                   EXSR      SRResetErr
 
      ** Process function keys
 
     C     PINKC         CASEQ     *ON           SREnd
     C     PINKL         CASEQ     *ON           SRCancel
     C                   CAS                     SRExitC
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Updates Database                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SDYRATUPD, *PSSR, SRResetErr                           *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** Update Front Office Transaction ID
 
     C                   EVAL      FSFOTR = PFOTRANSEL
 
      ** Update Yield Rates file
 
     C                   CALLB     'SDYRATUPD'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM                    NwYRFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, delete the invalid
      ** transaction actioned & commit the updates.
 
     C                   IF        PRetCodeOut <> *BLANKS and
     C                             PRetCodeOut <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
 
     C     ZAYRATD0      CHAIN     SDIYRATD0                          21
 
     C                   IF        *IN21 = *OFF
     C                   DELETE    SDIYRATD0
     C                   ENDIF
                                                                                              208179
      ** Delete invalid record from the log file.                                             208179
                                                                                              208179
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             208179
                                                                                              208179
     C                   EVAL      KMsgType = 'SDYRAT'                                        208179
     C                   EVAL      KFrntOffID = PFOTRANSEL                                    208179
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    208179
                                                                                              208179
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      208179
     C                   IF        *IN99 = *OFF                                               208179
     C                   DELETE    APILOGL0                                                   208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   ENDIF                                                                208179
 
     C                   COMMIT
     C                   ENDIF
 
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen
 
     C                   IF        PRetCodeOut = '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameAr2(1)
     C                   MOVEL     'USR9247'     MsgIDAr2(1)
     C                   EVAL      PERRUP = 'Y'
     C                   ELSE
     C                   EVAL      PERRUP = 'N'
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Else, return to the browse screen
 
     C                   CLEAR                   NewYRScrn
 
      ** Reset error fields
 
     C                   EXSR      SRResetErr
 
     C                   EVAL      WScrn = 'I'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Record                                      *
      *                                                               *
      * Called by: SRDispIni                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
      ** F10 taken, go on to update
 
     C                   EVAL      FSCHTP = #0ACTN
     C                   EVAL      WScrn = 'U'
     C/COPY WNCPYSRC,SDYRATRC04
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExitC - Exit Confirmation Screen                            *
      *                                                               *
      * Called by: SRConfirm                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRExitC       BEGSR
 
      ** No errors in validation, continue with updates
 
     C                   IF        Idx = *ZERO
     C                   EVAL      WScrn = 'U'
     C                   ELSE
 
      ** Go back to initial screen
 
     C                   EVAL      WScrn = 'A'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSFKeys - Set Function Key Status on Screen                  *
      *                                                               *
      * Called by: SRDispIni                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSFKeys      BEGSR
 
      ** According to Action Code, set WriteOnly Indicator
 
     C                   EVAL      PEINKG = 'N'
     C                   EVAL      PEINKH = 'N'
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKP = 'N'
     C                   EVAL      PEKYFD = 'N'
 
      ** Only make detail fields capable of input when the Option Selected
      ** is Update and the Action Code is either 'I' or 'A'
 
     C                   IF        (POPSEL = 'U') and (#0ACTN = 'I') or
     C                             (POPSEL = 'U') and (#0ACTN = 'A')
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
     C                   EVAL      WriteOnly = 'Y'
     C                   ENDIF
 
     C                   IF        #0ACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: SRRdNBrw, SRBrwInv, SRDispIni                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCancel - Cancel on Details Screen                           *
      *                                                               *
      * Called by: SRDispIni                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCancel      BEGSR
 
      ** If cancel was taken out from the confirmation screen, goto update
      ** screen
 
     C                   IF        WScrn = 'C'
     C                   EVAL      WScrn = 'A'
     C                   ELSE
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Else, return to the browse screen
 
     C                   EVAL      WScrn = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTDtDSubs - Transaction Details Data Substitution            *
      *                                                               *
      * Called by: SRRdNBrw                                           *
      *                                                               *
      * Calls: APDTASUBS                                              *
      *                                                               *
      *****************************************************************
 
     C     SRTDtDSubs    BEGSR
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier
 
     C                   CLEAR                   PIncDATA
     C                   CLEAR                   PCurDATA
 
     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      NewYRScrn     PIncDATA
     C                   PARM      CurYRScrn     PCurDATA
 
     C                   MOVEL     PIncDATA      NewYRScrn
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, AOAPIR0, *PSSR, ZACGTFLDNO                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDYRATRPR'
 
      ** Initialise data structures
 
     C                   CLEAR                   CurYRScrn
     C                   CLEAR                   CrYRFilFmt
     C                   CLEAR                   NewYRScrn
     C                   CLEAR                   NwYRFilFmt
     C                   CLEAR                   PrvYRScrn
 
      ** Initialise read next browse workfield
 
     C                   EVAL      WRdNb = *BLANKS
 
      ** Set screen to initial screen
 
     C                   MOVEL     'I'           WScrn
 
      ** Key lists
 
     C     ZAYRATD0      KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL
 
     C     ZAYRATX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    PFOTRANSEL
 
     C     KAPILOGL0     KLIST                                                                208179
     C                   KFLD                    KMsgType                                     208179
     C                   KFLD                    KFrntOffID                                   208179
     C                   KFLD                    KTimeStamp                                   208179
                                                                                              208179
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              208179
      ** Check if switchable feature CSC011 is switched on.                                   208179
                                                                                              208179
     C                   EVAL      CSC011 = 'N'                                               208179
                                                                                              208179
     C                   CALL      'AOSARDR0'                                                 208179
     C                   PARM      *BLANKS       PRtCd                                        208179
     C                   PARM      '*VERIFY'     POptn                                        208179
     C                   PARM      'CSC011'      PSard                                        208179
     C     SCSARD        PARM      SCSARD        DSFDY                                        208179
                                                                                              208179
      ** Database error                                                                       208179
                                                                                              208179
     C                   IF        (PRtCd <> *BLANKS) and                                     208179
     C                             (PRtCd <> '*NRF   ')                                       208179
     C                   EVAL      DBKEY = 'CSC011'                                           208179
     C                   EVAL      DBFILE = 'SCSARDPD'                                        208179
     C                   EVAL      DBASE = 903                                                208179
     C                   EXSR      *PSSR                                                      208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   IF        PRtCd = *BLANKS                                            208179
     C                   EVAL      CSC011 = 'Y'                                               208179
     C                   IN        SDSTAT                                                     208179
     C                   IN        SC24X7                                                     208179
     C                   ENDIF                                                                208179
 
      ** Get the field number for the Action Code field; the primary
      ** screen fields start from that number. Subtract one from it to
      ** give the value to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    PReturnCode
     C                   PARM                    PFormat1
     C                   PARM                    PField1
     C                   PARM                    PFieldNo
 
     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      PFldOffset1 = PFieldNo - 1
     C                   ENDIF
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDYRATR010
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,SDYRATRC05
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
