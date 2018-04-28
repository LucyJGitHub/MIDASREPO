     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Obtain x-ccy exchg rate & mlt/div')
      *****************************************************************
      *                                                               *
      *    Midas - Copy Source converted into ILE procedures          *
      *                                                               *
      *   ZXRATE - MODULE TO OBTAIN A CROSS-EXCHANGE RATE AND         *
      *            MULTIPLY/DIVIDE INDICATOR BETWEEN TWO CURRENCIES   *
      *                                                               *
      *    INPUT - ZRATE1 (13,8) BASE CURRENCY EXCHANGE RATE 1        *
      *            ZMDI1  (1)    ZRATE1 MULTIPLY/DIVIDE INDICATOR     *
      *            ZRATE2 (13,8) BASE CURRENCY EXCHANGE RATE 2        *
      *            ZMDI2  (1)    ZRATE2 MULTIPLY/DIVIDE INDICATOR     *
      *                                                               *
      *   OUTPUT - ZRATEX (13,8) CROSS EXCHANGE RATE                  *
      *            ZMDIX  (1)    CROSS MULTIPLY/DIVIDE INDICATOR      *
      *                                                               *
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
      *  Last Amend No. CAP074             Date 10Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 26Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP002 - Conversion of SE inputs into modular structure to   *
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
      ****INPUT****
      * BASE CURRENCY EXCHANGE RATE 1
     D  ZRATE1         S             13P 8
      * ZRATE1 MULTIPLY/DIVIDE INDICATOR
     D  ZMDI1          S              1A
      * BASE CURRENCY EXCHANGE RATE 2
     D  ZRATE2         S             13P 8
      * ZRATE2 MULTIPLY/DIVIDE INDICATOR
     D  ZMDI2          S              1A
      *
      ****OUTPUT****
      * CROSS EXCHANGE RATE
     D  ZRATEX         S             13P 8
      * CROSS MULTIPLY/DIVIDE INDICATOR
     D  ZMDIX          S              1A
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
      *
      ** +----- The converted ZXRATEZ1 starts here -----------------------+
     C*
     C* CALCULATE CROSS RATE
     C*
     C*    ..  IF M/D INDICATOR 1 = M/D INDICATOR 2
     C*
     C     ZMDI1         IFEQ      ZMDI2
     C     ZRATE2        IFNE      *ZEROS
     C*****ZRATE1********DIV       ZRATE2        ZRATEX                                       CAP074
     C     ZRATE1        DIV(H)    ZRATE2        ZRATEX                                       CAP074
     C                   END
     C*
     C                   ELSE
     C*    ..  ELSE
     C*
     C*****ZRATE1********MULT      ZRATE2        ZRATEX                                       CAP074
     C     ZRATE1        MULT(H)   ZRATE2        ZRATEX                                       CAP074
     C                   END
     C*
     C* SET CROSS M/D INDICATOR
     C*
     C                   MOVE      ZMDI1         ZMDIX
     C*
     C                   RETURN
      *
      ** +----- The converted ZXRATEZ1 ends here -------------------------+
      *
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
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
 
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
