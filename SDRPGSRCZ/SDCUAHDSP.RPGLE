     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer/Authority Holder Display Screen')    *
      *****************************************************************
      *                                                               *
      *  MIDAS - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUAHDSP - Midas SD Customer/Authority Holder Display Screen*
      *                                                               *
      * Function:  This module will display the Customer/Authority    *
      *            Holders                                            *
      *                                                               *
      *  (C) COPYRIGHT Finastra International Limited 2008            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG25211C          Date 14Aug09               *
      *                 BUG24083           Date 25May09               *
      *                 BUG23775           Date 21Apr09               *
      *                 BUG23774           Date 20Apr09               *
      *                 BUG22473           Date 26Jan09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25211C - Account Holder Shortname missing                 *
      *  BUG24083 - Disable F12 in the Add Screen Mode                *
      *  BUG23775 - Authority Holder Maintenance Display Issues       *
      *  BUG23774 - Updates are not committed                         *
      *  BUG22473 - Database Error occurs in Authority Holders object *
      *  CER034 - LF046 German Features - New Fields and Enquiries    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLoad       - Loading of Subfile                            *
      *  SREnter      - Read the subfile and Update the Screen Format *
      *  SRReset      - Clear/Reset Subfile                           *
      *  SRChgMod     - Change the Subfile Mode                       *
      *  SRReturn     - Return to SIN                                 *
      *  SRLoadFot    - Load Footer                                   *
      *  SRRmvMsg     - Remove program messages                       *
      *  SRLdScrFmt   - Load Screen Formats                           *
      *  SRDispScrn   - Display Screen                                *
      *  SRArrtoScrnA - Add Mode Array to Screen                      *
      *  SRSndMsg     - Send message to program's message Queue       *
      *  SRArrtoScrnC - Change Mode Array to Screen                   *
      *  SRGetErrLoc  - To get the Error Locations                    *
      *  SRErrInd     - Set Error Indicators                          *
      *  SRF09        - Processing for F09                            *
      *  SRF03        - Processing for F03                            *
      *  SRF05        - Processing for F05                            *
      *  SRF12        - Processing for F12                            *
      *  ZDATE2       - Convert Midas Day Number into Date (DDMMYY)   *
      *  *PSSR        - Program Exception Error routine               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Customer-Authority Holder Link Maint. file
      *
     FSDCUAHDDF CF   E             WORKSTN
     F                                     SFILE(SDACUDS0:WSflRrn)
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the
      **                          database error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields
      ** in the  PSDS.
      ** They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant
      ** giving the size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
     D/COPY ZACPYSRC,DTAQCHKDCL
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      ** External DS for Customer details
      *
     D SDVCUAH       E DS                  EXTNAME(SDVCUAHPD)
      *
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External Details for Non-Account Holder
      *
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for Access Programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D*NewScrnFmt    E DS                  EXTNAME(SDCUADPD)                                  CER059
     D NewScrnFmt    E DS                  EXTNAME(SDCUADPD1)                                 CER059
     D                                     PREFIX(N)
      *
     D*OldScrnFmt    E DS                  EXTNAME(SDCUADPD)                                  CER059
     D OldScrnFmt    E DS                  EXTNAME(SDCUADPD1)                                 CER059
     D                                     PREFIX(M)
      *
      ** OK Flags
      *
     D OKCuahDS      E DS                  EXTNAME(SDECUAHPD)
      *
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
      *
     D PEdtft          S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PStKey          S              7A
      *
     D OKCuArr         S              7A   DIM(1950)
     D WOKStr          S              7A
     D DDACTN          S              1A
     D WEof            S              1A
     D WLstDgt         S              1P 0
     D WExit           S              1A
     D WSflRrn         S              5P 0
     D WToArr          S              5P 0
     D WTempLd         S              5P 0
     D WFromDS         S              5P 0
     D WFromOK         S              5P 0
     D WMode           S              4A
     D DDCUST          S              6A
      *
      ** Counter
      *
     D Count           S              1A
      *
      ** F3 = Exit
      *
     D PINKC           S              1A
      *
      ** F5 = Refersh
      *
     D PINKE           S              1A
      *
      ** F09 = Toggele Mode
      *
     D PINKI           S              1A
      *
      ** F12 = Previous
      *
     D PINKL           S              1A
      *
      ** Paramters for access objects
      *
     D PTotRcd         S              5P 0
     D PCalledFrom     S              3A
      *
     D ActnArr         S              1A   DIM(1950)
     D ActnOK          S              1A   DIM(1950)
      *
     D FldCuArr        S             22A   DIM(1950)
     D NewFldCUArr     S             22A   DIM(1950)
      *
     D Ix              S              5P 0
     D WCtr            S              5P 0
     D WCountRcd       S              5P 0
     D WRcdWrt         S              5P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main Processing
      *
     C                   TIME                    DDTIME
      *
      ** Set up function keys and indicators                                                BUG23774
     C                   IF        DDACTN = 'I'                                             BUG23774
     C                   EVAL      *IN71  = *ON                                             BUG23774
     C                   EVAL      *IN72  = *ON                                             BUG23774
     C                   EVAL      *IN87  = *OFF                                            BUG23774
     C                   EVAL      *IN89  = *OFF                                            BUG23774
     C                   ENDIF                                                              BUG23774
      *                                                                                     BUG23774
     C                   IF        DDACTN = 'A'                                             BUG23774
     C                   EVAL      *IN71  = *ON                                             BUG23774
     C                   EVAL      *IN72  = *ON                                             BUG23774
     C                   EVAL      *IN87  = *OFF                                            BUG23774
     C                   EVAL      *IN89  = *OFF                                            BUG23774
     C                   ENDIF                                                              BUG23774
      *                                                                                     BUG23774
     C                   IF        DDACTN = 'E'                                             BUG23774
     C                   EVAL      *IN71  = *OFF                                            BUG23774
     C                   EVAL      *IN72  = *OFF                                            BUG23774
     C                   EVAL      *IN87  = *ON                                             BUG23774
     C                   EVAL      *IN89  = *ON                                             BUG23774
     C                   ENDIF                                                              BUG23774
      *                                                                                     BUG23774
     C                   IF        DDACTN = 'D'                                             BUG23774
     C                   EVAL      *IN71  = *OFF                                            BUG23774
     C                   EVAL      *IN72  = *OFF                                            BUG23774
     C                   EVAL      *IN87  = *ON                                             BUG23774
     C                   EVAL      *IN89 = *OFF                                             BUG23774
     C                   ENDIF                                                              BUG23774
      *                                                                                     BUG23774
     C                   IF        WMode = '*ADD'                                           BUG24083
     C                   EVAL      *IN89 = *ON                                              BUG24083
     C                   ENDIF                                                              BUG24083
                                                                                            BUG24083
     C                   EXSR      SRLoad
     C                   EXSR      SRLoadFot
      *
     C                   DOU       WExit = *ON
      *
     C                   WRITE     SDACUDC1
     C                   EXFMT     SDACUDC0
      *
     C     *INKC         CASEQ     *ON           SRF03
     C     *INKL         CASEQ     *ON           SRF12
     C     *INKI         CASEQ     *ON           SRF09
     C     *INKE         CASEQ     *ON           SRF05
     C                   CAS                     SREnter
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   EXSR      SRReturn
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadFot - Load Footer                                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadFot     BEGSR
      *
     C                   IF        PCalledFrom = 'RPR'
      *
     C                   WRITE     SDACUDF3
     C                   EVAL      *IN71 = *OFF
     C                   ELSE
      *
     C                   IF        (DDACTN = 'I' OR DDACTN = 'A')
     C                   WRITE     SDACUDF0
     C                   ELSEIF    DDACTN = 'E'
     C                   WRITE     SDACUDF1
     C                   ELSEIF    DDACTN = 'D'
     C                   WRITE     SDACUDF2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRmvMsg - Remove program messages                           *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls:'ZA0250'                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRRmvMsg      BEGSR
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLdScrFmt - Load Screen Formats                             *
      *                                                               *
      *  Called By: SRLoad                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLdScrFmt    BEGSR
      *
     C                   EVAL      WFromDS = 7
     C                   EVAL      WFromOK = 2
      *
     C                   DOW       WCtr <= PTotRcd
      *
     C                   IF        PCalledFrom = 'SIN'
     C                   EVAL      %SUBST(OldScrnFmt:WFromDS:22) =
     C                             FldCuArr(WCtr)
     C                   ENDIF
      *
     C                   EVAL      %SUBST(NewScrnFmt:WFromDS:22) =
     C                             FldCuArr(WCtr)
      *
     C                   EVAL      %SUBST(OKCuahDS:WFromOK:7) =
     C                             OKCuArr(WCtr)
      *
     C                   EVAL      WFromDS = WFromDS + 22
     C                   EVAL      WFromOK = WFromOK + 7
      *
     C                   IF        %REM(WCtr:150) = 0
     C                   EVAL      WCtr = WCtr + 1
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WCtr = WCtr + 1
      *
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad  - Loading of subfile                                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRGetErrLoc, SRLdScrFmt, SRDispScrn,         *
      *         SRSndMsg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
     C                   EXSR      SRReset
      *                                                                                     BUG23775
     C                   EXSR      SRGetSName                                               BUG23775
      *
     C                   IF        PTotRcd = *ZEROS
      *
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN52 = *ON
     C                   WRITE     SDACUDC0
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      MsgIDArr(1) = 'ASM0001'
      *
     C                   ELSE
      *
     C                   EXSR      SRGetErrLoc
      *
      ** IF Error Load ScreenFmt else the sin must have loaded
      *
     C                   IF        WToArr <> 0
      *
     C                   EVAL      Ix = 0
     C                   EVAL      WRcdWrt = 1
     C                   EVAL      WCtr = 1
      *
      ** Load all Records
      *
     C                   DOW       Ix <= %DIV(PTotRcd:150)
     C                   EXSR      SRLdScrFmt
     C                   EXSR      SRDispScrn
     C                   EVAL      WCtr = WCtr + 150
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
     C                   EVAL      WLstDgt = %REM(WToArr:10)
     C                   EVAL      DDSFRC = WToArr - WLstDgt + 1
      *
     C                   ELSE
      *
      ** No Error
      *
     C                   EVAL      WRcdWrt = 1
     C                   EVAL      Ix = 0
     C                   EVAL      WCtr = 1
      *
     C                   DOW       Ix <= %DIV(PTotRcd:150)
     C                   EXSR      SRDispScrn
     C                   EVAL      WCtr = Wctr + 150
     C                   EXSR      SRLdScrFmt
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
      ** First Page
      *
     C                   EVAL      DDSFRC = 1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      SRSndMsg
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDispScrn - Display Screen                                  *
      *                                                               *
      *  Called By: SRLoad                                            *
      *                                                               *
      *  Calls: SRErrInd                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDispScrn    BEGSR
      *
     C                   EVAL      WFromDS = 7
     C                   EVAL      WFromOK = 2
      *
     C                   IF        PEdtft = 'P'
     C                   EVAL      *IN81 = *ON
     C                   ELSEIF    PEdtft = 'N'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   ELSEIF    PEdtft = ' ' OR PEdtft = 'Y'
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
      *
      ** Load Subfile Records
      *
     C                   DOW       WRcdWrt <= PTotRcd
      *
     C                   MOVEA     '00000000'    *IN(32)
     C                   EVAL      *IN41 = *OFF
      *
     C                   EVAL      DDSELC = ActnArr(WRcdWrt)
     C                   EVAL      DDAUTH =
     C                             %SUBST(OldScrnFmt:WFromDS:10)
     C                   EVAL      DDLTYP =
     C                             %SUBST(OldScrnFmt:WFromDS+10:2)
     C                   EVAL      DDPRG1 =
     C                             %SUBST(OldScrnFmt:WFromDS+12:2)
     C                   EVAL      DDPRG2 =
     C                             %SUBST(OldScrnFmt:WFromDS+14:2)
     C                   EVAL      DDPRG3 =
     C                             %SUBST(OldScrnFmt:WFromDS+16:2)
     C                   EVAL      DDPRG4 =
     C                             %SUBST(OldScrnFmt:WFromDS+18:2)
     C                   EVAL      DDTYPA =
     C                             %SUBST(OldScrnFmt:WFromDS+20:2)
      *
      ** Get authority holder shortname
      *
      ** Check if its a valid Non-Account Holder
      *
     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDAUTH        PCust
     C     SDNAHO        PARM      SDNAHO        DSSDY
      *
     C                   IF        PRtcd = *BLANKS
     C**********         MOVE      NHNAHO        DDAUSN                                    BUG25211C
     C                   MOVEL     NHSHNM        DDAUSN                                    BUG25211C
     C                   ELSE
      *
      ** If not found, it must be customer
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDAUTH        PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS OR
     C                             PStKey = 'ERROR'
     C                   MOVE      *BLANKS       DDAUSN
     C                   ELSE
     C                   MOVE      BBCSSN        DDAUSN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      SRErrInd
      *
     C                   ADD       1             WSflRrn
      *
     C                   IF        WMode = '*ADD' OR
     C                             (WMode = '*CHG' AND
     C                             PCalledFrom = 'RPR')
     C                   EVAL      *IN15 = *ON
     C                   ENDIF
      *
     C                   WRITE     SDACUDS0
      *
     C                   IF        WMode = '*ADD' OR
     C                             (WMode = '*CHG' AND
     C                             PCalledFrom = 'RPR')
     C                   EVAL      *IN15 = *OFF
     C                   ENDIF
      *
     C                   IF        %REM(WRcdWrt:150) = 0
     C                   ADD       1             WRcdWrt
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             WRcdWrt
      *
     C                   EVAL      WFromDS = WFromDS + 22
     C                   EVAL      WFromOK = WFromOK + 7
      *
     C                   ENDDO
      *
     C                   IF        WSflRrn > 0
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrInd - Set Error Indicators                              *
      *                                                               *
      *  Called By: SRDispScrn                                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRErrInd      BEGSR
      *
     C                   IF        ActnOK(WRcdWrt) = 'N'
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK:1) = 'N'
     C                   EVAL      *IN34 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK+1:1) = 'N'
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK+2:1) = 'N'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK+3:1) = 'N'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK+4:1) = 'N'
     C                   EVAL      *IN38 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK+5:1) = 'N'
     C                   EVAL      *IN39 = *ON
     C                   ENDIF
      *
     C                   IF        %SUBST(OKCuahDS:WFromOK+6:1) = 'N'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG23775
      *                                                               *                     BUG23775
      *  SRGetSName - Get Short Name                                  *                     BUG23775
      *                                                               *                     BUG23775
      *  Called By:   SRLoad                                          *                     BUG23775
      *                                                               *                     BUG23775
      *  Calls:                                                       *                     BUG23775
      *                                                               *                     BUG23775
      *****************************************************************                     BUG23775
      *                                                                                     BUG23775
     C     SRGetSName    BEGSR                                                              BUG23775
      *                                                                                     BUG23775
      ** Get Customer Shortname                                                             BUG23775
      *                                                                                     BUG23775
     C                   CALL      'AOCUSTR0'                                               BUG23775
     C                   PARM      *BLANKS       PRtcd                                      BUG23775
     C                   PARM      '*KEY'        POptn                                      BUG23775
     C                   PARM      DDCUST        PCust                                      BUG23775
     C                   PARM      *BLANKS       PStKey                                     BUG23775
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23775
      *                                                                                     BUG23775
     C                   IF        PRtcd <> *BLANKS                                         BUG23775
     C                   MOVE      *BLANKS       DDCUSN                                     BUG23775
     C                   ELSE                                                               BUG23775
     C                   MOVE      BBCSSN        DDCUSN                                     BUG23775
     C                   ENDIF                                                              BUG23775
      *                                                                                     BUG23775
     C                   ENDSR                                                              BUG23775
      *****************************************************************                     BUG23775
      /EJECT                                                                                BUG23775
      *****************************************************************
      *                                                               *
      *  SRF09 - Processing for F09                                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRReturn                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRF09         BEGSR
      *
     C                   EVAL      *INKI = *OFF
     C                   EVAL      PINKI = *ON
      *
     C                   IF        WMode = '*CHG'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
      *
     C                   EXSR      SRReturn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF03 - Processing for F03                                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRReturn                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRF03         BEGSR
      *
     C                   EVAL      PINKC = *ON
     C                   EXSR      SRReturn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF05 - Processing for F05                                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRReturn                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRF05         BEGSR
      *
     C                   EVAL      *INKE = *OFF
     C                   EVAL      PINKE = *ON
     C                   EXSR      SRReturn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF12 - Processing for F12                                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRReturn                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRF12         BEGSR
      *
     C                   IF        WMode = '*ADD'                                           BUG24083
     C                   EVAL      *IN89 = *ON                                              BUG24083
     C                   EVAL      PINKL = *OFF                                             BUG24083
     C                   ELSE                                                               BUG24083
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      PINKL = *ON
     C                   ENDIF                                                              BUG24083
                                                                                            BUG24083
     C                   EXSR      SRReturn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return to SIN                                     *
      *                                                               *
      *  Called By: Main Processing, SRF09, SRF03, SRF05, SRF12       *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReturn      BEGSR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   IF        RunBefore = *BLANKS
     C                   CALL      'DBERRCTL'
     C                   ENDIF
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Clear/Reset Subfile                                *
      *                                                               *
      *  Called By: SRLoad                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear subfile and reset subfile display indicator
      *
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *OFF
     C                   WRITE     SDACUDC0
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
      *
      ** Reset Subfile record Number
      *
     C                   EVAL      WSflRrn = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processsing                                 *
      *                                                               *
      *  Called By: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    Returncode
     C                   PARM                    DDACTN
     C                   PARM                    DDCUST
     C                   PARM                    WMode
     C                   PARM                    NewScrnFmt
     C                   PARM                    OldScrnFmt
     C                   PARM                    FldCuArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    ActnOK
     C                   PARM                    ActnArr
     C                   PARM                    PCalledFrom
     C                   PARM                    PEdtft
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKI
     C                   PARM                    PINKL
     C                   PARM                    OKCuahDS
     C                   PARM                    OKCuArr
     C                   PARM                    PTotRcd
      *
     C                   MOVEL     'SDCUAHDSP'   DBPGM
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   EVAL      DDPRGM = PSProcName
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDJBNM = PSJobName
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error.
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     001           DBASE
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      DDMRDT = BJMRDT
      *
     C                   WRITE     SDACUDC0
      *
     C**********         IF        DDACTN = 'I'                                             BUG23774
     C**********         EVAL      *IN71  = *ON                                             BUG23774
     C**********         EVAL      *IN72  = *ON                                             BUG23774
     C**********         EVAL      *IN87  = *OFF                                            BUG23774
     C**********         EVAL      *IN89  = *OFF                                            BUG23774
     C**********         ENDIF                                                              BUG23774
      *
     C**********         IF        DDACTN = 'A'                                             BUG23774
     C**********         EVAL      *IN71  = *ON                                             BUG23774
     C**********         EVAL      *IN72  = *ON                                             BUG23774
     C**********         EVAL      *IN87  = *OFF                                            BUG23774
     C**********         EVAL      *IN89  = *OFF                                            BUG23774
     C**********         ENDIF                                                              BUG23774
      *
     C**********         IF        DDACTN = 'E'                                             BUG23774
     C**********         EVAL      *IN71  = *OFF                                            BUG23774
     C**********         EVAL      *IN72  = *OFF                                            BUG23774
     C**********         EVAL      *IN87  = *ON                                             BUG23774
     C**********         EVAL      *IN89  = *ON                                             BUG23774
     C**********         ENDIF                                                              BUG23774
      *
     C**********         IF        DDACTN = 'D'                                             BUG23774
     C**********         EVAL      *IN71  = *OFF                                            BUG23774
     C**********         EVAL      *IN72  = *OFF                                            BUG23774
     C**********         EVAL      *IN87  = *ON                                             BUG23774
     C**********         EVAL      *IN89 = *OFF                                             BUG23774
     C**********         ENDIF                                                              BUG23774
      *
      ** Get Customer Shortname
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDCUST        PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS OR
     C                             PStKey = 'ERROR'
     C                   MOVE      *BLANKS       DDCUSN
     C                   ELSE
     C                   MOVE      BBCSSN        DDCUSN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnter - Read the subfile and Update the Screen Format      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRReturn                                              *
      *                                                               *
      *****************************************************************
      *
     C     SREnter       BEGSR
      *
     C                   EVAL      WEof = 'N'
                                                                                            BUG22473
      ** Skip processing processing of subfile if no records found                          BUG22473
                                                                                            BUG22473
     C                   IF        PTotRcd > 0                                              BUG22473
      *
     C                   IF        WMode = '*CHG'
     C                   EXSR      SRArrtoScrnC
     C                   ELSE
     C                   EXSR      SRArrtoScrnA
     C                   ENDIF
     C                   ENDIF                                                              BUG22473
      *
     C                   IF        WEof = 'N'
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRArrtoScrnA  - Add Mode Array to Screen                     *
      *                                                               *
      *  Called by: SREnter                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRArrtoScrnA  BEGSR
      *
     C                   EVAL      WCtr = 1
      *
     C                   CLEAR                   FldCuArr
      *
     C                   READC     SDACUDS0                               98
      *
     C                   IF        *IN98 = *ON
     C                   EVAL      WEof = 'Y'
     C                   ENDIF
      *
     C                   DOW       *IN98 = *OFF
      *
     C                   IF        DDAUTH <> *BLANKS OR
     C                             DDLTYP <> *BLANKS OR
     C                             (DDPRG1 <> 'AL' AND
     C                             DDPRG1 <> *BLANKS) OR
     C                             DDPRG2 <> *BLANKS OR
     C                             DDPRG3 <> *BLANKS OR
     C                             DDPRG4 <> *BLANKS OR
     C                             DDTYPA <> *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):1:10) = DDAUTH
     C                   EVAL      %SUBST(FldCUArr(WCtr):11:2) = DDLTYP
     C                   EVAL      %SUBST(FldCUArr(WCtr):13:2) = DDPRG1
     C                   EVAL      %SUBST(FldCUArr(WCtr):15:2) = DDPRG2
     C                   EVAL      %SUBST(FldCUArr(WCtr):17:2) = DDPRG3
     C                   EVAL      %SUBST(FldCUArr(WCtr):19:2) = DDPRG4
     C                   EVAL      %SUBST(FldCUArr(WCtr):21:2) = DDTYPA
     C                   EVAL      WCtr = WCtr + 1
     C                   ELSE
     C                   EVAL      %SUBST(FldCUArr(WCtr):1:10) =
     C                             *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):11:2) =
     C                             *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):13:2) =
     C                             *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):15:2) =
     C                             *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):17:2) =
     C                             *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):19:2) =
     C                             *BLANKS
     C                   EVAL      %SUBST(FldCUArr(WCtr):21:2) =
     C                             *BLANKS
      *
     C                   ENDIF
      *
     C                   READC     SDACUDS0                               98
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRArrtoScrnC  - Change Mode Array to Screen                  *
      *                                                               *
      *  Called by: SREnter                                           *
      *                                                               *
      *  Calls: SRLdScrFmt                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRArrtoScrnC  BEGSR
      *
     C                   READC     SDACUDS0                               98
      *
     C                   IF        *IN98 = *ON
     C                   EVAL      WEof = 'Y'
     C                   ENDIF
      *
     C                   DOW       *IN98 = *OFF
      *
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):1:10) =
     C                             DDAUTH
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):11:2) =
     C                             DDLTYP
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):13:2) =
     C                             DDPRG1
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):15:2) =
     C                             DDPRG2
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):17:2) =
     C                             DDPRG3
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):19:2) =
     C                             DDPRG4
     C                   EVAL      %SUBST(FldCUArr(WSflRrn):21:2) =
     C                             DDTYPA
      *
     C                   EVAL      ActnArr(WSflRrn) = DDSELC
      *
     C                   READC     SDACUDS0                               98
      *
     C                   ENDDO
      *
     C                   EVAL      WCtr = 1
     C                   EXSR      SRLdScrFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send message to program's message Queue           *
      *                                                               *
      *  Called by : SRLoad                                           *
      *                                                               *
      *  Calls : ZA0350                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMsg      BEGSR
      *
      ** If no message file specified, use the default message file
      *
     C                   EVAL      Ix = 1
      *
     C                   DOW       MsgIDArr(Ix) <> *BLANKS
      *
     C                   MOVEL     MsgIDArr(Ix)  PMsgId
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   EVAL      Ix = Ix + 1
      *
     C                   ENDDO
      *
     C                   EVAL      MsgIDArr = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetErrLoc - To get the Error Locations                     *
      *                                                               *
      *  Called by : SRLoad                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRGetErrLoc   BEGSR
      *
     C                   EVAL      WCtr = 1
     C                   EVAL      WToArr = *ZEROS
      *
     C                   DOW       WCtr <= PTotRcd
      *
     C                   IF        %SCAN('N':OKCuArr(Wctr)) <> 0
     C                   EVAL      WToArr = WCtr
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WCtr = Wctr + 1
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C/COPY ZSRSRC,ZDATE2Z2LE
      *
      *****************************************************************
      ** Program, module and procedure names for database error
      ** procesing
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2008
