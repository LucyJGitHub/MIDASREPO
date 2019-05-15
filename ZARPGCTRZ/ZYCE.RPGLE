     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Aus yield, check cum or ex coupon date')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZYCE    -   For Australian Yield Formulae - Determine        *
      *              whether the passed date is in the cum- or ex-    *
      *              coupon date range for this security.             *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZYCE          *
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
      *  Prev Amend No. CAP002  *CREATE    Date 21Apr98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Input Fields ***
     D NCD             S              5P 0
     D WRKD            S              5P 0
     D EDFT            S              3A
     D ZLOC            S              3A
     D NMCY            S              3A
 
      ** Working Variables
     D ZDAYNO          S              5P 0
     D ZCCY            S              3A
     D ZDYNBR          S              5P 0
     D ZNRDYS          S              2S 0
 
      ** +-----------------------------------------------------------------+
 
 
      ** Execute the standard subroutine
     C                   EXSR      ZYCE
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZYCEZ1 starts here --------------------------+
     C****************************************************************
     C* SUB-ROUTINE - ZYCE
     C*
     C* For Australian Yield Formulae - Determine whether the passed
     C* date is in the cum- or ex- coupon date range for this security.
     C* (Coupon date is a cum-coupon date)
     C****************************************************************
     C*
     C*  LAST CHANGE NO.  S01195                        13NOV90
     C*  PREV CHANGE NO.  S01232                        15OCT89
     C*
     C****************************************************************
     C*
     C*  S01195 - Holiday Processing : call to XDATE replaced by ZBKDT.
     C*  S01232 - CREATED FOR AUSTRALIAN YIELD MODIFICATION
     C*
     C****************************************************************
     C*  INPUT
     C*  =====
     C*
     C*  WRKD (5,0) - Date to be checked against next coupon date.
     C*  NCD  (5,0) - Next coupon date
     C*  SECTY/LF record for security
     C*
     C*  OUTPUT
     C*  ======
     C*
     C*  SCUMEX (1)  - CUM/EX indicator - value is 'C' or 'X'.
     C*
     C*  CALLS
     C*  =====
     C*
     C*  ZBKDT                                                            S01195
     C*
     C****************************************************************
     C*
     C     ZYCE          BEGSR
     C*          ----
     C*
     C                   MOVE      'C'           SCUMEX            1
     C     WRKD          IFNE      NCD
     C                   MOVEL     EDFT          ZNRDYS
     C     ZNRDYS        IFNE      *ZEROS
     C                   MOVE      EDFT          WEDFT             1
     C     WEDFT         IFEQ      'W'
     C*
     C*         working days
     C*
     C                   Z-ADD     NCD           ZDAYNO
     C                   MOVE      NMCY          ZCCY
     C                   EXSR      ZBKDT                                                       S0119
     C                   ELSE
     C*
     C*         actual  days
     C*
     C     NCD           SUB       ZNRDYS        ZDYNBR
     C                   END
     C*
     C     WRKD          IFLT      NCD
     C     WRKD          ANDGE     ZDYNBR
     C                   MOVE      'X'           SCUMEX
     C                   END
     C                   END
     C                   END
     C*
     C     ZYCEND        ENDSR
     C*
      ** +--- The converted ZYCEZ1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZYCE in this module executes another standard subroutine,        *
      *   ZBKDT, which has also been converted to a module.                *
      *  This subroutine is also called ZBKDT and simply does a CALLB to   *
      *   the module that contains subroutine ZBKDT                        *
      *                                                                    *
     C     ZBKDT         BEGSR
 
     C                   CALLB     'ZBKDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
 
     C                   ENDSR
      **********************************************************************
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
      ** Date to be checked againts next coupon date (5P 0)
      ** Next Coupon Date (5P 0)
      ** Ex-default date from Security details (3A)
      ** Location (3A)
      ** Nominal Currency (3A)
     C                   PARM                    WRKD
     C                   PARM                    NCD
     C                   PARM                    EDFT
     C                   PARM                    ZLOC
     C                   PARM                    NMCY
 
      * OUTPUTS
      ** Cum/Ex coupon indicator (1A)
     C                   PARM                    SCUMEX
 
     C                   ENDSR
 
      *****************************************************************
