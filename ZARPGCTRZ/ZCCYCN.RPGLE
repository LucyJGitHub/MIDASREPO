     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Convert amount to a different currency')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  ZCCYCN - Convert amount into another amount in a different   *
      *           currency.                                           *
      *                                                               *
      *  Function:  This module convert an amount on one currency to  *
      *             using the spot rates for the two currencies.      *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZCCYCN        *
      *  subroutine.  The subroutine consists of two /COPY members.   *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
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
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 30Apr98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP003 - Conversion of input functions to modules for use as *
      *           APIs - Phase 2.                                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** +--- The converted ZPOWERZ1 starts here --------------------------+
 
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
 
      ** +--- The converted ZPOWERZ1 ends here ----------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Input fields
     ** ------------
 
     D ZAMTF           S             15P 0
     D ZCCYF           S              3A
     D ZCCYT           S              3A
     D ZRATEF          S             13P 8
     D ZRATET          S             13P 8
     D ZMDINF          S              1A
     D ZMDINT          S              1A
     D ZCDPF           S              1P 0
     D ZCDPT           S              1P 0
 
      ** Output fields
      ** -------------
 
     D ZAMTT           S             15P 0
     D ZCRSRT          S             13P 8
     D ZCRSMD          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Execute Processing Subroutine
      *
     C                   EXSR      SRZCCYCN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZCCYCN - Processing subroutine                              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZCCYCN      BEGSR
      *
      ** +--- The converted ZCCYCN starts here ---------------------------+
      *
      ** If 'FROM' currency equal to 'TO' currency set amount in 'TO'
      ** currency equal to amount in 'FROM' Currency.
      *
     C     ZCCYF         IFEQ      ZCCYT
     C                   Z-ADD     ZAMTF         ZAMTT
     C                   Z-ADD     1             ZCRSRT
     C                   MOVE      'M'           ZCRSMD
     C     1000000000    MULT      1000000       ZCRSRN
     C                   GOTO      CCYEND
     C                   END
      *
      ** Initialize cross exchange rate (ZCRSSRT) to Zero
      *
     C                   Z-ADD     *ZEROS        ZCRSRT
      *
      ** Convert 'FROM' rate to multiply rate
      *
     C     ZMDINF        IFEQ      'M'
     C                   Z-ADD     ZRATEF        ZRATF1           13 8
     C     1000000000    MULT      ZRATEF        ZRATF2           30 8
     C     10            MULT      ZRATF2        ZRATF2
     C                   ELSE
     C     1             DIV       ZRATEF        ZRATF1
     C     1000000000    MULT      10            ZRWORK           20 0
     C     ZRWORK        DIV(H)    ZRATEF        ZRATF2
     C                   END
      *
      ** Convert 'TO' rate to multiply rate
      *
     C     ZMDINT        IFEQ      'M'
     C                   Z-ADD     ZRATET        ZRATT1           13 8
     C     1000000000    MULT      ZRATET        ZRATT2           30 8
     C     10            MULT      ZRATT2        ZRATT2
     C                   ELSE
     C     1             DIV       ZRATET        ZRATT1
     C     1000000000    MULT      10            ZRWORK
     C     ZRWORK        DIV(H)    ZRATET        ZRATT2
     C                   END
      *
      ** now calculate cross rate
      *
     C     ZRATT1        IFNE      *ZEROS
     C     ZRATF1        DIV       ZRATT1        ZCRSRT
      *
      ** Calculate double precision FX rates
      **  first split figure into teo parts
      *
     C     1000000000    MULT      1000000       ZRWORK
     C     ZRATF2        MULT      ZRWORK        ZRATBF           30 0
     C                   Z-ADD     ZRATF2        ZRATSF           15 8
      *
      ** Divide both big and small parts by to FX rate and add to cross
      ** rate to be used in calculations
      *
     C     ZRATBF        DIV(H)    ZRATT2        ZCRSRN           30 9
     C     ZRATSF        DIV(H)    ZRATT2        ZCRSR1           30 9
     C                   ADD       ZCRSR1        ZCRSRN
     C                   END
      *
      ** Move Mult/Div Ind, for 'FROM' currency to Cross Rate Mult/Div
      ** Indicator (ZCRSMD)
      *
     C                   MOVE      'M'           ZCRSMD
      *
      ** If Cross exchange rate is equal to zero
      ** set ZAMTT to *ZERO and Exit
      *
     C     ZCRSRN        IFEQ      0
     C                   Z-ADD     *ZEROS        ZAMTT
     C                   GOTO      CCYEND
     C                   END
      *
      ** If decimal places for 'FROM' currency (ZCDPF) equals decimal
      ** places for 'TO' currency convert amount by simple
      ** multiplication.
      *
     C     ZCDPF         IFEQ      ZCDPT
     C     ZAMTF         MULT(H)   ZCRSRN        ZAMTO            30 0
     C                   END
      *
      ** If decimal places for 'FROM' currency (ZCDPF) not equals decimal
      ** places for 'TO' currency, adjust amount for different DP.
      *
     C     ZCDPF         IFNE      ZCDPT
      *
      ** subtract decimal places from 'FROM' decimal places 'TO'
      ** In power
      *
     C     ZCDPT         SUB       ZCDPF         ZWKPX             1 0
     C     ZWKPX         ADD       4             IdB               3 0
      *
      ** If power element (8,4) less than 1
      *
     C     POWER(IdB)    IFLT      1
      *
      ** multiply amount in from currency by element IN power array
      *
     C     POWER(IdB)    MULT      ZAMTF         ZWK153           15 3
 
     C     ZWK153        MULT(H)   ZCRSRN        ZAMTO
     C                   END
      *
      ** If power element (8,4) greater or equal to 1
      *
     C     POWER(IdB)    IFGE      1
     C     ZAMTF         MULT      POWER(IdB)    ZAMTO
     C     ZAMTO         MULT(H)   ZCRSRN        ZAMTO
     C                   END
     C                   END
      *
     C     ZAMTO         DIV(H)    ZRWORK        ZAMTT
      *
     C     CCYEND        ENDSR
      *
      ** +--- The converted ZCCYCN ends here -----------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Received parameters
      ** -------------------
      * Amount in 'FROM' currency (15P 0)                                      *
      * From Currency (3A)                                                     *
      * TO currency (3A)                                                       *
      * Spot Rate for 'FROM' currency (13P 8)                                  *
      * Spot Rate for 'TO' currency (13P 8)                                    *
      * Multiply/Divide Indicator for 'FROM' currency  (1A)                    *
      * Multiply/Divide Indicator for 'TO' currency (1A)                       *
      * Currency Decimal places for 'FROM' currency (1P 0)                     *
      * Currency Decimal places for 'TO' currency (1P 0)
     C                   PARM                    ZAMTF
     C                   PARM                    ZCCYF
     C                   PARM                    ZCCYT
     C                   PARM                    ZRATEF
     C                   PARM                    ZRATET
     C                   PARM                    ZMDINF
     C                   PARM                    ZMDINT
     C                   PARM                    ZCDPF
     C                   PARM                    ZCDPT
 
      ** Returned parameters
      ** -------------------
      * Amount in 'TO' Currency (i.e. Converted Amount) (15P 0)                *
      * Cross Exchange Rate (13P 8)
      * Cross Rate Multiply/Divide Indicator (1A)
 
     C                   PARM                    ZAMTT
     C                   PARM                    ZCRSRT
     C                   PARM                    ZCRSMD
 
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
**  CPY@
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
