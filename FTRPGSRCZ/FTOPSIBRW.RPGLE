     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments SSI browse')                *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPSIBRW - Outgoing Payments SSI Browse                     *
      *                                                               *
      *  Function:  This is the browse screen processing              *
      *             for Funds Transfer Outgoing Payments              *
      *             Standard Settlement Instructions                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 217768             Date 09Jun03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template (Recompile)                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217768 - OPSI - Can not Exit if invalid action entered       *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPSIBDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(FTOPSIS1:@@RRN)
     F                                     INFDS(INFDS#)
      *
     FFTOSSIL1  IF   E           K DISK    INFSR(*PSSR)
      **  Outgoing Payments SSI Details
      *
      *
     FFTOPSAPD  O    E           K DISK    INFSR(*PSSR)
      **  SSI Print Request File
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
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
     D******SVSTAT          S                   LIKE(SSTAT)                                   217768
     D SVSTAT          S                   LIKE(S1STAT)                                       217768
     D Idx             S              3P 0
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
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
     D  QQDRA1       E                     EXTFLD(QQDRAC)                                     CGL029
     D  QQORB1       E                     EXTFLD(QQORBK)                                     CGL029
     D  QQCDR1       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
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
     C                   Return
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
     C                   Move      '0'           @INKI
     C                   Move      '0'           @INKE
     C                   Move      '0'           @INKL
     C                   Move      'N'           @Rollup
      *
      **  Reset any work fields
     C                   Move      'N'           RcdSel
      *
      **  Reset subfile indicators
     C                   Move      *Off          *In85
     C                   Move      'N'           RcdSel
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * DspSfl - Build and Display Browse Sub-File
      ********************************************************************
     C     DspSfl        Begsr
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
     C                   Write     FTOPSIM0
      *
      **  Write screen footer
     C                   Write     FTOPSIF1
      *
      **  Write the subfile control record to the screen to display
     C                   Move      *on           *In82
     C                   Exfmt     FTOPSIS0
      *
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
     C                   Move      *Blanks       S1STAT
     C                   Exsr      ClrSfl
     C                   Exsr      BldSfl
     C                   Movel     '1'           @INKE
      *
      **  F9 = Insert requested
     C     *INKI         Wheneq    *On
     C                   Clear                   SSIScrnFmt
     C                   Move      'I'           SACTION
     C                   Movel     '1'           @INKI
     C                   Return
      *
      **  ROLLUP requested (*IN88 is on) - Build next sub-file page
     C     *IN88         Wheneq    *On
     C                   Move      'Y'           @Rollup
     C                   Exsr      BldSfl
      *
      **  Selection values have been entered or have changed
      **  so rebuild sub-file
     C     S1DRCY        Whenne    SVDRCY
     C     S1DRAC        orne      SVDRAC
     C     S1REF1        orne      SVREF1
     C     S1REF2        orne      SVREF2
     C     S1CRCY        orne      SVCRCY
     C     S1STAT        orne      SVSTAT
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
      **  If status entered on screen then only include record
      **  if status on record matches requrested value
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
     C                   Write     FTOPSIS1
      *
     C                   Endif
      *
      ** Read next SSI details
     C                   Read      FTOSSIL1                               89
     C                   Enddo
      *
      ** Set subfile record number field for display and save number
      ** of records output to subfile so far .
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
      **  If a value has been entered in the debit currency do not include
      **  if not same currency and other selection values entered
     C     S1DRCY        Ifne      *Blanks
     C     S1DRCY        andne     OSDRCY
     C     S1DRAC        Ifne      *Blanks
     C     S1REF1        orne      *Blanks
     C     S1REF2        orne      *Blanks
     C     S1CRCY        orne      *Blanks
     C     S1STAT        orne      *Blanks
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
      **  If status entered on screen then only include record
      **  if status on record matches value entered on screen
     C     S1STAT        Ifeq      'C'
     C     OSSTAT        andne     'C'
     C     S1STAT        oreq      'A'
     C     OSSTAT        andne     'A'
     C     S1STAT        oreq      'D'
     C     OSSTAT        andne     'D'
     C     S1STAT        oreq      'R'
     C     OSSTAT        andne     'R'
     C                   Move      'N'           Include           1
     C                   Goto      EndChkSSI
     C                   Endif
      *
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
     C                   Select
     C     OSSTAT        Wheneq    'A'
     C                   Movel(p)  'Authorised'  SSTAT
     C     OSSTAT        Wheneq    'C'
     C                   Movel(p)  'Complete  '  SSTAT
     C     OSSTAT        Wheneq    'D'
     C                   Movel(p)  'Deleted   '  SSTAT
     C     OSSTAT        Wheneq    'R'
     C                   Movel(p)  'Reauthorise' SSTAT
     C                   Endsl
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
     C                   Write     FTOPSIS0
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
     C                   Move      S1STAT        SVSTAT
      *
      **  Reposition file LF/FTOSSIL1 to start
     C     *Loval        Setll     FTOSSIL1
      *
      **  If selection values entered then position the file at key
     C     S1DRCY        Ifne      *Blanks
     C     K@OSSI        Setll     FTOSSIL1
     C                   Endif
      *
      **  Reset end of file indicator
     C                   Move      *Off          *In89
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
      **  Read next changed sub-file record util action requested
     C     *In79         Doueq     *On
     C     SOPTION       orne      *Blanks
     C                   Readc     FTOPSIS1                               79
     C     *In79         Ifeq      *Off
     C     SOPTION       andeq     *Blanks
     C                   Update    FTOPSIS1
     C                   Endif
     C                   Enddo
      *
      **  Change subfile record read
     C     *In79         Ifeq      *off
      *
      **  Initialise action code with option entered by user
     C                   Move      SOPTION       SACTION
      *
     C**********         Select                                                               217768
      **********                                                                              217768
      ********Print*request*made*********************************************                 217768
     C*****SACTION       Wheneq    'P'                                                        217768
     C**********         Exsr      PrintSSI                                                   217768
      **********                                                                              217768
      ********Amend/Enquire/Authorise/Delete*action*requested****************                 217768
      ********Retrieve*and*validate*details**********************************                 217768
     C*****SACTION       Wheneq    'A'                                                        217768
     C*****SACTION       oreq      'E'                                                        217768
     C*****SACTION       oreq      'X'                                                        217768
     C*****SACTION       oreq      'D'                                                        217768
     C**********         Exsr      RTVSSI                                                     217768
      **********                                                                              217768
     C**********         Endsl                                                                217768
      *                                                                                       217768
     C     SACTION       Ifeq      'P'                                                        217768
     C                   Exsr      PrintSSI                                                   217768
      *                                                                                       217768
      **  Amend/Enquire/Authorise/Delete action requested                                     217768
      **   Retrieve and validate details                                                      217768
     C                   Else                                                                 217768
     C                   Exsr      RTVSSI                                                     217768
     C                   EndIf                                                                217768
      *
      **  Reset option code to blank if no errors in validaion
     C     Idx           Ifeq      *Zero
     C                   Move      *Blank        SOPTION
     C                   Else
     C                   Z-Add     @@RRN         DDSREC
     C                   Endif
      *
      **  Update sub-file record
     C                   Update    FTOPSIS1
      *
     C                   Endif
      *
     C                   Endif
      *
      *
     C     EBLDSF        Endsr
      /EJECT
      ********************************************************************
      * PrintSSI - Submit Job to Print Details of SSI
      ********************************************************************
     C     PrintSSI      BEGSR
      *
      **  Write record to PF/FTOPSAPD
     C                   Move      SDRCY         OSDRCY
     C                   Move      SDRAC         OSDRAC
     C                   Move      SREF1         OSREF1
     C                   Move      SREF2         OSREF2
     C                   Move      SCRCY         OSCRCY
     C                   Move      'Y'           OSPRTI
     C                   Write     FTOPSAD0
      *
      **  Submit print request job
     C                   Call      'FTC000511'
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      * RtvSSI - Retrieve and Validate SSI
      ********************************************************************
     C     RtvSSI        BEGSR
      *
      **  Reset error message arrays and fields
     C                   Z-add     *Zero         Idx               3 0
     C                   Z-add     *Zero         WIdx
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
      *
      **  Call retrieval module
     C                   Callb     'FTOPSIRTV'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Action Code
     C                   Parm                    SACTION
      *    Transaction key fields
     C                   Parm                    SDRCY                          Debit Ccy
     C                   Parm                    SDRAC                          Debit Account
     C                   Parm                    SREF1                          Reference I
     C                   Parm                    SREF2                          Reference II
     C                   Parm                    SCRCY                          Pay Ccy
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
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
     C                   Move      'N'           RcdSel
     C                   Else
     C                   Move      *Off          *In84
     C                   Move      *Off          *In85
     C                   Move      'Y'           RcdSel
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
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Record Selected Indicator
     C                   Parm                    RcdSel            1
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *
      *
      ** Initialize program name
     C                   Movel     'FTOPSIBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   Movel     PsJobName     DDWID
     C                   Move      @MRDT         DDMRDT
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
