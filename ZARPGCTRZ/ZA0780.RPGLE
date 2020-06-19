     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Apply Forward Points to an Exch Rate')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA0780 - Apply Forward Points to an Exchange Rate            *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 248024             Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23050A          Date 20Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 04Nov98               *
      *                 143747             Date 28Sep98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  248024 - Apply fix patterned after 242105 for determining    *
      *           'Normally Quoted Decimal for forward points.        *
      *           Applied fix 243459.                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23050A -Reciprocal rate indicator not defaulting.         *
      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
     F*  CAP006 - Allow exchange rate with five digits (154453)       *
      *  143747 - Forward points conversion error                     *
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

      ** Include the ZA standard declares
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

      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @@AY            S             10  0 DIM(10) CTDATA PERRCD(1)

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
      * Initialize outputs = scaled & unscaled rate
      *
     C                   Z-ADD     0             @@GSRT                         gross scaled rate
     C                   Z-ADD     0             @@GURT                         gross unscld rate
      *
      * ZA0780 - APPLY FORWARD POINTS TO AN EXCHANGE RATE.
      *
     C                   EXSR      ZA0780
      *
      * RETURN
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      * ZA0780 - APPLY FORWARD POINTS TO AN EXCHANGE RATE            *
      ****************************************************************
     C     ZA0780        BEGSR
      *
      **  SCALE THE RATE PRIOR TO APPLYING THE FORWARD POINTS.
      *
     C     @@SCAL        IFEQ      'Y'
      *
      ** CONVERT AN UNSCALED RATE TO A SCALED RATE
      *
     C                   CALLB     'ZA1150'
      *
      * INPUTS
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@SXP2                         scaling exponent
     C******             PARM      @@IRAT        @@INRT           12 8                        CAP006
     C                   PARM      @@IRAT        @@INRT           13 8                        CAP006
     C                   PARM                    @@DMD1            1
      *
      * OUTPUTS
     C******             PARM      *ZEROS        @@SCRT           12 8                        CAP006
     C******             PARM      *ZEROS        @@ISRT           12 8                        CAP006
     C                   PARM      *ZEROS        @@SCRT           13 8                        CAP006
     C                   PARM      *ZEROS        @@ISRT           13 8                        CAP006
     C                   PARM      *ZEROS        @@ERCD            1 0          errors
      *
      **  IF THE ERROR CODE FROM ZA1150 IS 1 OR 3
      **  THEN A DATABASE ERROR HAS OCCURRED.
      *
     C     @@ERCD        IFEQ      1
     C     @@ERCD        OREQ      3
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '@@SCRT'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** SCALED RATE
      *
     C                   Z-ADD     @@SCRT        @@IRAT
     C                   END
      *
      ** IF EITHER CURRENCY IS THE BASE CURRENCY OBTAIN NUMBER OF
      ** NORMALLY QUOTED DECIMAL PLACES FOR THE OTHER CURRENCY.
      *
     C     DDBCCY        IFEQ      BNCYDL
     C     DDSCCY        OREQ      BNCYDL
      *
     C     DDBCCY        IFEQ      BNCYDL
     C                   MOVE      @@NDP2        @@NDP             1 0
     C                   ELSE
     C                   MOVE      @@NDP1        @@NDP
     C                   END
      *
      ** IF NEITHER IS BASE CURRENCY OBTAIN THE NUMBER OF QUOTED
      ** DECIMAL PLACES USING ZA0790.
      ** NOTE THAT THE RATE USED IS SCALED.
      *
     C                   ELSE
     C                   EXSR      ZA0790
     C                   END
      *
      ** NOW APPLY FORWARD POINTS TO EXCHANGE RATE.
      *
     C                   Z-ADD     @@NDP         @@C               2 0
     C                   ADD       1             @@C
     C     @@FPNT        DIV       @@AY(@@C)     @@WF1            15 8
     C     @@WF1         ADD       @@IRAT        @@GSRT           13 8
      *
      * Check whether F/Points has made Outright Rate negative :
      *
     C     @@GSRT        IFLT      *ZERO                                           -VE.RATE
     C                   Z-ADD     *ZERO         @@GSRT
     C                   END
      *
      **  UNSCALE THE RATE FOR OUTPUT.
      *
     C     @@DMD1        IFEQ      'M'
     C                   Z-ADD     @@SXP1        @@SEXP
     C                   ELSE
     C                   Z-ADD     @@SXP2        @@SEXP
     C                   END
      *
      ** CONVERT A SCALED RATE TO AN UNSCALED RATE
      *
     C                   CALLB     'ZA1160'
      *
      * INPUTS
     C                   PARM                    @@SEXP            1 0          scaling exponent
     C******             PARM      @@GSRT        @@INRT           12 8          CAP006 rate
     C                   PARM      @@GSRT        @@INRT           13 8          CAP006 rate
      *
      * OUTPUTS
     C******             PARM      *ZEROS        @@USRT           12 8                        CAP006
     C                   PARM      *ZEROS        @@USRT           13 8                        CAP006
      *
     C                   Z-ADD     @@USRT        @@GURT
     C*
     C     ZA0789        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0790 - DETERMINE NUMBER OF NORMALLY QUOTED DECIMAL PLACES   *
      *****************************************************************
     C     ZA0790        BEGSR
      *
     C     @@NDP1        IFEQ      @@NDP2
     C     @@NDP1        ANDEQ     5
     C                   Z-ADD     5             @@NDP             1 0
     C                   GOTO      ZA0799
     C                   END
      *                                                                                       248024
      ** Compare normally-quoted decimal places of both currencies invovled;                  248024
      ** If both are the same, use either value as NQD...                                     248024
      *                                                                                       248024
     C     @@NDP1        IFEQ      @@NDP2                                                     248024
     C                   Z-ADD     @@NDP1        @@NDP                                        248024
     C                   GOTO      ZA0799                                                     248024
     C                   ENDIF                                                                248024
      *                                                                                       248024
      ** If they are not the same, use the lesser value of the two...                         248024
      *                                                                                       248024
     C     @@NDP1        IFNE      @@NDP2                                                     248024
     C     @@NDP1        IFLT      @@NDP2                                                     248024
     C                   Z-ADD     @@NDP1        @@NDP                                        248024
     C                   ELSE                                                                 248024
     C     @@NDP2        IFLT      @@NDP1                                                     248024
     C                   Z-ADD     @@NDP2        @@NDP                                        248024
     C                   ENDIF                                                                248024
     C                   ENDIF                                                                248024
     C                   GOTO      ZA0799                                                     248024
     C                   ENDIF                                                                248024
     C*
     C     @@IRAT        IFGE      100
     C                   Z-ADD     2             @@NDP
     C                   ELSE
     C     @@IRAT        IFLT      100
     C     @@IRAT        ANDGE     20
     C*******************Z-ADD     3             @@NDP                          143747
     C                   Z-ADD     2             @@NDP                          143747
     C                   ELSE
     C     @@IRAT        IFLT      20
     C     @@IRAT        ANDGE     1
     C                   Z-ADD     4             @@NDP
     C                   ELSE
     C     @@IRAT        IFLT      1
     C*******************Z-ADD     5             @@NDP                          143747
     C**********         Z-ADD     4             @@NDP                              143747 BUG23050A
     C                   Z-ADD     5             @@NDP                                     BUG23050A
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     ZA0799        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      * ICD
     C                   PARM                    BNCYDL            3            sell ccy
      *
     C                   PARM                    @@IRAT           13 8          exchange rate
     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
     C                   PARM                    @@FPNT            7 2          forward points
      *
     C                   PARM                    @@SCAL            1            scale rate?
      *
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
      *
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
      *
      * OUTPUTS
      *
     C                   PARM                    @@GSRT           13 8          gross scaled rate
     C                   PARM                    @@GURT           13 8          gross unscld rate
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**   @@AY   - Array of powers of 10.
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
