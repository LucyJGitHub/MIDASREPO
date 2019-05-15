     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid Additional Custmr Details Repair')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDACUDRPR - Invalid Additional Customer Detials              *
      *              Repair Function                                  *
      *                                                               *
      *  Function:  This function allows invalid Additional Customer  *
      *             details to be 'repaired' and applied to the       *
      *             Midas database.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25533           Date 19Aug09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER034             Date 16Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. CSW207A            Date 06Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD029             Date 22Aug05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *           (Recompile)                                         *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes (Recompile)                     *
      *  CSD029 - Customer Details Additional Fields                  *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation on Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas API Transaction errors by FO ID & Timestamp
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Invalid ACUD by Timestamp & FOID
     FSDIACUDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIACUDD0:SDIACUDX0)
 
      ** Midas SD Invalid ACUD by FOID & Timestamp
     FSDIACUDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid Log File from Support Database
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
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
 
     D @EI             S              1    DIM(60)
 
      ** Array of Fields in error, temporary store
     D TmpFldNmAr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs, temporary store
     D TmpMsgIdAr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      * Current Additional Customer in File Format
     D CrCuFilFmt    E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(C_)
 
      ** Current Additional Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDACUDPD)
     D                                     PREFIX(@)
 
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVACUDPD)
 
      ** New Additional Customer in Screen Format - Primary Details
     D NewCuPrim     E DS                  EXTNAME(SDACUDPD)
 
      ** Previous Additional Customer in Screen Format - Primary Details
     D PrvCuPrim     E DS                  EXTNAME(SDACUDPD)
     D                                     PREFIX(@P)
 
      ** Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDEACUDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
                                                                                              CSD029
     D SVALSCRN        DS           250                                                       CSD029
     D  DDDS01                 1     25                                                       CSD029
     D  DDDS02                26     50                                                       CSD029
     D  DDDS03                51     75                                                       CSD029
     D  DDDS04                76    100                                                       CSD029
     D  DDDS05               101    125                                                       CSD029
     D  DDDS06               126    150                                                       CSD029
     D  DDDS07               151    175                                                       CSD029
     D  DDDS08               176    200                                                       CSD029
     D  DDDS09               201    225                                                       CSD029
     D  DDDS10               226    250                                                       CSD029
      *                                                                                      CER034A
      ** Current Customer Details Screen - 2 format                                          CER034A
      *                                                                                      CER034A
     D CurCustDet2   E DS                  EXTNAME(SDACU3DPD)                                CER034A
     D                                     PREFIX(C1)                                        CER034A
      *                                                                                      CER034A
      ** Current Customer Details Screen - 2 format                                          CER034A
      *                                                                                      CER034A
     D CurCustDet3   E DS                  EXTNAME(SDACU4DPD)                                CER034A
     D                                     PREFIX(C2)                                        CER034A
      *                                                                                      CER034A
      ** Previous Customer Details Screen - 2 format                                         CER034A
      *                                                                                      CER034A
     D PrvCustDet2   E DS                  EXTNAME(SDACU3DPD)                                CER034A
     D                                     PREFIX(P1)                                        CER034A
      *                                                                                      CER034A
      ** Previous Customer Details Screen - 3 format                                         CER034A
      *                                                                                      CER034A
     D PrvCustDet3   E DS                  EXTNAME(SDACU4DPD)                                CER034A
     D                                     PREFIX(P2)                                        CER034A
      *                                                                                      CER034A
      ** OK Flag for Customer Details Screen - 2                                             CER034A
      *                                                                                      CER034A
     D OKCustDet2    E DS                  EXTNAME(SDEACU3PD)                                CER034A
      *                                                                                      CER034A
      ** OK Flag for Customer Details Screen - 3                                             CER034A
      *                                                                                      CER034A
     D OKCustDet3    E DS                  EXTNAME(SDEACU4PD)                                CER034A
      *                                                                                      CER034A
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 CER034A
      *                                                                                      CER034A
      ** New Customer Details Screen - 2 format                                              CER034A
      *                                                                                      CER034A
     D NewCustDet2   E DS                  EXTNAME(SDACU3DPD)                                CER034A
      *                                                                                      CER034A
      ** New Customer Details Screen - 3 format                                              CER034A
      *                                                                                      CER034A
     D NewCustDet3   E DS                  EXTNAME(SDACU4DPD)                                CER034A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D PTmeStpSel      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
 
     D FormatP         S             10A   INZ('SDACUDPD')
     D FormatD         S             10A   INZ('SDACUDPD')                                   CER034A
     D FormatE         S             10A   INZ('SDACUDPD')                                   CER034A
     D FieldP          S             10A   INZ('DDACTN')
     D FldOffsetP      S              5P 0
     D FieldNo         S              5P 0
 
     D WKCUST          S                   LIKE(DDCUST)
     D WeF             S              1A   INZ(*Blanks)
     D WeB             S              1A   INZ(*Blanks)
     D WeS             S              1A   INZ(*Blanks)
     D WeM             S              1A   INZ(*Blanks)
     D WeV             S              1A   INZ(*Blanks)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
 
     D KMsgType        S              8A
     D KFrntOffID      S                   LIKE(PFOTranSel)
     D KTimeStamp      S                   LIKE(PTmeStpSel)
 
      ** Parameter for Access Object
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
 
      ** Parameter for APDTASUBS
     D IncData         S           2000A
     D CurData         S           2000A
     D SubsChar        S              1A
 
      ** Parameter for SDACUDRPB
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PFOTranSel      S             20A
 
      ** Parameter for SDACUDRTV
     D P@Mode          S              6A
     D P@RsMd          S              1A
     D DDACTNOK        S              1A
     D DDCUSTOK        S              1A
 
      ** Parameter for SDACUDDSP
     D PEKyFd          S              1A
     D PEdtFd          S              1A
     D PEPrtd          S              1A
     D PEINKG          S              1A
     D PEINKJ          S              1A
     D PEINKW          S              1A                                                    BUG23518
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKW           S              1A                                                    BUG23518
     D SDCUSDcall      S              1A
     D PSDACUDENQ      S              1A
     D PCGL032         S              1A
 
      ** Index for error indicators
     D Idx             S              3P 0
     D WIdx_PVAL       S              3P 0
     D PRVN_WARN       S              3P 0
     D E               S              3P 0
     D F               S              3P 0
 
      ** Other Variable
     D CGL032          S              1A
     D ##DDCUST        S              6A
     D @RdNB           S              1A
     D @Scrn           S              1A
     D CSC011          S              1A
     D CSD029          S              1A                                                      CSD029
                                                                                              CSD029
      ** Parameters for AOSVALR0                                                              CSD029
     D P@OP01          S             20A                                                      CSD029
     D P@OP02          S             20A                                                      CSD029
     D P@OP03          S             20A                                                      CSD029
     D P@OP04          S             20A                                                      CSD029
     D P@OP05          S             20A                                                      CSD029
     D P@OP06          S             20A                                                      CSD029
     D P@OP07          S             20A                                                      CSD029
     D P@OP08          S             20A                                                      CSD029
     D P@OP09          S             20A                                                      CSD029
     D P@OP10          S             20A                                                      CSD029
     D P@VL01          S            200A                                                      CSD029
     D P@VL02          S            200A                                                      CSD029
     D P@VL03          S            200A                                                      CSD029
     D P@VL04          S            200A                                                      CSD029
     D P@VL05          S            200A                                                      CSD029
     D P@VL06          S            200A                                                      CSD029
     D P@VL07          S            200A                                                      CSD029
     D P@VL08          S            200A                                                      CSD029
     D P@VL09          S            200A                                                      CSD029
     D P@VL10          S            200A                                                      CSD029
      *                                                                                      CER034A
     D PKySt           S              7A                                                     CER034A
     D WIdx_DVal       S              3P 0                                                   CER034A
     D WIdx_EVal       S              3P 0                                                   CER034A
     D WeD             S              1A   INZ(*BLANKS)                                      CER034A
     D WeE             S              1A   INZ(*BLANKS)                                      CER034A
     D WDspScrn1       S              1A                                                     CER034A
     D PFieldMFB       S             10A   INZ('DDTITL')                                     CER034A
     D PFieldMFE       S             10A   INZ('DDREM3')                                     CER034A
     D WFldOffstMB     S              5P 0                                                   CER034A
     D WFldOffstME     S              5P 0                                                   CER034A
     D PFieldMFD       S             10A   INZ('DDFXCU')                                     CER034A
     D PFieldMFC       S             10A   INZ('DDZCFG')                                     CER034A
     D WFldOffstMD     S              5P 0                                                   CER034A
     D WFldOffstMC     S              5P 0                                                   CER034A
     D WDspScrn2       S              1A                                                     CER034A
     D PCallFrom       S              1A                                                     CER034A
      *                                                                                      CER034A
      ** Index for arrays of of warning message ids etc                                      CER034A
     D WIdx            S              3P 0                                                   CER034A
      *                                                                                      CER034A
      ** Switchable Features                                                                 CER034A
     D CER034          S              1A                                                     CER034A
     D CER038          S              1A                                                     CER034A
     D CER041          S              1A                                                     CER034A
     D CER047          S              1A                                                     CER034A
     D CER048          S              1A                                                     CER034A
     D CER045          S              1A                                                      CER045
     D CER054          S              1A                                                    BUG24714
 
     D @VAL01          C                   'AddCustDtlFl01'                                   CSD029
     D @VAL02          C                   'AddCustDtlFl02'                                   CSD029
     D @VAL03          C                   'AddCustDtlFl03'                                   CSD029
     D @VAL04          C                   'AddCustDtlFl04'                                   CSD029
     D @VAL05          C                   'AddCustDtlFl05'                                   CSD029
     D @VAL06          C                   'AddCustDtlFl06'                                   CSD029
     D @VAL07          C                   'AddCustDtlFl07'                                   CSD029
     D @VAL08          C                   'AddCustDtlFl08'                                   CSD029
     D @VAL09          C                   'AddCustDtlFl09'                                   CSD029
     D @VAL10          C                   'AddCustDtlFl10'                                   CSD029
 
      **--------------------------------------------------------------------
 
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
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      ** Issue rollback to clear any possible updates in window functions
 
     C                   IF        PINKL = '1'
     C                   ROLBK
     C                   ENDIF
 
      ** Do Screen: Browse Invalid Deals
 
     C                   IF        @Scrn = 'I'
     C                   EXSR      SRScrn@I
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   IF        @Scrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      ** DO While Screen: Primary Details Screen
 
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   DOW       @Scrn = 'P'
     C                   EXSR      SRScrn@P
     C                   ENDDO
                                                                                              CSD029
     C                   DOW       @Scrn = 'S'                                                CSD029
     C                   EXSR      SRScrn2@p                                                  CSD029
     C                   ENDDO                                                                CSD029
      *                                                                                      CER034A
      ** Additional Customer Details Screen - 2                                              CER034A
      *                                                                                      CER034A
     C                   IF        WDspScrn1 = 'Y'                                           CER034A
      *                                                                                      CER034A
     C                   IF        WeD <> 'Y'                                                CER034A
     C                   EXSR      SRSndMD                                                   CER034A
     C                   EVAL      WeD = 'Y'                                                 CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   EVAL      WIdx_DVal = *ZEROS                                        CER034A
      *                                                                                      CER034A
     C                   DOW       @SCRN = 'D'                                               CER034A
     C                   EXSR      SRScrnD                                                   CER034A
     C                   ENDDO                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Additional Customer Details Screen - 3                                              CER034A
      *                                                                                      CER034A
     C                   IF        WDspScrn2 = 'Y'                                           CER034A
      *                                                                                      CER034A
     C                   IF        WeE <> 'Y'                                                CER034A
      *                                                                                      CER034A
     C                   EXSR      SRSndME                                                   CER034A
     C                   EVAL      WeE = 'Y'                                                 CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   EVAL      WIdx_EVal = *ZEROS                                        CER034A
      *                                                                                      CER034A
     C                   DOW       @SCRN = 'E'                                               CER034A
     C                   EXSR      SRScrnE                                                   CER034A
     C                   ENDDO                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
 
      ** Do File Updates
 
     C                   IF        @Scrn = 'U'
     C                   EXSR      SRUpdats
     C                   ENDIF
 
      ** Terminate program
 
     C                   IF        @Scrn = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRScrn@I - Browse Invalid Additional Customers
      *****************************************************************
     C     SRScrn@I      BEGSR
 
      ** Reset Read Next Browse Subfile Record
 
     C                   EVAL      @RdNB = *Blanks
 
      ** Build Browse Subfile
 
     C                   CALLB     'SDACUDRPB'
 
      ** Input :
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Build Subfile
     C                   PARM      'Y'           PBdSfl
 
      ** Read Subfile Record
     C                   PARM      *Blanks       PRdSfl
 
      ** Error in update of previous deal
     C                   PARM                    PErrUp
     C                   PARM                    CSC011
 
      ** OUTPUT :
      ** Error Message
     C                   PARM      *Blanks       PErrMs
 
      ** Option Selected
     C                   PARM                    POpSel
 
      ** Action Selected
     C                   PARM                    PAcSel
 
      ** FO Transaction ID Selected
     C                   PARM                    PFOTranSel
 
      ** Customer Number
     C                   PARM      *Blanks       DDCUST
 
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
 
      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If error set on external switches
 
     C                   IF        PErrMs <> *Blanks
     C                   EVAL      *INU6 = *ON
     C                   ENDIF
 
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
 
     C                   IF        PINKC = '1' or
     C                             PINKL = '1' or
     C                             PErrMs <> *Blanks
     C                   EXSR      SREndP
     C                   GOTO      EScrn@I
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   EVAL      @RdNB = 'Y'
     C                   EVAL      @Scrn = 'R'
 
     C     EScrn@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrw - Read Next Browse Subfile Record
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read Next Subfile Record
 
     C                   CALLB     'SDACUDRPB'
 
      ** INPUT :
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Build Subfile
     C                   PARM      *Blanks       PBdSfl
 
      ** Read Subfile Record
     C                   PARM      'Y'           PRdSfl
 
      ** Error in update of previous deal
     C                   PARM                    PErrUp
     C                   PARM                    CSC011
 
      ** OUTPUTS :
      ** Error Message
     C                   PARM      *Blanks       PErrMs
 
      ** Option Selected
     C                   PARM      *Blanks       POpSel
 
      ** Action Selected
     C                   PARM      *Blanks       PAcSel
 
      ** FO Transaction ID Selected
     C                   PARM      *Blanks       PFOTranSel
 
      ** Additional Customer Number
     C                   PARM      *Blanks       DDCUST
 
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
 
      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      ERdNBrw
     C                   ENDIF
 
      ** If Invalid Additional Customer Read From Subfile
 
     C                   IF        POpSel <> *Blanks
 
      ** Clear file formats
 
     C                   CLEAR                   NwCuFilFmt
 
      ** Blank the Screens
 
     C                   EVAL      WKCUST = DDCUST
     C                   EVAL      WeF = *Blanks
     C                   EVAL      WeB = *Blanks
     C                   EVAL      WeS = *Blanks
     C                   EVAL      WeM = *Blanks
     C                   EVAL      WeV = *Blanks
     C                   CLEAR                   NewCuPrim
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIdArr  = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
 
      ** Retrieve Additional Customer details
 
     C                   EVAL      DDCUST = WKCUST
     C                   EVAL      DDACTN = PAcSel
     C                   EVAL      DDFRNT = PFOTranSel
 
      ** Make sure Invalid transaction's  details are passed to 'Retreive'
      ** module for SPF checking .
 
     C     ZATRNKX0      CHAIN     SDIACUDX0                          99
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      P@Mode = '*FRONT'
     C                   ELSE
     C                   IF        DDCUST = *Blanks
     C                   EVAL      P@Mode = '*FRONT'
     C                   ELSE
     C                   EVAL      P@Mode = *Blanks
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRRtvCus
 
      ** If Additional Customer details were retrieved
      ** Convert the Customer to screen format.
 
     C                   IF        C_E5CUST <> *Blanks and
     C                             DDACTN   <>  'I'
     C                   EXSR      SRCvtCus
     C                   EVAL      NwCuFilFmt = CrCuFilFmt
     C                   ENDIF
 
      ** Now overwite the fields on the main details screen with those
      ** on the invalid Customers file (except for the Midas Customer
      ** reference retrieved above using the front office transaction ID).
      ** Access invalid Customer with timestamp and front office transaction ID.
 
      ** Additional Customer details:
 
     C                   EVAL      ##DDCUST = DDCUST
     C     ZATRNKX0      CHAIN     SDIACUDX0                          99
 
     ** If Additional Customer details were retrieved and this is an amendment
 
     C                   IF        C_E5CUST <> *Blanks and
     C                             DDACTN = 'A'
 
      * Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *Blanks
 
     C     GHSUBS        SCAN      NewCuPrim                              99
     C                   IF        *IN99 = *ON
     C                   EVAL      RepPrim = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
 
     C                   IF        (RepPrim = 'Y')
     C                   EXSR      SRTDtDtaSubs
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** If action code, or Customer reference were NOT OK
      ** blank out action code so that the input cannot proceed
 
     C                   IF        DDACTNOK = 'N' or
     C                             DDCUSTOK = 'N'
     C                   EVAL      DDACTN = *Blanks
     C                   ENDIF
 
      ** Send the Additional Customers error messages to the primary details screen
      ** and Go to Primary Details Screen
 
     C                   EXSR      SRSndM@P
     C                   EVAL      WIdx_PVAL = *Zeros
     C                   EVAL      @Scrn = 'P'
 
      ** Else If No Invalid Additional Customer Read from Subfile
 
     C                   ELSE
 
     ** Go to Browse Screen
 
     C                   EVAL      @Scrn = 'I'
     C                   ENDIF
 
     C     ERdNBrw       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSndM@P - Send a Message to Primary Details Screen
      *****************************************************************
     C     SRSndM@P      BEGSR
 
     C                   EVAL      E = Idx
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C                   IF        DDACTNOK = 'N' or
     C                             DDCUSTOK = 'N'
     C                   ADD       1             E
 
      ** Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      ** first by the user
 
     C                   EVAL      TmpfldNmAr = *Blanks
     C                   EVAL      TmpMsgIdAr = *Blanks
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   EVAL      FldNameArr(1) = *Blanks
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   EVAL      MsgIdArr(1) = *Blanks
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'APM0110'
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     OKCuPrim      @EI
 
      ** Read error messages for Customer
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN99 = *OFF
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    ABFIELDNAM
     C                   PARM      *Zeros        FieldNo
 
     C                   IF        ReturnCode = *Blanks
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr(E) = ABMSGID
     C                   EVAL      F = ABFIELDID
     C                   EVAL      F = F - FldOffsetP
 
     C                   IF        F < 1  or
     C                             F > 60
     C                   EVAL      F = 1
     C                   ENDIF
 
     C                   EVAL      @EI(F) = 'N'
 
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     @EI           OKCuPrim
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRScrn@P - Process Screen: Primary Details
      *****************************************************************
     C     SRScrn@P      BEGSR
 
      ** Enable/disable detail fields on primary details screen
      ** if changes to the data are allowed
      ** (key fields = action code & Customer reference; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'D', or 'E')
 
     C                   IF        DDACTN = 'I' and
     C                             POpSel = 'U' or
     C                             DDACTN = 'A' and
     C                             POpSel = 'U'
     C                   EVAL      PEdtFd = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFd = 'N'
     C                   ENDIF
 
      ** KJ = Command Key 10 = Confirm Delete
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
      *                                                                                     BUG23518
      ** KW = Command Key 22 = Confirm Closure / Release                                    BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'C' OR DDACTN = 'R'                             BUG23518
     C                   EVAL      PEINKW = 'Y'                                             BUG23518
     C                   ELSE                                                               BUG23518
     C                   EVAL      PEINKW = 'N'                                             BUG23518
     C                   ENDIF                                                              BUG23518
 
      ** Update 'previous' screen
 
     C                   EVAL      PrvCuPrim = NewCuPrim
 
      ** Set function key status on Primary Screen
 
     C                   EXSR      SRSFKeys
 
      ** If action code, or Customer reference were NOT OK
      ** blank out action code so that the input cannot proceed
 
     C                   IF        DDACTNOK = 'N' or
     C                             DDCUSTOK = 'N'
     C                   EVAL      DDACTN = *Blanks
     C                   ENDIF
 
      ** WRITE/READ DISPLAY SCREEN - Primary Details
 
     C                   CALLB     'SDACUDDSP'
 
      ** INPUT PARAMETERS :
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Additional Customer (In Screen Format - Primary)
     C                   PARM                    NewCuPrim
 
      ** Fields in error
     C                   PARM                    OKCuPrim
 
      ** Called from customer details module or direct from Midas menu
     C                   PARM      *Blanks       SDCUSDcall
 
      ** Set to 'R' to indicate it is called from this module
     C                   PARM      'R'           PSDACUDENQ
 
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
     C                   PARM      'N'           PEKyFd
     C                   PARM                    PEdtFd
     C                   PARM      'N'           PEINKG
 
      ** Protected field due to CGL032
     C                   PARM                    PEPrtd
 
      ** Switchable features CGL032
     C                   PARM                    PCGL032
 
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = COMMAND KEY 10 = Confirm Delete
 
      ** OUTPUT PARAMETERS :
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKJ                                      BUG23518
     C                   PARM      '0'           PINKW                                      BUG23518
 
      ** Reset Errors ....
 
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIdArr  = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
 
      ** F3 - End Program
 
     C     PINKC         CASEQ     '1'           SREndP
 
      ** F12 - Cancel on Primary Screen
 
     C     PINKL         CASEQ     '1'           SRCanc@P
 
      ** Validate input to Primary Screen
 
     C                   CAS                     SRVal@P
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVal@P  - Validate Input to Primary Details Screen
      *****************************************************************
     C     SRVal@P       BEGSR
 
      ** Retrieve Customer details
 
     C                   EVAL      P@Mode = *Blanks
     C                   EXSR      SRRtvCus
 
      ** If action code, or Customer reference are NOT OK
      ** Re-output screen with error messages on it
 
     C                   IF        DDACTNOK = 'N' or
     C**********                   DDCUSTOK = 'N'                                            CER034A
     C                             DDCUSTOK = 'N' OR                                         CER034A
     C                             (CER048 = 'Y'  AND                                        CER034A
     C                             DDCUSTOK = 'W' )                                          CER034A
     C                   GOTO      EndVal@P
     C                   ENDIF
 
      ** If Delete
 
     C                   IF        DDACTN = 'D'
 
      ** If CK/10 Taken, Go onto Updates
 
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      @Scrn = 'U'
     C                   ENDIF
     C                   GOTO      EndVal@P
     C                   ENDIF
      *                                                                                     BUG23518
      ** If Closure / Release                                                               BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'C' OR DDACTN = 'R'                             BUG23518
      *                                                                                     BUG23518
      ** If F22 pressed, goto Updates                                                       BUG23518
      *                                                                                     BUG23518
     C                   IF        PEINKW = 'Y' AND PINKW = 'Y'                             BUG23518
     C                   EVAL      @Scrn = 'U'                                              BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   GOTO      EndVal@P                                                 BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Customer in File Format
 
     C                   EVAL      Idx = *Zeros
     C                   EVAL      WIdx_PVAL = *Zeros
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   CLEAR                   NwCuFilFmt
 
      ** Validate Primary Customer details
 
     C                   CALLB     'SDACUDVAL'
 
      ** INPUTS :
      ** Response mode
     C                   PARM                    RespMode
 
      ** Customer Primary Details
     C                   PARM                    NewCuPrim
 
      ** Switchable feature CGL032
     C                   PARM                    CGL032
 
      **OUTPUTS :
      ** Customer Primary Details OK inds
     C                   PARM                    OKCuPrim
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_PVAL
 
      ** Valid Customer layout (DS) from/to caller
     C                   PARM                    NwCuFilFmt
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EndVal@P
     C                   ENDIF
 
 
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-display the screen
 
     C                   IF        NewCuPrim <> PrvCuPrim or
     C                             WIdx_PVAL <> PrvN_Warn
     C                   GOTO      EndVal@P
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIdArr  = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
 
     C**********         IF        CSD029 = 'Y'                                       CSD029 CER034A
      *                                                                                      CER034A
     C                   IF        CSD029 = 'Y'   and                                        CER034A
     C                             (WDspScrn1 <> 'Y'  and                                    CER034A
     C                              WDspScrn2 <> 'Y')                                        CER034A
     C                   EVAL      @Scrn = 'S'                                                CSD029
      *                                                                                      CER034A
     C                   ELSE                                                                CER034A
     C                   IF        WDspScrn1 = 'Y'                                           CER034A
     C                   EVAL      @SCRN = 'D'                                               CER034A
      *                                                                                      CER034A
     C                   ELSE                                                                CER034A
     C                   IF        WDspScrn2 = 'Y'                                           CER034A
     C                   EVAL      @SCRN = 'E'                                               CER034A
      *                                                                                      CER034A
     C                   ELSE                                                                 CSD029
     C                   EVAL      @Scrn = 'U'
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
     C**********         ENDIF                                                        CSD029 CER034A
 
     C     EndVal@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCus - Retrieve Additional Customer
      *****************************************************************
     C     SRRtvCus      BEGSR
 
      ** Retrieve Additional Customer
 
     C                   CALLB     'SDACUDRTV'
 
      ** INPUTS :
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    P@Mode
 
      ** Response mode
     C                   PARM      'S'           P@RsMd
 
      ** Action Code
     C                   PARM      PAcSel        DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    DDFRNT
 
      ** (Midas) Customer Reference
     C                   PARM                    DDCUST
 
