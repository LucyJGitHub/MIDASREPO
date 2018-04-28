     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC PB Fields display')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCC2DP - Futures and Options currency OTCs display        *
      *                                                               *
      *  Function:  This module displays the secound details screen   *
      *             of the over-the-counter currency options display  *
      *             function.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFOTCC2DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-18 Field Error - highlight screen fields               *
      *                                                               *
      *       79  Protect transaction detail fields                   *
      *       80  Single branching                                    *
      *       81  Originating branches not used                       *
      *       82  Portfolio management not installed                  *
      *       83  Midas-Plato interface not installed                 *
      *       84  Security module not installed                       *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(9)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D FFEOTCC       E DS                  EXTNAME(FFEOTCCPD)
     D  FFEOTCPB              37     45
      ** External Data strucutre for currency option OK Flags
 
     D FFOTCC        E DS                  EXTNAME(FFOTCCPD)
     D                                     PREFIX(#0:1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PINKC           S              1
     D PINKL           S              1
     D NewInst         S              1
     D PRActn          S              1
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      SRMAIN
 
      ** Return
 
     C     PINKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMAIN - Main Processing
      *****************************************************************
     C     SRMAIN        BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     FFEOTCPB      @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DO        9
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      ** Set up the transaction reference and action code to be used
      ** by the message handler.
     C                   EVAL      TranRef = #0TNBR
     C                   EVAL      ActionCode = #0ACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      **--------------------------------------------------------------------------------------------
 
      ** Protect screen fields when not insert or amend
 
     C                   MOVE      '0'           *IN79
     C                   MOVE      '1'           *IN85
 
     C     #0ACTN        IFNE      'I'
     C     #0ACTN        ANDNE     'A'
     C     PRActn        OREQ      'N'
     C                   MOVE      '1'           *IN79
     C                   ENDIF
 
     C     #0ACTN        IFEQ      'I'
     C     NewInst       ANDEQ     'Y'
     C                   MOVE      '0'           *IN85
     C                   ENDIF
      ** Write message subfile, details and footer screen
 
     C                   TIME                    #0TIME
     C                   WRITE     FFOTCC2DC0
     C                   WRITE     FFOTCC2DF0
     C                   WRITE     FFOTCC2DF1
     C                   READ      FFOTCC2DF0                             70
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   Z-ADD     10            E
     C                   Z-ADD     1             C
     C     C             DO        9
     C                   MOVE      '0'           *IN(E)
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
 
      * SET RETURN KEYS
 
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKL         PINKL
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
     C     *ENTRY        PLIST
 
      ** Input
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Transaction (in screen format)
     C                   PARM                    FFOTCC
 
      ** Premium
     C                   PARM                    #0PREM
     C                   PARM                    NewInst
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Fields in error
     C                   PARM                    FFEOTCC
 
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PRActn
 
      ** Output
 
      ** Function keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     #0WSID
     C                   MOVEL     PsUser        #0USER
 
      ** Message subfile control
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           #0PGMQ
 
      ** Set screen protect/non-display indicators
 
      ** Single-branching (protect booking branch)
 
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   ENDIF
 
      ** Originating Branches not used
 
     C     BKOBRU        IFNE      'Y'
     C     BJSBRC        ORNE      *BLANK
     C                   MOVE      '1'           *IN81
     C                   ENDIF
 
      ** Portfolio Management not installed (protect portfolio)
 
     C     BGPFMG        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   ENDIF
 
      ** CPL002 not installed (protect Spot Price)
 
     C     BGN2ST        IFNE      'Y'
     C                   MOVE      '1'           *IN83
     C                   ENDIF
 
      ** Security Module not installed (protect SE fields)
 
     C     BGSECS        IFNE      'Y'
     C                   MOVE      '1'           *IN84
     C                   ENDIF
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for FF *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY FFCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
