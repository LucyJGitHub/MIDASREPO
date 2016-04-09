     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Get no of days in year for int calc meth')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1011 - Determine number of days in a year for default      *
      *           interest calculation method.                        *
      *                                                               *
      *  Function:  This module determines the effective number of    *
      *             days in a year, given an interest calculation     *
      *             method.                                           *
      *             It is a converted version of the subroutine       *
      *             MM1011, which was hard coded in MM0026 and MM0027 *
      *             (at least).                                       *
      *                                                               *
      *  Component of:                                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22910           Date 13Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22910 - Serious Midas error has occurred during insert    *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Number of days in year for calculation method (3,0P, returned
      ** to caller)
     D @@DAYO          S              3P 0
 
      ** Default interest calculation method (1A, from caller)
     D ZZCALC          S              1A
 
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
 
     C*****************************************************************
     C*   MM1011 - DETERMINE NUMBER OF DAYS IN A YEAR FOR DEFAULT     *
     C*            INTEREST CALCULATION METHOD                        *
     C*                                                               *
     C*  CALLED BY    -                                               *
     C*                                                               *
     C*  CALLS        -                                               *
     C*                                                               *
     C*  FIELDS INPUT ZZCALC  - DEFAULT INPUT CALCULATION METHOD      *   056095
     C*                                                               *
     C*  FIELDS OUTPUT @@DAYO - DAYS IN YR FOR DFLT INTEREST CALC METH*
     C*                                                               *
     C*  WORKFIELDS           - NONE                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C** IF DFLT INTEREST CALCULATION METHOD '1' OR '4' SET DAYS IN
     C** TO '365'
     C     ZZCALC        IFEQ      '1'                                          B1             05609
     C     ZZCALC        OREQ      '4'                                          *1             05609
     C                   MOVE      365           @@DAYO                         *1
     C                   END                                                    E1
     C*
     C** IF DFLT INTEREST CALCULATION METHOD '2' '3' OR '5' SET DAYS IN
     C** TO '360'
     C     ZZCALC        IFEQ      '2'                                          B1             05609
     C     ZZCALC        OREQ      '3'                                          *1             05609
     C     ZZCALC        OREQ      '5'                                          *1             05609
     C     ZZCALC        OREQ      '0'                                                      BUG22910
     C                   MOVE      360           @@DAYO                         *1
     C                   END                                                    E1
     C*
     C** IF DFLT INTEREST CALCULATION METHOD '6' SET DAYS IN YEAR '360'
     C     ZZCALC        IFEQ      '6'                                          B1             05609
     C                   MOVE      366           @@DAYO                         *1
     C                   END                                                    E1
     C*
     C**  SET ATTRIBUTES OF DEFAULT INTEREST CALCULATION METHOD
     C                   MOVEL     ZZCALC        ZZCALC            1                           05609
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
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
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Number of days in year for calculation method (3,0P, returned
      ** to caller)
     C                   PARM                    @@DAYO
      ** Default interest calculation method (1A, from caller)
     C                   PARM                    ZZCALC
 
 
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
(c) Misys International Banking Systems Ltd. 2001
