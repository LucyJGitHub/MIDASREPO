     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Display one CCT header screen 2')
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1026DP - Display one CCT header : screen 2                     *
      *                                                                    *
      *  Function:  This module display a header of a Customer Credit      *
      *             Transfer                                               *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09                    *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07                    *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01                    *
      *                 184417             Date 02Oct00                    *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00                    *
      *                 184060             Date 22Sep00                    *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 08Oct99                    *
      *                                    Date ddmmmyy                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  CSW209 - SWIFT 2009 Changes                                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                          *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  188649 - Allow authorisation text on screen                       *
      *  184417 - Recompiled over FTM1026DDF                               *
      *  185107 - Mapping of details from swift message - Recompile        *
      *  184060 - No transaction type code in detail screen -Recompile     *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1026DDFCF   E             WORKSTN
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      *     31-45 Field Error - highlight screen fields                    *
      *     71    Protect fields screen                                    *
      *     72    Disable F5                                               *
      *     73    Disable F10                                              *
      *     78    To display appropriate title (incoming or outgoing)      *
      *     79    CSW209 display                                           *                  CSW209
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
     D NBSCREENS       C                   Const(2)
 
      ** Fields on the screen
     D***NBFIELDS        C                   Const(16)                                        CSW209
     D NBFIELDS        C                   Const(17)                                          CSW209
 
      ** Place of the first indicator PC on the screen
     D*STARTPC*******  C                   Const(31)
     D STARTPC         C                   Const(30)
 
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
     D ScreenHdr     E DS                  EXTNAME(FT102HSPD)
 
      * Fields of the screen memorized
     D ScreenMem     E DS                  EXTNAME(FT102HSPD) PREFIX(M)
 
      ** Error Indicators
     D OkFields      E DS                  EXTNAME(FTE102H2PD)
 
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
     D Prtcd           S              7A                                                      CSW209
 
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
 
      **  Switch on senders charges non - display indicator
     C                   EVAL      *IN28 = *ON
 
      **  Retrieve and display time
     C                   Time                    Wtime
     C                   Move      WtHH          SHH
     C                   Move      WtMM          SMM
     C                   Move      WtSS          SSS
     C                   Move      ActionCode    SACTN
     C                   Movel     @CctTyp       PCCTTYP
 
     C                   Z-ADD     1             c                 2 0
     C                   Z-ADD     STARTPC       e                 2 0
 
      ** Reset previous hilighted fields
     C     c             Dougt     NBFIELDS
     C                   Movel     '0'           *IN(e)
     C                   Add       1             c
     C                   Add       1             e
     C                   Enddo
 
      ** Enable all the fields and function key
     C                   Movel     '0'           *IN71
     C                   Movel     '0'           *IN72
     C                   Movel     '0'           *IN73
 
      ** Title conditionning
      ** -------------------
      ** Test whether message type is incoming or outgoing and display
      ** appropriate header messages
     C     @CctTyp       Ifeq      'BO'
     C                   Movel     '1'           *IN78
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
      ** All fields are protected, except CCT for transfer ID and
      ** Transaction Reference
     C                   Movel     '1'           *IN71
 
     C                   Other
 
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
     C                   Move      PCCTCHG       MPCCTCHG
     C                   Move      PCCTCCY       MPCCTCCY
     C                   Move      PSUMSCG       MPSUMSCG
     C                   Move      PSUMRCH       MPSUMRCH
     C                   Move      PTRNSTP       MPTRNSTP
     C                   Move      PREGRP1       MPREGRP1
     C                   Move      PREGRP2       MPREGRP2
     C                   Move      PREGRP3       MPREGRP3
     C                   Move      PCCTBOC       MPCCTBOC
     C                   Move      PADNLI1       MPADNLI1
     C                   Move      PADNLI2       MPADNLI2
     C                   Move      PADNLI3       MPADNLI3
     C                   Move      PADNLI4       MPADNLI4
     C                   Move      PADNLI5       MPADNLI5
     C                   Move      PADNLI6       MPADNLI6
 
     C                   Endif
 
      ** Check if SWIFT 2009 is installed                                                     CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM                    PRtCd                                        CSW209
                                                                                              CSW209
     C                   IF        PRtCd = 'CSW2009'                                          CSW209
     C                   EVAL      *IN79 = *ON                                                CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      *IN79 = *OFF                                               CSW209
     C                   ENDIF                                                                CSW209
 
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
     C                   If        *INKK And ActionCode = 'E'
     C                   Exfmt     FTM1026DF2
     C                   Else
 
     C                   Write     #MSGCTL
     C                   Write     FTM1026DF1
 
     C                   Read      FTM1026DF1                             99    *
     C                   Endif
 
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
      * DftOutFlds - Default Output fields (retrieved from the file) to    *
      *              the screen                                            *
      **********************************************************************
     C     DftOutFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DftOutFlds'  SrStack(q)
 
     C                   Move      PCCTID        SCCTID
     C                   Move      PFILREF       SFILREF
     C                   Move      PCCTTYP       SCCTTYP
     C                   Move      PCCTTST       SCCTTST
     C                   Move      PTRNSTP       STRNSTP
     C                   Move      PCCTCHG       SCCTCHG
     C                   Move      PSUMSCG       SSUMSCG
     C                   Move      PCCTCCY       SSUMSCY
     C                   Move      PSUMRCH       SSUMRCH
     C                   Move      PCCTCCY       SSUMRCY
     C                   Move      PREGRP1       SPREGP1
     C                   Move      PREGRP2       SPREGP2
     C                   Move      PREGRP3       SPREGP3
     C                   Move      PCCTBOC       SCCTBOC
     C                   Move      PADNLI1       SADIF1
     C                   Move      PADNLI2       SADIF2
     C                   Move      PADNLI3       SADIF3
     C                   Move      PADNLI4       SADIF4
     C                   Move      PADNLI5       SADIF5
     C                   Move      PADNLI6       SADIF6
     C                   If        *IN79 = *ON                                                CSW209
     C                   Move      PSNWRK        SNTWRK                                       CSW209
     C                   Move      PSMTPY        SMSGTY                                       CSW209
     C                   Move      PSVALF        SVLFLG                                       CSW209
     C                   Move      POMVLF        SCOMVF                                       CSW209
     C                   Move      POCVLF        SCOCVF                                       CSW209
     C                   EndIf                                                                CSW209
      *
     C                   MOVEL     PINUSER       SINUSER
     C                   MOVEL     PINDATE       SINDATE
     C                   MOVEL     PINTIME       SINTIME
     C                   MOVEL     PUPDUSR       SUPDUSR
     C                   MOVEL     PUPDDTE       SUPDDTE
     C                   MOVEL     PUPDTIM       SUPDTIM
     C                   MOVEL     PAUP1         SAUP1
     C                   MOVEL     PAUP2         SAUP2
     C                   MOVEL     PAUIN         SAUIN
     C                   MOVEL     PBAUTH        SBAUTH
     C                   MOVEL     PBATUSR       SBATUSR
     C                   MOVEL     PCDUAL        SCDUAL
 
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
      *
      ** If the total transfer ccy (or amount) has been changed the the
      ** sum of charges need to be blank until they can recalculated prior to
      ** update, otherwise a database error will occur.
      *
     C                   IF        PSumCCt = *Blanks
     C                   EVAL      SSUMRCH = *Blanks
     C                   EVAL      SSUMSCG = *Blanks
     C                   ENDIF
 
     C                   Move      STRNSTP       PTRNSTP
     C                   Move      SCCTCHG       PCCTCHG
     C                   Move      SSUMSCG       PSUMSCG
     C                   Move      SSUMSCY       PCCTCCY
     C                   Move      SSUMRCH       PSUMRCH
     C                   Move      SPREGP1       PREGRP1
     C                   Move      SPREGP2       PREGRP2
     C                   Move      SPREGP3       PREGRP3
     C                   Move      SCCTBOC       PCCTBOC
     C                   Move      SADIF1        PADNLI1
     C                   Move      SADIF2        PADNLI2
     C                   Move      SADIF3        PADNLI3
     C                   Move      SADIF4        PADNLI4
     C                   Move      SADIF5        PADNLI5
     C                   Move      SADIF6        PADNLI6
     C                   If        *IN79 = *ON                                                CSW209
     C                   Move      SNTWRK        PSNWRK                                       CSW209
     C                   Move      SMSGTY        PSMTPY                                       CSW209
     C                   Move      SVLFLG        PSVALF                                       CSW209
     C                   Move      SCOMVF        POMVLF                                       CSW209
     C                   Move      SCOCVF        POCVLF                                       CSW209
     C                   EndIf                                                                CSW209
 
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
 
     C                   Move      MPTRNSTP      STRNSTP
     C                   Move      MPCCTCHG      SCCTCHG
     C                   Move      MPSUMSCG      SSUMSCG
     C                   Move      MPCCTCCY      SSUMSCY
     C                   Move      MPSUMRCH      SSUMRCH
     C                   Move      MPCCTCCY      SSUMRCY
     C                   Move      MPTRNSTP      STRNSTP
     C                   Move      MPREGRP1      SPREGP1
     C                   Move      MPREGRP2      SPREGP2
     C                   Move      MPREGRP3      SPREGP3
     C                   Move      MPCCTBOC      SCCTBOC
     C                   Move      MPADNLI1      SADIF1
     C                   Move      MPADNLI2      SADIF2
     C                   Move      MPADNLI3      SADIF3
     C                   Move      MPADNLI4      SADIF4
     C                   Move      MPADNLI5      SADIF5
     C                   Move      MPADNLI6      SADIF6
     C                   If        *IN79 = *ON                                                CSW209
     C                   Move      MPSNWRK       SNTWRK                                       CSW209
     C                   Move      MPSMTPY       SMSGTY                                       CSW209
     C                   Move      MPSVALF       SVLFLG                                       CSW209
     C                   Move      MPOMVLF       SCOMVF                                       CSW209
     C                   Move      MPOCVLF       SCOCVF                                       CSW209
     C                   EndIf                                                                CSW209
 
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
 
      ** Transfer type from header ('BI' or 'BO')
     C                   Parm                    @CctTyp           2
     C                   Parm                    @FilRef          16
 
      ** Memorize fields for F5
     C                   Parm                    MemoFields        1
 
      ** Details CCT (in screen format)
     C                   Parm                    ScreenHdr
 
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
     C                   Movel     'FTM1026DP'   DBPGM
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
