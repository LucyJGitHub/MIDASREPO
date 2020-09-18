     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments insert screen')             *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY6DP - Outgoing Payments Initial Insert Screen          *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD027047           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 217801             Date 16Jun03               *
      *                 217769             Date 09Jun03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217801 - OPSS - Payment details missing when inserting       *
      *           payment using the template                          *
      *  217769 - OPSS - Can not Exit if invalid action entered       *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAY6DF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(FTOPAYS1:@@RRN)
      *
     FFTOSSIL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **                                                                    ------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **                                                                    ------------------------
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
      *
     D SVDRCY          S                   LIKE(SDRCY)
     D SVDRAC          S                   LIKE(SDRAC)
     D SVREF1          S                   LIKE(SREF1)
     D SVREF2          S                   LIKE(SREF2)
     D SVCRCY          S                   LIKE(SCRCY)
     D Idx             S              3P 0
     D WarnRef         S                   LIKE(TranRef)
     D SaveRef         S                   LIKE(TranRef)
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
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D NewPmtScn7    E DS                  EXTNAME(FTOPY8PD) PREFIX(S)
      *  New Payment in Screen Format (SSI Insert Screen)
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)  PREFIX(AC)
      * External data structure for currency codes
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      * External data structure for nostro codes
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * External data structure for customer details
      *
     D W@DRAC          DS
      * Data structure for debit acount
     D W@Retl                  1     10
     D*W@Blnks**              11     15                                                       CGL029
     D W@Blnks                11     21                                                       CGL029
     D W@Cust                  1      6
     D W@Acod                  7     16                                                       CGL029
     D W@Acsq                 17     18                                                       CGL029
     D W@Brch                 19     21                                                       CGL029
     D*W@Acod***               7     10                                                       CGL029
     D*W@Acsq***              11     12                                                       CGL029
     D*W@Brch***              13     15                                                       CGL029
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD) PREFIX(@)
      * Common Work Fields
                                                                                              CGL029
      ** Access Object Parameters                                                             CGL029
     D PACCD           S             10A                                                      CGL029
     D PAcod           S             10A                                                      CGL029
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
      *
      ** Initialisation
     C                   Exsr      INIT
      *
      ** Mode: Build Browse Sub-File
     C     BldDspRead    Ifeq      'B'
     C                   Exsr      ClrSfl
     C                   Exsr      BldSfl
     C                   Endif
      *
      ** Mode: Display Browse Sub-File
     C     BldDspRead    Ifeq      'B'
     C     BldDspRead    oreq      'D'
     C                   Exsr      DspSfl
     C                   Endif
      *
      *
      ** Mode: Read Next Changed Sub-File Record
     C     BldDspRead    Ifeq      'R'
     C                   Exsr      ReadSfl
     C                   Endif
      *
      **  Return to calling program
     C**********         Return                                                             MD027047
     C                   SETON                                        LR                    MD027047
      *
      /EJECT
      *****************************************************************
      * INIT - Initialisation Processing each time module is invoked
      *****************************************************************
     C     INIT          BEGSR
      *
      **  Reset all screen function indicator work fields which are
      **  returned to calling program
     C                   Move      '0'           @INKC
     C                   Move      '0'           @INKE
     C                   Move      '0'           @INKP
     C                   Move      '0'           @INKI
     C                   Move      'N'           @Rollup
      *
      **  Reset any work fields
     C                   Move      'N'           @CrtPmnt
      *
      **  Reset subfile indicators
     C                   Move      *Off          *In84
     C                   Move      *Off          *In85
      *
      **  Clear SSI payment details
     C                   Clear                   SSIScrnFmt
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * DspSfl - Build and Display Browse Sub-File
      ********************************************************************
     C     DspSfl        Begsr
      *
      ** Save pevious warning value
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
      *
      ** If payment has just been inserted then send message to screen
     C     @SITR         Ifne      *Blank
     C                   Exsr      NewPayMsg
     C                   Endif
      *
      ** Set up the customer reference to be used by the message handler
     C                   Eval      TranRef = SDRCY+SDRAC+SREF1+SREF2+SCRCY
     C                   Eval      ActionCode = SACTION
      *
      ** Send any error messages to the program message queue
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sends any error messages to the program
      ** message queue if there are any validation errors
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
      **  Retrieve time for display
     C                   Time                    DDTIME
      *
      **  If no sub-file records written then do not display
     C     @@RRN         Ifeq      *Zero
     C                   Move      *off          *In81
     C                   Else
     C                   Move      *on           *In81
     C                   Endif
      *
      **  Write out message subfile
     C                   Write     FTOPAYM0
      *
      **  Write screen footer
     C                   Write     FTOPAYF1
      *
      **  Write the subfile control record to the screen to display
     C                   Move      *on           *In82
     C                   Exfmt     FTOPAYS0
      *
      **  Reset error message arrays and fields
     C                   Z-add     *Zero         Idx               3 0
     C                   Z-add     *Zero         WIdx
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
     C                   Move      *ALL'Y'       FTEOPSI
      *
      **  Check screen response
     C                   Select
      *
      **  F3 = Exit requested
     C     *INKC         Wheneq    *On
     C                   Movel     '1'           @INKC
     C                   Move      *On           *INLR
     C                   Return
      *
      **  F5 = Refresh screen
     C     *INKE         Wheneq    *On
     C                   Move      *Blanks       S1DRCY
     C                   Move      *Blanks       S1DRAC
     C                   Move      *Blanks       S1REF1
     C                   Move      *Blanks       S1REF2
     C                   Move      *Blanks       S1CRCY
     C                   Exsr      ClrSfl
     C                   Exsr      BldSfl
     C                   Movel     '1'           @INKE
      *
      **  F15 = Display Existing Payments
     C     *INKP         Wheneq    *On
     C                   Movel     '1'           @INKP
      *
      *
      **  F9 = Insert payment with no SSI requested
     C     *INKI         Wheneq    *On
     C                   Move      'N'           @CRTPMNT          1
     C                   Clear                   NewPmtScn7
     C                   Movel     '1'           @INKI
      *
      **  ROLLUP requested (*IN88 is on) - Build next sub-file page
     C     *IN88         Wheneq    *On
     C                   Move      'Y'           @Rollup
     C                   Exsr      BldSfl
      *
      **  If selection values have been entered or have changed
      **  then rebuild sub-file
     C     S1DRCY        Whenne    SVDRCY
     C     S1DRAC        orne      SVDRAC
     C     S1REF1        orne      SVREF1
     C     S1REF2        orne      SVREF2
     C     S1CRCY        orne      SVCRCY
     C                   Exsr      ClrSfl
     C                   Exsr      BldSfl
      *
     C                   Endsl
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
      * BldSfl - Build Subfile Page
      ********************************************************************
     C     BldSfl        BEGSR
      *
      ** Reset subfile page counter
     C                   Z-Add     0             @@CNT             3 0
      *
      ** Restore no. of records written to sub-file so far
     C                   Z-Add     ##RRN         @@RRN
      *
      ** Read through SSI file details
     C                   Read      FTOSSIL1                               89
      *
      **  Build sub-file page until page full or no more records
     C     *IN89         Doweq     *Off
     C     @@CNT         Andlt     13
      *
      **  Check if record read is to be output to the sub-file
     C                   Exsr      ChkSSI
      *
      **  Only output record if slected for output
     C     Include       Ifeq      'Y'
      *
      **  Increment subfile record no. and page count record
     C                   Add       1             @@RRN
     C                   Add       1             @@CNT
      *
      **  Format SSI details for output
     C                   Exsr      FmtSSI
      *
      **  Write subfile recprd
     C                   Write     FTOPAYS1
      *
     C                   Endif
      *
      ** Read next SSI details
     C                   Read      FTOSSIL1                               89
     C                   Enddo
      *
      ** Set subfile record number field for display and save
      ** nomber of records output to subfile so far
     C                   Z-add     @@RRN         DDSREC
     C                   Z-Add     @@RRN         ##RRN
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * ChkSSI - Check if SSI Details are to be output to subfile
      ********************************************************************
     C     ChkSSI        Begsr
      *
      **  Reset include flag
     C                   Move      'Y'           Include           1
      *
      **  Only included if SSI has been authorised
     C     OSSTAT        Ifne      'A'
     C     OSSTAT        andne     'R'
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
      *
      **  If a value has been entered in the debit currency do not include
      **  if not same currency and other selection values entered
     C     S1DRCY        Ifne      *Blanks
     C     S1DRCY        andne     OSDRCY
     C     S1DRAC        Ifne      *Blanks
     C     S1REF1        orne      *Blanks
     C     S1REF2        orne      *Blanks
     C     S1CRCY        orne      *Blanks
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
     C                   Endif
      *
      **  If a value has been entered in the debit account field
     C     S1DRAC        Ifne      *Blanks
     C                   Call      'QCLSCAN'
     C                   Parm                    OSDRAC
     C                   Parm      15            LENGTH1           3 0
     C                   Parm      1             START             3 0
     C                   Parm                    S1DRAC
     C                   Parm      15            LENGTH2           3 0
     C                   Parm      '1'           TRANSLATE         1
     C                   Parm      '1'           TRIM              1
     C                   Parm      '?'           WILD              1
     C                   Parm                    RESULT            3 0
     C     RESULT        Iflt      1
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
     C                   Endif
      *
      **  If a value has been entered in the Reference 1 field
     C     S1REF1        Ifne      *Blanks
     C                   Call      'QCLSCAN'
     C                   Parm                    OSREF1
     C                   Parm      10            LENGTH1           3 0
     C                   Parm      1             START             3 0
     C                   Parm                    S1REF1
     C                   Parm      10            LENGTH2           3 0
     C                   Parm      '1'           TRANSLATE         1
     C                   Parm      '1'           TRIM              1
     C                   Parm      '?'           WILD              1
     C                   Parm                    RESULT            3 0
     C     RESULT        Iflt      1
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
     C                   Endif
      *
      **  If a value has been entered in the Reference 2 field
     C     S1REF2        Ifne      *Blanks
     C                   Call      'QCLSCAN'
     C                   Parm                    OSREF2
     C                   Parm      10            LENGTH1           3 0
     C                   Parm      1             START             3 0
     C                   Parm                    S1REF2
     C                   Parm      10            LENGTH2           3 0
     C                   Parm      '1'           TRANSLATE         1
     C                   Parm      '1'           TRIM              1
     C                   Parm      '?'           WILD              1
     C                   Parm                    RESULT            3 0
     C     RESULT        Iflt      1
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
     C                   Endif
      *
      **  If a value has been entered in the Pay Ccy field
     C     S1CRCY        Ifne      *Blanks
     C     S1CRCY        andne     OSCRCY
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
      *
     C     EndChkSsi     Endsr
      /EJECT
      ********************************************************************
      * FmtSSI - Format SSI Details for Output to Subfile
      ********************************************************************
     C     FmtSSI        Begsr
      *
     C                   Move      *Blanks       SOPTION
     C                   Move      OSDRCY        SDRCY
     C                   Move      OSDRAC        SDRAC
     C                   Move      OSREF1        SREF1
     C                   Move      OSREF2        SREF2
     C                   Move      OSCRCY        SCRCY
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * ClrSfl - Clear Subfile
      ********************************************************************
     C     ClrSfl        BEGSR
      *
      **  Initialise subfile relative record number
     C                   Z-Add     0             ##RRN             5 0
     C                   Z-Add     0             @@RRN             5 0
     C                   Z-Add     0             @@CNT             3 0
      *
      **  Set subfile and subfile control display indicators to non-display
     C                   Move      *off          *In81
     C                   Move      *off          *In82
     C                   Move      *off          *In79
     C                   Move      *Off          *In84
      *
      **  Clear subfile
     C                   Move      *On           *IN87
     C                   Write     FTOPAYS0
     C                   Move      *Off          *IN87
      *
      **  Reposition file LF/FTOSSIL1
     C                   Exsr      PosSSI
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * PosSSI - Reposition SSI Details File
      ********************************************************************
     C     PosSSI        Begsr
      *
      **  Key list for LF/FTOSSIL1
     C     K@OSSI        Klist
     C                   Kfld                    S1DRCY
     C                   Kfld                    S1DRAC
     C                   Kfld                    S1REF1
     C                   Kfld                    S1REF2
     C                   Kfld                    S1CRCY
      *
      **  Save values last entered
     C                   Move      S1DRCY        SVDRCY
     C                   Move      S1DRAC        SVDRAC
     C                   Move      S1REF1        SVREF1
     C                   Move      S1REF2        SVREF2
     C                   Move      S1CRCY        SVCRCY
      *
      **  Reposition file LF/FTOSSIL1 to start
     C     *Loval        Setll     FTOSSIL1
      *
      **  If selection values entered then position the file at key
     C     S1DRCY        Ifne      *Blanks
     C     K@OSSI        Setll     FTOSSIL1                               90
     C                   Endif
      *
      **  Reset end of file indicator
     C                   Move      *Off          *In89
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * NewPayMsg - Send Message for Payment Just Inserted
      ********************************************************************
     C     NewPayMsg     Begsr
      *
      ** Set message id. arrays to send message for successful insert            CFT007
     C                   Z-add     Idx           Ix                3 0
     C                   Add       1             Ix
     C                   Movel     @SITR         MsgDtaArr(Ix)
     C                   Movel     'SPREF'       FldNameArr(Ix)
     C                   Movel     'FTM2622'     MsgIdArr(Ix)
     C                   Movel     *BLANK        @SITR
     C                   Z-add     Ix            Idx
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * ReadSfl - Read Subfile Changed Records
      ********************************************************************
     C     ReadSfl       BEGSR
      *
      **  Read through message sub-file if it exists
     C     @@RRN         Ifne      *Zero
      *
      **  Read next changed sub-file record
     C     *In79         Doueq     *On
     C     SOPTION       orne      *Blanks
     C                   Readc     FTOPAYS1                               79
     C     *In79         Ifeq      *Off
     C     SOPTION       andeq     *Blanks
     C                   Update    FTOPAYS1
     C                   Endif
     C                   Enddo
      *
      **  Change subfile record read
     C     *In79         Ifeq      *off
      *
      ** Reset warning work fields
     C                   Z-add     0             Widx_PVAL         3 0
      *
      **  Amend/Enquire/Authorise/Delete action requested
      **   Retrieve and validate details
     C*****SOPTION       Ifeq      'I'                                                        217769
     C                   Exsr      RTVSSI
     C**********         Endif                                                                217769
      *
      **  Check status of SSI is authorised
     C     Idx           Ifeq      *Zero
     C                   Exsr      ChkStat
     C                   Endif
      *
      **  Errors on retrieval of SSI details redisplay screen
     C     Idx           Ifne      *Zero
     C                   Z-Add     @@RRN         DDSREC
     C                   Goto      UpdatSfl
     C                   Endif
      *
      ** If warnings not previously displayed reoutput screen
     C     WIdx          Ifne      0
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C                   Eval      WarnRef = SDRCY+SDRAC+SREF1+SREF2+SCRCY
     C     WIdx_PVAL     Ifne      PrvN_Warn
     C     WarnRef       orne      SaveRef
     C                   Eval      SaveRef = WarnRef
     C                   Z-Add     @@RRN         DDSREC
     C                   Goto      UpdatSfl
     C                   Endif
     C                   Endif
      *
      ** Reset warning work fields
     C                   Z-add     0             Widx_PVAL         3 0
     C                   Z-add     0             PrvN_Warn         3 0
     C                   Move      *Blanks       SaveRef
     C                   Move      *Blanks       WarnRef
      *
      **  Convert SSI details to screen format if no errors on retrieval
     C                   Exsr      CVTSSI
      *
      **  Set flag to indicate payment to be created from SSI
     C                   Move      'Y'           @CrtPmnt
      *
      **  Reset option code to blank
     C                   Move      *Blank        SOPTION
      *
      **  Reset error message arrays and fields
     C                   Z-add     *Zero         Idx               3 0
     C                   Z-add     *Zero         WIdx
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
     C                   Move      *ALL'Y'       FTEOPSI
      *
      **  Reset subfile record error indicator
     C                   Move      *Off          *In84
     C                   Move      *Off          *In85
      *
      **  Update sub-file record
     C     UpdatSfl      Tag
     C                   Update    FTOPAYS1
      *
     C                   Endif
      *
     C                   Endif
      *
      *
      **  If all changed records have been read then rebuild sub-file
     C     *In79         Ifeq      *on
     C                   Exsr      ClrSfl
     C                   Exsr      BldSfl
     C                   Endif
      *
     C     EndReadSfl    Endsr
      /EJECT
      ********************************************************************
      * RtvSSI - Retrieve and Validate SSI
      ********************************************************************
     C     RtvSSI        BEGSR
      *
      **  Reset error message arrays and fields
     C                   Z-add     *Zero         Idx               3 0
     C                   Z-add     *Zero         WIdx
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
      *
      ** Validate the Action code                                                             217769
     C     SOPTION       Ifeq      'I'                                                        217769
     C                   Move      'E'           SACTION                                      217769
     C                   Else                                                                 217769
      ** Error.                                                                               217769
     C                   Move      '*'           SACTION                                      217769
     C                   EndIf                                                                217769
      *                                                                                       217769
      **  Set flag so that if SSI is unauthorised then it retrieves
      **  details from the main SSI file PF/FTOSSIPD and not the
      **  pending details that exist on PF/FTOSIXPD
     C                   Move      'N'           @@RTVOSIX
      *
      **  Call retrieval module
     C                   Callb     'FTOPSIRTV'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Action Code
     C**********         Parm      'E'           SACTION                                      217769
     C                   Parm                    SACTION                                      217769
      *    Transaction key fields
     C                   Parm                    SDRCY                          Debit Ccy
     C                   Parm                    SDRAC                          Debit Account
     C                   Parm                    SREF1                          Reference I
     C                   Parm                    SREF2                          Reference II
     C                   Parm                    SCRCY                          Pay Ccy
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to Caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *
      **  Set on indicator to highlight the subfile record in error
     C     Idx           Ifne      *Zero
     C                   Move      *On           *In84
     C                   Move      *On           *In85
     C                   Else
     C                   Move      *Off          *In84
     C                   Move      *Off          *In85
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * ChkStat - Check Status of SSI
      *****************************************************************
     C     ChkStat       Begsr
      *
      **  Reset error indicator work field
     C                   Z-add     Idx           Ix                3 0
     C                   Z-add     WIdx          Wx                3 0
      *
      **  If SSI has been deleted then cannot proceed
     C     OSSTAT        Ifeq      'D'
     C                   Move      *On           *In84
     C                   Move      *On           *In85
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FTA0169'     MsgIdArr(Ix)
     C                   Endif
      *
      **  If SSI is complete or requires reauthorisation then send warning
     C     OSSTAT        Ifeq      'C'
     C     OSSTAT        oreq      'R'
     C                   Move      *On           *In84
     C                   Move      *On           *In85
     C                   Add       1             Wx
     C                   Movel     'SACTION'     WFldNamArr(Wx)
     C                   Movel     'FTA0170'     WMsgIdArr(Wx)
     C                   Endif
      *
      **  Reset error indicator field
     C                   Z-add     Ix            Idx
     C                   Z-add     Wx            WIdx
      *
     C     EndChkStat    Endsr
      /EJECT
      *****************************************************************
      * CVTSSI - Convert SSI File Details to screen format
      *****************************************************************
     C     CVTSSI        Begsr
      *
      **  Call convert module
     C                   Callb     'FTOPSICVT'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *
      **  Clear SSI Details for display by FTOPAY7DP
     C                   Clear                   NewPmtScn7
      *
      **  Set SSI Details for display by FTOPAY7DP
     C                   Move      SDRAC         SSDRAC
     C                   Move      SDRCY         SSDRCY
     C                   Move      SCRCY         SSCRCY
     C     OSDSTT        Ifeq      'F'
     C                   Movel     OSDST1        SSCRAC
     C                   Else
     C                   Movel     OSSNCO        SSCRAC
     C                   Endif
      *
      ** Display Payment Details and Bank to Bank info                                        217801
     C                   Move      SDTP1         SSDTP1                                       217801
     C                   Move      SDTP2         SSDTP2                                       217801
     C                   Move      SDTP3         SSDTP3                                       217801
     C                   Move      SDTP4         SSDTP4                                       217801
      *                                                                                       217801
     C                   Move      SBBI1         SSBBI1                                       217801
     C                   Move      SBBI2         SSBBI2                                       217801
     C                   Move      SBBI3         SSBBI3                                       217801
     C                   Move      SBBI4         SSBBI4                                       217801
     C                   Move      SBBI5         SSBBI5                                       217801
     C                   Move      SBBI6         SSBBI6                                       217801
      *                                                                                       217801
      **  Get customer name of Debit Account
     C                   Exsr      GetDRNM
      *
      **  Get customer name of Credit Account
     C                   Exsr      GetCRNM
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * GetDRNM- Get Customer Name of Debit Account
      *****************************************************************
     C     GetDRNM       BEGSR
      *
      **  Determine customer number if retail account no. in debit account
     C                   Movel     SDRAC         W@DRAC
     C     W@Blnks       Ifeq      *Blanks
     C                   Movel     W@Retl        @Retl
     C                   Movel     *Blanks       @Cust
     C                   Movel     *Blanks       @Cycd
     C**********         Movel     *Blanks       @Acod                                        CGL029
     C                   MOVE      *BLANKS       PAcod                                        CGL029
     C                   Movel     *Blanks       @Acsq
     C                   Movel     *Blanks       @Brch
      *
      **  Get customer number of debit account
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY    '    @OPTN
     C                   Parm                    @Retl            10
     C                   Parm                    @Cust             6
     C                   Parm                    @Cycd             3
     C**********         Parm                    @Acod             4                          CGL029
     C                   PARM                    PAcod                                        CGL029
     C                   Parm                    @Acsq             2
     C                   Parm                    @Brch             3
     C     ACCNT         Parm      ACCNT         DSSDY
      *
     C                   Movel     ACCNUM        W@Cust
     C                   Movel     ACACOD        W@Acod
     C                   Movel     ACACSQ        W@Acsq
     C                   Movel     ACBRCA        W@Brch
      *
     C                   Endif
      *
      **   Get customer report name
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      W@Cust        @KEY1            10
     C                   Parm      *Blanks       @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        @RTCD = *Blank
     C                   Movel     BBCRNM        SSDRNM
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * GetCRNM- Get Customer Name of Credit Account
      *****************************************************************
     C     GetCRNM       BEGSR
      *
      **  Get nostro customer number if credit account contains a nostro
     C     OSDSTT        Ifeq      'F'
     C     OSSNCT        oreq      'N'
     C     OSDSTT        Ifeq      'F'
     C     3             SubSt     SSCRAC:1      @CYCD             3
     C     2             SubSt     SSCRAC:4      @NONB             2
     C                   Endif
     C     OSSNCT        Ifeq      'N'
     C                   Move      OSCRCY        @CYCD
     C     2             SubSt     SSCRAC:1      @NONB             2
     C                   Endif
     C                   Call      'AONOSTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      *Blanks       @CUST
     C                   Parm                    @CYCD
     C**********         Parm      *Blanks       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       PACCD                                        CGL029
     C                   Parm      *Blanks       @ACSN             2
     C                   Parm                    @NONB
     C                   Parm      *Blanks       @BRCD             3
     C                   Parm      *Blanks       @CSSN            10
     C                   Parm      *Blanks       @PNOI             1
     C     SDNOST        Parm      SDNOST        DSFDY
     C                   Movel     A7CUST        W@Cust
      *
      ** Otherwise credit account must be a retail number
     C                   Else
     C                   Movel     SSCRAC        W@DRAC
     C     W@Blnks       Ifeq      *Blanks
     C                   Movel     W@Retl        @Retl
     C                   Movel     *Blanks       @Cust
     C                   Movel     *Blanks       @Cycd
     C**********         Movel     *Blanks       @Acod                                        CGL029
     C                   MOVE      *BLANKS       PAcod                                        CGL029
     C                   Movel     *Blanks       @Acsq
     C                   Movel     *Blanks       @Brch
      *
      **  Get customer number of debit account
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY    '    @OPTN
     C                   Parm                    @Retl            10
     C                   Parm                    @Cust             6
     C                   Parm                    @Cycd             3
     C**********         Parm                    @Acod             4                          CGL029
     C                   PARM                    PAcod                                        CGL029
     C                   Parm                    @Acsq             2
     C                   Parm                    @Brch             3
     C     ACCNT         Parm      ACCNT         DSSDY
      *
     C                   Movel     ACCNUM        W@Cust
     C                   Movel     ACACOD        W@Acod
     C                   Movel     ACACSQ        W@Acsq
     C                   Movel     ACBRCA        W@Brch
     C                   Endif
      *
     C                   Endif
      *
      **   Get customer report name
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      W@Cust        @KEY1            10
     C                   Parm      *Blanks       @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        @RTCD = *Blank
     C                   Movel     BBCRNM        SSCRNM
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Display/Read Browse Sub-File Indicator
     C                   Parm                    BldDspRead        1
      *    Create new payment from SSI indicator
     C                   Parm                    @CRTPMNT          1
      *    SSI details in screen format
     C                   Parm                    SSIScrnFmt
      *    Screen format details for display by FTOPAY7DP
     C                   Parm                    NewPmtScn7
      *    Successful insert payment
     C                   Parm                    @SITR            15
      *    Function Keys
     C                   Parm                    @INKC             1
     C                   Parm                    @INKE             1
     C                   Parm                    @INKP             1
     C                   Parm                    @INKI             1
     C                   Parm                    @ROLLUP           1
      *
      *
      ** Initialize program name
     C                   Movel     'FTOPAY6DP'   DBPGM
      *
      ** Get Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '901'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      ** Move workstation ID to screen field.
     C                   Movel     PsJobName     DDWID
     C                   Move      BJMRDT        DDMRDT
      *
      **  Build sub-file page on intial call of module
     C                   Exsr      BldSfl
      *
      * Message subfile control
     C                   Move      '1'           *IN94
     C                   Movel     '*'           DDPGMQ
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **                                                                    ------------------------
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
