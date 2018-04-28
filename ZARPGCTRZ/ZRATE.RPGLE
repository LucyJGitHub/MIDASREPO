     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate effective interest rate')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZRATE   -   Calculate effective interest rate                *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZRATE         *
      *  subroutine.  The subroutine consists of one /COPY member.    *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
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
      *  Last Amend No. CAP002  *CREATE    Date 21Apr98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** +-----------------------------------------------------------------+
 
      ** Execute the standard subroutine
     C                   EXSR      ZRATE
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZRATEZ1 starts here --------------------------+
      *****************************************************************
      **                                                             **
      ** ZRATE  - Subroutine to calculate effective interest rate.   **
      **          (Currently applies to Partly Paid and Asset-Backed **
      **           Securities).                                      **
      **                                                             **
      ** INPUT  - ZCPNR (11,7) Current Coupon Rate                   **
      **          ZPPDI (1A)   Partly Paid Indicator                 **
      **          ZPPCP (15,0) Current Partly Paid Price             **
      **          ZSFPP (15,0) Fully Paid Price                      **
      **          ZPROT (1A)   Processing Type                       **
      **          ZCFCT (10,9) Current Factor                        **   052254
      **                                                             **
      ** OUTPUT - IRATE (15,9) Effective Interest Rate               **
      **                                                             **
      *****************************************************************
      **                                                             **
      ** LAST AMEND NO. 052254             DATE 07JAN94              **
      ** PREV AMEND NO. E20085             DATE 03NOV89              **
      *                                                              **
      *--------------------------------------------------------------**
      **                                                             **
      *  052254 - CURRENT FACTOR amended from 9,8 to 10,9            **
      ** E20085 - Rewrite of Subroutine.                             **
      **         - Includes change to correct Partly Paids.          **
      **         - Effective Interest Rate field, IRATE, has been    **
      **           redefined to increase its accuracy.               **
      **         - Field ZSINP is removed because it is not used.    **
      **         - Processing has been restructured to make it much  **
      **           simpler, more efficient and easier to read.       **
      **                                                             **
      *****************************************************************
      *
     C     ZRATE         BEGSR                                                  *** ZRATE  ***
      *
      ***  Define the fields
      *
     C                   Z-ADD     ZCPNR         ZCPNR            11 7
     C                   MOVE      ZPPDI         ZPPDI             1
     C                   Z-ADD     ZPPCP         ZPPCP            15 0
     C                   Z-ADD     ZSFPP         ZSFPP            15 0
     C                   MOVE      ZPROT         ZPROT             1
     C                   Z-ADD     ZCFCT         ZCFCT            10 9                         05225
      *
      ***  If Coupon Rate or Partly Paid Price are zero then set the
      ***  Effective Interest Rate to zero and Exit, else set up the
      ***  Interest Rate with the Current Coupon Rate.
      *
     C     ZCPNR         IFEQ      *ZEROS
     C     ZPPDI         OREQ      'Y'
     C     ZPPCP         ANDEQ     *ZEROS
      *
     C                   Z-ADD     *ZEROS        IRATE
     C                   GOTO      EZRATE
      *
     C                   ELSE
      *
     C                   Z-ADD     ZCPNR         IRATE            15 9
      *
     C                   END
      *
      ***  If Partly Paid, then calculate the fraction of Part Payment
      ***  and multiply it with the Interest Rate.
      ***  (If PP Price = FP Price, fraction = 1, so skip. Note: since
      ***   FP >= PP, we have also avoided possible division by zero.)
      *
     C     ZPPDI         IFEQ      'Y'
     C     ZPPCP         ANDNE     ZSFPP
      *
     C     ZPPCP         DIV       ZSFPP         WRK109           10 9
     C                   MULT(H)   WRK109        IRATE
      *
     C                   END
      *
      ***  If Processing Type = '8' Security, then multiply the
      ***  Interest Rate by the Current Factor.
      *
     C     ZPROT         IFEQ      '8'
      *
     C                   MULT(H)   ZCFCT         IRATE
     C*
     C                   END
      *
     C     EZRATE        ENDSR
      *
      **********************************************************************
      ** +--- The converted ZRATEZ1 ends here ----------------------------+
 
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
 
      * INPUTS
 
      * Current Coupon Rate
      * Partly Paid Indicator
      * Current Partly Paid Price
      * Fully Paid Price
      * Processing Type
      * Current Factor
     C                   PARM                    ZCPNR
     C                   PARM                    ZPPDI
     C                   PARM                    ZPPCP
     C                   PARM                    ZSFPP
     C                   PARM                    ZPROT
     C                   PARM                    ZCFCT
 
      * OUTPUTS
 
      * Effective Interest Rate
     C                   PARM                    IRATE
 
     C                   ENDSR
      *****************************************************************
