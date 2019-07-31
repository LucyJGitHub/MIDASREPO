     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-traded display')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRDSP - Futures and Options, exchange-traded display     *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the exchange traded screen input function.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG9185             Date 08Nov05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 06Sep99               *
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 26Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Recompiled over the changes to /COPY   *
      *           MSGHNDDCL.                                          *
      *  CPL002 - Midas-Plato Interface.                              *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of FF inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFEXTRDDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect transaction key fields                      *
      *           (action code, market & transaction number)          *
      *       70  Protect transaction detail fields                   *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       79  Highlight transaction status                        *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
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
 
      ** Include the FF standard declares
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for FF-specific
      ** variables.
     D/COPY FFCPYSRC,DECLAREVAR
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
 
     D*@EI******       S              1    DIM(53)                                            CFF007
     D @EI             S              1    DIM(57)                                            CFF007
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D FFBSET        E DS                  EXTNAME(FFBSETPD)
      ** EXTERNAL DATA STRUCTURE FOR BROKER SETTLEMENTS FORMAT DEFINITION
 
     D FFEBSET       E DS                  EXTNAME(FFEBSETPD)
      ** EXTERNAL DATA STRUCTURE FOR BROKER SETTLEMENTS OK FLAGS
 
     D FFCSET        E DS                  EXTNAME(FFCSETPD)
      ** EXTERNAL DATA STRUCTURE FOR CUSTOMER SETTLEMENTS FORMAT DEFINITION
 
     D FFECSET       E DS                  EXTNAME(FFECSETPD)
      ** EXTERNAL DATA STRUCTURE FOR CUSTOMER SETTLEMENTS OK FLAGS
 
     D FFEXTR        E DS                  EXTNAME(FFEXTRPD)
      ** EXTERNAL DATA STRUCTURE FOR EXCHANGE-TRADED FORMAT DEFINITION
 
     D FFEEXTR       E DS                  EXTNAME(FFEEXTRPD)
      ** EXTERNAL DATA STRUCTURE FOR EXCHANGE-TRADED OK FLAGS
 
 
     D                 DS
     D  FFFOTX                 1     40
     D  FFSIDN                10     15
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
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
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     FFEEXTR       @EI
     C**********         MOVEA     FFEBSET       @EI(25)                        CPL002
     C**********         MOVEA     FFECSET       @EI(36)                        CPL002
     C**********         MOVEA     FFEBSET       @EI(28)                               CPL002 CFF007
     C**********         MOVEA     FFECSET       @EI(41)                               CPL002 CFF007
     C                   MOVEA     FFEBSET       @EI(32)                                      CFF007
     C                   MOVEA     FFECSET       @EI(45)                                      CFF007
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C*****C****         DO        53                                                         CFF007
     C     C             DO        57                                                         CFF007
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      ** Set up the transaction reference and action code to be used
      ** by the message handler.
     C                   EVAL      TranRef = STNBR
     C                   EVAL      ActionCode = SACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      *
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C     SACTN         COMP      *BLANK                                 68
      *
      * ENABLE KEY FIELDS (ACTION CODE & TRANSACTION NUMBER)
     C     @EKYFD        COMP      'Y'                                6969
 
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE,
      * MARKET AND TRANSACTION NUMBER)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKP        COMP      'Y'                                    75
      *
      * TRANSACTION STATUS
      *
     C     FFSTS         COMP      *BLANK                             7979
      *
      * TEXT = SUCCESSFUL INSERT
      *
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     @NAR(1)       FFFOTX
     C/COPY WNCPYSRC,FFEXTRXC01
     C                   MOVEL     @SIDN         FFSIDN
     C                   MOVEL     *BLANK        @SIDN
     C                   ELSE
      *
      * TEXT = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       FFFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        FFFOTX
     C                   END
     C                   END
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    FFTIME
     C                   WRITE     FFEXTRS0
     C                   WRITE     FFEXTRD1
     C                   WRITE     FFEXTRF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      FFEXTRD1                               99    *
     C                   ENDIF
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    ReturnCode
      *
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    FFBSET
     C                   PARM                    FFCSET
     C                   PARM                    FFEXTR
      *
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      *
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      *
      * FIELDS IN ERROR
     C                   PARM                    FFEBSET
     C                   PARM                    FFECSET
     C                   PARM                    FFEEXTR
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     FFWSID
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           FFPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLAY INDICATORS
      *
      *
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Originating Branches not used
      *
     C     BKOBRU        IFNE      'Y'
     C     BJSBRC        ORNE      *BLANK
     C                   MOVE      '1'           *IN81
     C                   END
      *
      ** Portfolio Management not installed (protect portfolio/PM ins.type)
      *
     C     BGPFMG        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
 
      ** CFF007 is not installed                                                              CFF007
                                                                                              CFF007
     C     CFF007        IFNE      'Y'                                                        CFF007
     C                   MOVE      '1'           *IN87                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      **--------------------------------------------------------------------------------------------
      ** The following /COPY determines whether the Profit-Centre Accounting
      ** feature is on.  CAC003 is set to 'Y' if CAC003 is on and the
      ** Analytical Accounting module is on (BGN0ST = 'Y').
     C/COPY FFCPYSRC,CAC003CHEK
      **--------------------------------------------------------------------------------------------
 
      *
      * Profit Centres not used or CAC003 installed (protect profit centre)
      *
     C     BKPRCU        IFNE      'Y'
     C     CAC003        OREQ      'Y'
     C                   MOVE      '1'           *IN83
     C                   END
 
      *
      * CAC003 not installed (protect book/transaction profit centres)
      *
     C     CAC003        IFNE      'Y'
     C                   MOVE      '1'           *IN84
     C                   END
 
      *                                                                         CPL002
      * CPL002 not installed (protect Spot Price)                               CPL002
      *                                                                         CPL002
     C     BGN2ST        IFNE      'Y'                                          CPL002
     C                   MOVE      '1'           *IN85                          CPL002
     C                   END                                                    CPL002
      *                                                                         CPB001
      ** Private Banking Module ot installed (protect portfolio/PM ins.type)    CPB001
      *                                                                         CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      '1'           *IN86                          CPB001
     C                   END                                                    CPB001
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
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Tran No. 999999 successfully inserted.
F10=CONFIRM DELETE
