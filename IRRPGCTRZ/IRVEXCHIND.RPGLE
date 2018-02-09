     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Exchange Indicators')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Validation Module                            *
      *                                                               *
      *  IRVEXCHIND - Validate Exchange Indicators                    *
      *                                                               *
      *  Function:  This module accepts the value date and maturity   *
      *             date exchange indicators and confirms whether     *
      *             they are valid. If they are the 10A return code   *
      *             will contain blanks. If they are not the return   *
      *             code will contain 'Error'                         *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CIR003             Date 12Sep00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** FRA/IRS message generator indicator passed as a parameter from calling program.
     D  CSW005         S              1A
 
      ** Value date exchange indicator passed as a parameter from calling program
     D  SVDEI          S              1A
 
      ** Maturiry date exchange indicator passed as a parameter from calling program
     D  SMDEI          S              1A
 
      ** Principal change date indicator passed as a parameter from calling program
     D  SPDEI          S              1A
 
      ** IRC availability indicator passed as a parameter from calling program
     D   CIR001        S              1A
 
      ** Principal Exchange on Ccy-IRS feature passed as a parm from pgm        CIR003
     D   CIR003        S              1A                                        CIR003
                                                                                CIR003
      ** Value date exchange indicator passed as a parameter from calling pgm   CIR003
     D  PVDEI          S              1A                                        CIR003
                                                                                CIR003
      ** Maturiry date exchange ind. passed as a parameter from calling pgm     CIR003
     D  PMDEI          S              1A                                        CIR003
                                                                                CIR003
      ** Principal change date indicator passed as a parameter from calling pgm CIR003
     D  PPDEI          S              1A                                        CIR003
                                                                                CIR003
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message passed back to calling program as a parameter
     DMsgid1           S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program as a parameter
     DMsgid2           S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program as a parameter
     DMsgid3           S                   LIKE(#Msgid)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Validate Exchange indicators if FRA/IRS Msg Gen is *ON
      **  and also Principal change date exchange indicator if
      **  IRC is *ON.
     C     CSW005        IFEQ      'Y'
     C     CIR003        OREQ      'Y'                                          CIR003
      *
      ** Default indicators to 'Y' if not entered
     C     SVDEI         IFEQ      *BLANK
     C                   EVAL      SVDEI = 'Y'
     C                   ENDIF
     C     SMDEI         IFEQ      *BLANK
     C                   EVAL      SMDEI = 'Y'
     C                   ENDIF
      *
     C     SVDEI         IFNE      'Y'
     C     SVDEI         ANDNE     'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0049'     Msgid1
     C                   ENDIF
      *
     C     SMDEI         IFNE      'Y'
     C     SMDEI         ANDNE     'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0049'     Msgid2
     C                   ENDIF
      *
     C     CIR001        IFEQ      'Y'
      *
      ** Default indicator to 'Y' if not entered
     C     SPDEI         IFEQ      *BLANK
     C                   EVAL      SPDEI = 'Y'
     C                   ENDIF
     C     SPDEI         IFNE      'Y'
     C     SPDEI         ANDNE     'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0050'     Msgid3
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *                                                                         CIR003
     C     CIR003        IFEQ      'Y'                                          CIR003
     C     ErrorFound    ANDNE     'Y'                                          CIR003
      *                                                                         CIR003
     C     PVDEI         IFEQ      'Y'                                          CIR003
     C     SVDEI         ANDEQ     'N'                                          CIR003
     C     PMDEI         OREQ      'Y'                                          CIR003
     C     SMDEI         ANDEQ     'N'                                          CIR003
     C     PPDEI         OREQ      'Y'                                          CIR003
     C     SPDEI         ANDEQ     'N'                                          CIR003
     C                   EVAL      RetCodeIn = 'Warning'                        CIR003
     C                   MOVEL     'MMM0025'     Msgid1                         CIR003
     C                   ENDIF                                                  CIR003
      *                                                                         CIR003
     C                   ENDIF                                                  CIR003
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    Msgid3
     C                   PARM                    CSW005
     C                   PARM                    SVDEI
     C                   PARM                    SMDEI
     C                   PARM                    CIR001
     C                   PARM                    SPDEI
     C                   PARM                    CIR003                         CIR003
     C                   PARM                    PVDEI                          CIR003
     C                   PARM                    PMDEI                          CIR003
     C                   PARM                    PPDEI                          CIR003
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
