     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Repair - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSD2RP - Customers Repair - Extension                     *
      *                                                               *
      *  Function:  This function allows invalid extended Customers   *
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  Entry Module of:  SDCUSD2RP  - SD Customers Repair pgm       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG13228           Date 07Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG13228- Change to parameters of SDCUSD9VL                  *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
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
      *  *IN50  -  Error on field L6LXPAPS                            *
      *  *IN51  -  Error on field L6LXCGRP                            *
      *  *IN52  -  Error on field L6LXCONS                            *
      *  *IN53  -  Error on field L6LXECOS                            *
      *  *IN54  -  Error on field L6LXNCOS                            *
      *  *IN55  -  Error on field L6LXINRF                            *
      *  *IN56  -  Error on field L6LXPERF                            *
      *  *IN57  -  Error on field L6LXAUTG                            *
      *  *IN58  -  Error on field L6LXPROG                            *
      *  *IN59  -  Error on field L6LXASSP                            *
      *  *IN61  -  Error on field L6LXICCD                            *
      *  *IN62  -  Error on field L6LXMCID                            *
      *  *IN63  -  Error on field L6LXSMRS                            *
      *  *IN70  -  Protect/display field L6LXAUTG, L6LXPROG, L6LXASSP *
      *  *IN72  -  Protect/display field L6LXICCD, L6LXMCID           *
      *  *IN85  -  Chain to SDICULXY6 FAILED - RTVIDX1                *
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
      **                         error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
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
 
     D @EI             S              1    DIM(13)
 
      ** Current Customer in File Format (VF)
     D CrDlFilFmt    E DS                  EXTNAME(SDCUX2L0)
 
      ** Current Customer (invalid) in Screen Format (#6LX)
     D CrDlScnFmt    E DS                  EXTNAME(SDICULX2PD)
     D                                     PREFIX(SS)
 
      ** New Customer in File Format (#6LXVF)
     D NwDlFilFmt    E DS                  EXTNAME(SDVCULX2PD)
 
      ** New Customer in Screen Format (#nLX)
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)
 
      ** Previous Customer in Screen Format
     D PrvDlScnFmt   E DS                  EXTNAME(SDCURXPD) PREFIX(P)
 
      ** Error indicators (OK#6LX)
     D OkFlags       E DS                  EXTNAME(SDECULX2PD)
 
      ** Data passed from caller program
     D PDATA           DS          1024
     D**#1FLD1**               1      6  0                                                   CSD027A
 
     D  #1CUST                 1      6
     D  #1PAIN                 7      7
     D  #1PCNB                 8     13
     D  #1COLC                15     16
     D  #1LINC                17     18
     D  #1BRCD                19     21
     D  #1BNBI                22     22
     D  #2CNCZ                23     24
     D  #1FOTR                45     64
     D  #1TMST                65     90Z
     D  #1CRNM                91    110
     D  #1NCOS               111    114
     D  #1DEXT               115    115
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested
      ** field).
 
     D Format          S             10A   INZ('SDCUSDPD')
     D Field           S             10A   INZ('L6LXPAPS')
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
     D TITLE           S              7
 
      ** "Standard" modules parameters
 
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
      ** Extra Input Parameters
 
     D ULX008          S              1
     D ULX012          S              1
     D ULX004          S              1                                                     BUG13228
     D BJMRDT          S              1
     D BGLRIN          S              1
 
     D Idx             S              3P 0 INZ(0)
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
     C                   PARM                    PDATA
     C                   PARM                    W0RTN
     C                   PARM                    NwDlScnFmt
     C                   PARM                    NwDlFilFmt
     C                   PARM                    ULX008
     C                   PARM                    ULX012
     C                   PARM                    BJMRDT
     C                   PARM                    BGLRIN
     C                   PARM                    ULX004                                     BUG13228
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
 
      ** Save first the screen details
 
     C                   EVAL      PrvDLScnFmt = NwDLScnFmt
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C     WWERR         DOUEQ     'N'
      *
     C                   CALLB     'SDCUSD9DP'
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
      *
      ** Extra Input Parameters
      *
     C                   PARM                    ULX008
     C                   PARM                    ULX012
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
     C                   PARM                    BJMRDT
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
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
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C     ACTN          IFEQ      'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ERN0929'     MsgIdArr(1)
     C                   GOTO      VAEXIT
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'SDCUSD9VL'
     C                   PARM                    ACTN
     C                   PARM                    PDATA
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
      ** Extra Input Parameters
      *
     C                   PARM                    ULX008
     C                   PARM                    ULX012
     C                   PARM                    ULX004                                     BUG13228
      *
      ** No errors so update the extension file
      *
     C     Idx           IFEQ      0
     C                   MOVE      'N'           WWERR
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
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
     C                   SETON                                        LR
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
     C                   EVAL      NwDLScnFmt = PrvDLScnFmt
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
     C     WFIRST        IFEQ      *BLANKS
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      *
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C     ACTN          WHENEQ    'E'
     C     ACTN          OREQ      'X'
     C                   MOVEL     'Y'           @EIN20
     C     ACTN          WHENEQ    'D'
     C                   MOVEL     'Y'           @EIN20
     C                   MOVEL     'Y'           @EINKJ
     C                   MOVEL     'N'           @EINKE
     C     ACTN          WHENEQ    'I'
     C     ACTN          OREQ      'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKE
     C                   ENDSL
      *
      ** Setup key values using transaction data passed from caller
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOTR
     C                   KFLD                    #1TMST
      *
     C                   MOVE      'N'           WFIRST
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
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ** If there was an error default the offset to 188
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member SDCUSDPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset = 188
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
     C                   Z-ADD     0             E
      *
     C     *IN99         DOWEQ     '0'
      *
     C                   MOVEL     ABFIELDNAM    WWFLD#6
      *
     C     WWFLD#6       IFEQ      'L6'
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
     C     ACTN          IFEQ      'D'
     C                   EXSR      SRDELET
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
