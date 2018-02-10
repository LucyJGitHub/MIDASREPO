     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits LUX Repair')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMNASP2RP - Negotiable Assets Purchase LUX Repair            *
      *                                                               *
      *  Function:  This function allows invalid extended NASP        *
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  Entry Module of:  MMNASP2RP  - MM NASP Repair pgm            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 09May06               *
      *                 BUG9711            Date 26Jan06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *            (recompile)                                        *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN25  -  SFLEND control                                     *
      *  *IN50  -  Error on field L6LXLUSU                            *
      *  *IN51  -  Error on field L6LXIM93                            *
      *  *IN52  -  Error on field L6LXCLAT                            *
      *  *IN53  -  Error on field L6LXCOAM                            *
      *  *IN54  -  Error on field L6LXSUBR                            *
      *  *IN55  -  Error on field L6LXMOBL                            *
      *  *IN56  -  Error on field L6LXRISC                            *
      *  *IN57  -  Error on field L6LXGUAC                            *
      *  *IN58  -  Error on field L6LXIMEX                            *
      *  *IN59  -  Error on field L6LXPPSC                            *
      *  *IN60  -  Error on field L6LXGUAC                            *
      *  *IN61  -  Error on field L6LXEVMT                            *
      *  *IN62  -  Error on field L6LXOPTP                            *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** External DS for dealing details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** First DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Currency Details file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D @EI             S              1    DIM(14)
 
      ** New Deal in File Format (#6LXVL)
     D NwDlFilFmt    E DS                  EXTNAME(MMVNPLX1PD)
 
      ** New Deal in Screen Format (LnLX)
     D NwDlScnFmt    E DS                  EXTNAME(MMNPRXPD)
 
      ** New Deal in Screen Format (Reset purposes)
     D PrvDlScnFmt   E DS                  EXTNAME(MMNPRXPD) PREFIX(P)
 
      * Valid file layout
     D ValidDeal     E DS                  EXTNAME(MMVNASPPD)
      ** Error indicators (OK#6LX)
     D OkFlags       E DS                  EXTNAME(MMENPLX1PD)
 
 
      ** Data passed from caller program
     D/COPY QWINDSRC,MMLDNISDTA
     D DATALUX         DS          1024
     D  L1FLD1                 1      6  0
     D  L1DN38                 1      6
     D  L1DLTP                 7      8
     D  L1CNUM                 9     14
     D  L1CCY                 15     17
     D  L1AMNT                18     32  0
     D  L1VDAT                33     38
     D  L1MDAT                39     44
     D  L1FOTR                45     64
     D  L1TMST                65     90Z
     D  #1DEXT                91     91
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
 
     D Format          S             10A   INZ('MMNASPPD')
     D Field           S             10A   INZ('L6LXLUSU')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
      ** "Standard" variables
 
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D SROW            S              3S 0
     D SCOL            S              3S 0
     D TITLE           S              7
 
      ** "Standard" modules parameters
 
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
     D ZFIELD          S             16
     D ZADEC           S              1  0
 
     D @CURR           S              3
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
     C                   PARM                    @RTCD
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    W0RTN
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ValidDeal
 
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
 
     C                   CALLB     'MMNASP2DP'
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
     C                   PARM                    @EIN20
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      W0RTN = *BLANKS
      *
      ** Verify action
      *
     C     @INKC         CASEQ     '1'           SREXIT
     C     @INKE         CASEQ     '1'           SRRESET
     C     @INKJ         CASEQ     '1'           SRDELET
     C     @INKL         CASEQ     '1'           SRPREV
     C                   CAS                     SRVALID
     C                   ENDCS
 
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   EXSR      SREND
 
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
 
     C                   IF        ACTN = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ERN0929'     MsgIdArr(1)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'MMNASP2VL'
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ValidDeal
     C                   PARM                    BNDCSP
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELET - Delete record                                       *
      *                                                               *
      *****************************************************************
     C     SRDELET       BEGSR
 
     C                   EXSR      SREND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Exit from program if F3 has been pressed             *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
 
     C                   MOVE      'Y2U9999'     W0RTN
     C                   EXSR      SREND
 
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
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
 
     C                   EXSR      SRINIT
      *
      ** Restore initial value of NwDlScnFmt
      *
     C                   EVAL      NwDlScnFmt = PrvDlScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPREV - Exit from program if F12 has been pressed            *
      *                                                               *
      *****************************************************************
     C     SRPREV        BEGSR
 
     C                   EVAL      W0RTN   = 'USR0790'
     C                   EVAL      NwDlScnFmt = PrvDlScnFmt
     C                   EXSR      SREND
 
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
     C                   IF        WFIRST = *Blanks
      *
      ** Get installation control data
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      *
      *
     C                   SELECT
     C                   WHEN      ACTN = 'E' or
     C                             ACTN = 'X'
     C                   EVAL      @EIN20 = 'Y'
      *
     C                   WHEN      ACTN = 'D'
     C                   EVAL      @EIN20 = 'Y'
     C                   EVAL      @EINKJ = 'Y'
     C                   EVAL      @EINKE = 'N'
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
     C                   KFLD                    L1FOTR
     C                   KFLD                    L1TMST
      *
      ** Access Currency file to retrieve decimal position
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      L1CCY         @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RtCd         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     @CURR         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
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
 
     C                   IF        ReturnCode = *BLANK
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ** If there was an error default the offset to 71
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      *
     C                   ELSE
     C                   EVAL      FldOffset = 71
     C                   ENDIF
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AODEALR1'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDDEAL        PARM      SDDEAL        DSSDY
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
     C                   Z-ADD     0             E
 
     C                   DOW       Not *In99
 
     C                   MOVEL     ABMSGID       WWFLD#6
 
     C                   IF        WWFLD#6 = 'ER'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     @EI           OkFlags
     C                   ENDIF
      *
      ** If delete does not require window to be displayed, do here
      *
     C                   IF        ACTN = 'D'
     C                   EXSR      SRDELET
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
