     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT RFT credit display 2')
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1013DP - Display one RFT detail : screen 2                     *
      *                                                                    *
      *  Function:  This module display a detail of a Request For          *
      *  Transfert                                                         *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 188649             Date 09Feb01                    *
      * Midas DBA 3.03 ----------------------------------------------------*
      *                 177810  *CREATE    Date 14APR00                    *
      *                 CFT006  *CREATE    Date 22Sep99                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  188649 - Include authorisation text                               *
      *  177810 - Hide exchange rate on outgoing MT101 enquiry.            *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1013DDFCF   E             WORKSTN
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      *     31-48 Field Error - highlight screen fields                    *
      *     70    Protect fields for outgoing RFT                          *
      *     71    Protect fields screen                                    *
      *     72    Disable F5                                               *
      *     73    Disable F10                                              *
      *     78    To display appropriate title (incoming or outgoing)      *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * IniPgm : Initialisation  (called each time)                        *
      * Main : MAIN processing                                             *
      * HdlErrFlds : Handle Error fields                                   *
      * DftOutFlds : Default Output fields                                 *
      * RtnFields : Return fields                                          *
      * RtvFields : Retrieve fields                                        *
      *                                                                    *
      **********************************************************************
      /EJECT
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ AutomatiCally included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatiCally included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Number of screens
     D NBSCREENS       C                   Const(3)
 
      ** Fields on the screen
     D NBFIELDS        C                   Const(18)
 
      ** Place of the first indicator PC on the screen
     D STARTPC         C                   Const(31)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
 
      * Fields of the screen
     D ScreenDtl     E DS                  EXTNAME(FT101DSPD)
 
      * Fields of the screen memorized
     D ScreenMem     E DS                  EXTNAME(FT101DSPD) PREFIX(M)
 
      ** Error Indicators
     D OkFields      E DS                  EXTNAME(FTE101S2PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** DATA STRUCTURES
      ** ---------------
 
     D STIME           DS
     D   SHH                          2
     D   SS1                          1    Inz(':')
     D   SMM                               Like(SHH)
     D   SS2                               Like(SS1) Inz(':')
     D   SSS                               Like(SHH)
 
     D WRunTime        DS
     D   Wtime                        6  0
     D   WtHH                         2  0 Overlay(Wtime:1)
     D   WtMM                         2  0 Overlay(Wtime:3)
     D   WtSS                         2  0 Overlay(Wtime:5)
 
      ** ARRAYS
      ** ------
 
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
 
      ** Array of error indicators
     D @EI             S              1    DIM(NBFIELDS)
 
      ** Screens in error
     D ScreenErr       S              2    Dim(NBSCREENS)
 
 
      ** FLAGS
      ** -----
 
      ** INDEXS
      ** ------
     D q               S              2  0
     D i               S                   Like(q)
 
      ** WORKING VARIABLES
      ** -----------------
 
      ** PARAMETERS
      ** ----------
      ** Parameters for AOCREPT
     D MsgID           S              7
     D Msgf            S             10    Inz('FTUSRMSG')
     D Msglib          S             10    Inz('*LIBL')
     D Msgdta          S            256
     D Msgrel          S              5
     D Msgq            S             10
     D Msgt            S              7
 
      ** Parameters for ZA0920
     D RtnCod          S             10
     D AmtN13D0        S             13  0
     D Qecn            S              1  0
     D BndCsp          S              1    Inz('.')
     D AmtA14          S             14
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatiCally: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Beg'         SrStack(q)
 
      **  Initialization
     C                   Exsr      IniPgm
 
      **  Main processing
     C                   Exsr      Main
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
      ** Return
     C     *INKC         Ifeq      '1'
     C                   Seton                                        LR
     C                   Endif
     C                   Return
      *
      *****************************************************************
      /EJECT
      **********************************************************************
      * INIT - Initialisation  (called each time)                          *
      **********************************************************************
     C     IniPgm        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'IniPgm'      SrStack(q)
 
      **  Retrieve and display time
     C                   Time                    Wtime
     C                   Move      WtHH          SHH
     C                   Move      WtMM          SMM
     C                   Move      WtSS          SSS
     C                   Move      ActionCode    SACTN
 
     C                   Z-ADD     1             c                 2 0
     C                   Z-ADD     STARTPC       e                 2 0
 
      ** Reset previous hilighted fields
     C     c             Dougt     NBFIELDS
     C                   Movel     '0'           *IN(e)
     C                   Add       1             c
     C                   Add       1             e
     C                   Enddo
 
      ** Enable all the fields and function key
     C                   Movel     '0'           *IN70
     C                   Movel     '0'           *IN71
     C                   Movel     '0'           *IN72
     C                   Movel     '0'           *IN73
 
      ** Title conditionning
      ** -------------------
      ** Test whether message type is incoming or outgoing and display
      ** appropriate header messages
     C     RftTyp        Ifeq      'RO'
     C                   Movel     '1'           *IN78
     C                   Movel     '1'           *IN70                          177810
     C                   Else
     C                   Movel     '0'           *IN78
     C                   EndIf
 
      ** Fields protection
      ** -----------------
     C                   Select
     C     ActionCode    Wheneq    'E'
     C                   Movel     '1'           *IN71
 
     C     ActionCode    Wheneq    'X'
     C                   Movel     '1'           *IN71
 
     C     ActionCode    Wheneq    'D'
     C                   Movel     '1'           *IN71
 
     C     ActionCode    Wheneq    'R'
      ** All fields are protected, except RFT for transfert ID and
      ** Transaction Reference
     C                   Movel     '1'           *IN71
 
     C                   Other
      ** If Amend or Insert, protect the Payment Amt/Ccy and Credit Val Date
      ** for outgoing transfers.
     C     RftTyp        Ifeq      'RO'
     C                   Movel     '1'           *IN70
     C                   EndIf
 
     C                   Endsl
 
      ** Function key protection
      ** -----------------------
     C                   Select
     C     ActionCode    Wheneq    'E'
      ** F5 Disabled
      ** F10 Disabled
     C                   Movel     '1'           *IN72
     C                   Movel     '1'           *IN73
 
     C     ActionCode    Wheneq    'X'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
 
     C     ActionCode    Wheneq    'R'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
 
     C     ActionCode    Wheneq    'D'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
 
     C     ActionCode    Wheneq    'A'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
 
     C     ActionCode    Wheneq    'I'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
 
     C                   Endsl
 
      **  Memorize fields in case of refresh (F5)
     C     MemoFields    Ifeq      'Y'
     C                   Movel     'N'           MemoFields
     C                   Move      PFXDREF       MPFXDREF
     C                   Move      PTRNAMT       MPTRNAMT
     C                   Move      PTRNCCY       MPTRNCCY
     C                   Move      PXRATE        MPXRATE
     C                   Move      PXRATEO       MPXRATEO
     C                   Move      PPAYAMT       MPPAYAMT
     C                   Move      PPAYCCY       MPPAYCCY
     C                   Move      PCRDVDT       MPCRDVDT
     C                   Move      PTOOAMT       MPTOOAMT
     C                   Move      PTOCCY        MPTOCCY
     C                   Move      PCHGACC       MPCHGACC
     C                   Move      PTDCHGS       MPTDCHGS
     C                   Move      PRCVCHG       MPRCVCHG
     C                   Move      PRCHCCY       MPRCHCCY
     C                   Move      PRCTCHG       MPRCTCHG
     C                   Move      PRCTCCY       MPRCTCCY
     C                   Move      PRCPCHG       MPRCPCHG
     C                   Move      PRCPCCY       MPRCPCCY
 
     C                   Endif
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * MAIN - MAIN processing                                             *
      **********************************************************************
     C     Main          Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Main'        SrStack(q)
 
      ** Not handle error in fields in 'Enquire' mode
      ** and after a refresh
     C     ActionCode    Ifne      'E'
     C     Keypressed    andne     '05'
     C                   Exsr      HdlErrFlds
     C                   Endif
 
      ** Default output fields
     C                   Exsr      DftOutFlds
 
      ** Write message subfile, details and footer screen
     C                   Write     #MSGCTL
     C                   Write     FTM1013DF1
 
     C                   Read      FTM1013DF1                             99    *
 
      ** Clear message queue
     C                   Call      'ZA0250'
 
      ** KeyPress
     C                   Exsr      KeyPress
 
      ** Return fields from the screen
     C                   Exsr      RtnFields
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * RtnFields - Return fields                                          *
      **********************************************************************
     C     RtnFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtnFields'   SrStack(q)
 
     C                   Move      SFXDREF       PFXDREF
     C                   Move      STRNAMT       PTRNAMT
     C                   Move      STRNCCY       PTRNCCY
     C                   Move      SXRATE        PXRATE
     C                   Move      SXRATEO       PXRATEO
     C                   Move      SPAYAMT       PPAYAMT
     C                   Move      SPAYCCY       PPAYCCY
     C                   Move      SCRDVDT       PCRDVDT
     C                   Move      STOOAMT       PTOOAMT
     C                   Move      STOCCY        PTOCCY
     C                   Move      SCHGACC       PCHGACC
     C                   Move      STDCHGS       PTDCHGS
     C                   Move      SRCVCHG       PRCVCHG
     C                   Move      SRCHCCY       PRCHCCY
     C                   Move      SRCTCHG       PRCTCHG
     C                   Move      SRCTCCY       PRCTCCY
     C                   Move      SRCPCHG       PRCPCHG
     C                   Move      SRCPCCY       PRCPCCY
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * HdlErrFlds - Handle Error fields                                   *
      **********************************************************************
     C     HdlErrFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'HdlErrFlds'  SrStack(q)
 
      ** Move 'OK' flags into array (for checking)
     C                   Movea     OkFields      @EI
 
      ** Set screen error indicators according to status of 'OK' flags
     C                   Z-add     1             c                 2 0
     C                   Z-add     STARTPC       e                 2 0
      *
     C     c             Dougt     NBFIELDS
     C     @EI(c)        Ifeq      'N'
     C     @EI(c)        oreq      'W'
     C                   Movel     '1'           *IN(e)
     C                   Endif
     C                   Add       1             c
     C                   Add       1             e
     C                   Enddo
 
      ** Do while error messages found
      ** Write error messages (with or without data) to subfile
     C                   Z-add     1             c
     C     c             Dowle     ArrayMax
     C*****c             andlt     IdxErr3
     C     FldNameArr(C) Andne     *BLANKS
     C                   Movel     MsgIdArr(c)   MsgID
     C                   Movel     MsgDtaArr(c)  Msgdta
     C                   Exsr      SndMsg
     C                   Add       1             c
     C                   Enddo
 
      ** Do while warning messages found
      ** Write warning messages (with or without data) to subfile
     C                   Z-add     1             c
     C     c             Dowle     ArrayMax
     C     WFldNamArr(C) Andne     *BLANKS
     C                   Movel     WMsgIdArr(C)  MsgID
     C                   Movel     WMsgDtaArr(C) Msgdta
     C                   Exsr      SndMsg
     C                   Add       1             c
     C                   Enddo
 
      ** Indicate if others screens are in error
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     ScreenErr(i)  Ifne      *BLANK
     C                   Movel     'RFD0001'     MsgID
     C                   Movel     ScreenErr(i)  Msgdta
     C                   Exsr      SndMsg
     C                   Endif
     C                   Enddo
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * DftOutFlds - Default Output fields                                 *
      **********************************************************************
     C     DftOutFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DftOutFlds'  SrStack(q)
 
     C                   Move      PRFTHDR       SRFTHDR
     C                   Move      PCUSREF       SCUSTRF
     C                   Move      PTRNSID       STRNSID
     C                   Move      PSNDREF       SSNDREF
     C                   Move      PFXDREF       SFXDREF
     C                   Move      PTRNAMT       STRNAMT
     C                   Move      PTRNCCY       STRNCCY
     C                   Move      PXRATE        SXRATE
     C                   Move      PXRATEO       SXRATEO
     C                   Move      PPAYAMT       SPAYAMT
     C                   Move      PPAYCCY       SPAYCCY
     C                   Move      PCRDVDT       SCRDVDT
     C                   Move      PTOOAMT       STOOAMT
     C                   Move      PTOCCY        STOCCY
     C                   Move      PCHGACC       SCHGACC
     C                   Move      PTDCHGS       STDCHGS
     C                   Move      PRCVCHG       SRCVCHG
     C                   Move      PRCHCCY       SRCHCCY
     C                   Move      PRCTCHG       SRCTCHG
     C                   Move      PRCTCCY       SRCTCCY
     C                   Move      PRCPCHG       SRCPCHG
     C                   Move      PRCPCCY       SRCPCCY
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
     C**********************************************************************
      /EJECT
      **********************************************************************
      * RtvFields - Retrieve Fields                                        *
      **********************************************************************
     C     RtvFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvFields'   SrStack(q)
 
     C                   Move      MPFXDREF      SFXDREF
     C                   Move      MPTRNAMT      STRNAMT
     C                   Move      MPTRNCCY      STRNCCY
     C                   Move      MPXRATE       SXRATE
     C                   Move      MPXRATEO      SXRATEO
     C                   Move      MPPAYAMT      SPAYAMT
     C                   Move      MPPAYCCY      SPAYCCY
     C                   Move      MPCRDVDT      SCRDVDT
     C                   Move      MPTOOAMT      STOOAMT
     C                   Move      MPTOCCY       STOCCY
     C                   Move      MPCHGACC      SCHGACC
     C                   Move      MPTDCHGS      STDCHGS
     C                   Move      MPRCVCHG      SRCVCHG
     C                   Move      MPRCHCCY      SRCHCCY
     C                   Move      MPRCTCHG      SRCTCHG
     C                   Move      MPRCTCCY      SRCTCCY
     C                   Move      MPRCPCHG      SRCPCHG
     C                   Move      MPRCPCCY      SRCPCCY
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
     C**********************************************************************
      /EJECT
      **********************************************************************
      * FmtAmt - FORMAT AMOUNT FOR DISPLAY                                 *
      **********************************************************************
     C     FmtAmt        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'FmtAmt'      SrStack(q)
 
     C                   Callb     'ZA0920'
     C                   Parm      *BLANK        RtnCod
     C                   Parm                    AmtN13D0
     C                   Parm                    Qecn
     C                   Parm                    BndCsp
     C                   Parm      *BLANK        AmtA14
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * KeyPress - Key pressed                                             *
      **********************************************************************
     C     KeyPress      Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'KeyPress'    SrStack(q)
 
     C                   Movel     *BLANK        KeyPressed
 
     C                   Select
     C     *INKC         Wheneq    '1'
     C                   Movel     '03'          KeyPressed
 
     C     *INKE         Wheneq    '1'
     C                   Movel     '05'          KeyPressed
     C                   Exsr      RtvFields
 
     C     *INKJ         Wheneq    '1'
     C                   Movel     '10'          KeyPressed
 
     C     *INKK         Wheneq    '1'
     C                   Movel     '11'          KeyPressed
 
     C     *INKL         Wheneq    '1'
     C                   Movel     '12'          KeyPressed
 
     C                   Endsl
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * SndMsg  - Send a message                                           *
      **********************************************************************
     C     SndMsg        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SndMsg'      SrStack(q)
 
      ** Only write message if requested
     C     Msgid         Ifne      *BLANK
     C                   Callb     'AOCREPT'
     C                   Parm                    MsgID
     C                   Parm                    Msgf
     C                   Parm                    Msglib
     C                   Parm                    Msgdta
     C                   Parm      '*SAME'       Msgrel
     C                   Parm                    PSProcName
     C                   Parm      *BLANK        Msgq
     C                   Parm      *BLANK        Msgt
      *
     C                   Movel     *BLANK        MsgID
     C                   Movel     *BLANK        Msgdta
      *
     C                   Endif
      *
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * *INZSR - INITIAL PROCESSING (CALLED ONCE)                          *
      **********************************************************************
     C     *INZSR        Begsr
      *
      ** Parameters
      *
     C     *ENTRY        Plist
 
      ** INPUT PARAMETERS
 
      ** Return code
     C                   Parm                    RetCodeIn
 
      ** Action Code
     C                   Parm                    ActionCode
 
      ** Transfer type from header ('RI' or 'RO')
     C                   Parm                    RftTyp            2
 
      ** Memorize fields for F5
     C                   Parm                    MemoFields        1
 
      ** Details RFT (in screen format)
     C                   Parm                    ScreenDtl
 
      ** Fields in error
     C                   Parm                    OkFields
 
      ** Other Screen in error
     C                   Parm                    ScreenErr
 
      ** Errors
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
      ** Warnings
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
 
      ** OUTPUT PARAMETERS
 
      ** Function key pressed
     C                   Parm                    KeyPressed        2
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
 
 
      ** END OF PARAMETERS DECLARATION
 
 
 
      ** Initialize program name
      *
     C                   Movel     'FTM1013DP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   Movel     PsJobName     SWSID
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         Ifeq      'M'
     C                   Seton                                        98
     C                   Endif
      *
     C                   Movel     AGMRDT        SRUNA
     C                   Movel     PSUser        SUSER
 
      ** Message subfile control '+'
     C                   Seton                                        77
 
      ** Set screen protect/non-display indicators
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
** Ctdata CPY@
(c) Misys International Banking Systems Ltd. 2001
