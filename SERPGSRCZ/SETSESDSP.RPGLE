     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade SWIFT Extended Settlement Display')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSESDSP - Midas SE Trade SWIFT Extended Settlement Screen  *
      *                                                               *
      *  Function: This module is for the display and maintenance of  *
      *            the Extended Settlement (both A and B records)     *
      *            initial screen details.                            *
      *                                                               *
      *  Component of: SETSESSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. AR580857           Date 21Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR580857 - QFIN label is erroneous (Recompile)               *
      *  CSW210 - SWIFT Changes 2010                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         Destination From Depot                          *
      *    04         Destination To Depot                            *
      *    05         Euroclear/Cedel destination                     *
      *    06         Non Euroclear/Cedel destination                 *
      *    07         Deliver message                                 *
      *    08         Receive message                                 *
      *    09         Switchable feature CSW098 is on or date is      *
      *               greater than 16 October 1998. Can also be error *
      *               on call to SWIFT98.                             *
      *    10-79      Field Error - highlight screen fields           *
      *    30         Swift 2010 Fields                               *                       CSW210
      *    80         Protect Input Fields                            *
      *    81         Receive message and CSE029 is on                *
      *    82         CSE028 is switched on                           *
      *    83         ISO15022 is 'Y'                                 *
      *    88         ISO15022 is 'Y' and CSE028 is 'Y'               *
      *    89         Deliver message and CSE029 is on                *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMainP - Main processing                                    *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security diary events initial screen
     FSETSESDSDFCF   E             WORKSTN INFSR(*PSSR)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Arrays for screen error indicators
     D WZ0             S              1    DIM(79) CTDATA PERRCD(79)
     D WEI             S              1    DIM(79)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
     D Scrn            S              1A
     D Previous        S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D WTDTP           S              2A
     D WWCLTY          S              2A
     D SWRTN           S              7A
     D WCUST           S              6A
     D CSW210          S              1A                                                      CSW210
      *
      ** Function keys activated
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
     D PINKN           S              1A
     D PINKS           S              1A
     D PINKT           S              1A
     D PEINKE          S              1A
     D PEINKL          S              1A
      *
      ** Constants
     D BJMRDT          S              7A
     D CSE028          S              1A
     D CSE029          S              1A
     D PWHEN           S              1A
      *
      ** Trades Extended Settlement Screen Detail
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(S:2)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)
      *
      ** OK Flags for Extension Screen
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** Security Customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Main processing
      *
     C                   EXSR      SRMainP
      *
      ** Return
      *
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainP - Main processing                                    *
      *                                                               *
      *****************************************************************
     C     SRMainP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     SEETES        WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx
     C                   Z-ADD     10            Ex
 
     C                   DOU       Cx > 79
 
     C                   IF        WEI(Cx) = 'N' OR WEI(Cx) = 'W'
     C                   EVAL      *IN(Ex) = *ON
     C                   ENDIF
 
     C                   EVAL      Cx = Cx + 1
     C                   EVAL      Ex = Ex + 1
     C                   ENDDO
      *
      ** Set up Screen Navigations
      *
     C                   EVAL      Scrn = '1'
     C                   EVAL      Previous = '0'
 
     C                   DOU       (*INKC = *ON) OR
     C                             (*INKE = *ON) OR
     C                             (*INKL = *ON) OR
     C                             (*INKN = *ON)
 
     C                   SELECT
      *
      ** Set up for Display of Screen 1
      *
     C                   WHEN      Scrn = '1'
 
     C                   IF        *INKL = *ON
     C                   IF        Previous = '0'
     C                   LEAVE
     C                   ELSE
     C                   EVAL      Scrn = '2'
     C                   EVAL      Previous = '1'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN85 = *ON
     C                   EVAL      Scrn = '2'
     C                   EVAL      Previous = '1'
     C                   ENDIF
 
     C
      *
      ** Set up for Display of Screen 2
      *
     C                   WHEN      Scrn = '2'
 
     C                   IF        *INKL = *ON
     C                   IF        Previous = '1'
     C                   EVAL      Scrn = '1'
     C                   EVAL      Previous = '2'
     C                   ELSE
     C                   IF        CSE028 = 'Y'
     C                   EVAL      Scrn = '3'
     C                   EVAL      Previous = '2'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (*IN84 = *ON) and
     C                             (CSE028 = 'Y')
     C                   EVAL      Scrn = '3'
     C                   EVAL      Previous = '2'
     C                   ENDIF
 
     C                   IF        *IN86 = *ON
     C                   EVAL      Scrn = '1'
     C                   EVAL      Previous = '2'
     C                   ENDIF
 
     C
      *
      ** Set up for Display of Screen 3
      *
     C                   WHEN      Scrn = '3'
 
     C                   IF        *INKL = *ON
     C                   EVAL      Scrn = '2'
     C                   EVAL      Previous = '3'
     C                   ENDIF
 
     C                   IF        *IN88 = *ON
     C                   EVAL      Scrn = '2'
     C                   EVAL      Previous = '3'
     C                   ENDIF
 
     C                   ENDSL
      *
      ** Write Message subfile, details and footer screens.
      *
     C                   WRITE     SETSESDSC0
 
     C                   SELECT
     C                   WHEN      Scrn = '1'
     C                   WRITE     SETSESDSF0
      *
      ** If not Write Only, Read screen details
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SETSESDSF0                             01
     C                   ENDIF
      *
      ** Enter Key is pressed, exit from program to do validation
      *
     C
     C                   IF        (*INKC <> *ON) and (*INKE <> *ON) and
     C                             (*INKN <> *ON) and (*IN85 <> *ON) and
     C                             (*IN87 <> *ON)
     C                   LEAVE
     C                   ENDIF
 
     C                   WHEN      Scrn = '2'
     C                   WRITE     SETSESDSF1
      *
      ** If not Write Only, Read screen details
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SETSESDSF1                             01
     C                   ENDIF
      *
      ** Enter Key is pressed, exit from program to do validation
      *
     C
     C                   IF        (*INKC <> *ON) and (*INKE <> *ON) and
     C                             (*INKN <> *ON) and (*IN84 <> *ON) and
     C                             (*IN86 <> *ON)
     C                   LEAVE
     C                   ENDIF
 
     C                   WHEN      Scrn = '3'
     C                   WRITE     SETSESDSF2
      *
      ** If not Write Only, Read screen details
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SETSESDSF2                             01
     C                   ENDIF
      *
      ** Enter Key is pressed, exit from program to do validation
      *
     C
     C                   IF        (*INKC <> *ON) and (*INKE <> *ON) and
     C                             (*INKN <> *ON) and (*IN88 <> *ON)
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WZ0           *IN(10)
      *
      ** Set return keys.
      *
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKE = *INKE
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKN = *INKN
     C                   EVAL      PINKS = *INKS
     C                   EVAL      PINKT = *INKT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Security API Trades Extended Settlements screen details from incoming
      ** transaction - format definition file
     C                   PARM                    NwSE1ScnFmt
      *
      ** Security API Trades Extended Settlements retrieved from file
      ** - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KL = Command key 12 = Cancel
     C                   PARM                    PEINKE
     C                   PARM                    PEINKL
      *
      ** Security API Trades Extended Settlements Error Indicator File
     C                   PARM                    SEETES
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM                    WriteOnly
      *
      ** Data for MT5xxs
     C                   PARM                    PDATA
      *
      ** Extra Parameter for TRADSDX2
     C                   PARM                    PWHEN
     C                   PARM                    WWCLTY
     C                   PARM                    WTDTP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** MT5xx SSI Enhancements
     C                   PARM                    CSE028
      *
      ** ISO15022 Message Generation
     C                   PARM                    CSE029
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KE = Command key 05 = Refresh
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKL
     C                   PARM                    PINKN
     C                   PARM                    PINKS
     C                   PARM                    PINKT
 
     C                   MOVE      PSRPN         SSRPN
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           SPGMQ
      *
      ** Set user and job details
      *
     C                   EVAL      SUSER = PsUser
     C                   EVAL      SWSID = PsJobName
     C                   EVAL      SRUNA = BJMRDT
      *
      ** Set up non-input capable screen fields from parm received.
      *
     C                   MOVE      PACTN         SACTN
     C                   MOVE      PTDRF         STDRF
     C                   MOVE      PBLKR         SBLKR
     C                   MOVE      PSESN         SSESN
      *
      ** Check to see if switchable feature CSW098 is on or if date is
      ** greater than 16 October 1998.
      *
     C                   CALL      'SWIFT98'                            09
     C                   PARM                    SWRTN
 
     C                   IF        *IN09 = *ON
     C                   EVAL      DBKey = 'SWIFT98'
     C                   EVAL      DBFile = 'ERR CALL'
     C                   Z-ADD     2             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        SWRTN = 'CSW098 '
     C                   EVAL      *IN09 = *ON
     C                   ELSE
     C                   EVAL      *IN09 = *OFF
     C                   ENDIF
      *
      ** Set up screen title for destination depot
      *
     C     PWHEN         IFNE      *BLANKS
     C     PDELF         IFNE      PDELT
     C                   MOVE      PTCNR         WCUST
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCUST
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
 
     C     PWHEN         IFEQ      'A'
     C     PTDTP         IFEQ      'TP'
     C                   EVAL      *IN04 = *ON
     C                   ELSE
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
     C                   ELSE
     C     PTDTP         IFEQ      'TP'
     C                   EVAL      *IN03 = *ON
     C                   ELSE
     C                   EVAL      *IN04 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Non-display A/c for payment & Safe-keeping a/c if destination
      ** Euroclear or Cedel
      *
     C     WWCLTY        IFEQ      '14'
     C                   EVAL      *IN05 = *ON
     C                   ELSE
      *
      ** Non-display Clearing Correspondent if Destination is neither
      ** Cedel nor Euroclear
      *
     C                   EVAL      *IN06 = *ON
     C                   ENDIF
      *
      ** Non-display either Receiver or Deliverer of Securities depending
      ** on the type
      *
     C     WTDTP         IFEQ      'TP'
     C                   EVAL      *IN08 = *ON
     C                   ELSE
     C                   EVAL      *IN07 = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** Display narrative for Receiver's Custodian and Safe A/C
      *
     C     *IN08         IFEQ      *OFF
     C     CSE029        ANDEQ     'Y'
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
      *
      ** Display narrative for Deliverer's Custodian and Safe A/C
      *
     C     *IN07         IFEQ      *OFF
     C     CSE029        ANDEQ     'Y'
     C                   EVAL      *IN89 = *ON
     C                   ENDIF
      *
      ** Enable display of counterparty safekeeping a/c if
      ** CSE028 is on and ISO15022 is on.
      *
     C     CSE028        IFEQ      'Y'
     C     PSNEW         ANDEQ     'Y'
     C     PGMES         ANDEQ     'Y'
     C                   EVAL      *IN88 = *ON
     C                   ELSE
     C                   EVAL      *IN88 = *OFF
     C                   ENDIF
 
     C     CSE028        IFEQ      'Y'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
      *
      ** Set up protect Indicator for Enquiry
      *
     C     PACTN         IFEQ      'E'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      ** If ISO15022 is equal to 'Y', enable Rollup Key
      *
     C     CSE028        IFEQ      'Y'
     C     PSNEW         IFEQ      'Y'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
      ** greater than  or equal to 20 November 2010.                                          CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM                    SWRTN                                        CSW210
      *                                                                                       CSW210
     C                   IF        SWRTN = 'CSW2010'                                          CSW210
     C                   EVAL      *IN30 = *ON                                                CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      *IN30 = *OFF                                               CSW210
     C                   ENDIF                                                                CSW210
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
**  WZ0
000000000000000000000000000000000000000000000000000000000000000000000
