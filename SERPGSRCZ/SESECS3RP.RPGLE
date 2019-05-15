     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *===============================================================*
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE SECS - Repair - LU Window')
      *===============================================================*
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SESECS3RP - SE Securities Details 2 LUX  Repair              *
      *                                                               *
      *  Function: This function allows invalid Extended Securities   *
      *             Details to be 'repaired' and applied to the       *
      *             Midas database.                                   *
      *  Entry Module of: SESECS3RP - Securities Details Repair Pgm   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *===============================================================*
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *  *IN03  -  F3 Pressed exit program                            *
      *  *IN05  -  F5 Pressed redisplay the screen                    *
      *  *IN10  -  F10 Pressed delete                                 *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN25  -  SFLEND control                                     *
      *  *IN35  -  Enable F5                                          *
      *  *IN40  -  Enable F10                                         *
      *  *IN50  -  Error on field #6LXLUSU                            *
      *  *IN51  -  Error on field #6LXSUBR                            *
      *  *IN52  -  Error on field #6LXIM93                            *
      *  *IN53  -  Error on field #6LXCLAT                            *
      *  *IN54  -  Error on field #6LXSECT                            *
      *  *IN55  -  Error on field #6LXROFC                            *
      *  *IN56  -  Error on field #6LXRATC                            *
      *  *IN57  -  Error on field #6LXVOTR                            *
      *  *IN58  -  Error on field #6LXSECD                            *
      *  *IN59  -  Error on field #6LXSNCD                            *
      *  *IN60  -  Error on field #6LXEEEM                            *
      *  *IN61  -  Error on field #6LXQUOT                            *
      *  *IN70  -  Error on field #6LXER91                            *
      *  *IN99  -  General purpose indicator                          *
      *                                                               *
      *===============================================================*
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      *================================
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** Manually included D-specs
      ** =========================
      *
      *
      ** Named constants
      ** ---------------
      *
      *
      ** Arrays and Data Structures
      ** --------------------------
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Error Indicators Array
      *
     D @EI             S              1    DIM(12)
      *
      ** New Extension in File Format (#6LXVV)
      *
     D NwExFilFmt    E DS                  EXTNAME(SEVSELX3PD)
      *
      ** New Extension in Screen Format (#nLX)
      *
     D NwExScnFmt    E DS                  EXTNAME(SESERXPD)
      *
      ** New Extension in Screen Format (Reset purposes)
      *
     D PrvExScnFmt   E DS                  EXTNAME(SESERXPD) PREFIX(P)
      *
      ** Error indicators (OK#6LX)
      *
     D OkFlags       E DS                  EXTNAME(SEESELX3PD)
      *
      ** Data passed from caller program
      *
     D DATALUX         DS          1024
     D  L1SESN                 1     10A
     D  L1FOTR                11     30A
     D  L1ISNO                31     42A
     D  #1DEXT                43     43
     D  #2DEXT                44     44
     D  #3DEXT                45     45
      *
      ** Parameters for ERL910 call
      *
     D DSER91        E DS                  EXTNAME(ERL910DA)
      *
      ** Declared variables
      ** ------------------
      *
      ** Field to ask for Guarantees to be maintained  (only on window,
      ** not existing in the extension file)
      *
     D #6LXER91        S              1A
      *
      ** Fields for getting the starting field number from file
      ** ZAFLDNPD (parameters to ZAGETFLDNO, plus the offset to the
      ** requested field).
      *
     D Format          S             10A   INZ('SESECSPD')
     D Field           S             10A   INZ('L6LXLUSU')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
     D LstFldSet       S              5P 0
      *
      ** "Standard" variables
      *
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D E               S              3P 0
     D F               S              3P 0
     D WWFLD#6         S              2
     D ZFIELD          S             16
     D ZADEC           S              1P 0
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D W0RTN           S              7
     D PDTMST          S               Z
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D TITLE           S              7
      *
      ** "Standard" modules parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
      *
      ** Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    W0RTN
     C                   PARM                    PDTMST
     C                   PARM                    NwExScnFmt
     C                   PARM                    NwExFilFmt
 
      *****************************************************************
      **             M  A  I  N     P  R  O  C  E  S  S  I  N  G      *
      *****************************************************************
      *
      ** Save initial screen format value
      *
     C                   EVAL      PrvExScnFmt = NwExScnFmt
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C                   DOU       WWERR = 'N'
 
     C                   CALLB     'SESECS7DP'
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwExScnFmt
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
     C                   PARM      'N'           #6LXER91
 
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
      ** Loop on display while #6LXER91 is not valid
      ** N.B.: If there is an error with #6LXER91, a message is
      **       displayed by the display module (SESECS7DP) itself
      *
     C                   IF        #6LXER91 <> 'Y' AND #6LXER91 <> 'N'
     C                   ITER
     C                   ENDIF
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
      ** after having called ERL910 (Guarantees/Collateral/Provisions
      ** Maintenance)
      *
     C                   IF        ACTN = 'E'
     C                   EXSR      SREND
     C                   ENDIF
 
     C                   IF        ACTN = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LX61001'     MsgIdArr(1)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Validation for each fields.
      *
     C                   CALLB     'SESECS7VL'
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwExScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwExFilFmt
      *
      ** No errors so call ERL910 (Guarantees/Collateral/Provisions
      ** Maintenance and update the extension file
      *
     C                   IF        Idx = 0
     C                   MOVE      'N'           WWERR
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
      ** Call Guarantees/Collateral/Provisions Maintenance (ERL910)
      *
      ** Activate the following coding when the extension can be
      ** removed
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
     C                   EVAL      *INLR = *ON
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
     C                   EVAL      W0RTN   = 'Y2U9999'
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
     C                   EVAL      OkFlags = *ALL'Y'
     C                   MOVEA     *BLANKS       FldNameArr
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   MOVEA     *BLANKS       MsgDtaArr
     C                   MOVEA     *BLANKS       WFldNamArr
     C                   MOVEA     *BLANKS       WMsgIdArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
 
     C                   EXSR      SRINIT
      *
      ** Restore initial value of NwExScnFmt
      *
     C                   EVAL      NwExScnFmt = PrvExScnFmt
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
     C                   EVAL      NwExScnFmt = PrvExScnFmt
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
 
     C                   IF        @RtCd <> *blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
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
     C                   WHEN      ACTN    = 'E'
     C                   EVAL      @EIN20  = 'Y'
     C                   EVAL      @EINKJ  = 'N'
     C                   EVAL      @EINKE  = 'N'
 
     C                   WHEN      ACTN    = 'D'
     C                   EVAL      @EIN20  = 'Y'
     C                   EVAL      @EINKJ  = 'Y'
     C                   EVAL      @EINKE  = 'N'
 
     C                   WHEN      ACTN    = 'I' Or
     C                             ACTN    = 'A'
     C                   EVAL      @EIN20  = 'N'
     C                   EVAL      @EINKJ  = 'N'
     C                   EVAL      @EINKE  = 'Y'
     C                   ENDSL
      *
      ** Setup key values using transaction data passed from caller
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    L1FOTR
     C                   KFLD                    PDTMST
 
     C                   EVAL      WFIRST = 'N'
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
 
     C                   IF        ReturnCode = *BLANK
     C                   EVAL      FldOffset  = FieldNo - 1
      *
      ** If there was an error default the offset to 139
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member SESECSPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset  = 139
     C                   ENDIF
      *
      ** Get the last field number
      *
     C                   EXSR      ZACGTLSTFLDNO
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for the current transaction
      *
     C                   IF        #2DEXT  = 'Y'
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   EVAL      E       = *ZERO
 
     C                   DOW       *IN99   = *OFF
      *
     C                   EVAL      WWFLD#6 = %SUBST(ABMSGID:1:2)
      *
     C                   IF        WWFLD#6 = 'LX' and
     C                             ABFIELDID > FldOffSet And
     C                             ABFIELDID < LstFldSet
     C                   EVAL      E       = E + 1
     C                   EVAL      FldNameArr(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr(E)   = ABMSGID
     C                   EVAL      F       = ABFIELDID - FldOffset
     C                   EVAL      @EI(F)  = 'N'
     C                   ENDIF
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     @EI           OkFlags
     C                   ENDIF
      *
      ** If delete does not require window to be displayed, do here
      *
     C                   IF        ACTN    = 'D'
     C                   EXSR      SRDELET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZACGTLSTFLDNO -  Get the last field number of current        *
      *                   extension file.                             *
      *                                                               *
      *****************************************************************
     C     ZACGTLSTFLDNO BEGSR
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    RetCodeIn
     C                   PARM                    Format
     C                   PARM      'L6LXQUOT'    Field
     C                   PARM                    FieldNo
 
     C                   IF        RetCodeIn = *BLANK
     C                   EVAL      LstFldset = FieldNo + 1
      *
      ** If there was an error default the offset to 139
      ** (first extension field sequence  - 1 on ZAFLDNPD file
      ** (member SESECSPD)
      *
     C                   ELSE
     C                   EVAL      LstFldset = 139
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error       *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
