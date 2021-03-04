     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees Repair')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  DLDLFERPR - Invalid Dealing Fees repair                      *
      *                                                               *
      *  Function:  This function allows invalid Dealing fees to be   *
      *             'repaired' and applied to the Midas database.     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *           for Lending                                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)

     FDLIDLFEL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLIDLFED0 : DLIDLFEX0)

     FDLIDLFEL1 UF   E           K DISK    INFSR(*PSSR)
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
     D/COPY ZACPYSRC,STD_D_SPEC
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @EI             S              1    DIM(60)

   41 ** Array of Fields in error, temporary store
   42D TmpFldNmAr      S             10A   DIM(ArrayMax)

   42 ** Array of error message IDs, temporary store
   42D TmpMsgIdAr      S                   DIM(ArrayMax)
   42D                                     LIKE(#MsgID)

      * Current Dealing Fee in File Format
     D CrDfFilFmt    E DS                  EXTNAME(DLFEED)
     D                                     PREFIX(C_)

      * Current Dealin Fee in Screen Format - Primary Details
     D CrDfScnFmt    E DS                  EXTNAME(DLDLFEPD)
     D                                     PREFIX(@)

      * New Dealing Fee in File Format
     D NwDfFilFmt    E DS                  EXTNAME(DLVDLFEPD)

      * New Dealing Fee in Screen Format
     D NwDfScnFmt    E DS                  EXTNAME(DLDLFEPD)

      * New Transaction Detail in File Format
     D VFRec                 154    222
     D VFPay                 223    711

      * Error indicators
     D OKFlagsDS     E DS                  EXTNAME(DLEDLFEPD)

     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(D_)

     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(E_)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Midas SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for Midas Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

     **  Payment Instructions (File Format)
     D P_PAYF        E DS                  EXTNAME(SDESFPPD)

     **  Receive Instructions (File Format)
     D P_RECF        E DS                  EXTNAME(SDESFRPD)

     **  FRA/IRS Instructions (File Format)
     D P_FRIF        E DS                  EXTNAME(SDESFFPD)

     **  Payment Instructions (Screen Format)
     D P_PAYS        E DS                  EXTNAME(SDESSPPD)

     **  Receive Instructions (Screen Format)
     D P_RECS        E DS                  EXTNAME(SDESSRPD)

     **  FRA/IRS Instructions (Screen Format)
     D P_FRIS        E DS                  EXTNAME(SDESSFPD)

      ** External DS For API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS For Invalide Dealing Fee
      *D DLIDLFEX0     E DS
      *   DDFRNT                             EXTFLD(DDFOTRANID)

      ** First DS For Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS For Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

     D DDSTAT          S             16A

      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Clear Screen (Y / N)
     D CLRSCRN         S              1A

      ** Timestamp selected
     D @TMESTPSEL      S             26Z

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('DLDLFEPD')
     D Field           S             10A   INZ('DDACTN')

     D DADLNO          S              6A
     D DAFSEQ          S              2A
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0

      ** Workfields for Settlement Instructions
     D PKEY1           S             10A
     D PKYST           S              7A
     D P_RTCD          S             10A
     D P_ACTN          S              1A
     D P_DLNO          S              6A
     D P_PPAY          S              1A
     D P_PREC          S              1A
     D P_BRCA          S              3A
     D P_DATP          S              5  0
     D P_DATR          S              5  0

      ** Workfields for browse
     D @RDNB           S              1A
     D @BDSFL          S              1A
     D @RDSFL          S              1A
     D @ERRUP          S              1A
     D @ERRMS          S              7A
     D @OPSEL          S              1A
     D @ACSEL          S              1A
     D @FOTRANSEL      S             20A

      ** Workfields for retrieve
     D @@MODE          S              6A
     D @@RSMD          S              1A

      ** Workfields for function keys
     D @EKYFD          S              1A
     D @EDTFD          S              1A
     D @EINKG          S              1A
     D @EINKH          S              1A
     D @EINKJ          S              1A
     D @EINKK          S              1A
     D @EINKL          S              1A
     D @EINKN          S              1A
     D @EINKP          S              1A
     D @INKC           S              1A
     D @INKG           S              1A
     D @INKH           S              1A
     D @INKJ           S              1A
     D @INKK           S              1A
     D @INKL           S              1A
     D @INKN           S              1A
     D @INKP           S              1A
     D P_CALP          S              4
     D P_PCCY          S                   LIKE(DDFCCY)
     D P_RCCY          S                   LIKE(DDFCCY)
     D P_CSNM          S                   LIKE(BBCSSN)
     D P_TTYP          S              2A
     D P_FFND          S              1A
     D P_ISDA          S              4A
     D P_AGTY          S              6A
     D P_AGDT          S              6A
     D P_AGVV          S              2A
     D P_BLANK         S              2A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095

     D WIdx            S              3S 0
     D Idx             S              3S 0
     D E               S              3S 0
     D F               S              3S 0

      ** Fields defined for Enhancement CSC011
     D CSC011          S              1A
     D KMsgType        S              8A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D KFrntOffID      S                   LIKE(@FOTRANSEL)
     D KTimeStamp      S                   LIKE(@TMESTPSEL)
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A

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

      * Do Screen: Browse invalid Deal Fees

     C                   IF        @SCRN = 'B'
     C                   EXSR      SCRN@B
     C                   END

      ** Read next browse subfile record

     C                   IF        @SCRN = 'R'
     C                   EXSR      RDNBRW
     C                   ENDIF

      ** Do while screen: Details Screen

     C                   Z-ADD     *ZERO         WIdx
     C                   DOW       @SCRN = 'D'
     C                   EXSR      SCRN@D
     C                   ENDDO

      ** Do while Screen: Settlement Details

     C                   DOW       @SCRN = 'S'
     C                   EXSR      SCRN@S
     C                   END

      ** Screen: Confirmation of Input

     C                   IF        @SCRN = 'C'
     C                   EXSR      SCRN@C
     C                   END

      ** Do File updates

     C                   IF        @SCRN = 'U'
     C                   EXSR      UPDATS
     C                   ENDIF

      ** Terminate program

     C                   IF        @SCRN = 'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Deal Fees
      *****************************************************************
     C     SCRN@B        BEGSR

      ** Reset Read next browse subfile record

     C                   MOVEL     *BLANK        @RDNB

      ** Build browse subfile

     C                   CALLB     'DLDLFERPB'

      ** Input Parameters

      ** Retrun Code
     C                   PARM      *BLANK        RetCodeOut

      ** Build Sub-file
     C                   PARM      'Y'           @BDSFL

      ** Read Subfile record
     C                   PARM      *BLANK        @RDSFL

      * Error in update of previous deal
     C                   PARM                    @ERRUP

      ** Output Parameters

      ** Error Message
     C                   PARM      *BLANK        @ERRMS

      ** Option Selected
     C                   PARM                    @OPSEL

      ** Action Selected
     C                   PARM                    @ACSEL

      ** FO Transction  Id Selected
     C                   PARM                    @FOTRANSEL

      ** Deal Number
     C                   PARM      *blanks       DDDLNO

      ** Fee Sequence
     C                   PARM      *blanks       DDFSEQ

      ** Timestamp of Transaction Selected
     C                   PARM                    @TMESTPSEL

      ** Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL

      ** CSC011 indicator
     C                   PARM                    CSC011

      ** If error set on external switches

     C                   IF        @ERRMS <> *BLANK
     C                   MOVE      '1'           *INU6
     C                   END

      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program

     C                   IF        @INKC = '1' or @INKL = '1' or
     C                             @ERRMS <> *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END

      ** Read next browse subfile record

     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN

     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next Browse Subfile Record
      *****************************************************************
     C     RDNBRW        BEGSR

      ** Read next Subfile record

     C                   CALLB     'DLDLFERPB'

      ** Input Parameters

      ** Return code
     C                   PARM      *BLANK        RetCodeOut

      ** Build Sub-file
     C                   PARM      *BLANK        @BDSFL

      ** Read Sub-file record
     C                   PARM      'Y'           @RDSFL

      ** Error in update of previous deal
     C                   PARM                    @ERRUP

      ** Output Parameters

      ** Error Message
     C                   PARM      *BLANK        @ERRMS

      ** Option Selected
     C                   PARM      *BLANK        @OPSEL

      ** Action Selected
     C                   PARM      *BLANK        @ACSEL

      ** FO Transaction Id Selected
     C                   PARM      *BLANK        @FOTRANSEL

      ** Currency Code
     C                   PARM      *BLANK        DDDLNO

      ** Dealing Fee Code
     C                   PARM      *BLANK        DDFSEQ

      ** Timestamp of Transaction Selected
     C                   PARM                    @TMESTPSEL

      ** Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL

      ** CSC011 indicator
     C                   PARM                    CSC011

      * If CK/3 taken within invalid transaction deletion function,
      * end program

     C                   IF        @INKC = '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   ENDIF

      ** If Invalid Deal Fee read from sub-file

     C                   IF        @OPSEL <> *BLANK

      ** Clear file formats
     C                   CLEAR                   NwDfFilFmt
     C                   CLEAR                   CrDfFilFmt

      ** Blank the Screens
     C                   MOVE      DDDLNO        DADLNO
     C                   MOVE      DDFSEQ        DAFSEQ
     C                   CLEAR                   NwDfScnFmt

      ** Reset Errors
     C                   EXSR      ResetErr

      ** Retrieve Dealing Fee details
     C                   MOVE      DADLNO        DDDLNO
     C                   MOVE      DAFSEQ        DDFSEQ
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    DLFRNT

      ** Make sure Invalid transaction's  details are passed to 'Retreive'
      ** module for SPF checking .

     C     ZATRNKX0      CHAIN     DLIDLFEX0                          99

      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ** if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).

     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   IF        DDDLNO = *BLANK and DDFSEQ = *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      RTVDLFE

      ** If Dealing Fee details were retrieved
      ** Convert the Dealing Fee to screen format.

     C                   IF        DDDLNO <> *BLANK and
     C                             DDFSEQ <> *BLANK and DDACTN <> 'I'
     C                   EXSR      CVTDLFE
     C                   MOVEL     CrDfFilFmt    NwDfFilFmt
     C                   END

      ** Now overwite the fields on the main details screen with those
      ** on the invalid Dealing Fees file (except for the Midas Dealing Fee
      ** reference retrieved above using the front office transaction ID).
      ** Access invalid Dealing Fee with timestamp and front office transactionID.

      ** Dealing Fee details:
     C     ZATRNKX0      CHAIN     DLIDLFEX0                          99

      ** If Deal Fee details were retrieved and this is an amendment

     C                   IF        DDDLNO <> *BLANK and
     C                             DDFSEQ <> *BLANK and DDACTN <> 'A'

      ** Data Substitution - Transaction Details

     C                   IF        GHSUBS <> *BLANK

     C     GHSUBS        SCAN      NwDfScnFmt                             99
     C                   IF        *IN99
     C                   EXSR      TDtDtaSubs
     C                   ENDIF


     C                   END
     C                   END

      ** If action code, or Deal Fee reference were NOT OK
      ** blank out action code so that the input cannot proceed

     C                   IF        OKACTN = 'N' or OKDLNO = 'N' or
     C                             OKFSEQ = 'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF

      ** Send the Dealing Fee error messages to the details screen

     C                   EXSR      SNDM@D
     C                   MOVE      'D'           @SCRN

      ** else if no invalid Dealing Fee read from subfile

     C                   ELSE

      ** Go to browse screen

     C                   MOVE      'B'           @SCRN
     C                   ENDIF

     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@D - SEND A MESSAGE TO DETAILS SCREEN
      *****************************************************************
     C     SNDM@D        BEGSR

     C                   Z-ADD     Idx           E

      ** If there are fundamental errors in this transaction
      ** Identify this fact.

     C                   IF        OKACTN = 'N' or OKDLNO = 'N' or
     C                             OKFSEQ = 'N'
     C                   ADD       1             E

      ** Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      ** first by the user

     C                   EVAL      TmpfldNmAr = *BLANKS
     C                   EVAL      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF

      ** Initialize error indicators

     C                   MOVEA     OKFlagsDS     @EI

      ** Read error messages for Dealing Fee

     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99

      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'

     C                   DOW       *IN99 = '0'

     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    Format
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo

     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   IF        F < 1 or F > 60
     C                   Z-ADD     1             F
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF

     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO

     C                   MOVEA     @EI           OKFlagsDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@D - PROCESS SCREEN: DETAILS
      *****************************************************************
     C     SCRN@D        BEGSR

      ** Enable/disable detail fields on primary details screen
      ** if changes to the data are allowed
      ** (key fields = action code & Deal Fee reference; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'D', or 'E')

     C                   IF        DDACTN = 'I' and @OPSEL = 'U' or
     C                             DDACTN = 'A' and @OPSEL = 'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF

      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF

      ** Set function key status on PRIMARY screen
     C                   EXSR      SFKEYS

      ** Write/Read Display Screen - Details

     C                   CALLB     'DLDLFEDSP'

      ** INPUT PARAMETERS :
      ** Return code
     C                   PARM      *BLANK        RetCodeOut

      ** Dealing Fee (IN SCREEN FORMAT - Primary)
     C                   PARM                    NwDfScnFmt

      ** Fields in error
     C                   PARM                    OKFlagsDS

      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Enabled Key & Detail Fields

     C                   PARM      '0'           @EKYFD
     C                   PARM                    @EDTFD

      ** Enabled Function Keys
      ** KG = COMMAND KEY 07 = READ PREVIOUS
      ** KH = COMMAND KEY 08 = READ NEXT
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      ** Status
     C                   PARM                    DDSTAT

      ** OUTPUT PARAMETERS :
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP

      ** Reset Errors

     C                   EXSR      ResetErr

      ** F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP

      ** F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@D

      ** Validate input to Primary screen
     C                   CAS                     VAL@D
     C                   ENDCS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@D  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@D         BEGSR

      ** Retrieve Deal Fee details

     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVDLFE

      ** If action code, or Dealing Fee reference are NOT OK
      ** Re-output screen with error messages on it

     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKFSEQ        OREQ      'N'
     C                   GOTO      EndVAL@D
     C                   ENDIF

      ** For Delete processing

     C     DDACTN        IFEQ      'D'

      ** Update Deal Fee in File Format

     C                   MOVEL     CrDfFilFmt    NwDfFilFmt

      ** If CK/10 taken, go onto Updates

     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   GOTO      EndVAL@D
     C                   ENDIF

      ** For Enquire processing

     C                   IF        DDACTN = 'E'

     C                   IF        @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF

      ** Reset Errors
     C                   EXSR      ResetErr

     C                   GOTO      EndVAL@D
     C                   ENDIF

      ** For Autorization processing

     C     DDACTN        IFEQ      'X'

      ** Update Deal in File Format

     C                   MOVEL     CrDfFilFmt    NwDfFilFmt

      ** Continue to Settlements Screen

     C                   MOVEL     'S'           @SCRN

     C                   GOTO      EndVAL@D
     C                   ENDIF

      ** Validation process for Inserts and Amends

     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'

      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Deal Fee in File Format

     C                   CLEAR                   NwDfFilFmt
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       OKFlagsDS

      ** Validate Primary Deal Fee details

     C                   CALLB     'DLDLFEVAL'

      ** INPUTS :

      ** Response mode
     C                   PARM                    RespMode

      ** Deal Fee Details (Screen Format)
     C                   PARM                    NwDfScnFmt

      ** OUTPUTS :

      ** Deal Fee Details OK Flags
     C                   PARM                    OKFlagsDS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx

      ** Valid Deal Fee layout (DS) from/to caller (File Format)
     C                   PARM                    NwDfFilFmt

      ** Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC

      ** Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD

      ** If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@D
     C                   ENDIF
     C                   ENDIF

      ** Clear any warning messages

     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVEL     'S'           @SCRN

     C     EndVAL@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDLFE - RETRIEVE DEAL FEE
      *****************************************************************
     C     RTVDLFE       BEGSR

      ** RETRIEVE Deal Fee

     C                   CALLB     'DLDLFERTV'

      ** INPUTS :

      ** Return code
     C                   PARM      *BLANK        RetCodeOut

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE

      ** Response mode
     C                   PARM      'S'           @@RSMD

      ** Action Code
     C                   PARM                    @ACSEL

      ** Front Office Transaction ID
     C                   PARM                    DDFRNT

      ** (Midas) Dealing Fee Reference
     C                   PARM                    DDDLNO
     C                   PARM                    DDFSEQ

      ** OUTPUTS :

      ** (Current) Dealing Fee in file format
     C                   PARM                    CrDfFilFmt

      ** OK - Action code
     C                   PARM      *BLANK        OKACTN

      ** OK - Dealing Fee Reference
     C                   PARM      *BLANK        OKDLNO
     C                   PARM      *BLANK        OKFSEQ

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx

      ** Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC

      ** Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD

     C     EndRTVDLFE    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDLFE - CONVERT DEAL FEE Details ( File --> Screen )
      *****************************************************************
     C     CVTDLFE       BEGSR

      ** Call program to fill screen fields with data from DLFEED

     C                   CALLB     'DLDLFECVT'

      ** INPUTS :
      ** Return Code
      ** Customer in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrDfFilFmt

      ** OUTPUTS
      ** Customer - screen formats
     C                   PARM                    NwDfScnFmt

      ** Update 'Current' Deal Fee with Deal Fee in Screen Format
     C                   MOVEL     NwDfScnFmt    CrDfScnFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@D - CANCEL ON DETAILS SCREEN
      *****************************************************************
     C     CANC@D        BEGSR

      ** If Records are still to be read from the subfile, read them

     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE

      ** Else, return to the browse screen

     C                   MOVEL     'B'           @SCRN
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR

      ** Determine if pay settlement should be protected

     C                   IF        DDACTN ='E' or DDACTN = 'D' or DDACTN = 'X'
     C                   MOVE      'Y'           P_PPAY
     C                   MOVE      'Y'           P_PREC
     C                   ENDIF

     C                   IF        DDACTN ='I' or DDACTN = 'A'
     C                   MOVE      'N'           P_PPAY
     C                   MOVE      'N'           P_PREC
     C                   ENDIF

     C     OKCUST        IFEQ      'Y'
     C                   MOVEL(P)  DDCUST        PKey1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PKey1
     C                   PARM                    PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ENDIF

      ** Determine parameters for settlement details input

     C                   EXSR      DETP@S

      ** Settlement Instructions Input

     C                   CALLB     'ZASETINSIN'

      ** INPUTS:

      ** Return Code
     C                   PARM      *BLANK        P_RTCD

      ** Action code
     C                   PARM      DDACTN        P_ACTN

      ** Deal number
     C                   PARM      DDDLNO        P_DLNO

      ** Protect Payment
     C                   PARM                    P_PPAY

      ** Protect Receive
     C                   PARM                    P_PREC

      ** Calling program
     C                   PARM      'DLFE'        P_CALP

      ** Payment currency
     C                   PARM      DDFCCY        P_PCCY

      ** Receive currency
     C                   PARM      DDFCCY        P_RCCY

      ** Customer shortname
     C                   PARM      BBCSSN        P_CSNM

      ** Transaction Type
     C                   PARM      C_DFDTYP      P_TTYP

      ** Federal Funds Ind.
     C                   PARM      *BLANK        P_FFND

      ** Booking branch
     C                   PARM      C_DFBRCA      P_BRCA

      ** Receipt Date
     C                   PARM                    P_DATR

      ** Payment Date
     C                   PARM                    P_DATP

      ** Payment instructions
     C                   PARM                    P_PAYS

      ** Receive instructions
     C                   PARM                    P_RECS

      ** FRA/IRS instructions
     C                   PARM                    P_FRIS

      * OUTPUTS:

      ** Payment instructions
     C                   PARM                    P_PAYF

      ** Receive instructions
     C                   PARM                    P_RECF

      ** FRA/IRS instructions
     C                   PARM                    P_FRIF

      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKK                                      MD036070
     C                   PARM      '0'           @INKL

      ** CK/3 - End program

     C     @INKC         CASEQ     '1'           ENDP

      ** CK/12 - Cancel on settlement details

     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S

      ** Exit From Settlement Details

     C                   CAS                     EXIT@S
     C                   ENDCS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR

     C     C_DFPYON      IFEQ      'S'
     C     C_DFPYON      OREQ      ' '
     C                   EVAL      P_DATR = C_DFPSTD
     C                   EVAL      P_DATP = C_DFPSTD
     C                   ENDIF

     C     C_DFPYON      IFEQ      'E'
     C                   EVAL      P_DATR = C_DFPEND
     C                   EVAL      P_DATP = C_DFPEND
     C                   ENDIF

     C                   IF        DDACTN = 'A' OR DDACTN = 'E' OR DDACTN = 'X'
     C                             OR DDACTN = 'D'
     C                   MOVEL     VFREC         P_RECF
     C                   MOVEL     VFPAY         P_PAYF
     C                   EVAL      FLPOBR = C_DFOMDB
     C                   EVAL      FLROBR = C_DFOSDB
     C                   ELSE

     C                   CALLB     'ZASETINDFT'

      ** INPUTS:

      ** Calling program
     C                   PARM      'DLFE'        P_CALP

      ** Payment currency
     C                   PARM      DDFCCY        P_PCCY            3

      ** Receive currency
     C                   PARM      DDFCCY        P_RCCY            3

      ** Customer shortname
     C                   PARM      BBCSSN        P_CSNM

      ** Transaction Type
     C                   PARM      *BLANK        P_TTYP

      ** Federal Funds Ind.
     C                   PARM      *BLANK        P_FFND

      ** Version of ISDA Rules govern
     C                   PARM                    P_ISDA

      ** Type of ISDA agreement
     C                   PARM                    P_AGTY

      ** Date of ISDA Agreement
     C                   PARM                    P_AGDT

      ** Version of ISDA Agreement
     C                   PARM                    P_AGVV

      ** Version of ISDA Agreement century
     C                   PARM                    P_BLANK
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095

      ** OUTPUTS:

      ** Payment instructions
     C                   PARM                    P_PAYF

      ** Receive instructions
     C                   PARM                    P_RECF

      ** FRA/IRS instructions
     C                   PARM                    P_FRIF

     C                   ENDIF

      ** Clear payment instructions if protected

     C     P_PPAY        IFEQ      'Y'
     C                   CLEAR                   P_PAYF
     C                   Z-ADD     *ZERO         FLPSTM
     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
     C                   ENDIF

      ** Clear receipt instructions if protected

     C     P_PREC        IFEQ      'Y'
     C                   CLEAR                   P_RECF
     C                   Z-ADD     *ZERO         FLRSTM
     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
     C                   EVAL      FLROBN = *BLANKS                                           CSD027
     C                   EVAL      FLROCN = *BLANKS                                           CSD027
     C                   ENDIF

      ** Convert Settlement Details From File To Screen Format

     C                   CALLB     'ZASETINCVT'

      ** INPUTS:

      ** File Payment Settlement Instruction
     C                   PARM                    P_PAYF

      ** File Receipt Settlement Instruction
     C                   PARM                    P_RECF

      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        P_FRIF

      ** OUTPUTS:

      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        P_PAYS

      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        P_RECS

      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        P_FRIS
     C                   PARM      DDFCCY        InRCCY                                      CSF011A
     C                   PARM      DDFCCY        InPCCY                                      CSF011A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS & AMENDS
      *****************************************************************
     C     SCRN@C        BEGSR

      ** Prior to validation, initialize error indicators as 'OK'

     C                   MOVE      *ALL'Y'       OKFlagsDS

      ** Validate Dealing Fee details
     C                   CALLB     'DLDLFEVAL'

      ** INPUTS:

      ** Response mode
     C                   PARM                    RespMode

      ** Deal Fee Details (Screen Format)
     C                   PARM                    NwDfScnFmt

      ** OUTPUTS:

      ** Deal Fee Details OK Flags
     C                   PARM                    OKFlagsDS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx

      ** Valid Deal Fee layout (DS) from/to caller (File Format)
     C                   PARM                    NwDfScnFmt

      * Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC

      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD

      ** If transaction is valid output message 'Press enter to accept'

     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR4450'     MsgIdArr(1)
     C                   ENDIF

      ** Write/Read Display Screen

     C                   CALLB     'DLDLFEDSP'

      ** INPUTS:

      ** Return code
     C                   PARM      *BLANK        RetCodeOut

      ** Deal Fee (In screen format - Primary)
     C                   PARM                    NwDfScnFmt

      ** Fields in error
     C                   PARM                    OKFlagsDS

      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Enabled Key & Detail Fields

     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD

      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
     C                   PARM      'N'           @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP

      ** Status
     C                   PARM                    DDSTAT

      ** OUTPUTS:

      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP

      ** Reset errors

     C                   EXSR      ResetErr

      ** CK/3 - End Program

     C     @INKC         CASEQ     '1'           ENDP

      ** CK/12 - Cancel on confirmation screen

     C     @INKL         CASEQ     '1'           CANC@C

      ** Exit Confirmation Screen

     C                   CAS                     EXIT@C
     C                   ENDCS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR

      ** Return to Details Screen

     C                   MOVEL     'D'           @SCRN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR

      ** If No Errors in Validation

     C     Idx           IFEQ      *ZERO

      ** Continue with Updates

     C                   MOVEL     'U'           @SCRN

      ** Else, Return to Main Details Screen

     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT SCREEN
      *****************************************************************
     C     CANC@S        BEGSR

      ** Return to Details Screen

     C                   MOVEL     'D'           @SCRN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR

      ** If No Errors in Validation

     C     Idx           IFEQ      *ZERO

      ** Continue with Confirmation of Update

     C                   MOVEL     'C'           @SCRN

      ** Else, Return To Main Details Screen

     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR

      ** Update valid Dealing Fee: Dealing Fee reference using MOVE op code

     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C                   EVAL      DLRECI = 'D'
     C     DDACTN        WHENEQ    'D'
     C                   EVAL      DLRECI = 'R'
     C                   ENDSL

     C                   IF        D_BRCA <> *BLANK
     C                   EVAL      DLBRCA = D_BRCA
     C                   ELSE
     C                   EVAL      DLBRCA = E_BRCA
     C                   ENDIF

     C                   MOVE      DDDLNO        DLDLNO
     C                   MOVE      DDCUST        DLCUST
     C                   MOVE      DDFSEQ        DLFSEQ
     C                   MOVE      DDFCOD        DLFCOD
     C                   EVAL      DLFCCY = DDFCCY

     C                   IF        DDFSGN = '-'
     C                   MOVE      DDFAMT        DLFAMT
     C                   ELSE
     C                   MOVE      DDFAMT        DLFAMT
     C                   ENDIF

     C                   MOVE      DDSDAT        DLSDAT
     C                   MOVE      DDEDAT        DLPEND
     C                   EVAL      DLPYON = DDFIND
     C                   MOVE      DDNPYD        DLNPYD
     C                   EVAL      DLFREQ = DDFREQ
     C                   MOVE      DDPDAY        DLDYIM
     C                   EVAL      DLFRNT = DDFRNT

      ** Carry forward file data to valid file

      **  Last Change Date
     C                   Z-ADD     BJRDNB        DLLCHD
     C                   Z-ADD     BJRDNB        DLORED

      ** AMEND -  Set the specific fields for amend

     C                   IF        DDACTN = 'A'

     C                   IF        DLFSTS = 'A' or
     C                             DLFSTS = 'R'
     C                   EVAL      DLFSTS = 'R'
     C                   ELSE
     C                   EVAL      DLFSTS = 'C'
     C                   ENDIF
     C                   EVAL      DLFRNT = C_DFFRNT
     C*                  MOVE      C_BACBSR      BVCBSR
     C*                  MOVE      C_BAVDRC      BVVDRC
     C*                  MOVE      'Y'           BVSYLL
     C*                  MOVE      'Y'           BVSYLR
     C*                  MOVE      C_BABSCD      BVBSCD
     C*                  MOVEL     C_BATMST      BVTMESTMP
     C                   ELSE

      ** Initialise non-validated valid file fields for Insert

     C     DDACTN        IFEQ      'I'
     C                   EVAL      DLFSTS = 'C'
     C*                  Z-ADD     *ZERO         BVCBSR
     C*                  Z-ADD     *ZERO         BVVDRC
     C*                  MOVE      *BLANKS       BVSYLL
     C*                  MOVE      *BLANKS       BVSYLR
     C*                  MOVE      *BLANKS       BVBSCD
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     *BLANK        @RTCD

      ** Dealing Fee Updates

     C                   CALLB     'DLDLFEUPD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwDfFilFmt

      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise delete the invalid dealing fee actioned & commit the updates

     C     RetCodeOut    IFEQ      '*ERROR '
     C     RetCodeOut    OREQ      '*ERTBTK'
     C                   ROLBK
     C                   ENDIF

     C     RetCodeOut    IFEQ      '*ERROR '
     C                   EXSR      *PSSR
     C                   ELSE
     C     RetCodeOut    IFNE      '*ERTBTK'
     C     ZATRNKD0      CHAIN     DLIDLFED0                          99
     C  N99              DELETE    DLIDLFED0

      ** Delete invalid record from the log file

     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR

     C                   EVAL      KMsgType = 'DLDLFE'
     C                   EVAL      KFrntOffID = @FOTRANSEL
     C                   EVAL      KTimeStamp = @TMESTPSEL

     C     KAPILOGL0     CHAIN     APILOGL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
     C                   ENDIF

      ** Issue Commit
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF

      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
     C     RetCodeOut    IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C***lh              MOVE      'N'           @ERRUP

      ** If update not done due to error in Background Update of TABLETK file
      ** Send message 'Unable to update' to screen.
     C
     C                   IF        RETCodeOut =   '*ERTBTK'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR0015'     MsgIdArr(1)
     C                   MOVEL     'D'           @SCRN
     C                   GOTO      EUPDAT
     C                   ENDIF
     C                   ENDIF
     C

      ** If records are still to be read from the subfile, read them
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE

      ** Else, return to the browse screen
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF

     C     EUPDAT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR

      ** Enable/disable function keys

      ** KG = COMMAND KEY 07 = READ PREVIOUS Dealing Fee
      ** KH = COMMAND KEY 08 = READ NEXT Dealing Fee

     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH            1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PARNAMES - Flag if there are changed participant names
      *****************************************************************
     C     PARNAMES      BEGSR

      ** If any 'P', the user to be prompted to confirm if new party or not
     C     'P'           LOOKUP    ChgNamArr                              99
     C                   MOVE      *IN99         CHGNAME           1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR

     C                   MOVEL     'T'           @SCRN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************

     C     TDtDtaSubs    BEGSR


     C                   RESET                   ReturnCode

     C                   CALLB     'APDTASUBS'

      ** Return Code
     C                   PARM                    ReturnCode       10

      ** Substitution character
     C                   PARM      GHSUBS        SubsChar          1

      ** Incoming Data
     C                   PARM      NwDfScnFmt    IncDATA        2000

      ** Current Data
     C                   PARM      CrDfScnFmt    CurDATA        2000

     C                   MOVEL     IncDATA       NwDfScnFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL - Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR

      ** Go to details screen
     C                   MOVEL     'D'           @SCRN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErr - Reset error indicators
      *****************************************************************
     C     ResetErr      BEGSR

      * Reset Error Indicators
     C                   MOVE      *ALL'Y'       OkFlagsDS
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      Idx = *Zero
     C                   EVAL      WIdx = *Zero

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters
     C     *ENTRY        PLIST

      * INPUTS

      ** Dummy, to re-use the menu control pgm for SD, SDC0001
     C                   PARM                    DUMMY1            6

      ** Dummy, to re-use the menu control pgm for SD, SDC0001
     C                   PARM                    DUMMY2            1

      ** Initialize program name
     C                   MOVEL     'DLDLFERPR'   DBPGM

      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Module Details
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access API ICD Details
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
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
     C                   IF        (PRtCd <> *BLANKS) AND
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

      ** Key Lists
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL

     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL

     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp

      ** Get the field number for the action code field; the details
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM      *ZERO         FieldNo

     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset  = FieldNo - 1
     C                   ENDIF

      ** Start on Browse Screen
     C                   MOVEL     'B'           @SCRN             1

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
**  CPY@
(c) Finastra International Limited 2004
