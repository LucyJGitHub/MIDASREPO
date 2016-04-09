     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Calc int between two day numbers')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subroutines                                 *
      *                                                               *
      *  GLINTC - Calc int between two day numbers                    *
      *                                                               *
      *  Function:   This module calculates the interest between      *
      *              2 day numbers.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 BUG9005            Date 29Nov05               *
      *                 CAP076   *CREATE   Date 10May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *           to Midas Plus                                       *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  BUG9005- ZINTDY expects to be ZZCALC to be a character       *
      *           field not numeric.                                  *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Conversion of SR/GLINTC                             *
      *                                                               *
      *****************************************************************
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
 
      **
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
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details
      *
      ********************************************************************
      *
      *    GLINTC SR. TO CALCULATE INTEREST BETWEEN ANY TWO DAY NUMBERS.
      *
      *    CALCULATION METHODS ARE -
      *    1  ACTUAL/365
      *    2  ACTUAL/360
      *    3  360/360 (SOMETIMES CALLED 30/360)
      *    4  365/365 (EXCLUDING 29/02)
      *    5  365/360 (EXCLUDING 29/02)
      *    6  ACTUAL/366
      *    0  ACR/366                                                                        CER016A
      *
      *    CALL MODULE - ZINTDY
      *
      *****************************************************************
      *
      **  CALCULATE NUMBER OF DAYS OF THE CALCULATION METHOD USED
      *
     C                   MOVE      ZICALC        ZICALCA           1                         BUG9005
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeIn                      O: Return code
     C                   PARM                    ZZINDY            5 0          O: No interest days
     C                   PARM                    ZIBEG                          I: Starting date
     C                   PARM                    ZIEND                          I: Finishing date
     C**********         PARM                    ZICALC                       I: Calc. basis BUG9005
     C                   PARM                    ZICALCA                      I: Calc. basis BUG9005
     C**********         PARM                    INT6DY           15 7          O: Total days 242286
     C                   PARM                    INT6DY           15 9                        242286
      *
      *
      ** Multiply Rate & Day No. first
      *
     C     ZIAMT         MULT      ZIRATE        ZIWRK1           30 9
     C     ZICALC        IFEQ      6
     C     ZIWRK1        MULT      INT6DY        ZIWRK2
     C                   ELSE
     C     ZIWRK1        MULT      ZZINDY        ZIWRK2           30 9
     C                   END
      *
     C     ZICALC        IFEQ      2
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      5
     C     ZICALC        OREQ      7
     C     CIR004        ANDEQ     'Y'
     C     ZICALC        OREQ      0                                                         CER016A
     C     ZIWRK2        DIV(H)    36000         ZINTR            30 9
     C                   END
     C     ZICALC        IFEQ      1
     C     ZICALC        OREQ      4
     C     ZIWRK2        DIV(H)    36500         ZINTR
     C                   END
     C     ZICALC        IFEQ      6
     C     ZIWRK2        DIV(H)    36600         ZINTR
     C                   END
     C*
     C                   RETURN
     C*
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
 
     C     *ENTRY        PLIST                                                  Entry parameter
      *
      * INPUTS
      *
     C                   PARM                    ZIBEG             5 0          I: Starting Date
     C                   PARM                    ZIEND             5 0          I: Finishing Date
     C                   PARM                    ZICALC            1 0          I: Calc. basis
     C                   PARM                    ZIAMT            15 0          I: Principal
     C                   PARM                    ZIRATE           11 7          I: Rate of interest
      *
      * OUTPUTS
      *
     C                   PARM                    ZINTR            30 9          O: Interest amount
      *
      ** Check if Dealing Calculation Method is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CIR004'      @SARD             6
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR004            1
     C                   ELSE
     C                   MOVE      'N'           CIR004
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
