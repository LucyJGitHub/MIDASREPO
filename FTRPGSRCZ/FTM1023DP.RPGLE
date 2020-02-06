     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Display one CCT detail screen 2')
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1023DP - Display one CCT detail : screen 2                     *
      *                                                                    *
      *  Function:  This module display the details of a Customer Credit   *
      *             Transfer                                               *
      *                                                                    *
      *  (c) Finastra International Limited 2001                      *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01                    *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 22Nov99                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                          *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  188649 - Allow authorisation text pn screen                       *
      *  184060 - No transaction type code in detail screen -Recompile     *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1023DDFCF   E             WORKSTN
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      *     31-43 Field Error - highlight screen fields                    *
      *     70    Protect fields for outgoing CCT                          *
      *     71    Protect fields screen                                    *
      *     72    Disable F5                                               *
      *     73    Disable F10                                              *
      *     74    Enable F11                                               *
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
     D NBSCREENS       C                   Const(2)
 
      ** Fields on the screen
     D NBFIELDS        C                   Const(17)
 
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
     D ScreenDtl     E DS                  EXTNAME(FT102DSPD)
 
      * Fields of the screen memorized
     D ScreenMem     E DS                  EXTNAME(FT102DSPD) PREFIX(M)
 
      ** Error Indicators
     D OkFields      E DS                  EXTNAME(FTE102S2PD)
 
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
      *                                                                                       CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
     D PRtCd           S              7A                                                      CSW201
 
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
 
      ** Reset previous highighted fields
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
     C                   Movel     '1'           *IN74
 
     C     ActionCode    Wheneq    'X'
     C                   Movel     '1'           *IN71
     C                   Movel     '0'           *IN74
 
     C     ActionCode    Wheneq    'D'
     C                   Movel     '1'           *IN71
     C                   Movel     '0'           *IN74
 
     C     ActionCode    Wheneq    'R'
      ** All fields are protected, except CCT for transfert ID and
      ** Transaction Reference
     C                   Movel     '1'           *IN71
     C                   Movel     '0'           *IN74
 
     C                   Other
     C                   Movel     '0'           *IN74
 
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
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** enable fields introduced by this enhancement.                                        CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      *IN83 = *ON                                                CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      *IN83 = *OFF                                               CSW201
     C                   ENDIF                                                                CSW201
 
      **  Memorize fields in case of refresh (F5)
     C     MemoFields    Ifeq      'Y'
     C                   Movel     'N'           MemoFields
     C                   Move      PSNDCHG       MPSNDCHG
     C                   Move      PSNDCCY       MPSNDCCY
     C                   Move      PSNDOCG       MPSNDOCG
     C                   Move      PSTRCCY       MPSTRCCY
     C                   Move      PSNDCTF       MPSNDCTF
     C                   Move      PSPYCCY       MPSPYCCY
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** save the fields introduced by this enhancement to their                              CSW201
      ** corresponding memorized fields.                                                      CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   MOVE      PSNDCHG2      MPSNDCHG2                                    CSW201
     C                   MOVE      PSNDCCY2      MPSNDCCY2                                    CSW201
     C                   MOVE      PSNDOCG2      MPSNDOCG2                                    CSW201
     C                   MOVE      PSNDCTF2      MPSNDCTF2                                    CSW201
     C                   MOVE      PSNDCHG3      MPSNDCHG3                                    CSW201
     C                   MOVE      PSNDCCY3      MPSNDCCY3                                    CSW201
     C                   MOVE      PSNDOCG3      MPSNDOCG3                                    CSW201
     C                   MOVE      PSNDCTF3      MPSNDCTF3                                    CSW201
     C                   MOVE      PSNDCHG4      MPSNDCHG4                                    CSW201
     C                   MOVE      PSNDCCY4      MPSNDCCY4                                    CSW201
     C                   MOVE      PSNDOCG4      MPSNDOCG4                                    CSW201
     C                   MOVE      PSNDCTF4      MPSNDCTF4                                    CSW201
     C                   MOVE      PSNDCHG5      MPSNDCHG5                                    CSW201
     C                   MOVE      PSNDCCY5      MPSNDCCY5                                    CSW201
     C                   MOVE      PSNDOCG5      MPSNDOCG5                                    CSW201
     C                   MOVE      PSNDCTF5      MPSNDCTF5                                    CSW201
     C                   ENDIF                                                                CSW201
     C                   Move      PRCVCHG       MPRCVCHG
     C                   Move      PRCVCCY       MPRCVCCY
     C                   Move      PRCVOCG       MPRCVOCG
     C                   Move      PRTRCCY       MPRTRCCY
     C                   Move      PRCVCTF       MPRCVCTF
     C                   Move      PRPYCCY       MPRPYCCY
     C                   Move      PGOPFLG       MPGOPFLG
     C                   Move      PREMI1        MPREMI1
     C                   Move      PREMI2        MPREMI2
     C                   Move      PREMI3        MPREMI3
     C                   Move      PREMI4        MPREMI4
     C                   Move      PREGRP1       MPREGRP1
     C                   Move      PREGRP2       MPREGRP2
     C                   Move      PREGRP3       MPREGRP3
 
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
     C                   If        *INKK And ActionCode = 'E'
     C                   Exfmt     FTM1023DF2
     C                   Else
 
     C                   Write     #MSGCTL
     C                   Write     FTM1023DF1
 
     C                   Read      FTM1023DF1                             99    *
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
      * RtnFields - Return fields                                          *
      **********************************************************************
     C     RtnFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtnFields'   SrStack(q)
 
     C                   Move      SFilRef       PFilRef
     C                   Move      SCctTyp       PCCtTyp
     C                   Move      SSNDCHG       PSNDCHG
     C                   Move      SSNDCCY       PSNDCCY
     C                   Move      SSNDOCG       PSNDOCG
     C                   Move      SSTRNCY       PSTRCCY
     C                   Move      SSNDCTF       PSNDCTF
     C                   Move      SSPAYCY       PSPYCCY
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** move screen fields introduced by this enhancement to their                           CSW201
      ** corresponding screen details data structure.                                         CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   MOVE      SSDCHG2       PSNDCHG2                                     CSW201
     C                   MOVE      SSDCCY2       PSNDCCY2                                     CSW201
     C                   MOVE      SSDOCG2       PSNDOCG2                                     CSW201
     C                   MOVE      SSDCTF2       PSNDCTF2                                     CSW201
     C                   MOVE      SSDCHG3       PSNDCHG3                                     CSW201
     C                   MOVE      SSDCCY3       PSNDCCY3                                     CSW201
     C                   MOVE      SSDOCG3       PSNDOCG3                                     CSW201
     C                   MOVE      SSDCTF3       PSNDCTF3                                     CSW201
     C                   MOVE      SSDCHG4       PSNDCHG4                                     CSW201
     C                   MOVE      SSDCCY4       PSNDCCY4                                     CSW201
     C                   MOVE      SSDOCG4       PSNDOCG4                                     CSW201
     C                   MOVE      SSDCTF4       PSNDCTF4                                     CSW201
     C                   MOVE      SSDCHG5       PSNDCHG5                                     CSW201
     C                   MOVE      SSDCCY5       PSNDCCY5                                     CSW201
     C                   MOVE      SSDOCG5       PSNDOCG5                                     CSW201
     C                   MOVE      SSDCTF5       PSNDCTF5                                     CSW201
     C                   ENDIF                                                                CSW201
     C                   Move      SRCVCHG       PRCVCHG
     C                   Move      SRCVCCY       PRCVCCY
     C                   Move      SRCVOCG       PRCVOCG
     C                   Move      SRTRNCY       PRTRCCY
     C                   Move      SRCVCTF       PRCVCTF
     C                   Move      SRPAYCY       PRPYCCY
     C                   Move      SGOPFLG       PGOPFLG
     C                   Move      SREMI1        PREMI1
     C                   Move      SREMI2        PREMI2
     C                   Move      SREMI3        PREMI3
     C                   Move      SREMI4        PREMI4
     C                   Move      SREGRP1       PREGRP1
     C                   Move      SREGRP2       PREGRP2
     C                   Move      SREGRP3       PREGRP3
 
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
      * DftOutFlds - Default Output fields                                 *
      **********************************************************************
     C     DftOutFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DftOutFlds'  SrStack(q)
 
     C                   Move      PCCTID        SCCTID
     C                   Move      PTRNSID       STRNSID
     C                   Move      PFilRef       SFilRef
     C                   Move      PCCtTyp       SCctTyp
     C                   Move      PSNDCHG       SSNDCHG
     C                   Move      PSNDCCY       SSNDCCY
     C                   Move      PSNDOCG       SSNDOCG
     C                   Move      PSTRCCY       SSTRNCY
     C                   Move      PSNDCTF       SSNDCTF
     C                   Move      PSPYCCY       SSPAYCY
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** move screen detail fields introduced by this enhancement to their                    CSW201
      ** corresponding screen fields.                                                         CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** Initialise screen fields.                                                            CSW201
      *                                                                                       CSW201
     C                   MOVE      *BLANKS       SSPYCY2                                      CSW201
     C                   MOVE      *BLANKS       SSTRCY2                                      CSW201
     C                   MOVE      *BLANKS       SSDOCG2                                      CSW201
     C                   MOVE      *BLANKS       SSDCTF2                                      CSW201
                                                                                              CSW201
     C                   MOVE      *BLANKS       SSPYCY3                                      CSW201
     C                   MOVE      *BLANKS       SSTRCY3                                      CSW201
     C                   MOVE      *BLANKS       SSDOCG3                                      CSW201
     C                   MOVE      *BLANKS       SSDCTF3                                      CSW201
                                                                                              CSW201
     C                   MOVE      *BLANKS       SSPYCY4                                      CSW201
     C                   MOVE      *BLANKS       SSTRCY4                                      CSW201
     C                   MOVE      *BLANKS       SSDOCG4                                      CSW201
     C                   MOVE      *BLANKS       SSDCTF4                                      CSW201
                                                                                              CSW201
     C                   MOVE      *BLANKS       SSPYCY5                                      CSW201
     C                   MOVE      *BLANKS       SSTRCY5                                      CSW201
     C                   MOVE      *BLANKS       SSDOCG5                                      CSW201
     C                   MOVE      *BLANKS       SSDCTF5                                      CSW201
                                                                                              CSW201
     C                   MOVE      PSNDCHG2      SSDCHG2                                      CSW201
     C                   MOVE      PSNDCCY2      SSDCCY2                                      CSW201
     C                   IF        PSNDCHG2 <> *BLANKS                                        CSW201
     C                   MOVE      PSPYCCY       SSPYCY2                                      CSW201
     C                   MOVE      PSTRCCY       SSTRCY2                                      CSW201
     C                   MOVE      PSNDOCG2      SSDOCG2                                      CSW201
     C                   MOVE      PSNDCTF2      SSDCTF2                                      CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   MOVE      PSNDCHG3      SSDCHG3                                      CSW201
     C                   MOVE      PSNDCCY3      SSDCCY3                                      CSW201
     C                   IF        PSNDCHG3 <> *BLANKS                                        CSW201
     C                   MOVE      PSPYCCY       SSPYCY3                                      CSW201
     C                   MOVE      PSTRCCY       SSTRCY3                                      CSW201
     C                   MOVE      PSNDOCG3      SSDOCG3                                      CSW201
     C                   MOVE      PSNDCTF3      SSDCTF3                                      CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   MOVE      PSNDCHG4      SSDCHG4                                      CSW201
     C                   MOVE      PSNDCCY4      SSDCCY4                                      CSW201
     C                   IF        PSNDCHG4 <> *BLANKS                                        CSW201
     C                   MOVE      PSPYCCY       SSPYCY4                                      CSW201
     C                   MOVE      PSTRCCY       SSTRCY4                                      CSW201
     C                   MOVE      PSNDOCG4      SSDOCG4                                      CSW201
     C                   MOVE      PSNDCTF4      SSDCTF4                                      CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   MOVE      PSNDCHG5      SSDCHG5                                      CSW201
     C                   MOVE      PSNDCCY5      SSDCCY5                                      CSW201
     C                   IF        PSNDCHG5 <> *BLANKS                                        CSW201
     C                   MOVE      PSPYCCY       SSPYCY5                                      CSW201
     C                   MOVE      PSTRCCY       SSTRCY5                                      CSW201
     C                   MOVE      PSNDOCG5      SSDOCG5                                      CSW201
     C                   MOVE      PSNDCTF5      SSDCTF5                                      CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Move      PRCVCHG       SRCVCHG
     C                   Move      PRCVCCY       SRCVCCY
     C                   Move      PRCVOCG       SRCVOCG
     C                   Move      PRTRCCY       SRTRNCY
     C                   Move      PRCVCTF       SRCVCTF
     C                   Move      PRPYCCY       SRPAYCY
     C                   Move      PGOPFLG       SGOPFLG
     C                   Move      PREMI1        SREMI1
     C                   Move      PREMI2        SREMI2
     C                   Move      PREMI3        SREMI3
     C                   Move      PREMI4        SREMI4
     C                   Move      PREGRP1       SREGRP1
     C                   Move      PREGRP2       SREGRP2
     C                   Move      PREGRP3       SREGRP3
 
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
 
     C                   Move      MPSNDCHG      SSNDCHG
     C                   Move      MPSNDCCY      SSNDCCY
     C                   Move      MPSNDOCG      SSNDOCG
     C                   Move      MPSTRCCY      SSTRNCY
     C                   Move      MPSNDCTF      SSNDCTF
     C                   Move      MPSPYCCY      SSPAYCY
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** move memorized fields introduced by this enhancement to their                        CSW201
      ** corresponding screen fields.                                                         CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   MOVE      MPSNDCHG2     SSDCHG2                                      CSW201
     C                   MOVE      MPSNDCCY2     SSDCCY2                                      CSW201
     C                   MOVE      MPSNDOCG2     SSDOCG2                                      CSW201
     C                   MOVE      MPSNDCTF2     SSDCTF2                                      CSW201
     C                   MOVE      MPSNDCHG3     SSDCHG3                                      CSW201
     C                   MOVE      MPSNDCCY3     SSDCCY3                                      CSW201
     C                   MOVE      MPSNDOCG3     SSDOCG3                                      CSW201
     C                   MOVE      MPSNDCTF3     SSDCTF3                                      CSW201
     C                   MOVE      MPSNDCHG4     SSDCHG4                                      CSW201
     C                   MOVE      MPSNDCCY4     SSDCCY4                                      CSW201
     C                   MOVE      MPSNDOCG4     SSDOCG4                                      CSW201
     C                   MOVE      MPSNDCTF4     SSDCTF4                                      CSW201
     C                   MOVE      MPSNDCHG5     SSDCHG5                                      CSW201
     C                   MOVE      MPSNDCCY5     SSDCCY5                                      CSW201
     C                   MOVE      MPSNDOCG5     SSDOCG5                                      CSW201
     C                   MOVE      MPSNDCTF5     SSDCTF5                                      CSW201
     C                   ENDIF                                                                CSW201
     C                   Move      MPRCVCHG      SRCVCHG
     C                   Move      MPRCVCCY      SRCVCCY
     C                   Move      MPRCVOCG      SRCVOCG
     C                   Move      MPRTRCCY      SRTRNCY
     C                   Move      MPRCVCTF      SRCVCTF
     C                   Move      MPRPYCCY      SRPAYCY
     C                   Move      MPGOPFLG      SGOPFLG
     C                   Move      MPREMI1       SREMI1
     C                   Move      MPREMI2       SREMI2
     C                   Move      MPREMI3       SREMI3
     C                   Move      MPREMI4       SREMI4
     C                   Move      MPREGRP1      SREGRP1
     C                   Move      MPREGRP2      SREGRP2
     C                   Move      MPREGRP3      SREGRP3
 
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
     C                   Parm                    @Filref          16
 
      ** Memorize fields for F5
     C                   Parm                    MemoFields        1
 
      ** Details CCT (in screen format)
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
     C                   Movel     'FTM1023DP'   DBPGM
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
                                                                                              CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
                                                                                              CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRtCd                                        CSW201
                                                                                              CSW201
     C                   IF        PRtCd = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
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
(c) Finastra International Limited 2001
