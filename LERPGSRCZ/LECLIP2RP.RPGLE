     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE CLIP Repair - LU Window')                     *
      *****************************************************************
      *  Finastra - Lending Module                                    *
      *                                                               *
      *  LECLIP2RP - Midas LE Customer Loans Input - Lux Repair       *
      *                                                               *
      *  Function:  This function allows invalid extended Customers   *
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  Entry Module of: LECLIP2RP - Midas LE CLIP Repair - Extension*
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR910559           Date 10Dec12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR910559 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Add @ACTRV*
      *             parameter in LECLIP5VL. (Child: AR910560)         *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      *
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *
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
 
      *
     D  PDATA          DS          1024
     D   #1LNRF                1      6
     D   #1CUST                7     12
     D   #1PTYP               13     14
     D   #1CCY                15     17
     D   #1AMNT               18     32  0
     D   #1FOID               33     52
     D   #1TMSP               53     78Z
     D   #1DEXT               79     79
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for access programs, long data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External data structures for Midas Modules
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency Details file
 
     D @EI             S              1    DIM(12)
 
     D CrDlFilFmt    E DS                  EXTNAME(LECLX1L0)
      ** Current Customer in File Format
 
     D CrDlScnFmt    E DS                  EXTNAME(LEICLLX1PD)
     D                                     PREFIX(SS)
      ** Current Customer (invalid) in Screen Format (LC)
 
     D NwDlFilFmt    E DS                  EXTNAME(LEVCLLX1PD)
      ** New Customer in File Format
 
     D NwDlScnFmt    E DS                  EXTNAME(LECLRXPD)
      ** New Customer in Screen Format
 
     D OkFlags       E DS                  EXTNAME(LEECLLX1PD)
      ** Error indicators
 
 
      ** Data passed from caller program
     D/COPY QWINDSRC,SDCUSDDTA
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
 
     D Format          S             10A   INZ('LECLIPPD')
     D Field           S             10A   INZ('LSUBR')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
      ** "Standard" variables
 
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1A
     D W0RTN           S              7A
     D ULX004          S              1A
     D ULX612          S              1A
 
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
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Standard parameter list for window manager                   *
      *                                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    W0RTN
     C                   PARM                    ULX004
     C                   PARM                    ULX612
     C                   PARM                    NwDlScnFmt
     C                   PARM                    NwDlFilFmt
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Continue to redisplay the screen if errors remains
      *
     C     WWERR         DOUEQ     'N'
      *
     C                   IF        ULX004 = 'Y'
      *
     C                   CALLB     'LECLIP5DP'
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    #1PTYP
     C                   PARM                    ULX004
     C                   PARM                    ULX612
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
     C                   ENDIF
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
     C                   IF        ULX004 = 'Y'
      *
     C                   CALLB     'LECLIP5VL'
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
     C                   PARM                    @ACTRV            1                        AR910559
      *
     C                   ENDIF
      *
      ** No errors so update the extension file
      *
     C     Idx           IFEQ      0
     C     WIdx          ANDEQ     0
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
      * SREND - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
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
     C                   MOVE      'Y2U9999'     W0RTN
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
      ***  Clear the program message queue and call SR/SRINIT to retrieve
      ***  the last committed data from the extension file.
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
     C                   MOVE      'USR0790'     W0RTN
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Only do first time through
      *
     C     WFIRST        IFEQ      *BLANKS
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
      ** Protect input fields if enquiry and enable command keys according
      ** to action code
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
     C     *LIKE         DEFINE    VKLNRF        K@LNRF
     C                   MOVE      #1LNRF        K@LNRF
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FOID
     C                   KFLD                    #1TMSP
      *
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
      ** Get the field number for the first file on the window screen; the screen
      ** fields start from that number. Subtract one from it to give the value
      ** to subtract from each field's number.
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
      ** (first extension field sequence  - 1 on ZAFLDNPD file (member LECLIPPD)
      *
     C                   ELSE
     C                   EVAL      FldOffset = 190
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Read error messages for customer
      *
     C                   IF        #1DEXT = 'Y'
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             85
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   Z-ADD     0             E                 3 0
      *
     C     *IN85         DOWEQ     '0'
      *
     C                   MOVEL     ABMSGID       WWFLD#L           2
      *
     C     WWFLD#L       IFEQ      'ER'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
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
     C     ACTN          IFEQ      'D'
     C                   EXSR      SRDELET
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFTOS - Move file fields to screen fields                    *
      *                                                               *
      *****************************************************************
      *
     C     SRFTOS        BEGSR
      *
     C                   MOVE      VKSUBR        LSUBR
     C                   MOVE      VKMOBL        LMOBL
     C                   MOVE      VKRISC        LRISC
     C                   MOVE      VKIMEX        LIMEX
     C                   MOVE      VKPPSC        LPPSC
     C                   MOVE      VKCOAM        LCOAM
     C                   MOVE      VKDGRI        LDGRI
     C                   MOVE      VKIM93        LIM93
     C                   MOVE      VKCLAT        LCLAT
     C                   MOVE      VK1UAC        LGUAC
     C                   MOVE      VKLUSU        LLUSU
      *
     C                   MOVE      CrDlFilFmt    NwDlFilFmt
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINZ - Initialize screen fields                              *
      *                                                               *
      *****************************************************************
      *
     C     SRINZ         BEGSR
      *
     C                   MOVE      *BLANKS       WFIND
      *
     C                   MOVE      *BLANKS       LSUBR
     C                   MOVE      *BLANKS       LMOBL
     C                   MOVE      *ZEROS        LRISC
     C                   MOVE      *ZEROS        LIMEX
     C                   MOVE      *ZEROS        LPPSC
     C                   MOVE      *ZEROS        LCOAM
     C                   MOVE      *ZEROS        LDGRI
     C                   MOVE      *ZEROS        LIM93
     C                   MOVE      *ZEROS        LCLAT
     C                   MOVE      *ZEROS        LGUAC
     C                   MOVE      *ZEROS        LLUSU
      *
     C                   ENDSR
      *
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
