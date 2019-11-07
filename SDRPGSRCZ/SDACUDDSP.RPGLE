     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Display')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUDDSP - SDACUSPD Transaction Details Display             *
      *                                                               *
      *  Function:  This module displays the SDACUSPD Transaction     *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24833           Date 09Jul09               *
      *                 BUG23640           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23518A          Date 07Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22133           Date 20Jan09               *
      *                 CER034             Date 06Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24845           Date 09Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 251935             Date 12Dec07               *
      *                 BUG15001           Date 11Oct07               *
      *                 BUG14672           Date 23Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 08Jun07               *
      *                 CSD029             Date 22Aug05               *
      *                 233004             Date 12Apr05               *
      *                 232543             Date 30Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate                          *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24833 - Missing field in Additional Customer Details Scrn *
      *             (Recompile)
      *  BUG23640 - Labels were amended for clarity                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23518A - Display 'Close/Release' key in Repair            *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22133 - Delete option missing from selection screen       *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  BUG24845 - Allow protected fields related to CGL032 to be    *
      *              amended when CSW207 is ON. Apply fix 251685.     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  251935 - Additonal Customer Details fields should be         *
      *           amendable                                           *
      *  BUG15001 - Some fields are editable during enquiry in ACUD   *
      *  BUG14672 - Some fields in Addtional Customer details are not *
      *             saved                                             *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD029 - Customer Details Additional Field (Recompile)       *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Additional Customer Details Display File
     FSDACUDDF  CF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display condition                                   *
      *       71  Display condition                                   *
      *       72  Display condition                                   *
      *       73  Position cursor on first field if no error          *
      *       79  Display Condition                                   *
      *       83  Enable/disable function for F7 F8                   *
      *       99  Read error                                          *
      *****************************************************************
      /EJECT
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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      /COPY ZACPYSRC,MSGHNDDCL
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
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D*@FUNCTIONS      S             79    DIM(2) CTDATA PERRCD(1)                          BUG22133
     D*@FUNCTIONS      S             79    DIM(3) CTDATA PERRCD(1)                 BUG22133 BUG23518
     D*@FUNCTIONS      S             79    DIM(4) CTDATA PERRCD(1)                BUG23518 BUG23518A
     D @FUNCTIONS      S             79    DIM(5) CTDATA PERRCD(1)                         BUG23518A

      ** SDACUSPD Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDACUDPD)

      ** SDACUDPD Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDEACUDPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for SAR Details                                                        BUG23640
     D SCSARD        E DS                  Extname(SCSARDPD)                                BUG23640
                                                                                            BUG23640
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Midas SD Midas modules Data Structure                                                CSW207
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSW207
                                                                                              CSW207

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A                                                    BUG23640

      ** Parameter of *Entry
     D SDCUSDcall      S              1A
     D PEKYFD          S              1A
     D PEDTFD          S              1A
     D PEINKG          S              1A
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKL           S              1A
     D PINKJ           S              1A                                                    BUG22133
     D PINKW           S              1A                                                    BUG23518

      ** Value is 'Y' if its called from SDACUDENQ
      ** Value is ' ' if its called from SDACUDSIN
      ** Value is 'R' if its called from SDACUDRPR
     D PSDACUDENQ      S              1A

      ** Switchable feature CGL032
     D PCGL032         S              1A
     D PEPRTD          S              1A

      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1                                                       CSW207
                                                                                              CSW207
      ** Index for error indicators
     D C               S              2P 0
     D E               S              2P 0

      ** Other Variables
     D WDate           S              4A
      *                                                                                       232543
     D                 DS                                                                     232543
     D WIssDate                       8A                                                      232543
     D  IsDteYY                1      4A                                                      232543
     D  IsDteMM                5      6A                                                      232543
     D  IsDteDD                7      8A                                                      232543
                                                                                              232543
      ** Date format MMDDYYYY                                                                 232543
     D                 DS                                                                     232543
     D DteFmtM                        8A                                                      232543
     D  DteM_MM                1      2A                                                      232543
     D  DteM_DD                3      4A                                                      232543
     D  DteM_YY                5      8A                                                      232543
                                                                                              232543
      ** Date format DDMMYYYY                                                                 232543
     D                 DS                                                                     232543
     D DteFmtD                        8A                                                      232543
     D  DteD_DD                1      2A                                                      232543
     D  DteD_MM                3      4A                                                      232543
     D  DteD_YY                5      8A                                                      232543
      ** Switchable features                                                                BUG23640
      *                                                                                     BUG23640
     D CER047          S              1A                                                    BUG23640
     D CER048          S              1A                                                    BUG23640


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Main processing

     C                   EXSR      SRMain

      ** Return

     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMain - Main Processing
      *****************************************************************
     C     SRMain        BEGSR

      ** Move 'OK' Flags into array (For Checking)

     C                   MOVEA     OKTrnDets     @EI

      ** Set Screen Error Indicators according to Status of 'OK' Flags

     C                   Z-ADD     1             C
     C                   Z-ADD     10            E

     C                   DOU       C > 60
     C                   IF        @EI(C) = 'N' or
     C                             @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO

      ** Set up function keys

     C                   SELECT
     C                   WHEN      DDACTN = 'E' and
     C                             PSDACUDENQ = 'Y'
     C                   EVAL      TOGLTEXT = @FUNCTIONS(2)
     C                   WHEN      PSDACUDENQ = 'R' AND                                    BUG23518A
     C                             (DDACTN = 'C' OR DDACTN = 'R')                          BUG23518A
     C                   EVAL      TOGLTEXT = @FUNCTIONS(5)                                BUG23518A
     C                   WHEN      PSDACUDENQ = 'R'
     C                   EVAL      TOGLTEXT = @FUNCTIONS(2)
     C                   WHEN      DDACTN = 'D'                                             BUG22133
     C                   EVAL      TOGLTEXT = @FUNCTIONS(3)                                 BUG22133
     C                   WHEN      DDACTN = 'C' OR DDACTN = 'R'                             BUG23518
     C                   EVAL      TOGLTEXT = @FUNCTIONS(4)                                 BUG23518
     C                   OTHER
     C                   EVAL      TOGLTEXT = @FUNCTIONS(1)
     C                   ENDSL

      ** Set up the customer reference to be used by the message handler

     C                   EVAL      TranRef = DDCUST
     C                   EVAL      ActionCode = DDACTN

      ** Set up Date of Birth field on the screen

     C                   IF        BJDFIN = 'D'
     C                   MOVEL     DDDBTH        DDDATE3
     C                   MOVE      DDDBTH        WDate
     C                   MOVE      WDate         DDDATE1
     C                   MOVEL     WDate         DDDATE2
     C                   ELSE
     C                   MOVEL     DDDBTH        DDDATE3
     C                   MOVE      DDDBTH        WDate
     C                   MOVE      WDate         DDDATE2
     C                   MOVEL     WDate         DDDATE1
     C                   ENDIF
                                                                                              232543
      ** Set up Issuing Date on the screen                                                    232543
                                                                                              232543
     C                   MOVEL     DDISDT        WIssDate                                     232543
     C                   IF        BJDFIN = 'D'                                               232543
     C                   MOVEL     IsDteDD       DteD_DD                                      232543
     C                   MOVEL     IsDteMM       DteD_MM                                      232543
     C                   MOVEL     IsDteYY       DteD_YY                                      232543
     C                   MOVEL     DteFmtD       DDISDT1                                      232543
     C                   ELSE                                                                 232543
     C                   MOVEL     IsDteMM       DteM_MM                                      232543
     C                   MOVEL     IsDteDD       DteM_DD                                      232543
     C                   MOVEL     IsdteYY       DteM_YY                                      232543
     C                   MOVEL     DteFmtM       DDISDT1                                      232543
     C                   ENDIF                                                                232543

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Protect all fields

     C                   EVAL      *IN70 = *ON

      ** Enable Detail Fields (All Fields except Action Code & Deal Number)

     C                   IF        PEDTFD = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF

     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN83 = *ON
     C                   ENDIF

      ** Protected field due to CGL032

     C                   IF        PEPRTD = 'Y'
     C                             OR DDACTN <> 'E'                                           251935
     C                             AND DDACTN <> 'D'                                        BUG24845
     C                             AND CSW207 = 'Y'                                           251935
     C**********                   OR CSW207 = 'Y'                                 BUG14672 BUG15001
     C                   EVAL      *IN71 = *OFF
     C                   ELSE
     C                   EVAL      *IN71 = *ON
     C                   ENDIF

      ** Switchable feature CGL032

     C                   IF        PCGL032 = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE                                                                 233004
     C                   EVAL      *IN72 = *OFF                                               233004
     C                   ENDIF

      ** Switchable feature CSW207                                                            CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EVAL      *IN84 = *OFF                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN84 = *ON                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Switchable feature CER050                                                            CER050
                                                                                              CER050
     C                   IF        CER050 = 'Y'                                               CER050
     C                   If        DDACTN = 'I' and DDAPRC = *Blank                           CER050
     C                   Eval      DDAPRC = 'Y'                                               CER050
     C                   Endif                                                                CER050
     C                   Eval      *IN82 = *OFF                                               CER050
     C                   ELSE                                                                 CER050
     C                   Eval      *IN82 = *ON                                                CER050
     C                   ENDIF                                                                CER050
                                                                                              CER050
      ** If delete, enable F10                                                              BUG22133
                                                                                            BUG22133
     C                   IF        DDACTN = 'D'                                             BUG22133
     C                   EVAL      *IN85 = *ON                                              BUG22133
     C                   ELSE                                                               BUG22133
     C                   EVAL      *IN85 = *OFF                                             BUG22133
     C                   ENDIF                                                              BUG22133
                                                                                            BUG22133
      ** If Closure / Release, enable F22                                                   BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'C' OR DDACTN = 'R'                             BUG23518
     C                   EVAL      *IN86 = *ON                                              BUG23518
     C                   ELSE                                                               BUG23518
     C                   EVAL      *IN86 = *OFF                                             BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** Position cursor on first field if no errors

     C     'N'           LOOKUP    @EI                                    73

      ** Write message subfile, Securities Clients Details and footer screen

     C                   TIME                    DDTIME
     C                   WRITE     SDACUDM0
     C                   WRITE     SDACUDD1
     C                   WRITE     SDACUDF1

     C                   READ      SDACUDD1                               99

      ** Set screen error indicators off

     C                   MOVEA     @Z0           *IN(10)

      ** Set return keys

     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ                                            BUG22133
     C                   EVAL      PINKW = *INKW                                            BUG23518

      ** If F12 or ENTER is press, set F3 = *ON if called from Customer Details
      ** so it will not return on browse screen

     C                   IF        *INKL = '1'
     C                   IF        SDCUSDcall = 'C'
     C                   EVAL      PINKC = '1'
     C                   EVAL      PINKL = '0'
     C                   ELSE
     C                   EVAL      PINKL = *INKL
     C                   ENDIF
     C                   ENDIF

      ** Merge dates on Date of Birth field (screen format)

     C                   IF        BJDFIN = 'D'
     C                   EVAL      DDDBTH = DDDATE3 + DDDATE2 + DDDATE1
     C                   ELSE
     C                   EVAL      DDDBTH = DDDATE3 + DDDATE1 + DDDATE2
     C                   ENDIF
                                                                                              232543
      ** Set up Issuing Date from the screen                                                  232543
                                                                                              232543
     C                   IF        BJDFIN = 'D'                                               232543
     C                   MOVEL     DDISDT1       DteFmtD                                      232543
     C                   MOVEL     DteD_DD       IsDteDD                                      232543
     C                   MOVEL     DteD_MM       IsDteMM                                      232543
     C                   MOVEL     DteD_YY       IsDteYY                                      232543
     C                   MOVEL     WIssDate      DDISDT                                       232543
     C                   ELSE                                                                 232543
     C                   MOVEL     DDISDT1       DteFmtM                                      232543
     C                   MOVEL     DteM_DD       IsDteDD                                      232543
     C                   MOVEL     DteM_MM       IsDteMM                                      232543
     C                   MOVEL     DteM_YY       IsDteYY                                      232543
     C                   MOVEL     WIssDate      DDISDT                                       232543
     C                   ENDIF                                                                232543

     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------

      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUT PARAMETERS :
      ** Return code
     C                   PARM                    RetCodeIn

      ** Transaction Details in screen format
     C                   PARM                    TrnDets

      ** Transaction Details OK indicators
     C                   PARM                    OKTrnDets

      ** Called from customer details module or direct from Midas menu
     C                   PARM                    SDCUSDcall

      ** Called from SDACUDENQ module if value is 'Y'
     C                   PARM                    PSDACUDENQ

      ** ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** WARNING
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Enabled Key & Detail Fields
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM                    PEINKG

      ** Protected field due to CGL032
     C                   PARM                    PEPRTD

      ** Switchable features CGL032
     C                   PARM                    PCGL032

      ** OUTPUT PARAMETERS :
      ** Function Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKJ                                      BUG22133
     C                   PARM                    PINKW                                      BUG23518

      ** Initialize program name

     C                   EVAL      DBPGM = 'SDACUDDSP'

      ** Move user and workstation ID to screen fields.

     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName

     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if Private Banking is switched on:                                             CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM      '*DBERR'      PRtCd                                        CSW207
     C                   PARM      '*FIRST '     POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBASE = 902                                                CSW207
     C                   EVAL      DBKEY  = POptn                                             CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                            BUG23640
      ** Call AOSARDR0 to check for CER047                                                  BUG23640
      *                                                                                     BUG23640
     C                   CALL      'AOSARDR0'                                               BUG23640
     C                   PARM      *BLANKS       PRtcd                                      BUG23640
     C                   PARM      '*VERIFY'     POptn                                      BUG23640
     C                   PARM      'CER047'      PSard                                      BUG23640
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23640
      *                                                                                     BUG23640
     C                   IF        PRtcd = *BLANKS                                          BUG23640
     C                   EVAL      CER047 = 'Y'                                             BUG23640
     C                   ELSE                                                               BUG23640
     C                   EVAL      CER047 = 'N'                                             BUG23640
     C                   ENDIF                                                              BUG23640
                                                                                              CSW207
      ** Call AOSARDR0 to check for CER048                                                  BUG23640
      *                                                                                     BUG23640
     C                   CALL      'AOSARDR0'                                               BUG23640
     C                   PARM      *BLANKS       PRtcd                                      BUG23640
     C                   PARM      '*VERIFY'     POptn                                      BUG23640
     C                   PARM      'CER048'      PSard                                      BUG23640
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23640
      *                                                                                     BUG23640
     C                   IF        PRtcd = *BLANKS                                          BUG23640
     C                   EVAL      CER048 = 'Y'                                             BUG23640
     C                   ELSE                                                               BUG23640
     C                   EVAL      CER048 = 'N'                                             BUG23640
     C                   ENDIF                                                              BUG23640
                                                                                            BUG23640
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                             BUG23640
     C                   EVAL      *IN88 = *ON                                              BUG23640
     C                   ELSE                                                               BUG23640
     C                   EVAL      *IN88 = *OFF                                             BUG23640
     C                   ENDIF                                                              BUG23640
                                                                                            BUG23640
      *                                                                                       CLE134
      ** Call AOSARDR0 to check for CLE134                                                    CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRtcd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSard                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C                   IF        PRtcd = *BLANKS                                            CLE134
     C                   EVAL      *IN89 = *ON                                                CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      *IN89 = *OFF                                               CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CER050
      ** Call AOSARDR0 to check for CER050                                                    CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'                                                 CER050
     C                   PARM      *BLANKS       PRtcd                                        CER050
     C                   PARM      '*VERIFY'     POptn                                        CER050
     C                   PARM      'CER050'      PSard                                        CER050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER050
      *                                                                                       CER050
     C                   IF        PRtcd = *BLANKS                                            CER050
     C                   move      'Y'           CER050            1                          CER050
     C                   ELSE                                                                 CER050
     C                   EVAL      CER050 = 'N'                                               CER050
     C                   ENDIF                                                                CER050

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR

     C                   EVAL      DBPGM = 'SDACUDDSP'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      **  Terminte the program

     C                   RETURN

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
      ***Added*a*new*element*for*@FUNCTIONS*to*display*F10*key                     BUG22133 BUG23518
      ***Added*a*new*element*for*@FUNCTIONS*to*display*F22*key                    BUG23518 BUG23518A
      ** Added a new element in @FUNCTIONS to display F22 key in Repair                    BUG23518A
** CTDATA @CPY
Finastra International Limited 2004
** CTDATA @Z0
000000000000000000000000000000000000000000000000000000000000
** CTDATA @FUNCTIONS
F3=Exit  F7=Previous Transaction  F8=Next Transaction  F12=Previous
F3=Exit  F12=Previous
F3=Exit  F7=Previous Transaction  F8=Next Transaction  F10=Delete  F12=Previous
F3=Exit  F7=Prev Transaction  F8=Next Transaction  F22=Close/Rel  F12=Previous
F3=Exit  F12=Previous  F22=Close/Release
