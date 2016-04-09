     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Display CCT detail screen')
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1021DP - Display CCT detail : screen                           *
      *                                                                    *
      *  Function:  This module display a detail of a Customer Credit      *
      *             Transfer                                               *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG24998           Date 17Jul09               *
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 221538             Date 16Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00                    *
      *                 184060             Date 22Sep00                    *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007             Date 21Mar00                    *
      *                 CFT006  *CREATE    Date 22Sep99                    *
      *                                    Date ddmmmyy                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                          *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221538 - Expansion of field details.                              *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)                 *
      *  188649 - Display authorised text                                  *
      *  185660 - When routing using ?,all message parts should be         *
      *         - processed                                                *
      *  184060 - No transaction type code in detail screen - Recompile    *
      *  CFT007 - BIC Database Plus                                        *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * IniPgm : Initialisation  (called each time)                        *
      * Main : MAIN processing                                             *
      * EndPgm :  End of the program                                       *
      * NxtDetail : Next Detail                                            *
      * ScrMngmnt :  Screen Management                                     *
      * DecideX : Determine which detail record need to be displayed       *
      * NxtScrX : Next screen X                                            *
      * UpdStsScr : Update status of the screens from validation module    *
      * SelScreen : Select the screen to display                           *
      * DspScreen : Display the appropriate screen                         *
      *                                                                    *
      **********************************************************************
     FFT102DL0  IF   E           K DISK
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
 
      ** Screen Name
     D FT1022DDF       C                   Const(01)
     D FT1023DDF       C                   Const(02)
 
      ** Place of the first indicator PC on the screen
     D STARTPC         C                   Const(29)
 
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
 
      * Fields of the file
     D FileDtl       E DS                  EXTNAME(FT102DPD)
 
      * Fields of the screen memorized
     D ScreenMem     E DS                  EXTNAME(FT102DSPD) PREFIX(M)
 
      ** Error Indicators
     D OkFields1     E DS                  EXTNAME(FTE102S1PD)
     D OkFields2     E DS                  EXTNAME(FTE102S2PD)
     D OkCctDtB      E DS                  EXTNAME(FTE102BPD)
 
     D MREFARR         S              8    DIM(100)                             185660
      ** Message reference array                                                185660
                                                                                185660
     D MPRTARR         S              3    DIM(100)                             185660
      ** Message part array                                                     185660
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D/COPY MECPYSRC,ME1100_ILE
 
      ** DATA STRUCTURES
      ** ---------------
     D ScreenName      DS
     D ScreenIdx                      2  0
 
      ** Current screen
     D ScrCurName      DS
     D ScreenCur                           Like(ScreenIdx)
 
      ** Screen Displayed
     D ScrDspName      DS
     D ScreenDsp                           Like(ScreenIdx)
 
      ** ARRAYS
      ** ------
 
      ** Errors coming from the validation
     D FldNmArr1       S                   Like(FldNameArr) Dim(ArrayMax)
     D MsgIdArr1       S                   Like(MsgIdArr)   Dim(ArrayMax)
     D MsgDtArr1       S                   Like(MsgDtaArr)  Dim(ArrayMax)
     D FldNmArr2       S                   Like(FldNameArr) Dim(ArrayMax)
     D MsgIdArr2       S                   Like(MsgIdArr)   Dim(ArrayMax)
     D MsgDtArr2       S                   Like(MsgDtaArr)  Dim(ArrayMax)
      ** Copy arrays
     D FldNmA1         S                   Like(FldNameArr) Dim(ArrayMax)
     D MsgIdA1         S                   Like(MsgIdArr)   Dim(ArrayMax)
     D MsgDtA1         S                   Like(MsgDtaArr)  Dim(ArrayMax)
     D FldNmA2         S                   Like(FldNameArr) Dim(ArrayMax)
     D MsgIdA2         S                   Like(MsgIdArr)   Dim(ArrayMax)
     D MsgDtA2         S                   Like(MsgDtaArr)  Dim(ArrayMax)
 
      ** Warnings coming from the validation
     D WFldNmArr1      S                   Like(WFldNamArr) Dim(ArrayMax)
     D WMsgIdArr1      S                   Like(WMsgIdArr)  Dim(ArrayMax)
     D WMsgDtArr1      S                   Like(WMsgDtaArr) Dim(ArrayMax)
     D WFldNmArr2      S                   Like(WFldNamArr) Dim(ArrayMax)
     D WMsgIdArr2      S                   Like(WMsgIdArr)  Dim(ArrayMax)
     D WMsgDtArr2      S                   Like(WMsgDtaArr) Dim(ArrayMax)
      ** Copy arrays
     D WFldNmA1        S                   Like(WFldNamArr) Dim(ArrayMax)
     D WMsgIdA1        S                   Like(WMsgIdArr)  Dim(ArrayMax)
     D WMsgDtA1        S                   Like(WMsgDtaArr) Dim(ArrayMax)
     D WFldNmA2        S                   Like(WFldNamArr) Dim(ArrayMax)
     D WMsgIdA2        S                   Like(WMsgIdArr)  Dim(ArrayMax)
     D WMsgDtA2        S                   Like(WMsgDtaArr) Dim(ArrayMax)
 
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
 
      ** Screen in error
     D Err             S              1    Dim(NBSCREENS)
 
      ** Screen displayed
     D Dsp             S                   Dim(NBSCREENS) Like(Err)
 
      ** Initial values of screen memorized
     D Mem             S                   Dim(NBSCREENS) Like(Err)
 
      ** Screens in error
     D ScreenErr       S              2    Dim(NBSCREENS)
 
      ** FLAGS
      ** -----
 
      ** To reinitialize array
     D Reinit          S              1
 
      ** Initialize when action code is X
     D InitX           S                   Like(Reinit)
 
      ** To memorize initial values to be retrieved when pressing F5
     D MemoFld         S                   Like(Reinit)
 
      ** For infernal loops
     D CarryOn         S                   Like(Reinit)
 
      ** INDEXS
      ** ------
     D q               S              2  0
     D i               S              2  0
     D nse             S              2  0
     D ErrorIdx        S              2  0
 
      ** WORKING VARIABLES
      ** -----------------
      ** Old CCT id
     D OldCctID        S                   Like(PCCTID)
 
      ** Function key returned by one of the screen
     D KeyPressed      S              2
 
      ** Function key memorized
     D OldKeyP         S                   Like(KeyPressed)
 
     D OkScan          S            256
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Message reference (input parameter)
     D MgmsgR          S                   LIKE(PhmsgR)
 
 
      ** PARAMETERS
      ** ----------
 
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
 
      **  End of the program
     C                   Exsr      EndPgm
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
      ** Return
     C     KeyPressed    Ifeq      '03'
     C                   Seton                                        LR
     C                   Endif
 
     C     KeyPressed    Ifeq      '12'
     C     ScreenCur     Andeq     FT1022DDF
     C                   Seton                                        LR
     C                   Endif
 
     C     KeyPressed    Ifeq      '10'
     C     ActionCode    Ifeq      'X'
     C     DecLstRec     Andeq     'Y'
     C                   Seton                                        LR
     C                   Endif
     C                   Endif
 
     C                   Return
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      * Main -  Main Processing                                            *
      **********************************************************************
 
     C     Main          Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Main'        SrStack(q)
 
     C                   Select
 
      ** During mode X, each time the key F10 is pressed we display
      ** the next transaction detail. (no validation is performed)
     C     ActionCode    Wheneq    'X'
     C                   Move      'Y'           CarryOn
     C     CarryOn       Doweq     'Y'
 
      ** Prepare next record
     C     InitX         Ifeq      'Y'
     C                   Exsr      NxtDetail
     C                   Endif
 
     C                   Exsr      ScrMngmnt
     C                   Z-add     ScreenCur     DecScreen
     C                   Movel     KeyPressed    DecKeyP
     C                   Movel     NxtDLstR      DecLstRec
     C                   Exsr      DecideX
     C     DecIter       Ifeq      'Y'
     C                   Movel     'N'           InitX
     C                   Iter
     C                   Endif
     C     DecLeave      Ifeq      'Y'
     C                   Leave
     C                   Endif
     C                   Movel     'Y'           InitX
 
      ** Format the datas for the screen
     C                   Movel     CCTID         NxtS_CCT         15
     C                   Movel     Trnsid        NxtS_Trn
     C                   Exsr      NxtScrX
     C                   Z-add     FT1022DDF     ScreenIdx
     C                   Z-add     FT1022DDF     ScreenCur
     C                   Enddo
 
     C                   Other
     C                   Exsr      ScrMngmnt
 
     C                   Endsl
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * IniPgm -  Init Pgm                                                 *
      **********************************************************************
 
     C     IniPgm        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'IniPgm'      SrStack(q)
 
     C                   Movel     *BLANK        ScreenErr
 
     C     ActionCode    Ifeq      'X'
      ** We will display the first screen
     C                   Z-add     FT1022DDF     ScreenIdx
     C                   Z-add     FT1022DDF     ScreenCur
 
      ** We position on the current record in order to get the next one
      ** in S/R NxtDetail.
 
     C     KCCtDtl       Setll     FT102DL0                               90
     C     KCCtDtl       Reade     FT102DL0                               90
 
     C                   Goto      End_IniPgm
     C                   Endif
 
      ** Copy arrays into parameter variables
     C                   Movea     FldNmArr1     FldNmA1
     C                   Movea     MsgIdArr1     MsgIdA1
     C                   Movea     MsgDtArr1     MsgDtA1
     C                   Movea     FldNmArr2     FldNmA2
     C                   Movea     MsgIdArr2     MsgIdA2
     C                   Movea     MsgDtArr2     MsgDtA2
     C                   Movea     WFldNmArr1    WFldNmA1
     C                   Movea     WMsgIdArr1    WMsgIdA1
     C                   Movea     WMsgDtArr1    WMsgDtA1
     C                   Movea     WFldNmArr2    WFldNmA2
     C                   Movea     WMsgIdArr2    WMsgIdA2
     C                   Movea     WMsgDtArr2    WMsgDtA2
 
      ** Update array Err() from validation module CVAL
 
      ** At least one error has been detected by the validation prog
     C     FldNmA1(1)    Ifne      *BLANK
     C                   Movel     'Y'           Err(FT1022DDF)
     C                   Else
     C     WFldNmA1(1)   Ifne      *BLANK
     C                   Movel     'Y'           Err(FT1022DDF)
     C                   Else
     C                   Movel     'N'           Err(FT1022DDF)
     C                   Endif
     C                   Endif
 
     C     FldNmA1(1)    Ifne      *BLANK
     C                   Movel     'Y'           Err(FT1022DDF)
     C                   Else
     C     WFldNmA1(1)   Ifne      *BLANK
     C                   Movel     'Y'           Err(FT1022DDF)
     C                   Else
     C                   Movel     'N'           Err(FT1022DDF)
     C                   Endif
     C                   Endif
 
     C     FldNmA2(1)    Ifne      *BLANK
     C                   Movel     'Y'           Err(FT1023DDF)
     C                   Else
     C     WFldNmA2(1)   Ifne      *BLANK
     C                   Movel     'Y'           Err(FT1023DDF)
     C                   Else
     C                   Movel     'N'           Err(FT1023DDF)
     C                   Endif
     C                   Endif
 
      ** No errors were detected by the validation prog
      ** In that case we look in the global  message array
      ** and if errors are found, we copy its contents to the
      ** current screen.
     C     FldNmA1(1)    Ifeq      *BLANK
     C     FldNmA2(1)    Andeq     *BLANK
     C     WFldNmA1(1)   Andeq     *BLANK
     C     WFldNmA2(1)   Andeq     *BLANK
     C     FldNameArr(1) Ifne      *BLANK
     C                   Select
     C     ScreenCur     Wheneq    FT1022DDF
     C                   Movel     'Y'           Err(FT1022DDF)
     C                   Movea     FldNameArr    FldNmA1
     C                   Movea     MsgIdArr      MsgIdA1
     C                   Movea     MsgDtaArr     MsgDtA1
 
     C     ScreenCur     Wheneq    FT1023DDF
     C                   Movel     'Y'           Err(FT1023DDF)
     C                   Movea     FldNameArr    FldNmA2
     C                   Movea     MsgIdArr      MsgIdA2
     C                   Movea     MsgDtaArr     MsgDtA2
 
     C                   Endsl
     C                   Endif
     C                   Endif
 
 
      ** ENTER has been pressed on the last screen.
      ** If no errors encountered that implies an update has been
      ** requested. So we reinitialize the context for the new
      ** transaction.
     C     Reinit        Ifeq      'N'
 
     C                   Select
 
     C     ActionCode    Wheneq    'D'
     C     ActionCode    Oreq      'R'
     C     OldKeyP       Ifeq      '10'
     C                   Movel     'Y'           Reinit
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     Err(i)        Ifeq      'Y'
     C                   Movel     'N'           Reinit
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif
 
     C     ActionCode    Wheneq    'A'
     C     ActionCode    Oreq      'I'
     C     ActionCode    Oreq      'E'
     C     OldKeyP       Ifeq      *BLANK
     C     ScreenCur     andeq     FT1023DDF
     C                   Movel     'Y'           Reinit
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     Err(i)        Ifeq      'Y'
     C                   Movel     'N'           Reinit
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif
 
     C                   Endsl
 
     C                   Endif
 
      ** Do we need to reinitialize the entire transaction ?
     C     Reinit        Ifeq      'Y'
 
      ** We will display the first screen
     C                   Z-add     FT1022DDF     ScreenIdx
     C                   Z-add     FT1022DDF     ScreenCur
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   add       1             i
     C                   Movel     'N'           Err(i)
     C                   Movel     'N'           Dsp(i)
     C                   Enddo
     C                   Endif
 
      **  Unwind subroutine stack name
     C     End_IniPgm    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * EndPgm -  End of the program                                       *
      **********************************************************************
 
     C     EndPgm        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'EndPgm'      SrStack(q)
 
      ** Reinit set to 'Y' can be used in any part of the program
      ** Now it terminate we flag this variable to 'N'
      ** Reinit can be 'Y' in 5 cases
      ** 1- after pressing ENTER on last screen that generates no errors
      ** 2- after pressing F12 on first screen (SETON  LR => *INZSR)
      ** 3- after pressing F3 (SETON  LR => *INZSR)
      ** 4- after pressing F10 and no errors (Action code not X)
      ** 5- after pressing F10 on the last screen (X) (SETON  LR => *INZSR)
     C                   Movel     'N'           Reinit
 
      ** If errors come from the update module we will display them
      ** just once.
     C     FldNameArr(1) Ifne      *BLANK
     C                   Movel     *BLANK        FldNameArr
     C                   Movel     *BLANK        MsgIdArr
     C                   Movel     *BLANK        MsgDtaArr
     C                   Endif
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * ScrMngmnt -  Screen Management                                     *
      **********************************************************************
 
     C     ScrMngmnt     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'ScrMngmnt'   SrStack(q)
 
      ** Select screen
      ** (InitX 'Y' => we display the first screen)
     C     ActionCode    Ifeq      'X'
     C     InitX         Ifne      'Y'
     C                   Exsr      SelScreen
     C                   Endif
     C                   Else
      ** (Reinit 'Y' => we display the first screen)
     C     Reinit        Ifne      'Y'
     C                   Exsr      SelScreen
     C                   Endif
     C                   Endif
 
      ** Display screen selected
     C                   Exsr      DspScreen
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * SelScreen - Select the screen to display                           *
      **********************************************************************
 
     C     SelScreen     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SelScreen'   SrStack(q)
 
      ** INPUT  VARIABLES
      ** ----------------
      ** Key pressed previously
      **                           OldKeyP
      ** Action Code
      **                           ActionCode
      ** OUTPUT VARIABLES
      ** ----------------
      ** Screen Name (or ScreenIdx)
      **                           ScreenName
 
      ** GENERAL RULE
      ** - The user can navigate across the screens whatever the errors
      ** are by pressing F12/F11 (an error message will be send to
      ** inform the user he has bypassed a screen)
      ** - If the user press ENTER and no errors appear on the current
      ** screen, then the program will display the next screen which is
      ** in error
 
     C                   Select
      ** ENTER pressed
     C     OldKeyP       Wheneq    *BLANK
     C                   Add       1             ScreenIdx
 
      ** F11 pressed
     C     OldKeyP       Wheneq    '11'
     C                   Add       1             ScreenIdx
 
      ** F12 pressed
     C     OldKeyP       Wheneq    '12'
     C                   Sub       1             ScreenIdx
 
     C                   Endsl
 
     C                   Select
 
     C     ActionCode    Wheneq    'E'
      ** In enquire mode NOTHING
 
     C                   Other
      ** Determine screen where stand remaining errors
     C                   Movel     *BLANK        ScreenErr
     C                   Z-add     0             i
     C                   Z-add     0             nse
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     Err(i)        Ifeq      'Y'
     C                   Add       1             nse
     C                   Move      i             ScreenErr(nse)
     C                   Endif
     C                   Enddo
 
      ** No errors found on other screens
     C     nse           Ifeq      0
 
      ** If ENTER pressed and errors found on the actual screen
      ** we will redisplay the actual one
     C     OldKeyP       Ifeq      *BLANK
     C     Err(ScreenCur)Ifeq      'Y'
     C                   Move      ScrCurName    ScreenName
     C                   Endif
     C                   Endif
 
     C                   Else
 
      ** Errors are found on other screens
 
      ** Function key pressed
     C     OldKeyP       Ifne      *BLANK
      ** If we go to the screen in error by pressing a function key we
      ** don't need to send any messages
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     ScreenErr(i)  Ifeq      ScreenName
     C                   Movel     *BLANK        ScreenErr(i)
     C                   Endif
     C                   Enddo
 
     C                   Else
 
      ** ENTER : we go to the screen in error automatically if
      ** no errors are displayed on the present screen
     C     Err(ScreenCur)Ifeq      'N'
     C                   Move      ScreenErr(1)  ScreenName
     C                   Movel     *BLANK        ScreenErr(1)
     C                   Else
 
      ** ENTER : if remaining errors we display the current screen
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     ScreenErr(i)  Ifeq      ScrCurName
     C                   Movel     *BLANK        ScreenErr(i)
     C                   Endif
     C                   Enddo
     C                   Move      ScrCurName    ScreenName
     C                   Endif
 
     C                   Endif
 
     C                   Endif
 
     C                   Endsl
 
 
      ** We cannot display screen 0 or screen N + 1 in a transaction
      ** with N screen
     C     ScreenIdx     Iflt      1
     C                   Z-add     1             ScreenIdx
     C                   Else
     C     ScreenIdx     Ifgt      NBSCREENS
     C                   Z-add     NBSCREENS     ScreenIdx
     C                   Endif
     C                   Endif
 
      **  Unwind subroutine stack name
     C     End_SelScr    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * DspScreen - Display the appropriate screen                         *
      **********************************************************************
 
     C     DspScreen     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DspScreen'   SrStack(q)
 
      ** INPUT VARIABLES
      ** ---------------
      ** Screen Name (or ScreenIdx)
      **                           ScreenName
 
      ** OUTPUT VARIABLES
      ** ----------------
      ** Current Screen (for the program)
      **                           ScreenCur
      ** Key pressed (for the program)
      **                           OldKeyP
      ** Screen  Displayed (for output parameter)
      **                           ScreenDsp
      ** Key pressed (for output parameter)
      **                           KeyPressed
 
     C                   Z-add     ScreenIdx     ScreenCur
     C                   Z-add     ScreenIdx     ScreenDsp
 
     C     Dsp(ScreenIdx)Ifeq      'N'
     C                   Movel     'Y'           Dsp(ScreenIdx)
      ** Memorize fields for refresh (F5)
     C                   Movel     'Y'           Mem(ScreenIdx)
     C                   Else
     C                   Movel     'N'           Mem(ScreenIdx)
     C                   Endif
 
     C                   Select
 
     C     ScreenIdx     Wheneq    FT1022DDF
     C                   Callb     'FTM1022DP'
     C                   Parm                    RetCodeIn        10
     C                   Parm                    ActionCode
     C                   Parm                    @CctTyp
     C                   Parm                    @FilRef
     C                   Parm      Mem(FT1022DDF)MemoFld
     C                   Parm                    ScreenDtl
     C                   Parm                    OkFields1
     C                   Parm                    ScreenErr
     C                   Parm                    FldNmA1
     C                   Parm                    MsgIdA1
     C                   Parm                    MsgDtA1
     C                   Parm                    WFldNmA1
     C                   Parm                    WMsgIdA1
     C                   Parm                    WMsgDtA1
     C                   Parm                    KeyPressed        2
     C                   Parm                    OldCctID
      * Cursor field for Bic Database +                                         CFT007
     C                   Parm                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
 
     C     ScreenIdx     Wheneq    FT1023DDF
     C                   Callb     'FTM1023DP'
     C                   Parm                    RetCodeIn        10
     C                   Parm                    ActionCode
     C                   Parm                    @CctTyp
     C                   Parm                    @FilRef
     C                   Parm      Mem(FT1023DDF)MemoFld
     C                   Parm                    ScreenDtl
     C                   Parm                    OkFields2
     C                   Parm                    ScreenErr
     C                   Parm                    FldNmA2
     C                   Parm                    MsgIdA2
     C                   Parm                    MsgDtA2
     C                   Parm                    WFldNmA2
     C                   Parm                    WMsgIdA2
     C                   Parm                    WMsgDtA2
     C                   Parm                    KeyPressed        2
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
 
     C                   Endsl
 
      ** The program needs to know which key was pressed previously
      ** (KeyPressed is an outpout parameter so its value can be
      ** altered by other modules in HSIN)
     C                   Movel     KeyPressed    OldKeyP
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * UpdStsScr - Update status of the screens                           *
      **********************************************************************
 
     C     UpdStsScr     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'UpdStsScr'   SrStack(q)
 
      ** INPUT VARIABLES
      ** ---------------
      ** Screen Index
     C     *Like         Define    ScreenIdx     UpScrIdx
      ** OK fields
      **                           UpOkFld
 
      ** OUTPUT VARIABLES
      ** ----------------
      ** Error Index
      **                           UpErrIdx
 
     C                   Z-add     0             UpErrIdx          2 0
 
     C     'N'           Scan      UpOkFld       UpErrIdx
     C     UpErrIdx      Ifne      0
     C                   Movel     'Y'           Err(UpScrIdx)
     C                   Else
     C     'W'           Scan      UpOkFld       UpErrIdx
     C     UpErrIdx      Ifne      0
     C                   Movel     'Y'           Err(UpScrIdx)
     C                   Else
     C                   Movel     'N'           Err(UpScrIdx)
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Z-add     0             UpScrIdx
     C                   Movel     *BLANK        UpOkFld         256
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * DecideX - Determine which detail record need to be displayed       *
      * DecLeave = 'Y' we leave the transaction 'X' (authorisation)        *
      *    - After 'F3' was pressed                                        *
      *    - After 'F10' was pressed on the last detail record             *
      *    - After 'F12' was pressed on the first screen of any details    *
      * DecIter = 'Y'  we remain on the current detail                     *
      *    - If F10 was not pressed                                        *
      **********************************************************************
 
     C     DecideX       Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DecideX'     SrStack(q)
 
      ** INPUT VARIABLES
      ** ---------------
      ** Screen Displayed
     C     *Like         Define    ScreenIdx     DecScreen
      ** Key Pressed
     C     *Like         Define    KeyPressed    DecKeyP
      ** Last Record
     C     *Like         Define    Reinit        DecLstRec
 
      ** OUTPUT VARIABLES
      ** ----------------
      ** Iter  (Y/N)
     C     *Like         Define    Reinit        DecIter
      ** Leave (Y/N)
     C     *Like         Define    Reinit        DecLeave
 
     C                   Movel     'N'           DecIter
     C                   Movel     'N'           DecLeave
 
     C     DecKeyP       Ifeq      '03'
     C                   Movel     'Y'           DecLeave
     C                   Goto      End_DecX
     C                   Endif
 
     C     DecLstRec     Ifeq      'Y'
     C     DecKeyP       andeq     '10'
     C                   Movel     'Y'           DecLeave
     C                   Goto      End_DecX
     C                   Endif
 
     C     DecScreen     Ifeq      FT1022DDF
     C     DecKeyP       andeq     '12'
     C                   Movel     'Y'           DecLeave
     C                   Goto      End_DecX
     C                   Endif
 
     C     DecKeyP       Ifne      '10'
     C                   Movel     'Y'           DecIter
     C                   Goto      End_DecX
     C                   Endif
 
     C     End_DecX      Tag
      **  Reset input variables
     C                   Movel     *BLANK        DecKeyP
     C                   Movel     *BLANK        DecLstRec
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * NxtDetail - Next Detail                                            *
      **********************************************************************
 
     C     NxtDetail     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'NxtDetail'   SrStack(q)
 
      ** OUTPUT VARIABLES
      ** ----------------
      ** Last Record  (Y/N)
     C     *Like         Define    Reinit        NxtDLstR
      ** Datas of FT102DPD
 
     C                   Movel     'N'           NxtDLstR
 
     C     KCCtDtl       Klist
     C                   Kfld                    Pcctid
 
     C     KcctDtl       Reade     FT102DL0                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'Y'           NxtDLstR
     C                   Endif
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
      * NxtScrX - Next screen X                                            *
      **********************************************************************
     C     NxtScrX       Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'NxtScrX'     SrStack(q)
 
      ** INPUT VARIABLES
      ** ---------------
      ** CCT_ID
      **                                         NxtS_CCT
      ** Transaction ID
      **                                         NxtS_TRN
 
     C                   CLEAR                   MREFARR                        185660
     C                   CLEAR                   MREFARR                        185660
 
      ** Retrieve datas of the detail
     C                   Callb     'FTM1022RV'
     C                   Parm                    RetCodeIn
     C                   Parm                    ActionCode        1
     C                   Parm                    NxtS_CCT         15
     C                   Parm                    NxtS_TRN         16
     C                   Parm      *BLANK        SWIFTR           28
     C                   Parm      *BLANK        SWIFTS            2
     C                   PARM                    MgmsgR
     C                   Parm                    FileDtl
     C                   Parm                    @Keyp             2
     C                   Parm                    PHead
     C                   PARM                    PData
     C                   PARM                    PDat2                                        CSW209
      * Message ref array                                                       185660
     C                   PARM                    MREFARR                        185660
      * Message part array                                                      185660
     C                   PARM                    MPRTARR                        185660
     C                   PARM                    OkCctDtB
     C                   PARM                    Ix
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Convert to screen format
     C                   Clear                   Phead
     C                   Callb     'FTM1022CT'
     C                   Parm                    RetCodeIn
     C                   PARM                    ActionCode                                   221538
     C                   Parm                    Phead
     C                   Parm      *blanks       Pdata
     C                   Parm      *blanks       Pdat2                                        CSW209
     C                   PARM      'SC'          CnvTyp            2
     C                   PARM                    @CCttyp           2
     C                   PARM                    @FilRef          16
     C                   Parm                    FileDtl
     C                   Parm                    ScreenDtl
 
      **  Reset input variables
     C                   Movel     *BLANK        NxtS_CCT
     C                   Movel     *BLANK        NxtS_TRN
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT                                                               *
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
     C                   Parm                    @CctTyp           2
     C                   Parm                    @FilRef          16
 
      ** Details CCT (in screen format)
     C                   Parm                    ScreenDtl
 
      ** Fields in error
     C                   Parm                    OkFields1
     C                   Parm                    OkFields2
 
      ** Errors coming from the validation
     C                   Parm                    FldNmArr1
     C                   Parm                    MsgIdArr1
     C                   Parm                    MsgDtArr1
     C                   Parm                    FldNmArr2
     C                   Parm                    MsgIdArr2
     C                   Parm                    MsgDtArr2
 
      ** Errors coming from other modules
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
      ** Warnings coming from validation
     C                   Parm                    WFldNmArr1
     C                   Parm                    WMsgIdArr1
     C                   Parm                    WMsgDtArr1
     C                   Parm                    WFldNmArr2
     C                   Parm                    WMsgIdArr2
     C                   Parm                    WMsgDtArr2
 
      ** OUTPUT PARAMETERS
 
      ** Function key pressed
     C                   Parm                    KeyPressed
 
      ** Old Request for transfert ID (for Reassign mode)
     C                   Parm                    OldCctID
 
      ** Screen Displayed (for SIN Module)
     C                   Parm                    ScrDspName
      * Cursor field for Bic Database +                                         CFT007
     C                   Parm                    CsrFld           10            CFT007
      * Status description                                                      188649
     C                   PARM                    SAIND            20            188649
 
      ** END OF PARAMETERS DECLARATION
 
 
     C     ActionCode    Ifeq      'X'
     C                   Movel     'Y'           InitX
     C                   Else
     C                   Movel     'Y'           Reinit
     C                   Endif
 
     C                   Endsr
      **********************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
