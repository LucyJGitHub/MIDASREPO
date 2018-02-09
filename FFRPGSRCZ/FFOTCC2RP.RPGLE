     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF OTCC - Repair')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCC2RP - Futures and Options Repair                       *
      *                                                               *
      *  Function:  This Function allows invalid Extended Currency OTC*
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  Entry Module of:  FFOTCC2RP  - FF Currency OTC Repair pgm    *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  *IN03  -  F3 Pressed exit program                            *
      *  *IN05  -  F5 Pressed redisplay the screen                    *
      *  *IN10  -  F10 Pressed delete                                 *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN25  -  SFLEND control                                     *
      *  *IN30  -  Redisplay the screen                               *
      *  *IN35  -  Enable F5                                          *
      *  *IN40  -  Enable F10                                         *
      *  *IN50  -  Error on field L6LXTIME                            *
      *  *IN51  -  Error on field L6LXCABR                            *
      *  *IN85  -  Chain to FFIOTLXY6 FAILED - RTVIDX1                *
      *  *IN99  -  Chain indicator                                    *
      *                                                               *
      *****************************************************************
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** First DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
     D @EI             S              1    DIM(2)
 
      ** New Futures and Options in File Format (#6LXFF)
     D NwDlFilFmt    E DS                  EXTNAME(FFVTNLX1PD)
 
      ** New Futures and Options in Screen Format (#nLX)
     D NwDlScnFmt    E DS                  EXTNAME(FFOTRXPD)
 
      ** New Futures and Options in Screen Format (Reset purposes)
     D PrvDlScnFmt   E DS                  EXTNAME(FFOTRXPD) PREFIX(P)
 
      ** Error indicators (OK#6LX)
     D OkFlags       E DS                  EXTNAME(FFEOTLX1PD)
 
      ** Data passed from caller program
     D DATALUX         DS          1024
     D  #1FLD1                 1      6  0
     D  #1ISTT                 1      5
     D  #1TNBR                 6     11
     D  #1MRKT                12     13
     D  #1FOTR                14     33
     D  #1TMST                34     59Z
     D  #1DEXT                60     60
      **
      **   Declared variables
      **   ==================
      **
      ** Fields for getting the starting field number from file (para-
      ** meters to ZAGETFLDNO, plus the offset to the requested field).
 
     D Format          S             10A   INZ('FFOTCCPD')
     D Field           S             10A   INZ('L6LXTIME')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
 
      ** "Standard" variables
 
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D W0RTN           S              7
 
      ** "Standard" modules parameters
 
      ** Enable Function Keys
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
      ** Function Keys
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
      ** Index error array
     D Idx             S              3P 0 INZ(0)
 
      ** Index warning array
     D WIdx            S              3P 0 INZ(0)
 
     D E               S              3  0
     D F               S              3  0
     D WWFLD#6         S              2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  Standard parameter list for window manager                   *
      *                                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    W0RTN
     C                   PARM                    NwDlScnFmt
     C                   PARM                    NwDlFilFmt
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Save initial screen format value
      *
     C                   EVAL      PrvDlScnFmt = NwDlScnFmt
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C                   DOU       WWERR = 'N'
      *
     C                   CALLB     'FFOTCC3DP'
      *
      ** INPUT Parameters
      *
      ** Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Depotin screen format
      *
     C                   PARM                    NwDlScnFmt
      *
      ** Ok flags
      *
     C                   PARM                    OkFlags
      *
      ** Fields in error
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enable Function Keys
      *
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
      *
      ** Indicators
      *
     C                   PARM                    @EIN20
      *
      ** Run Date
      *
     C                   PARM                    BJMRDT
      *
      ** OUTPUT parameters
      ** Functions Keys
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *BLANKS       W0RTN
      *
      ** Verify action
      *
     C     @INKC         CASEQ     '1'           SREXIT
     C     @INKE         CASEQ     '1'           SRRESET
     C     @INKJ         CASEQ     '1'           SRDELET
     C     @INKL         CASEQ     '1'           SRPREV
     C                   CAS                     SRVALID
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   EXSR      SREND
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Validate the screen                                 *
      *                                                               *
      *****************************************************************
     C     SRVALID       BEGSR
      *
      ** If the action code is enquire then simply exit from program
      *
     C                   IF        ACTN = 'E' or
     C                             ACTN = 'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   IF        ACTN = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ERN0929'     MsgIdArr(1)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'FFOTCC3VL'
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      ** No errors so update the extension file
      *
     C                   IF        Idx = 0
     C                   EVAL      WWERR = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELET - Delete record                                       *
      *                                                               *
      *****************************************************************
     C     SRDELET       BEGSR
      *
     C                   EXSR      SREND
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
      *
      *
     C                   EVAL      *InLR = *On
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Exit from program if F3 has been pressed             *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
      *
     C                   MOVE      'Y2U9999'     W0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESET - Refresh the screen if F5 has been pressed           *
      *                                                               *
      *****************************************************************
     C     SRRESET       BEGSR
      *
      ** Clear the program message queue and call SR/SRINIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   EXSR      SRINIT
      *
      ** Restore initial value of NwDlScnFmt
      *
     C                   EVAL      NwDlScnFmt = PrvDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPREV - Exit from program if F12 has been pressed            *
      *                                                               *
      *****************************************************************
     C     SRPREV        BEGSR
      *
     C                   MOVE      'USR0790'     W0RTN
     C                   EVAL      NwDlScnFmt = PrvDlScnFmt
     C                   EXSR      SREND
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Only do first time through
      *
     C                   IF        WFIRST = *BLANKS
      *
      ** Get installation control data
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Protect input fields if enquiry and enable command keys accor-
      ** ding to action code
      *
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
      *
      ** When "E" or "X", protect fields
      *
     C                   WHEN      ACTN = 'E' or
     C                             ACTN = 'X'
     C                   EVAL      @EIN20 = 'Y'
      *
      ** When "D", protect fields, enable Delete key and
      ** disable Refresh key
      *
     C                   WHEN      ACTN = 'D'
     C                   EVAL      @EIN20 = 'Y'
     C                   EVAL      @EINKJ = 'Y'
     C                   EVAL      @EINKE = 'N'
      *
      ** When "I" or "A", disable Delete key and enable Refresh key
      *
     C                   WHEN      ACTN = 'I' or
     C                             ACTN = 'A'
     C                   EVAL      @EINKJ = 'N'
     C                   EVAL      @EINKE = 'Y'
     C                   ENDSL
      *
      ** Setup key values using transaction data passed from caller
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOTR
     C                   KFLD                    #1TMST
      *
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Retrieve record in extension file
      *
      ** Get the field number for the first file on the window screen;
      ** the screen fields start from that number. Subtract one from
      ** it to give the value to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ** If there was an error default the offset to 53
      ** (first extension field sequence  - 1 on ZAFLDNPD file (member
      ** FFOTCCPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset = 53
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for deal
      *
     C                   IF        #1DEXT  = 'Y'
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   EVAL      E = 0
      *
     C                   DOW       Not *In99
      *
     C                   MOVEL     ABFIELDNAM    WWFLD#6
      *
     C                   IF        WWFLD#6 = 'L6'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OkFlags
     C                   ENDIF
      *
      ** If delete does not require window to be displayed, do here
      *
     C                   IF        ACTN = 'D'
     C                   EXSR      SRDELET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
