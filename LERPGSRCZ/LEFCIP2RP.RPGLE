     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Input LUX Repair')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIP2RP - LE Facilities Input LUX Repair                   *
      *                                                               *
      *  Function:  This module handles window processing when        *
      *             transaction is entered via RPR                    *
      *                                                               *
      *  Called by: LEFCIPRPR - LE Facility Input Repair              *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  85 - Found indicator                                         *
      *  99 - ReadE EOF indicator                                     *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT  - Initialization Subroutine                          *
      *  SRDELET - Delete record                                      *
      *  SRVALID - Validate the screen                                *
      *  SREND   - Exit from program                                  *
      *  SREXIT  - Exit from program if F3 has been pressed           *
      *  SRRESET - Refresh the screen if F5 has been pressed          *
      *  SRPREV  - Exit from program if F12 has been pressed          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      /EJECT
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
      /EJECT
      **---------------------------------------------------------------
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
      /EJECT
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** First DS for access programs, long data structure
      *
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Bank Details
      *
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External data structures for Midas Modules
      *
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External data structure for Currency Details file
      *
 
      **---------------------------------------------------------------
      ** External File DS
      **---------------------------------------------------------------
     D NwFCIPScnFmt  E DS                  EXTNAME(LEFCRXPD)
      *
      ** LE Facility input extra data layout File
      *
     D PrvFCIPScnFmt E DS                  EXTNAME(LEFCRXPD) PREFIX(P)
      *
      ** LE Facility input extra data layout File
      *
     D NwFCIPFilFmt  E DS                  EXTNAME(LEVFCLX1PD)
      *
      ** LE Facility  Valid File
      *
     D OKFlags       E DS                  EXTNAME(LEEFCLX1PD)
      *
      ** LE facility LUX error definition file
      *
 
      **---------------------------------------------------------------
      ** Definitions of Variables
      **---------------------------------------------------------------
 
     D DATALUX         DS          1024
      *
      **  Data  Structure for LUX Data
      *
     D  #1CNUM                 1      6
     D  #1FACT                 7      9
     D  #1FCNO                10     11
     D  #1RCTP                12     12
     D  #1CCY                 13     15
     D  #1AMNT                16     30S 0
     D  #1TMSP                31     56Z
     D  #1FOID                57     76
     D  #1DEXT                77     77
 
     D @EI             S              1    DIM(5)
      *
      ** Entry Parameters
      *
     D PACTN           S              1
     D PW0RTN          S              7
     D PReturnCode     S             10
      *
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested
      ** field).
      *
 
     D Format          S             10A   INZ('LEFCIPPD')
     D Field           S             10A   INZ('LSUBR')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
      *
      ** Array Index
      *
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
 
      *
      ** Standards Variables
      *
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D E               S              3S 0
     D F               S              3S 0
     D WWFLD#L         S              2A
 
      *
      ** Enable delete keys
      *
     D @EINKJ          S              1
      *
      ** Enable refresh keys
      *
     D @EINKE          S              1
      *
      ** Enable/protect field indicator
      *
     D @EIN20          S              1
      *
      ** Function keys
      *
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
 
      **---------------------------------------------------------------
      ** Calculation Specs
      **---------------------------------------------------------------
 
 
      ** Save first the screen details
 
     C                   EVAL      PrvFCIPScnFmt = NwFCIPScnFmt
 
     C                   EXSR      SRINIT
 
     C     WWERR         DOUEQ     'N'
     C                   CALLB     'LEFCIP3DP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwFCIPScnFmt
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
      ** Write Error Message to Subfile
 
     C                   MOVE      *ALL'Y'       OkFlags
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *BLANKS       PW0RTN
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
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Validate the screen                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALID       BEGSR
      *
      ** If the action code is enquire then simply exit from program
      *
     C                   IF        PACTN   = 'E' Or PACTN= 'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   IF        PACTN   = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ERN0929'     MsgIdArr(1)
     C                   GOTO      VAEXIT
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'LEFCIP3VL'
     C                   PARM                    PACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwFCIPScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwFCIPFilFmt
      *
      ** No errors, exit
      *
     C                   IF        Idx     = 0 And WIdx = 0
     C                   MOVE      'N'           WWERR
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELET - Delete record                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRDELET       BEGSR
      *
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialization Subroutine                            *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
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
      *
     C                   IF        @RTCD  <> *BLANKS
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
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C                   WHEN      PACTN   =  'E' Or
     C                             PACTN   =  'X'
     C                   MOVEL     'Y'           @EIN20
     C                   WHEN      PACTN   =  'D'
     C                   MOVEL     'Y'           @EIN20
     C                   MOVEL     'Y'           @EINKJ
     C                   MOVEL     'N'           @EINKE
     C                   WHEN      PACTN   =  'I' Or
     C                             PACTN   =  'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKE
     C                   ENDSL
      *
      ** Setup key values using transaction data passed from caller
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOID
     C                   KFLD                    #1TMSP
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
      ** Get the field number for the first file on the window screen;
      ** the screen fields start from that number. Subtract one from
      ** from it to give the value to subtract from each field's
      ** number.
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
      ** If there was an error default the offset to 185
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member SDCUSDPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset = 53
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for customer
      *
     C     #1DEXT        IFEQ      'Y'
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   Z-ADD     0             E
      *
     C                   DOW       *In85   = '0'
      *
     C                   MOVEL     ABMSGID       WWFLD#L
      *
     C                   IF        WWFLD#L = 'ER'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             85
     C                   ENDDO
      *
     C                   MOVEA     @EI           OkFlags
     C                   ENDIF
      *
      ** If delete does not require window to be displayed, do here
      *
     C                   IF        PACTN   = 'D'
     C                   EXSR      SRDELET
     C                   ENDIF
      *
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   EVAL      *INLR   = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPREV - Exit from program if F12 has been pressed            *
      *                                                               *
      *****************************************************************
      *
     C     SRPREV        BEGSR
      *
     C                   MOVE      'USR0790'     PW0RTN
     C                   EVAL      NwFCIPScnFmt = PrvFCIPScnFmt
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESET - Refresh the screen if F5 has been pressed           *
      *                                                               *
      *****************************************************************
      *
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
     C                   EVAL      NwFCIPScnFmt = PrvFCIPScnFmt
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Exit from program if F3 has been pressed             *
      *                                                               *
      *****************************************************************
      *
     C     SREXIT        BEGSR
      *
     C                   MOVE      'Y2U9999'     PW0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  Standard parameter list for window manager                   *
      *                                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PACTN
     C                   PARM                    DATALUX
     C                   PARM                    PW0RTN
     C                   PARM                    NwFCIPScnFmt
     C                   PARM                    NwFCIPFilFmt
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
