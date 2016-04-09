     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Currency Code')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVCURCODE - Validate Currency                                  *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             currency field and confirms if                    *
      *             valid. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: ZA_ALL - ALL ZA Service Program                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG4406            Date 01Oct04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG4406- Check revaluation for Treasury Management only.     *
      *  CSD006 - Use correct parameters for ZAVCURCODE               *
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
     FFDINTRLL  IF   E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency Details file
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Msgid1          S                   LIKE(#Msgid)
      ** Error message code 1 received as a parameter
 
      ** Currency Code is Mandatory and received as paramater
     D DDCCY           S              3A
 
      ** FRA/IRS Indicator received as a parameter
     D BGFIIN          S              1A
 
      ** Treasury Management Indicator received as a parameter
     D BGTRMG          S              1A
 
      **
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
     C                   CALLB     'ZAVCURCODE'
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDCCY
     C*******************PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSD006
 
     C                   IF        RetCodeIn  = 'Error'
     C                   EVAL      ErrorFound= 'Y'
     C                   ENDIF
 
     C     RetCodeIn     IFNE      'Error'
 
      ** Check revaluation has been run (1st ccy)
      * (only if FRA/IRS or Treasury Management in system)
     C*****BGFIIN        IFEQ      'Y'                                                       BUG4406
     C*****BGTRMG        OREQ      'Y'                                                       BUG4406
     C     BGTRMG        IFEQ      'Y'                                                       BUG4406
     C     @TEST1        KLIST
     C                   KFLD                    DDCCY
     C                   KFLD                    @TPRD1
     C                   KFLD                    @PRD1
      *
     C                   MOVE      *LOVAL        @TPRD1            1
     C                   Z-ADD     *LOVAL        @PRD1             2 0
      ** CHAIN TO FILE FDINTRLL
     C     @TEST1        SETLL     FDINTRLL
     C     DDCCY         READE     FDINTRLL                               65
     C     *IN65         IFEQ      '1'
     C     HWDLTF        OREQ      '*'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0316'     Msgid1
     C                   END
     C                   END
     C                   END
 
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C*
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDCCY
     C                   PARM                    BGFIIN
     C                   PARM                    BGTRMG
     C*******************PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSD006
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
