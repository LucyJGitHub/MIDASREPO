     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Convert Scaled rate to rate')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA1160 - Convert Scaled rate into rate                       *
      *                                                               *
      *  Function:  This module accepts a currency scaling exponent,  *
      *             a rate to be UNscaled and returns an UNscaled     *
      *             rate.                                             *
      *                                                               *
      *             This was originally a subroutine which was        *
      *             repeated in each of the MM deals input programs   *
      *             (and possibly elsewhere).  The section which was  *
      *             copied from MM0089 is clearly marked, and has not *
      *             been modified; code has been added around it      *
      *             to turn this into a compilable module.            *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. 154453             Date 04NOV98               *
      * Midas 10.6 (DBA 1.0) -------- PTF19 --------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 01AUG97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  154453 - Apply fix 129183                                    *
      *         - Exchange rate with 5 digits not accepted            *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters received:
      **   First scaling exponent
     D     @@SXP1      S              1S 0
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Start of D-specs converted from MM0089 ---------------------+
 
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
      **  Array of scaling factors.
 
      ** +--- End of D-specs converted from MM0089 -----------------------+
 
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
 
     C                   EXSR      ZA1160
 
     C                   RETURN
 
      ** +--- Start of subroutine converted from MM0089 ------------------+
      ****************************************************************
      *     ZA1160 -  Convert scaled rate to unscaled rate.          *
      *                                                              *
      *     CALLS:                                                   *
      *                                                              *
      *     INPUT:   @@SEXP - Scaling exponent.                      *
      *              @@INRT - Rate to be unscaled.                   *
      *                                                              *
      *     OUTPUT:  @@USRT - Unscaled rate.                         *
      *                                                              *
      *     USES:    @SF    - Array of scaling factors.              *
      *              @@C    - Index for array @SF.                   *
      *              @@SCAF - Scaling factor.                        *
      *                                                              *
      *     LAST AMEND NO. 000000             DATE   XX/XX/XX        *
      ****************************************************************
      *
     C     ZA1160        BEGSR
      *
      **  Define and initialise fields used and output fields.
     C                   Z-ADD     @@SEXP        @@SEXP            1 0
     C*****              Z-ADD     @@INRT        @@INRT           12 8          154453
     C                   Z-ADD     @@INRT        @@INRT           13 8          154453
      *
     C*****              Z-ADD     *ZEROS        @@USRT           12 8          154453
     C                   Z-ADD     *ZEROS        @@USRT           13 8          154453
      *
     C                   Z-ADD     *ZEROS        @@C               2 0
     C                   Z-ADD     *ZEROS        @@SCAF           10 0
      *
      **  If the input rate is zero, the output rate is zero, by-pass
      **  further processing.
     C     @@INRT        CABEQ     0             ZA1169
      *
      **  Determine the scaling factor from the scaling exponent.
     C                   Z-ADD     @@SEXP        @@C
     C                   ADD       1             @@C
     C                   Z-ADD     @SF(@@C)      @@SCAF
      *
      **  Calculate the unscaled rate.
     C     @@INRT        DIV(H)    @@SCAF        @@USRT
      *
     C     ZA1169        ENDSR
 
      ** +--- End of subroutine converted from MM0089 --------------------+
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on activation                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    @@SEXP                         1st ccy scaling expo
     C                   PARM                    @@INRT                         Rate to be scaled.
 
     C                   PARM                    @@USRT                         Inv. of scaled rate
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *blank
     C                   MOVE      'Y'           RunBefore
     C                   DUMP
 
     C                   CALLB     DBErrCtl
 
     C                   ENDIF
 
     C                   EVAL       *inu7 = *inu8 = *on
     C                   EVAL       *inlr = *on
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
 
      ** +--- The second compile-time array was converted from MM0089 ----+
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** Array of scaling factors - @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
