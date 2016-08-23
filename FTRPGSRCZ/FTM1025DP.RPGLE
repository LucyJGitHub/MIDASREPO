     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Display one CCT header screen 1')             *
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1025DP - Display one CCT detail : screen 1                     *
      *                                                                    *
      *  Function:  This module display a detail of a Customer Credit      *
      *             Transfer                                               *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      *  Last Amend No. MD022652           Date 07Oct13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007             Date 21Mar00                    *
      *                 CFT006  *CREATE    Date 22Sep99                    *
      *                                    Date ddmmmyy                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD022652 - Excluded Phase Processing                              *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes                                       *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  188649 - Allow authorised text on screen                          *
      *  185107 - Mapping of details from swift message - Recompile        *
      *  184060 - No transaction type code in detail screen -Recompile     *
      *  CFT007 - Bic database plus                                        *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1025DDFCF   E             WORKSTN
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      *     29-55 Field Error - highlight screen fields                    *
      *     70    Protect Fil reference                                    *
      *     71    Protect fields screen (Except CCT ID, fil ref)           *
      *     72    Disable F5                                               *
      *     73    Disable F10                                              *
      *     76    Hide BIC search key                                      *    CFT007
      *     78    To display appropriate title (incoming or outgoing)      *
      *     82    BIC Database Plus                                        *    CFT007
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
     D NBFIELDS        C                   Const(25)
 
      ** Place of the first indicator PC on the screen
     D STARTPC         C                   Const(28)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                CFT007
     D Scsard        E DS                  EXTNAME(SCSARDPD)                    CFT007
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS                                   CFT007
 
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
     D OkFields      E DS                  EXTNAME(FTE102H1PD)
 
 
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
 
      ** First Reassignment
     D KeyStored       S              1
 
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
 
      ** Swift 2007                                                                           CSW207
     D CSW207          S              1                                                       CSW207
     D RetCd           S              7                                                       CSW207
                                                                                              CSW207
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
                                                                                CFT007
      *                                                                         CFT007
      ** Access SAR details file to determine if CFT007                         CFT007
      ** (BIC Database +) is active                                             CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   PARM      *BLANKS       @Rtcd                          CFT007
     C                   PARM      '*VERIFY'     @Optn                          CFT007
     C                   PARM      'CFT007'      @Sard             6            CFT007
     C     SCSARD        PARM      SCSARD        Dsfdy                          CFT007
      *                                                                         CFT007
      ** Database Error                                                         CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd <> *BLANKS AND                         CFT007
     C                             @Rtcd <> '*NRF'                              CFT007
     C                   EVAL      DBFILE = 'SCSARDPD'                          CFT007
     C                   EVAL      DBASE = 999                                  CFT007
     C                   EVAL      DBKEY = 'CFT007'                             CFT007
     C                   EXSR      *PSSR                                        CFT007
     C                   ENDIF                                                  CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd = *BLANKS                              CFT007
     C                   MOVEL     'Y'           CFT007            1            CFT007
     C                   ELSE                                                   CFT007
     C                   MOVEL     'N'           CFT007                         CFT007
     C                   ENDIF                                                  CFT007
      *                                                                                     MD022652
      ** Access SAR details file to determine if CFT050                                     MD022652
      ** SWIFTRef Directories Upload is active                                              MD022652
      *                                                                                     MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   PARM      *BLANKS       PRtcd             7                        MD022652
     C                   PARM      '*VERIFY'     POptn             7                        MD022652
     C                   PARM      'CFT050'      PSard             6                        MD022652
     C     SCSARD        PARM      SCSARD        Dsfdy                                      MD022652
      *                                                                                     MD022652
      ** Database Error                                                                     MD022652
      *                                                                                     MD022652
     C                   IF        PRtcd <> *BLANKS AND                                     MD022652
     C                             PRtcd <> '*NRF'                                          MD022652
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022652
     C                   EVAL      DBASE = 999                                              MD022652
     C                   EVAL      DBKEY = 'CFT050'                                         MD022652
     C                   EXSR      *PSSR                                                    MD022652
     C                   ENDIF                                                              MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
     C                   IF        PRtcd = *BLANKS                                          MD022652
     C                   EVAL      CFT007 = 'Y'                                             MD022652
     C                   ENDIF                                                              MD022652
                                                                                            MD022652
 
      **  Retrieve and display time
     C                   Time                    Wtime
     C                   Move      WtHH          SHH
     C                   Move      WtMM          SMM
     C                   Move      WtSS          SSS
     C                   Move      ActionCode    SACTN
     C                   Movel     @CctTyp       PCCTTYP
     C                   Movel     PFilRef       @FilRef
 
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
     C                   If        @CctTyp = 'BO'
     C                   Eval      *IN78 = *ON
     C                   Else
     C                   Eval      *IN78 = *OFF
     C                   Endif
 
      ** Fields protection
      ** -----------------
     C                   Select
     C     ActionCode    Wheneq    'E'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN71
 
     C     ActionCode    Wheneq    'X'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN71
 
     C     ActionCode    Wheneq    'D'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN71
 
     C     ActionCode    Wheneq    'A'
     C                   Movel     '1'           *IN70
 
     C     ActionCode    Wheneq    'R'
      ** All fields are protected, except CCT for transfer ID and
      ** Transaction Reference
     C                   Movel     '1'           *IN71
 
     C**** ActionCode*** Wheneq    'I'
 
     C                   Endsl
 
      ** Function key protection
      ** -----------------------
     C                   Select
     C     ActionCode    Wheneq    'E'
      ** F5 Disabled
      ** F10 Disabled
     C                   Movel     '1'           *IN72
     C                   Movel     '1'           *IN73
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
 
     C     ActionCode    Wheneq    'X'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
 
     C     ActionCode    Wheneq    'D'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
 
     C     ActionCode    Wheneq    'A'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
      *                                                                         CFT007
      ** If BIC DB+ present, enable function keys                               CFT007
      *                                                                         CFT007
     C                   If        CFT007 = 'Y'                                 CFT007
     C                   Eval      *In82 = *On                                  CFT007
     C                   Eval      *In76 = *Off                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      *In82 = *Off                                 CFT007
     C                   Eval      *In76 = *On                                  CFT007
     C                   Endif                                                  CFT007
 
     C     ActionCode    Wheneq    'I'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
      *                                                                         CFT007
      ** If BIC DB+ present, enable function keys                               CFT007
      *                                                                         CFT007
     C                   If        CFT007 = 'Y'                                 CFT007
     C                   Eval      *In82 = *On                                  CFT007
     C                   Eval      *In76 = *Off                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      *In82 = *Off                                 CFT007
     C                   Eval      *In76 = *On                                  CFT007
     C                   Endif                                                  CFT007
 
     C                   Endsl
 
      ** Miscellaneous initialization depending of value of action code
      ** --------------------------------------------------------------
     C                   Movel     'N'           KeyStored
 
      **  Memorize fields in case of refresh (F5)
     C     MemoFields    Ifeq      'Y'
     C                   Movel     'N'           MemoFields
 
     C     ActionCode    Ifeq      'R'
     C                   Move      PCCTID        MPCCTID
     C                   Move      PSTID         MPSTID
     C                   Else
     C                   Move      PFILREF       MPFILREF
     C                   Move      PCCTTYP       MPCCTTYP
     C                   Move      PCCTTST       MPCCTTST
     C                   Move      PBRCA         MPBRCA
     C                   Move      PORBR         MPORBR
     C                   Move      PBOKC         MPBOKC
     C                   Move      PPRFC         MPPRFC
     C                   Move      PSWPRIO       MPSWPRIO
     C                   Move      POINST3       MPOINST3
     C                   Move      POINST1       MPOINST1
     C                   Move      PTOCUS1       MPTOCUS1
     C                   Move      PTOCUS2       MPTOCUS2
     C                   Move      PTOCUS3       MPTOCUS3
     C                   Move      PTOCUS4       MPTOCUS4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      MPTOCUS5 = PTOCUS5                                         CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      PSINST        MPSINST
     C                   Move      PCCTDST       MPCCTDST
     C                   Move      PSNDCOR       MPSNDCOR
     C                   Move      PRCVCOR       MPRCVCOR
     C                   Move      PDBTVDT       MPDBTVDT
     C                   Move      PCCTAMT       MPCCTAMT
     C                   Move      PCCTCCY       MPCCTCCY
     C                   Move      PTTVDTE       MPTTVDTE
     C                   Move      PCCTRTE       MPCCTRTE
     C                   Move      PSUMCCT       MPSUMCCT
     C                   Endif
 
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
 
      ** Default output fields from file to screen
     C                   Exsr      DftOutFlds
 
      ** Write message subfile, details and footer screen
     C                   Write     #MSGCTL
     C                   Write     FTM1025DF1
 
     C                   Read      FTM1025DF1                             99    *
 
      ** Clear message queue
     C                   Call      'ZA0250'
 
      ** KeyPress
     C                   Exsr      KeyPress
 
      ** Return fields from the screen to the screen file FT102HSPD
     C                   Exsr      RtnFields
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * DftOutFlds - Default Output fields (that have been retrieved) to   *
      *              the screen.                                           *
      **********************************************************************
     C     DftOutFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DftOutFlds'  SrStack(q)
      *
      ** If action code is 'I' then make sure the CCTID  is blank
      *
     C                   IF        ActionCode = 'I'
     C                   EVAL      PcctId = *blanks
     C                   ENDIF
 
     C                   Move      PCCTID        SCCTID
     C                   Move      PFILREF       SFILREF
     C                   Move      PCCTTYP       STRNTYP
     C                   Move      PCCTTST       STRNSTP
     C                   Move      PBRCA         SBRCA
     C                   Move      PORBR         SORBR
     C                   Move      PBOKC         SBOKC
     C                   Move      PPRFC         SPRFC
     C                   Move      PSWPRIO       SSWPRIO
     C                   Move      POINST3       SOINST
     C                   Move      POINST1       SOINS1
     C                   Move      PTOCUS1       STOCUS1
     C                   Move      PTOCUS2       STOCUS2
     C                   Move      PTOCUS3       STOCUS3
     C                   Move      PTOCUS4       STOCUS4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      STOCUS5 = PTOCUS5                                          CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      PSINST        SSINST
     C                   Move      PCCTDST       SCCTDST
     C                   Move      PSNDCOR       SSNDCOR
     C                   Move      PRCVCOR       SRCVCOR
     C                   Move      PDBTVDT       SDBTVDT
     C                   Move      PCCTAMT       SCCTAMT
     C                   Move      PCCTCCY       SCCTCCY
     C                   Move      PTTVDTE       STTVDT
     C                   Move      PCCTRTE       SCCTRT
     C                   Move      PSUMCCT       SSUMAMT
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * RtnFields - Return fields from the screen                          *
      **********************************************************************
     C     RtnFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtnFields'   SrStack(q)
      *
      ** If the total transfer ccy (or amount) has been changed the the
      ** sum of amounts need to be blank until it can recalcuted prior to
      ** update, otherwise a database error will occur.
      *
     C                   IF        MPCctCCy <> ScctCcy OR
     C                             MPCctAmt <> ScctAmt
     C                   EVAL      SSUMAMT = *Blanks
     C                   ENDIF
 
     C                   Move      SFILREF       PFILREF
     C                   Move      PFILREF       @FILREF
     C                   Move      STRNTYP       PCCTTYP
     C                   Move      STRNSTP       PCCTTST
     C                   Move      SBRCA         PBRCA
     C                   Move      SORBR         PORBR
     C                   Move      SBOKC         PBOKC
     C                   Move      SPRFC         PPRFC
     C                   Move      SSWPRIO       PSWPRIO
     C                   Move      SOINST        POINST3
     C                   Move      SOINS1        POINST1
     C                   Move      STOCUS1       PTOCUS1
     C                   Move      STOCUS2       PTOCUS2
     C                   Move      STOCUS3       PTOCUS3
     C                   Move      STOCUS4       PTOCUS4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      PTOCUS5 = STOCUS5                                          CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      SSINST        PSINST
     C                   Move      SCCTDST       PCCTDST
     C                   Move      SSNDCOR       PSNDCOR
     C                   Move      SRCVCOR       PRCVCOR
     C                   Move      SDBTVDT       PDBTVDT
     C                   Move      SCCTAMT       PCCTAMT
     C                   Move      SCCTCCY       PCCTCCY
     C                   Move      STTVDT        PTTVDTE
     C                   Move      SCCTRT        PCCTRTE
     C                   Move      SSUMAMT       PSUMCCT
 
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
     C                   Z-add     2             c                 2 0
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
     C**********************************************************************
      /EJECT
      **********************************************************************
      * RtvFields - Retrieve Fields                                        *
      **********************************************************************
     C     RtvFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvFields'   SrStack(q)
 
     C                   Move      MPCCTID       SCCTID
     C                   Move      MPFILREF      SFILREF
     C                   Move      MPCCTTYP      STRNTYP
     C                   Move      MPCCTTST      STRNSTP
     C                   Move      MPBRCA        SBRCA
     C                   Move      MPORBR        SORBR
     C                   Move      MPBOKC        SBOKC
     C                   Move      MPPRFC        SPRFC
     C                   Move      MPSWPRIO      SSWPRIO
     C                   Move      MPOINST3      SOINST
     C                   Move      MPOINST1      SOINS1
     C                   Move      MPTOCUS1      STOCUS1
     C                   Move      MPTOCUS2      STOCUS2
     C                   Move      MPTOCUS3      STOCUS3
     C                   Move      MPTOCUS4      STOCUS4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      STOCUS5 = MPTOCUS5                                         CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      MPSINST       SSINST
     C                   Move      MPCCTDST      SCCTDST
     C                   Move      MPSNDCOR      SSNDCOR
     C                   Move      MPRCVCOR      SRCVCOR
     C                   Move      MPDBTVDT      SDBTVDT
     C                   Move      MPCCTAMT      SCCTAMT
     C                   Move      MPCCTCCY      SCCTCCY
     C                   Move      MPTTVDTE      STTVDT
     C                   Move      MPCCTRTE      SCCTRT
     C                   Move      MPSUMCCT      SSUMAMT
 
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
     C                   Move      *Blank        Key05             1
 
     C                   Select
     C     *INKC         Wheneq    '1'
     C                   Movel     '03'          KeyPressed
                                                                                CFT007
     C     *INKD         Wheneq    '1'                                          CFT007
     C                   Movel     '04'          KeyPressed                     CFT007
 
     C     *INKQ         Wheneq    '1'                                          CFT007
     C                   Movel     '16'          KeyPressed                     CFT007
                                                                                CFT007
     C     *INKE         Wheneq    '1'
     C                   Movel     '05'          KeyPressed
     C                   Move      'Y'           Key05             1
     C     ActionCode    Ifeq      'R'
     C                   Move      MPCCTID       SCCTID
     C                   Move      MPFILREF      SFILREF
     C                   Else
     C                   Exsr      RtvFields
     C                   Endif
 
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
 
      ** CCT type
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
      * Cursor field for Bic Database +                                         CFT007
     C                   Parm                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
 
      ** END OF PARAMETERS DECLARATION
 
      ** Initialize program name
      *
     C                   Movel     'FTM1025DP'   DBPGM
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
                                                                                CFT007
      *                                                                         CFT007
      ** Access SAR details file to determine if CFT007                         CFT007
      ** (BIC Database +) is active                                             CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   PARM      *BLANKS       @Rtcd                          CFT007
     C                   PARM      '*VERIFY'     @Optn                          CFT007
     C                   PARM      'CFT007'      @Sard             6            CFT007
     C     SCSARD        PARM      SCSARD        Dsfdy                          CFT007
      *                                                                         CFT007
      ** Database Error                                                         CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd <> *BLANKS AND                         CFT007
     C                             @Rtcd <> '*NRF'                              CFT007
     C                   EVAL      DBFILE = 'SCSARDPD'                          CFT007
     C                   EVAL      DBASE = 999                                  CFT007
     C                   EVAL      DBKEY = 'CFT007'                             CFT007
     C                   EXSR      *PSSR                                        CFT007
     C                   ENDIF                                                  CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd = *BLANKS                              CFT007
     C                   MOVEL     'Y'           CFT007            1            CFT007
     C                   ELSE                                                   CFT007
     C                   MOVEL     'N'           CFT007                         CFT007
     C                   ENDIF                                                  CFT007
                                                                                              CSW207
      ** Check Swift 2007 is installed                                                        CSW207
                                                                                              CSW207
     C                   Call      'SWIF2007'                                                 CSW207
     C                   PARM                    RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
 
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