rgc   ** Value is ' ' to have the same effect of SDACUDSIN
rgc  C                   PARM      *Blanks       PSDACUDENQ
 
      ** OUTPUTS :
      ** (Current) Customer in file format
     C                   PARM                    CrCuFilFmt
 
      ** OK - Action code
     C                   PARM      *Blanks       DDACTNOK
 
      ** OK - Customer Reference
     C                   PARM      *Blanks       DDCUSTOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM      *Zeros        Idx
      *                                                                                      CER034A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     CER034A
      *                                                                                      CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIDArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
      *                                                                                      CER034A
      ** Array index (3P0) from/to caller                                                    CER034A
      *                                                                                      CER034A
     C                   PARM                    WIdx                                        CER034A
 
     C     EndRtvCus     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCvtCus - Put Additional Customer on the secondary screen
      *****************************************************************
     C     SRCvtCus      BEGSR
 
      ** Call program to fill screen fields with data
 
     C                   CALLB     'SDACUDCVT'
 
      ** INPUTS :
      ** Return Code
      ** Additional Customer in file format
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    CrCuFilFmt
 
      ** OUTPUTS
      ** Additional Customer - screen formats
     C                   PARM                    NewCuPrim
      *                                                                                      CER034A
      ** New Customer Details - Screen 2 format                                              CER034A
      *                                                                                      CER034A
     C                   PARM                    NewCustDet2                                 CER034A
      *                                                                                      CER034A
      ** New Customer Details - Screen 3 format                                              CER034A
      *                                                                                      CER034A
     C                   PARM                    NewCustDet3                                 CER034A
      *                                                                                      CER034A
     C                   EVAL      CurCustDet2 = NewCustDet2                                 CER034A
     C                   EVAL      CurCustDet3 = NewCustDet3                                 CER034A
 
      ** Update 'Current' Customer with Customer in Screen Format
 
     C                   EVAL      CurCuPrim = NewCuPrim
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanc@P - Cancel on Primary Details Screen
      *****************************************************************
     C     SRCanc@P      BEGSR
 
      ** If Records are still to be read from the subfile, read them
 
     C                   IF        @RdNB = 'Y'
     C                   EVAL      @Scrn = 'R'
     C                   ELSE
 
      ** Else, Return to the Browse Screen
 
     C                   EVAL      @Scrn = 'I'
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdats - Updates
      *****************************************************************
     C     SRUpdats      BEGSR
 
      ** Update valid Additional Customer: Additional Customer reference
 
     C                   EVAL      ACCUST = DDCUST
     C                   EVAL      ACTYLC = DDACTN
 
      ** Carry forward file data to valid file
 
     C                   EVAL      ACTMST = C_E5TMST
     C**********         EVAL      ACFRNT = C_E5FRNT                                          232543
     C                   EVAL      ACFRNT = DDFRNT                                            232543
     C                   EVAL      ACREPA = DDREPA                                            232543
 
     C                   EVAL      PRtcd = *Blanks
 
      ** Customers Updates
 
     C                   CALLB     'SDACUDUPD'
     C                   PARM      *Blanks       PRtcd
     C                   PARM                    NwCuFilFmt
 
      ** If there were any errors in the Update Functions, RollBack any
      ** updates and end this program.
      ** Otherwise Delete the Invalid Additional Customer Actioned & COMMIT the Updates
 
     C                   IF        PRtcd <> *Blanks and
     C                             PRtcd <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZATRNKD0      CHAIN     SDIACUDD0                          99
 
     C                   IF        *IN99 = *OFF
     C                   DELETE    SDIACUDD0
     C                   ENDIF
 
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDACUD'
     C                   EVAL      KFrntOffID = PFOTRANSEL
     C                   EVAL      KTimeStamp = PTMESTPSEL
 
     C     KAPILOGL0     CHAIN     APILOGL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   COMMIT
 
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
 
     C                   IF        PRtcd = '*RECUPD'
     C                   EVAL      PErrUp = 'Y'
     C                   ELSE
     C                   EVAL      PErrUp = 'N'
     C                   ENDIF
 
      ** If Records are still to be read from the subfile, read them
 
     C                   IF        @RdNB = 'Y'
     C                   EVAL      @Scrn = 'R'
     C                   ELSE
 
      ** Else, Return to the browse screen
 
     C                   EVAL      @Scrn =  'I'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSFKeys - Set Function Key Status on Screen
      *****************************************************************
     C     SRSFKeys      BEGSR
 
      ** Enable/disable function keys
 
      ** KG = Command Key 07 = Read Previous Customer
      ** KH = Command Key 08 = Read Next Customer
 
     C                   EVAL      PEINKG = 'N'
 
     C                   IF        PEdtFd = 'Y'
 
     C                   EVAL      PEKyFd = 'Y'
     C                   EVAL      PEPrtd = 'Y'
 
      ** Check Swichable feature
 
     C                   SELECT
     C                   WHEN      CGL032 = 'Y' and DDACTN = 'E'
     C                   EVAL      PCGL032 = 'N'
 
     C                   WHEN      CGL032 = 'Y' and DDACTN = 'A'
     C                   EVAL      PCGL032 = 'Y'
 
     C                   WHEN      CGL032 = 'N' and
     C                             (DDACTN = 'A' or DDACTN = 'E')
     C                   EVAL      PCGL032 = 'N'
     C                   EVAL      PEPrtd = 'N'
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      PEKyFd = 'N'
     C                   EVAL      PCGL032 = 'N'
     C                   EVAL      PEPrtd = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREndP - End Program
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      @Scrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTDtDtaSubs - Transaction Details Data Substitution          *
      *                                                               *
      *****************************************************************
     C     SRTDtDtaSubs  BEGSR
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepPrim = 'Y'
 
     C                   RESET                   ReturnCode
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar
 
      ** Incoming Data
     C                   PARM      NewCuPrim     IncDATA
 
      ** Current Data
     C                   PARM      CurCuPrim     CurDATA
 
     C                   EVAL      NewCuPrim = IncDATA
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD029
      *****************************************************************                       CSD029
      *  SRScrn2@p                                                    *                       CSD029
      *****************************************************************                       CSD029
     C     SRScrn2@P     BEGSR                                                                CSD029
                                                                                              CSD029
     C                   CALLB     'SDACUD2DP'                                                CSD029
                                                                                              CSD029
      ** INPUT PARAMETERS :                                                                   CSD029
      ** Return code                                                                          CSD029
     C                   PARM                    RetCodeIn                                    CSD029
                                                                                              CSD029
      ** Transaction Details in screen format                                                 CSD029
     C                   PARM                    CurCuPrim                                    CSD029
                                                                                              CSD029
      ** Screen details retrieved from AOSVALPD                                               CSD029
     C                   PARM                    SVALSCRN                                     CSD029
                                                                                              CSD029
      ** Transaction Details OK indicators                                                    CSD029
     C                   PARM                    OKCuPrim                                     CSD029
                                                                                              CSD029
      ** Errors                                                                               CSD029
                                                                                              CSD029
     C                   PARM                    FldNameArr                                   CSD029
     C                   PARM                    MsgIdArr                                     CSD029
     C                   PARM                    MsgDtaArr                                    CSD029
                                                                                              CSD029
      ** Warning                                                                              CSD029
     C                   PARM                    WFldNamArr                                   CSD029
     C                   PARM                    WMsgIDArr                                    CSD029
     C                   PARM                    WMsgDtaArr                                   CSD029
                                                                                              CSD029
      ** Enabled Key & Detail Fields                                                          CSD029
     C                   PARM                    PEKYFD                                       CSD029
     C                   PARM                    PEDTFD                                       CSD029
     C                   PARM                    PEINKG                                       CSD029
                                                                                              CSD029
      ** OUTPUT PARAMETERS :                                                                  CSD029
      ** Function Keys                                                                        CSD029
     C                   PARM                    PINKC                                        CSD029
     C                   PARM                    PINKL                                        CSD029
                                                                                              CSD029
     C                   SELECT                                                               CSD029
     C                   WHEN      PINKC = '1'                                                CSD029
     C                   EXSR      SREndP                                                     CSD029
                                                                                              CSD029
     C                   WHEN      PINKL = '1'                                                CSD029
     C                   IF        (WDspScrn1 <> 'Y') AND                                    CER034A
     C                             (WDspScrn2 <> 'Y')                                        CER034A
     C                   EVAL      @Scrn = 'P'                                                CSD029
      *                                                                                      CER034A
     C                   ELSEIF    WDspScrn2 = 'Y'                                           CER034A
     C                   EVAL      @SCRN = 'E'                                               CER034A
      *                                                                                      CER034A
     C                   ELSEIF    WDspScrn1 = 'Y'                                           CER034A
     C                   EVAL      @SCRN = 'D'                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
                                                                                              CSD029
     C                   OTHER                                                                CSD029
     C                   EVAL      ACFL01 = @DDF001                                           CSD029
     C                   EVAL      ACFL02 = @DDF002                                           CSD029
     C                   EVAL      ACFL03 = @DDF003                                           CSD029
     C                   EVAL      ACFL04 = @DDF004                                           CSD029
     C                   EVAL      ACFL05 = @DDF005                                           CSD029
     C                   EVAL      ACFL06 = @DDF006                                           CSD029
     C                   EVAL      ACFL07 = @DDF007                                           CSD029
     C                   EVAL      ACFL08 = @DDF008                                           CSD029
     C                   EVAL      ACFL09 = @DDF009                                           CSD029
     C                   EVAL      ACFL10 = @DDF010                                           CSD029
     C                   EVAL      @Scrn = 'U'                                                CSD029
     C                   ENDSL                                                                CSD029
                                                                                              CSD029
     C                   ENDSR                                                                CSD029
      *****************************************************************                       CSD029
      /EJECT
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRScrnD - Process Additional Details Screen 2                *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: SREndP, SRCancD, SRValD                               *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRScrnD       BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Default fields in case of Insert                                                    CER034A
      *                                                                                      CER034A
     C                   IF        DDACTN = 'I' AND CER048 = 'Y'                             CER034A
      *                                                                                      CER034A
     C                   IF        DDPIND = *BLANKS                                          CER034A
     C                   EVAL      DDPIND = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   IF        DDS24C = *BLANKS                                          CER034A
     C                   EVAL      DDS24C = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Write/Read Display Screen - Additional Details Screen 2                             CER034A
      *                                                                                      CER034A
     C                   CALLB     'SDACUD3DP'                                               CER034A
      *                                                                                      CER034A
     C                   PARM      *BLANKS       RetCodeIn                                   CER034A
     C                   PARM                    NewCuPrim                                   CER034A
     C                   PARM                    NewCustDet2                                 CER034A
     C                   PARM                    OKCustDet2                                  CER034A
     C                   PARM                    FldNameArr                                  CER034A
     C                   PARM                    MsgIdArr                                    CER034A
     C                   PARM                    MsgDtaArr                                   CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIdArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
     C                   PARM                    PEDTFD                                      CER034A
     C                   PARM                    CER047                                      CER034A
     C                   PARM                    CER048                                      CER034A
     C                   PARM                    PINKC                                       CER034A
     C                   PARM                    PINKH                                       CER034A
     C                   PARM                    PINKL                                       CER034A
      *                                                                                      CER034A
      ** Reset Errors                                                                        CER034A
      *                                                                                      CER034A
     C                   EVAL      OKCustDet2 = 'Y'                                          CER034A
     C                   EVAL      FldNameArr = *BLANKS                                      CER034A
     C                   EVAL      MsgIdArr = *BLANKS                                        CER034A
     C                   EVAL      MsgDtaArr = *BLANKS                                       CER034A
     C                   EVAL      WFldNamArr = *BLANKS                                      CER034A
     C                   EVAL      WMsgIdArr = *BLANKS                                       CER034A
     C                   EVAL      WMsgDtaArr = *BLANKS                                      CER034A
     C                   EVAL      PCallFrom  = '1'                                          CER034A
      *                                                                                      CER034A
      ** F3 - End Program                                                                    CER034A
      *                                                                                      CER034A
     C     PINKC         CASEQ     '1'           SREndP                                      CER034A
      *                                                                                      CER034A
      ** F12 - Cancel on Details Screen                                                      CER034A
      *                                                                                      CER034A
     C     PINKL         CASEQ     '1'           SRCancD                                     CER034A
      *                                                                                      CER034A
      ** Validate Input to Details Screen                                                    CER034A
      *                                                                                      CER034A
     C                   CAS                     SRValD                                      CER034A
      *                                                                                      CER034A
     C                   ENDCS                                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRScrnE - Process Additional Details Screen 3                *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: SRDefVal, SREndP, SRCancE, SRValE                     *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRScrnE       BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Default fields in case of Insert                                                    CER034A
      *                                                                                      CER034A
     C                   IF        DDACTN = 'I' AND WDspScrn2 = 'Y'                          CER034A
      *                                                                                      CER034A
      ** Default Screen Fields depending on which feature is ON                              CER034A
      *                                                                                      CER034A
     C                   EXSR      SRDefVal                                                  CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Write/Read Display Screen - Additional Details Screen 3                             CER034A
      *                                                                                      CER034A
     C                   CALLB     'SDACUD4DP'                                               CER034A
      *                                                                                      CER034A
     C                   PARM      *BLANKS       RetCodeIn                                   CER034A
     C                   PARM                    NewCuPrim                                   CER034A
     C                   PARM                    NewCustDet3                                 CER034A
     C                   PARM                    OKCustDet3                                  CER034A
     C                   PARM                    FldNameArr                                  CER034A
     C                   PARM                    MsgIdArr                                    CER034A
     C                   PARM                    MsgDtaArr                                   CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIdArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
     C                   PARM                    PEDTFD                                      CER034A
     C                   PARM                    CER034                                      CER034A
     C                   PARM                    CER038                                      CER034A
     C                   PARM                    CER041                                      CER034A
     C                   PARM                    PINKC                                       CER034A
     C                   PARM                    PINKH                                       CER034A
     C                   PARM                    PINKL                                       CER034A
      *                                                                                       CER045
      ** Pass the value of CER045                                                             CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *                                                                                      CER034A
      ** Reset Errors                                                                        CER034A
      *                                                                                      CER034A
     C                   EVAL      OKCustDet3 = 'Y'                                          CER034A
     C                   EVAL      FldNameArr = *BLANKS                                      CER034A
     C                   EVAL      MsgIdArr = *BLANKS                                        CER034A
     C                   EVAL      MsgDtaArr = *BLANKS                                       CER034A
     C                   EVAL      WFldNamArr = *BLANKS                                      CER034A
     C                   EVAL      WMsgIdArr = *BLANKS                                       CER034A
     C                   EVAL      WMsgDtaArr = *BLANKS                                      CER034A
     C                   EVAL      PCallFrom  = '2'                                          CER034A
      *                                                                                      CER034A
      ** F3 - End Program                                                                    CER034A
      *                                                                                      CER034A
     C     PINKC         CASEQ     '1'           SREndP                                      CER034A
      *                                                                                      CER034A
      ** F12 - Cancel on Details Screen                                                      CER034A
      *                                                                                      CER034A
     C     PINKL         CASEQ     '1'           SRCancE                                     CER034A
      *                                                                                      CER034A
      ** Validate Input to Details Screen                                                    CER034A
      *                                                                                      CER034A
     C                   CAS                     SRValE                                      CER034A
      *                                                                                      CER034A
     C                   ENDCS                                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRDefVal - Default values for new Screen 3                   *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: SRDefBUNum, SRDefMFIN, SRDefBICD, SRDefRCMP           *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRDefVal      BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Default FX Customer, If Blanks                                                      CER034A
      *                                                                                      CER034A
     C                   IF        CER034 = 'Y' and DDFXCU = *BLANKS                         CER034A
     C                   EVAL      DDFXCU = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Default Staff Member, If Blanks                                                     CER034A
      *                                                                                      CER034A
     C                   IF        CER034 = 'Y' and DDSMBR = *BLANKS                         CER034A
     C                   EVAL      DDSMBR = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Default Securities Customer, If Blanks                                              CER034A
      *                                                                                      CER034A
     C                   IF        CER034 = 'Y' and DDSMBR = *BLANKS                         CER034A
     C                   EVAL      DDSECU = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Default Language Id, If Blanks                                                      CER034A
      *                                                                                      CER034A
     C                   IF        CER038 = 'Y' AND DDLNID = *BLANKS                         CER034A
     C                   EVAL      DDLNID = 'GB'                                             CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Default Correspondent Type, If Blanks                                               CER034A
      *                                                                                      CER034A
     C                   IF        CER038 = 'Y' and DDCTYP = *BLANKS                         CER034A
     C                   EVAL      DDCTYP = 'DEFAULT'                                        CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Default Zero Confirmation Flag, If Blanks                                           CER034A
      *                                                                                      CER034A
     C                   IF        CER041 = 'Y' and DDZCFG = *BLANKS                         CER034A
     C                   EVAL      DDZCFG = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                       CER045
      ** Initialise the following new fields:                                                 CER045
      *  Borrower Sector Classification Code                                                  CER045
      *  Economic Activity Code                                                               CER045
      *  Borrower Sector Classification/BISTA                                                 CER045
      *  Additional Borrowers Statistics Key                                                  CER045
      *  Customer Required for Bundesbank Reporting                                           CER045
      *  Risk Classification/BISTA                                                            CER070
      *                                                                                       CER045
     C                   IF        CER045 = 'Y'                                               CER045
     C                   EVAL      DDBSCC = *BLANKS                                           CER045
     C                   EVAL      DDECAC = *BLANKS                                           CER045
     C                   EVAL      DDBIST = *BLANKS                                           CER045
     C                   EVAL      DDABSK = *BLANKS                                           CER045
     C                   EVAL      DDBEXT = *BLANKS                                           CER045
     C                   EVAL      DDRIGR = *BLANKS                                           CER070
     C                   ENDIF                                                                CER045
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRCancE - Cancel on Additional Customer Details Screen 3     *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRCancE       BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Return to Additional Details Screen 2                                               CER034A
      *                                                                                      CER034A
     C                   IF        WDspScrn1 = 'Y'                                           CER034A
     C                   EVAL      @SCRN = 'D'                                               CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      @SCRN = 'P'                                               CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRCancD - Cancel on Additional Customer Details Screen 2     *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRCancD       BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Return to Primary Details Screen                                                    CER034A
      *                                                                                      CER034A
     C                   EVAL      @SCRN = 'P'                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRValD - Validate Input to Additional Customer Details 2     *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRValD        BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** If Action Code is Insert/Amend                                                      CER034A
      *                                                                                      CER034A
     C                   IF        DDACTN = 'I' or DDACTN = 'A'                              CER034A
      *                                                                                      CER034A
      ** Store image of input screen and current number of warnings                          CER034A
      *                                                                                      CER034A
     C                   EVAL      PrvCustDet2 = NewCustDet2                                 CER034A
     C                   Z-ADD     PrvN_Warn     WIdx_DVal                                   CER034A
      *                                                                                      CER034A
      ** Prior to validation, initialize error indicators as 'OK'                            CER034A
      *                                                                                      CER034A
     C                   EVAL      Idx = *ZEROS                                              CER034A
     C                   EVAL      WIdx = *ZEROS                                             CER034A
     C                   EVAL      OKCustDet2 = 'Y'                                          CER034A
     C                   EVAL      FldNameArr = *BLANKS                                      CER034A
     C                   EVAL      MsgIDArr = *BLANKS                                        CER034A
     C                   EVAL      MsgDtaArr = *BLANKS                                       CER034A
      *                                                                                      CER034A
      ** Validate New Additional Detail                                                      CER034A
      *                                                                                      CER034A
     C                   CALLB     'SDACUD3VL'                                               CER034A
      *                                                                                      CER034A
     C                   PARM      *BLANKS       RespMode                                    CER034A
     C                   PARM                    NewCustDet2                                 CER034A
     C                   PARM                    DDCUST                                      CER034A
     C                   PARM                    DDJATP                                      CER034A
     C                   PARM                    DDTINO                                      CER034A
     C                   PARM                    CER047                                      CER034A
     C                   PARM                    CER048                                      CER034A
     C                   PARM                    CER054                                     BUG24714
     C                   PARM                    OKCustDet2                                  CER034A
     C                   PARM                    FldNameArr                                  CER034A
     C                   PARM                    MsgIdArr                                    CER034A
     C                   PARM                    MsgDtaArr                                   CER034A
     C                   PARM                    Idx                                         CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIdArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
     C                   PARM                    WIdx                                        CER034A
     C                   PARM                    NwCuFilFmt                                  CER034A
      *                                                                                      CER034A
      ** If errors returned                                                                  CER034A
      *                                                                                      CER034A
     C                   IF        Idx <> *ZEROS                                             CER034A
     C                   LEAVESR                                                             CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** If any screen defaulting or reformatting has occurred                               CER034A
      ** in validation or if the number of warnings has changed,                             CER034A
      ** re-display the screen                                                               CER034A
      *                                                                                      CER034A
     C                   IF        (NewCustDet2 <> PrvCustDet2) OR                           CER034A
     C                             (WIdx_DVal <> PrvN_Warn)                                  CER034A
     C                   LEAVESR                                                             CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      *                                                                                      CER034A
      ** Clear any warning messages                                                          CER034A
     C                   EVAL      OKCustDet2 = 'Y'                                          CER034A
     C                   EVAL      WFldNamArr = *BLANKS                                      CER034A
     C                   EVAL      WMsgIDArr = *BLANKS                                       CER034A
     C                   EVAL      WMsgDtaArr = *BLANKS                                      CER034A
      *                                                                                      CER034A
      ** Continue to Additional Customer Details Screen - 3                                  CER034A
      *                                                                                      CER034A
     C                   IF        WDspScrn2 = 'Y'                                           CER034A
     C                   EVAL      @SCRN = 'E'                                               CER034A
      *                                                                                      CER034A
     C                   ELSE                                                                CER034A
     C                   EVAL      @SCRN = 'S'                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRValE - Validate Input to Additional Customer Details 3     *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRValE        BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** If Action Code is Insert/Amend                                                      CER034A
      *                                                                                      CER034A
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                              CER034A
      *                                                                                      CER034A
      ** Store image of input screen and current number of warnings                          CER034A
      *                                                                                      CER034A
     C                   EVAL      PrvCustDet3 = NewCustDet3                                 CER034A
     C                   Z-ADD     PrvN_Warn     WIdx_EVal                                   CER034A
      *                                                                                      CER034A
      ** Prior to validation, initialize error indicators as 'OK'                            CER034A
      *                                                                                      CER034A
     C                   EVAL      Idx = *ZEROS                                              CER034A
     C                   EVAL      WIdx = *ZEROS                                             CER034A
     C                   EVAL      OKCustDet2 = 'Y'                                          CER034A
     C                   EVAL      FldNameArr = *BLANKS                                      CER034A
     C                   EVAL      MsgIDArr = *BLANKS                                        CER034A
     C                   EVAL      MsgDtaArr = *BLANKS                                       CER034A
      *                                                                                      CER034A
      ** Validate New Additional Detail                                                      CER034A
      *                                                                                      CER034A
     C                   CALLB     'SDACUD4VL'                                               CER034A
      *                                                                                      CER034A
     C                   PARM      *BLANKS       RespMode                                    CER034A
     C                   PARM                    NewCustDet3                                 CER034A
     C                   PARM                    DDCUST                                      CER034A
     C                   PARM                    CER034                                      CER034A
     C                   PARM                    CER038                                      CER034A
     C                   PARM                    CER041                                      CER034A
     C                   PARM                    OKCustDet3                                  CER034A
     C                   PARM                    FldNameArr                                  CER034A
     C                   PARM                    MsgIdArr                                    CER034A
     C                   PARM                    MsgDtaArr                                   CER034A
     C                   PARM                    Idx                                         CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIdArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
     C                   PARM                    WIdx                                        CER034A
     C                   PARM                    NwCuFilFmt                                  CER034A
      *                                                                                       CER045
      ** Pass the value of CER045                                                             CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *                                                                                      CER034A
      ** If errors returned                                                                  CER034A
      *                                                                                      CER034A
     C                   IF        Idx <> *ZEROS                                             CER034A
     C                   LEAVESR                                                             CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** If any screen defaulting or reformatting has occurred                               CER034A
      ** in validation or if the number of warnings has changed,                             CER034A
      ** re-display the screen                                                               CER034A
      *                                                                                      CER034A
     C                   IF        (NewCustDet3 <> PrvCustDet3) OR                           CER034A
     C                             (WIdx_EVal <> PrvN_Warn)                                  CER034A
     C                   LEAVESR                                                             CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                       CER045
      ** Trigger re-display of the screen showing the description for                         CER045
      ** 'H' value (currently it's 'Handwerker' but can be changed                            CER045
      * since it's a multi-language ready text field)                                         CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y' AND                                           CER045
     C                             OKABSK = 'Y' AND                                           CER045
     C                             DDABSK = 'H'                                               CER045
     C                   LEAVESR                                                              CER045
     C                   ENDIF                                                                CER045
      *                                                                                      CER034A
      ** Clear any warning messages                                                          CER034A
      *                                                                                      CER034A
     C                   EVAL      OKCustDet3 = 'Y'                                          CER034A
     C                   EVAL      WFldNamArr = *BLANKS                                      CER034A
     C                   EVAL      WMsgIDArr = *BLANKS                                       CER034A
     C                   EVAL      WMsgDtaArr = *BLANKS                                      CER034A
      *                                                                                      CER034A
      ** Continue to Secondary Detail Screen                                                 CER034A
      *                                                                                      CER034A
     C                   IF        CSD029 = 'Y'                                              CER034A
     C                   EVAL      @SCRN = 'S'                                               CER034A
     C                   ELSE                                                                CER034A
     C                   EVAL      @SCRN = 'U'                                               CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRSndMD - Send a Message to Additional Details New Screen 2  *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRSndMD       BEGSR                                                               CER034A
      *                                                                                      CER034A
     C                   EVAL      E = Idx                                                   CER034A
      *                                                                                      CER034A
      ** Initialize Error Indicators                                                         CER034A
      *                                                                                      CER034A
     C                   MOVEA     OKCustDet2    @EI                                         CER034A
      *                                                                                      CER034A
      ** Read Error Messages for Customer                                                    CER034A
      *                                                                                      CER034A
     C     ZATRNKD0      SETLL     ZATRNERRD0                                                CER034A
     C     ZATRNKD0      READE     ZATRNERRD0                                                CER034A
      *                                                                                      CER034A
      ** Add error message to array passed to detail screen and                              CER034A
      ** set OK flag for field to 'N'                                                        CER034A
      *                                                                                      CER034A
     C                   DOW       NOT %EOF (ZATRNERRL0)                                     CER034A
      *                                                                                      CER034A
     C                   CALLB     'ZACGTFLDNO'                                              CER034A
     C                   PARM      *BLANKS       ReturnCode                                  CER034A
     C                   PARM                    FormatD                                     CER034A
     C                   PARM                    ABFIELDNAM                                  CER034A
     C                   PARM      *ZEROS        FieldNo                                     CER034A
      *                                                                                      CER034A
     C                   IF        ReturnCode = *BLANKS                                      CER034A
     C                   ADD       1             E                                           CER034A
     C                   EVAL      FldNameArr(E) = ABFIELDNAM                                CER034A
     C                   EVAL      MsgIdArr(E) = ABMSGID                                     CER034A
     C                   EVAL      F = FieldNo                                               CER034A
     C                   EVAL      F = F - WfldOffstMB                                       CER034A
      *                                                                                      CER034A
     C                   IF        (F < 1) OR (F > 60)                                       CER034A
     C                   EVAL      F = 1                                                     CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   EVAL      @EI(F) = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C     ZATRNKD0      READE     ZATRNERRD0                                                CER034A
      *                                                                                      CER034A
     C                   ENDDO                                                               CER034A
      *                                                                                      CER034A
     C                   MOVEA     @EI           OKCustDet2                                  CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRSndME - Send a Message to Additional Details New Screen 3  *                      CER034A
      *                                                               *                      CER034A
      *  Called by: MAIN Processing                                   *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRSndME       BEGSR                                                               CER034A
      *                                                                                      CER034A
     C                   EVAL      E = Idx                                                   CER034A
      *                                                                                      CER034A
      ** Initialize Error Indicators                                                         CER034A
      *                                                                                      CER034A
     C                   MOVEA     OKCustDet3    @EI                                         CER034A
      *                                                                                      CER034A
      ** Read Error Messages for Customer                                                    CER034A
      *                                                                                      CER034A
     C     ZATRNKD0      SETLL     ZATRNERRD0                                                CER034A
     C     ZATRNKD0      READE     ZATRNERRD0                                                CER034A
      *                                                                                      CER034A
      ** Add error message to array passed to detail screen and                              CER034A
      ** set OK flag for field to 'N'                                                        CER034A
      *                                                                                      CER034A
     C                   DOW       NOT %EOF (ZATRNERRL0)                                     CER034A
      *                                                                                      CER034A
     C                   CALLB     'ZACGTFLDNO'                                              CER034A
     C                   PARM      *BLANKS       ReturnCode                                  CER034A
     C                   PARM                    FormatE                                     CER034A
     C                   PARM                    ABFIELDNAM                                  CER034A
     C                   PARM      *ZEROS        FieldNo                                     CER034A
      *                                                                                      CER034A
      *                                                                                      CER034A
     C                   IF        ReturnCode = *BLANKS                                      CER034A
     C                   ADD       1             E                                           CER034A
     C                   EVAL      FldNameArr(E) = ABFIELDNAM                                CER034A
     C                   EVAL      MsgIdArr(E) = ABMSGID                                     CER034A
     C                   EVAL      F = FieldNo                                               CER034A
     C                   EVAL      F = F - WfldOffstMD                                       CER034A
      *                                                                                      CER034A
     C                   IF        (F < 1) OR (F > 60)                                       CER034A
     C                   EVAL      F = 1                                                     CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   EVAL      @EI(F) = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C     ZATRNKD0      READE     ZATRNERRD0                                                CER034A
      *                                                                                      CER034A
     C                   ENDDO                                                               CER034A
      *                                                                                      CER034A
     C                   MOVEA     @EI           OKCustDet3                                  CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACUDRPR'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine if CGL032 is on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL032'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *Blanks and
     C                             PRtcd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 902
     C                   EVAL      DBKEY  = 'CGL032'
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CGL032 = 'Y'
     C                   ELSE
     C                   EVAL      CGL032 = 'N'
     C                   ENDIF
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   EVAL      DBASE  = 903
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if switchable feature CSC011 is switched on.
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   OPEN      APILOGL0
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
                                                                                              CSD029
      ** Check if CSD029 is installed                                                         CSD029
                                                                                              CSD029
     C                   CALL      'AOSARDR0'                                                 CSD029
     C                   PARM      *BLANKS       PRtcd                                        CSD029
     C                   PARM      '*VERIFY '    POptn                                        CSD029
     C                   PARM      'CSD029'      PSarD                                        CSD029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD029
                                                                                              CSD029
     C                   IF        PRtcd = *Blanks                                            CSD029
     C                   EVAL      CSD029 = 'Y'                                               CSD029
     C                   ELSE                                                                 CSD029
     C                   EVAL      CSD029 = 'N'                                               CSD029
     C                   IF        PRtcd <> '*NRF   '                                         CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD029
     C                   EVAL      DBKEY = 'CSD029'                                           CSD029
     C                   EVAL      DBASE = 906                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      *PSSR                                                      CSD029
     C                   ENDIF                                                                CSD029
     C                   ENDIF                                                                CSD029
      *                                                                                      CER034A
      ** Check for CER047                                                                    CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY'     POptn                                       CER034A
     C                   PARM      'CER047'      PSard                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
      ** Database Error                                                                      CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> *BLANKS AND                                      CER034A
     C                             PRtcd <> '*NRF   '                                        CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBASE  = 913                                              CER034A
     C                   EVAL      DBKEY  = 'CER047'                                         CER034A
     C                   EXSR      *PSSR                                                     CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *BLANKS                                           CER034A
     C                   EVAL      CER047 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
     C                   EVAL      CER047 = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Check for CER048                                                                    CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY'     POptn                                       CER034A
     C                   PARM      'CER048'      PSard                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
      ** Database Error                                                                      CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> *BLANKS AND                                      CER034A
     C                             PRtcd <> '*NRF   '                                        CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBASE  = 914                                              CER034A
     C                   EVAL      DBKEY  = 'CER048'                                         CER034A
     C                   EXSR      *PSSR                                                     CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *BLANKS                                           CER034A
     C                   EVAL      CER048 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
     C                   EVAL      CER048 = 'N'                                              CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                       CER045
      ** Check for CER045                                                                     CER045
      *                                                                                       CER045
     C                   CALLB     'AOSARDR0'                                                 CER045
     C                   PARM      *BLANKS       PRtcd                                        CER045
     C                   PARM      '*VERIFY'     POptn                                        CER045
     C                   PARM      'CER045'      PSard                                        CER045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER045
      *                                                                                       CER045
      ** Database Error                                                                       CER045
      *                                                                                       CER045
     C                   IF        PRtcd <> *BLANKS AND                                       CER045
     C                             PRtcd <> '*NRF   '                                         CER045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER045
     C                   EVAL      DBASE  = 103                                               CER045
     C                   EVAL      DBKEY  = 'CER045'                                          CER045
     C                   EXSR      *PSSR                                                      CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   IF        PRtcd = *BLANKS                                            CER045
     C                   EVAL      CER045 = 'Y'                                               CER045
     C                   ELSE                                                                 CER045
     C                   EVAL      CER045 = 'N'                                               CER045
     C                   ENDIF                                                                CER045
      *                                                                                      CER034A
      ** Check for CER054                                                                   BUG24714
      *                                                                                     BUG24714
     C                   CALLB     'AOSARDR0'                                               BUG24714
     C                   PARM      *BLANKS       PRtcd                                      BUG24714
     C                   PARM      '*VERIFY'     POptn                                      BUG24714
     C                   PARM      'CER054'      PSard                                      BUG24714
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG24714
      *                                                                                     BUG24714
      ** Database Error                                                                     BUG24714
      *                                                                                     BUG24714
     C                   IF        PRtcd <> *BLANKS AND                                     BUG24714
     C                             PRtcd <> '*NRF   '                                       BUG24714
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG24714
     C                   EVAL      DBASE  = 914                                             BUG24714
     C                   EVAL      DBKEY  = 'CER054'                                        BUG24714
     C                   EXSR      *PSSR                                                    BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   IF        PRtcd = *BLANKS                                          BUG24714
     C                   EVAL      CER054 = 'Y'                                             BUG24714
     C                   ELSE                                                               BUG24714
     C                   EVAL      CER054 = 'N'                                             BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
      ** Set Display Screen Flag accordingly                                                 CER034A
      *                                                                                      CER034A
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                              CER034A
     C                   EVAL      WDspScrn1 = 'Y'                                           CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      WDspScrn1 = 'N'                                           CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C**********         IF        (CER034 = 'Y') OR                                  CER034A CER045
     C**********                   (CER038 = 'Y') OR                                  CER034A CER045
     C**********                   (CER041 = 'Y')                                     CER034A CER045
     C                   IF        (CER034 = 'Y') OR                                          CER045
     C                             (CER038 = 'Y') OR                                          CER045
     C                             (CER041 = 'Y') OR                                          CER045
     C                             (CER045 = 'Y')                                             CER045
     C                   EVAL      WDspScrn2 = 'Y'                                           CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      WDspScrn2 = 'N'                                           CER034A
     C                   ENDIF                                                               CER034A
     C                                                                                        CSD029
     C                   IF        CSD029 = 'Y'                                               CSD029
                                                                                              CSD029
     C                   CALL      'AOSVALR0'                                                 CSD029
     C                   PARM      *BLANKS       PRtcd                                        CSD029
     C                   PARM      @VAL01        P@OP01                                       CSD029
     C                   PARM      *BLANKS       P@VL01                                       CSD029
     C                   PARM      @VAL02        P@OP02                                       CSD029
     C                   PARM      *BLANKS       P@VL02                                       CSD029
     C                   PARM      @VAL03        P@OP03                                       CSD029
     C                   PARM      *BLANKS       P@VL03                                       CSD029
     C                   PARM      @VAL04        P@OP04                                       CSD029
     C                   PARM      *BLANKS       P@VL04                                       CSD029
     C                   PARM      @VAL05        P@OP05                                       CSD029
     C                   PARM      *BLANKS       P@VL05                                       CSD029
     C                   PARM      @VAL06        P@OP06                                       CSD029
     C                   PARM      *BLANKS       P@VL06                                       CSD029
     C                   PARM      @VAL07        P@OP07                                       CSD029
     C                   PARM      *BLANKS       P@VL07                                       CSD029
     C                   PARM      @VAL08        P@OP08                                       CSD029
     C                   PARM      *BLANKS       P@VL08                                       CSD029
     C                   PARM      @VAL09        P@OP09                                       CSD029
     C                   PARM      *BLANKS       P@VL09                                       CSD029
     C                   PARM      @VAL10        P@OP10                                       CSD029
     C                   PARM      *BLANKS       P@VL10                                       CSD029
                                                                                              CSD029
     C                   IF        PRtcd <> *Blanks  AND                                      CSD029
     C                             PRtcd <> '*NRF   '                                         CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSD029
     C                   EVAL      DBKEY = 'P@OP01'                                           CSD029
     C                   EVAL      DBASE = 907                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      *PSSR                                                      CSD029
     C                   ELSE                                                                 CSD029
     C                   MOVEL     P@VL01        DDDS01                                       CSD029
     C                   MOVEL     P@VL02        DDDS02                                       CSD029
     C                   MOVEL     P@VL03        DDDS03                                       CSD029
     C                   MOVEL     P@VL04        DDDS04                                       CSD029
     C                   MOVEL     P@VL05        DDDS05                                       CSD029
     C                   MOVEL     P@VL06        DDDS06                                       CSD029
     C                   MOVEL     P@VL07        DDDS07                                       CSD029
     C                   MOVEL     P@VL08        DDDS08                                       CSD029
     C                   MOVEL     P@VL09        DDDS09                                       CSD029
     C                   MOVEL     P@VL10        DDDS10                                       CSD029
     C                   ENDIF                                                                CSD029
                                                                                              CSD029
     C                   ENDIF                                                                CSD029
 
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    PFOTranSel
 
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    FieldP
     C                   PARM      *Zeros        FieldNo
 
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      FldOffsetP = FieldNo - 1
     C                   ENDIF
      *                                                                                      CER034A
      ** Get the field number for the Title; the New Additional                              CER034A
      ** details screen - 2 fields start from subtract one                                   CER034A
      ** from it to give the value to subtract from each                                     CER034A
      ** field's number                                                                      CER034A
      *                                                                                      CER034A
     C                   CALLB     'ZACGTFLDNO'                                              CER034A
     C                   PARM                    ReturnCode                                  CER034A
     C                   PARM                    FormatD                                     CER034A
     C                   PARM                    PFieldMFB                                   CER034A
     C                   PARM                    FieldNo                                     CER034A
      *                                                                                      CER034A
     C                   IF        ReturnCode = *BLANKS                                      CER034A
     C                   EVAL      WFldOffstMB = FieldNo - 1                                 CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Get the field number for the Remarks field.                                         CER034A
      ** The New Additional details screen - 2 fields end                                    CER034A
      ** at that number                                                                      CER034A
      *                                                                                      CER034A
     C                   CALLB     'ZACGTFLDNO'                                              CER034A
     C                   PARM                    ReturnCode                                  CER034A
     C                   PARM                    FormatD                                     CER034A
     C                   PARM                    PFieldMFE                                   CER034A
     C                   PARM                    FieldNo                                     CER034A
      *                                                                                      CER034A
     C                   IF        ReturnCode = *BLANKS                                      CER034A
     C                   EVAL      WFldOffstME = FieldNo                                     CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Get the field number for the FX Customer; the New Additional                        CER034A
      ** details screen - 3 fields start from subtract one                                   CER034A
      ** from it to give the value to subtract from each                                     CER034A
      ** field's number                                                                      CER034A
      *                                                                                      CER034A
     C                   CALLB     'ZACGTFLDNO'                                              CER034A
     C                   PARM                    ReturnCode                                  CER034A
     C                   PARM                    FormatE                                     CER034A
     C                   PARM                    PFieldMFD                                   CER034A
     C                   PARM                    FieldNo                                     CER034A
      *                                                                                      CER034A
     C                   IF        ReturnCode = *BLANKS                                      CER034A
     C                   EVAL      WFldOffstMD = FieldNo - 1                                 CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Get the field number for the Credit Group field.                                    CER034A
      ** The New Additional details screen - 3 fields end                                    CER034A
      ** at that number                                                                      CER034A
      *                                                                                      CER034A
     C                   CALLB     'ZACGTFLDNO'                                              CER034A
     C                   PARM                    ReturnCode                                  CER034A
     C                   PARM                    FormatE                                     CER034A
     C                   PARM                    PFieldMFC                                   CER034A
     C                   PARM                    FieldNo                                     CER034A
      *                                                                                      CER034A
     C                   IF        ReturnCode = *BLANKS                                      CER034A
     C                   EVAL      WFldOffstMC = FieldNo                                     CER034A
     C                   ENDIF                                                               CER034A
 
      ** Start on Browse Screen
 
     C                   EVAL      @Scrn = 'I'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2004
