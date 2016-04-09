     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC PB Fields display')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCO2DP - Futures and Options non-currency OTCs display    *
      *                                                               *
      *  Function:  This module displays the secound details screen   *
      *             of the over-the-counter non-currency options      *
      *             display function.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFOTCO2DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      *       83  Security module not installed                       *
      *       84  Condition screen according to action code           *
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
 
     D FFEOTCO       E DS                  EXTNAME(FFEOTCOPD)
     D  FFEOTCPB              44     52
      ** External Data strucutre for currency option OK Flags
 
     D FFOTCO        E DS                  EXTNAME(FFOTCOPD)
     D                                     PREFIX(#1:1)
 
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
 
      ** Main processing
 
     C                   EXSR      SRMain
 
      ** Return
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = True
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
 
     C     C             DO        9
     C                   IF        @EI(C) = 'N' or @EI(C) = 'W'
     C                   EVAL      *IN(E) = '1'
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   EVAL      E = E + 1
     C                   ENDDO
 
      ** Set up the transaction reference and action code to be used
      ** by the message handler.
 
     C                   EVAL      TranRef = #1TNBR
     C                   EVAL      ActionCode = #1ACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      **--------------------------------------------------------------------------------------------
 
      ** Protect screen fields when not insert or amend
 
     C                   EVAL      *IN79 = False
     C                   EVAL      *IN84 = True
 
     C                   IF        #1ACTN <> 'I' and #1ACTN <> 'A' or
     C                             PRActn = 'N'
     C                   EVAL      *IN79 = True
     C                   ENDIF
 
     C                   IF        #1ACTN = 'I' and NewInst = 'Y'
     C                   EVAL      *IN84 = False
     C                   ENDIF
 
      ** Write message subfile, details and footer screen
 
     C                   TIME                    #1TIME
     C                   WRITE     FFOTCO2DF2
     C                   WRITE     FFOTCO2DC1
     C                   WRITE     FFOTCO2DF1
     C                   READ      FFOTCO2DF1                             70
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   Z-ADD     10            E
     C                   Z-ADD     1             C
     C     C             DO        9
     C                   EVAL      *IN(E) = '0'
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKL = *INKL
 
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
 
     C                   PARM                    FFOTCO
 
      ** Premium
 
     C                   PARM                    #1PREM
     C                   PARM                    NewInst
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Fields in error
 
     C                   PARM                    FFEOTCO
 
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
 
     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WSID = PsJobName
 
      ** Message subfile control
 
     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #1PGMQ = '*'
 
      ** Set screen protect/non-display indicators
 
      ** Single-branching (hide booking branch)
 
     C                   IF        BJSBRC <> *BLANK
     C                   EVAL      *IN80 = True
     C                   ENDIF
 
      ** Originating Branches not used
 
     C                   IF        BKOBRU <> 'Y' or BJSBRC <> *BLANK
     C                   EVAL      *IN81 = True
     C                   ENDIF
 
      ** Portfolio Management not installed (hide portfolio)
 
     C                   IF        BGPFMG <> 'Y'
     C                   EVAL      *IN82 = True
     C                   ENDIF
 
      ** Security Module not installed (protect SE fields)
 
     C                   IF        BGSECS <> 'Y'
     C                   EVAL      *IN83 = True
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
