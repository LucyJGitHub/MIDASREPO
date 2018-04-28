     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE TRAD - Repair - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SETRAD2RP - Trades Repair - LU Window                        *
      *                                                               *
      *  Function:  This Function allows Invalid Extended Trades to   *
      *             be 'repaired' and applied to the Midas Database   *
      *                                                               *
      *  Entry Module of:  SETRAD2RP  - SE Trades Repair pgm          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  *IN50  -  Error on field #6LXAGSD                            *
      *  *IN51  -  Error on field #6LXTTIM                            *
      *  *IN52  -  Error on field #6LXCABR                            *
      *  *IN53  -  Error on field #6LXMTRD                            *
      *  *IN70  -  Protect/display field #6LXTTIM and #6LXCABR        *
      *  *IN70  -  Protect/display field #6LXMTRD                     *
      *  *IN85  -  Chain to SEITDLXY6 FAILED - RTVIDX1                *
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
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
 
      **   Named constants
      **   ===============
 
      **   Arrays and Data Structures
      **   ==========================
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** First DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D @EI             S              1    DIM(4)
 
      ** New Trade in File Format (#6LXCC)
     D NwDlFilFmt    E DS                  EXTNAME(SEVTDLX1PD)
 
      ** New Trade in Screen Format (#nLX)
     D NwDlScnFmt    E DS                  EXTNAME(SETDRXPD)
 
      ** New Trade in Screen Format (Reset purposes)
     D PrvDlScnFmt   E DS                  EXTNAME(SETDRXPD) PREFIX(P)
 
      ** Error indicators (OK#6LX)
     D OkFlags       E DS                  EXTNAME(SEETDLX1PD)
 
      ** Data passed from caller program
     D/COPY QWINDSRC,SETRADGDTA
 
     D DATALUX         DS          1024
     D  QPETDRF                1      6
     D  QUTDBK                 7      8
     D  QUVTCNR                9     14
     D  #1TDVD                15     19  0
     D  #1TDDT                20     24  0
     D  #1ISSD                25     29  0
     D  #1MATY                30     34  0
     D  #1FOTR                35     54
     D  #1TMST                55     80Z
     D  #1DEXT                81     81                                                       CER001
 
      **   Declared variables
      **   ==================
 
      ** Fields for getting the starting field number from file (
      ** parameters to ZAGETFLDNO, plus the offset to the requested
      ** field).
 
     D Format          S             10A   INZ('SETRADPD')
     D Field           S             10A   INZ('L6LXAGSD')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
      ** "Standard" variables
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
 
      ** "Standard" *entry parameters
     D P@RtnCode       S              1
     D P@ActCode       S              1
     D P@DATALUX       S                   LIKE(DATALUX)
     D P@W0RTN         S              7
 
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
 
     D E               S              3S 0
     D F               S                   LIKE(E)
     D WWFLD#6         S              2A
 
     D ZDAYN           S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7
 
     D ULX008          S              1
     D ULX603          S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Standard parameter list for window manager                   *
      *                                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
      *
     C                   PARM                    P@RtnCode
     C                   PARM                    P@ActCode
     C                   PARM                    DATALUX
     C                   PARM                    P@W0RTN
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlScnFmt
      *
      *****************************************************************
      /EJECT
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
     C                   DOW       WWERR  <> 'N'
      *
     C                   CALLB     'SETRAD2DP'
      *
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
     C                   PARM                    ULX008
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      Idx        = *ZERo
     C                   EVAL      WIdx       = *ZERO
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      P@W0RTN    = *BLANKS
      *
      ** Verify action
      *
     C     @INKC         CASEQ     '1'           SREXIT
     C     @INKE         CASEQ     '1'           SRRESET
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
      *  SRVALID - Validate the screen                                *
      *                                                               *
      *****************************************************************
     C     SRVALID       BEGSR
      *
      ** If the action code is enquire then simply exit from program
      *
     C                   IF        P@ActCode = 'E' OR
     C                             P@ActCode = 'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   IF        P@ActCode = 'D'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'ERN0929'
     C                   ELSE
      *
      ** Validation for each fields.
      *
     C                   CALLB     'SETRAD2VL'
     C                   PARM                    P@RtnCode
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
     C                   PARM                    ULX008
      *
      ** No errors so update the extension file
      *
     C                   IF        Idx     = *ZERO
     C                   EVAL      WWERR   = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND - Exit from program                                    *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
      *
     C                   EVAL      *INLR   = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREXIT - Exit from program if F3 has been pressed            *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
      *
     C                   EVAL      P@W0RTN = 'Y2U9999'
     C                   EXSR      SREND
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESET - Refresh the screen if F5 has been pressed          *
      *                                                               *
      *****************************************************************
     C     SRRESET       BEGSR
      *
      ** Clear the program message queue and call SR/SRINIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
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
     C                   EVAL      P@W0RTN = 'USR0790'
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
     C                   IF        WFIRST  = *BLANKS
      *
      ** Get installation control data
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD  <> *BLANKS
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
 
     C                   IF        @RTCD  <> *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD)
      *
     C                   EVAL      ULX008  = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX008'      @SARD
      *
     C                   IF        @RTCD   = *BLANKS
     C                   EVAL      ULX008  = 'Y'
     C                   ENDIF
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      *
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C                   WHEN      P@ActCode = 'E' Or P@ActCode = 'X'
     C                   EVAL      @EIN20  = 'Y'
      *
     C                   WHEN      P@ActCode = 'D'
     C                   EVAL      @EIN20  = 'Y'
     C                   EVAL      @EINKJ  = 'Y'
     C                   EVAL      @EINKE  = 'N'
      *
     C                   When      P@ActCode = 'I' Or P@ActCode = 'A'
     C                   EVAL      @EINKJ  = 'N'
     C                   EVAL      @EINKE  = 'Y'
     C                   ENDSL
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOTR
     C                   KFLD                    #1TMST
      *
     C                   EVAL      WFIRST  = 'N'
     C                   ENDIF
      *
      ** Get the field number for the first file on the window screen;
      ** the screen fields start from that number. Subtract one from it
      ** to give the value to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset  = FieldNo - 1
      *
      ** If there was an error default the offset to 125
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member SETDEXPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset  = 134
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for deal
      *
     C                   IF        #1DEXT  = 'Y'                                              CER001
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   EVAL      E       = *ZERO
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WWFLD#6 = %SUBST(ABFIELDNAM:1:%SIZE(WWFLD#6))
      *
     C                   IF        WWFLD#6 = 'L6'
     C                   EVAL      E       = E + 1
     C                   EVAL      FldNameArr(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr(E)   = ABMSGID
     C                   EVAL      F       = ABFIELDID
     C                   EVAL      F       = F - FldOffset
     C                   EVAL      @EI(F)  = 'N'
     C                   ENDIF
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OkFlags
     C                   ENDIF
      *
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
(c) Misys International Banking Systems Ltd. 2005
