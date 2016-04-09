     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD - Repair - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD2RP - Invalid Account Details Repair Function          *
      *                                                               *
      *  Function:  This function allows invalid REACX1PD details to  *
      *             be 'repaired' and applied to the Midas database   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
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
      *  *IN50  -  Error on field L6LXCOBR and L6LXCOAC               *
      *  *IN51  -  Error on field L6LXCOAM                            *
      *  *IN52  -  Error on field L6LXLUSU                            *
      *  *IN53  -  Error on field L6LX1UAC                            *
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

      **---------------------------------------------------------------
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

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

      **
      **   Named constants
      **   ===============
      **

      **
      **   Arrays and Data Structures
      **   ==========================
      **

     D DataLux         DS          1024
     D  L1FLD1                 1      6  0
     D  L1CNUM                 1      6
     D  L1CCY                  7      9
     D  L1ACOD                10     19
     D  L1ACSQ                20     21
     D  L1BRCA                22     24
     D  L1ATYP                25     25
     D  L1STFQ                26     26
     D  L1AMNT                27     41  0
     D  L1FOTR                45     84
     D  L1TMST                85    110Z
     D  L1DEXT               111    111

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structures for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** New Account in File Format (#6LXWE)
     D NwDlFilFmt    E DS                  EXTNAME(GLVAMLX1PD)

      ** New Account in Screen Format (LnLX)
     D NwDlScnFmt    E DS                  EXTNAME(GLAMRXPD)

      ** New Account in Screen Format (Reset purposes)
     D PrvDlScnFmt   E DS                  EXTNAME(GLAMRXPD) PREFIX(P)

      ** Error indicators (OKL#LX)
     D OkFlags       E DS                  EXTNAME(GLEAMLX1PD)

     D @EI             S              1    DIM(5)

      ** Data passed from caller program
     D/COPY QWINDSRC,GLAMADDTA

      **
      **   Declared variables
      **   ==================
      **

      ** Fields for getting the starting field number from file
      ** (parmaters to ZAGETFLDNO, plus the offset to the requested
      ** field).

     D Format          S             10A   INZ('GLACCNPD')
     D Field           S             10A   INZ('L6LXCOBR')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0

      ** "Standard" variables

     D WFIRST          S              1
     D WWERR           S              1

      ** "Standard" *entry parameters

     D ACTN            S              1
     D W0RTN           S              7

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
     D L1FOTR20        S             20
     D E               S              3  0
     D F               S              3  0
     D WWFLDL6         S              2

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    ACTN
     C                   PARM                    DataLux
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
     C                   CALLB     'GLAMAD6DP'
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
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKJ
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
     C                   IF        ACTN='E' OR ACTN='X'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   IF        ACTN='D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ERN0929'     MsgIdArr(1)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'GLAMAD6VL'
     C                   PARM                    ACTN
     C                   PARM                    DataLux
     C                   PARM                    NwDlScnFmt
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
     C                   MOVE      *ON           *INLR
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
     C                   MOVEL     L1FOTR        L1FOTR20
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

     C                   IF        @RtCd <> *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Protect input fields if enquiry and enable command keys
      ** according to action code
      *
      ** KE = Command Key 05 = Refresh
      ** KJ = Command Key 10 = Confirm Delete
      *
     C                   SELECT
     C                   WHEN      ACTN = 'E' OR ACTN = 'X'
     C                   MOVEL     'Y'           @EIN20
     C                   WHEN      ACTN = 'D'
     C                   MOVEL     'Y'           @EIN20
     C                   MOVEL     'Y'           @EINKJ
     C                   MOVEL     'N'           @EINKE
     C                   WHEN      ACTN = 'I' OR ACTN = 'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKE
     C                   ENDSL
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    L1FOTR20
     C                   KFLD                    L1TMST
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AODEALR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSFDY
      *
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
      *
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ** If there was an error default the offset to 50
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member GLAMADPD))
      *
     C                   ELSE
     C                   EVAL      FldOffset = 50
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for deal
      *
     C                   IF        L1DEXT = 'Y'
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   Z-ADD     0             E
      *
     C                   DOW       NOT(%EOF())
      *
     C                   MOVEL     ABFIELDNAM    WWFLDL6
      *
     C                   IF        WWFLDL6 = 'L6'
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
