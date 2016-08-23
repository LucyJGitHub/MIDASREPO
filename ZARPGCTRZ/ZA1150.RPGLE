     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Convert rate to scaled rate')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA1150 - Convert rate into scaled rate                       *
      *                                                               *
      *  Function:  This module accepts two currency scaling          *
      *             exponents, a rate to be scaled, and a multiply/   *
      *             divide indicator, and returns a scaled rate, the  *
      *             inverse of the scaled rate and an error code.     *
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
     F*  154453 - Apply fix 129183                                    *
     F*         - Exchange rate with 5 digits not accepted            *
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
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)
 
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
 
     C                   EXSR      ZA1150
 
     C                   RETURN
 
      ** +--- Start of subroutine converted from MM0089 ------------------+
 
     C****************************************************************
     C*     ZA1150 -  Convert rate to scaled rate.                   *
     C*                                                              *
     C*     CALLS:                                                   *
     C*                                                              *
     C*     INPUT:   @@SXP1 - First currency scaling exponent.       *
     C*              @@SXP2 - Second currency scaling exponent.      *
     C*              @@INRT - Rate to be scaled.                     *
     C*              @@FCMD - First Currency Multiply/Divide Ind.    *
     C*                                                              *
     C*     OUTPUT:  @@SCRT - Scaled rate.                           *
     C*              @@ISRT - Inverse of scaled rate.                *
     C*              @@ERCD - Error code.                            *
     C*                                                              *
     C*     USES:    @SF    - Array of scaling factors.              *
     C*              @@C    - Index for array @SF.                   *
     C*              @@SCF1 - Scaling factor for currency 1.         *
     C*              @@SCF2 - Scaling factor for currency 2.         *
     C*              @@WKA  - Work field, 15,0N.                     *
     C*              @@WKB  - Work field, 15,0N.                     *
     C*
     C     ZA1150        BEGSR
     C*
     C**  Define and initialise fields used and output fields.
     C                   Z-ADD     @@SXP1        @@SXP1            1 0
     C                   Z-ADD     @@SXP2        @@SXP2            1 0
     C***********        Z-ADD     @@INRT        @@INRT           12 8          154453
     C                   Z-ADD     @@INRT        @@INRT           13 8          154453
     C                   MOVE      @@FCMD        @@FCMD            1
     C*
     C***********        Z-ADD     *ZEROS        @@SCRT           12 8          154453
     C***********        Z-ADD     *ZEROS        @@ISRT           12 8          154453
     C                   Z-ADD     *ZEROS        @@SCRT           13 8          154453
     C                   Z-ADD     *ZEROS        @@ISRT           13 8          154453
     C                   Z-ADD     *ZEROS        @@ERCD            1 0
     C*
     C                   Z-ADD     *ZEROS        @@C               2 0
     C                   Z-ADD     *ZEROS        @@SCF1           10 0
     C                   Z-ADD     *ZEROS        @@SCF2           10 0
     C                   Z-ADD     *ZEROS        @@WKA            15 0
     C                   Z-ADD     *ZEROS        @@WKB            15 0
     C*
     C**  If the input rate is zero, the two output rates are zero,
     C**  by-pass further processing.
     C     @@INRT        CABEQ     0             ZA1159
     C*
     C**  Determine the scaling factor from the scaling exponent for
     C**  the first currency.
     C                   Z-ADD     @@SXP1        @@C
     C                   ADD       1             @@C
     C                   Z-ADD     @SF(@@C)      @@SCF1
     C*
     C**  Determine the scaling factor from the scaling exponent for
     C**  the second currency.
     C                   Z-ADD     @@SXP2        @@C
     C                   ADD       1             @@C
     C                   Z-ADD     @SF(@@C)      @@SCF2
     C*
     C**  If the M/D indicator is M, then the scaled rate is calculated
     C**  as follows....
     C     @@FCMD        IFEQ      'M'
     C*
     C**  Calculate the scaled rate and its inverse.
     C     @@INRT        MULT      @@SCF1        @@SCRT
     C     @@SCF2        DIV(H)    @@INRT        @@ISRT
     C*
     C**  Calculate the scaled rate and its inverse, placing the result
     C**  into 15,0 fields to check for overflow.
     C     @@INRT        MULT      @@SCF1        @@WKA
     C     @@SCF2        DIV(H)    @@INRT        @@WKB
     C*
     C**  Otherwise, calculate the rate as follows....
     C                   ELSE
     C*
     C**  Calculate the scaled rate and its inverse.
     C     @@INRT        MULT      @@SCF2        @@SCRT
     C     @@SCF1        DIV(H)    @@INRT        @@ISRT
     C*
     C**  Calculate the scaled rate and its inverse, placing the result
     C**  into 15,0 fields to check for overflow.
     C     @@INRT        MULT      @@SCF2        @@WKA
     C     @@SCF1        DIV(H)    @@INRT        @@WKB
     C*
     C                   END
     C*
     C**  If the work fields are greater than 9999.99999999, set up the
     C**  error codes.
     C*****@@WKA         IFGE      10000                                        154453
     C     @@WKA         IFGE      100000                                       154453
     C                   Z-ADD     1             @@ERCD
     C                   END
     C*****@@WKB         IFGE      10000                                        154453
     C     @@WKB         IFGE      100000                                       154453
     C                   Z-ADD     2             @@ERCD
     C                   END
     C*****@@WKA         IFGE      10000                                        154453
     C*****@@WKB         ANDGE     10000                                        154453
     C     @@WKA         IFGE      100000                                       154453
     C     @@WKB         ANDGE     100000                                       154453
     C                   Z-ADD     3             @@ERCD
     C                   END
     C*
     C     ZA1159        ENDSR                                                  **ZA1159**
      ********************************************************************
 
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
     C                   PARM                    @@SXP1                         1st ccy scaling expo
     C                   PARM                    @@SXP2                         2nd ccy scaling expo
     C                   PARM                    @@INRT                         Rate to be scaled.
     C                   PARM                    @@FCMD                         1st Ccy Mult/Div ind
 
     C                   PARM                    @@SCRT                         Scaled rate.
     C                   PARM                    @@ISRT                         Inv. of scaled rate
     C                   PARM                    @@ERCD                         Error code.
 
 
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
