     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Format amount for output, based on CDP')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA0921 - Convert a (15,0) amount to a (17A) displayable      *
      *           field edited according to the number of supplied    *
      *           decimal places. Input negative amounts are output   *
      *           with a negative sign ('-').                         *
      *                                                               *
      *           This was originally a subroutine which was present  *
      *           in AB0330 (BJEDIT). It was modelled on ZA0920.      *
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
      *  Last Amend No. 156689             DATE 08Mar99               *
      *  Prev Amend No. CAP004             Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR *
      *  CAP004 - API's Phase 3.                                      *
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Start of D-specs converted from AB0330 ---------------------+
 
      * BJEDIT Array/field data structure; edited amount with/without sign
     D  @Z                     1     16
     D                                     DIM(16)                              BJEDIT Amt.char.
     D  @Y                     1     17
     D                                     DIM(17)                              BJEDIT Amt.char.
     D  @@AMTP                 1     16
     D  @@AMTD                 1     17
     D                 DS
      * BJEDIT Array/field data structure; amount to be edited
     D  @Q                     1     15  0
     D                                     DIM(15)                              BJEDIT Amt.num.
     D  @@AMTW                 1     15  0
 
      ** +--- End of D-specs converted from AB0330 -----------------------+
 
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
 
      ** Pass input parameter to subroutine field
     C                   EVAL      @@AMTW = AmountIn
     C                   EXSR      BJEDIT
 
      ** Copy subroutine fields to return parameters, and exit
     C                   MOVE      @@AMTP        AmountOutP
     C                   MOVE      @@AMTD        AmountOutD
 
     C                   RETURN
 
      ** +--- Start of subroutine converted from AB0330 ------------------+
 
     CSR   BJEDIT        BEGSR
      *====================================================
      * Convert numeric amount to edited alpha
      * This is a reworking of ZA0920, altered to allow the
      * editing of maximum-length and negative fields.
      *
      * Input  :  @@AMTW 15,0  Amount
      *           W@DECP 1,0   Decimal places
      *           @@DCSP 1     Decimal separator                                156689
      * Output :  @@AMTD 17    Edited amount (signed)
      *     or :  @@AMTP 16    Edited amount (unsigned)
      *----------------------------------------------------
      *
     C                   MOVE      *BLANK        @@AMTD                         Init.O'put
     C                   SETOFF                                         91      Init.Inds.
      *
     C     W@DECP        IFEQ      *ZERO                                        IF NO DEC.POS.
     C                   Z-ADD     2             P1                               Start pos.
     C                   Z-ADD     *ZERO         @@QECW            3 0            Start decimal
     C                   ELSE                                                   EL DEC.PLACES
     C                   Z-ADD     1             P1                               Start pos.
     C     16            SUB       W@DECP        @@QECW                           Start decimal
     C                   END                                                    FI
      *
     C     @@AMTW        IFLT      *ZERO                                        IF NEGATIVE
     C     *ZERO         SUB       @@AMTW        @@AMTW                           Make positive
     C                   MOVE      '-'           @@AMTD                           Negative
     C                   END                                                    FI
      *
     C     1             DO        15            P2                             DO EDIT
      *                    |
     C     W@DECP        IFNE      *ZERO                                        IF   ¦ DECIMAL
     C     P1            ANDEQ     @@QECW                                       AND  ¦ POSITION
     C*******************MOVE      '.'           @Z(P1)                         156689
     C                   MOVE      @@DCSP        @Z(P1)                         156689
     C                   ADD       1             P1                   91          Incr.ptr.Z
     C                   END                                                    FI
      *                    |
     C     *IN91         IFEQ      '0'                                          IF   ¦ LEADING
     C     @Q(P2)        ANDEQ     *ZERO                                         AND ¦ ZERO
     C                   MOVE      *BLANK        @Z(P1)                           Blank
     C                   ELSE                                                   EL IN NUMBER
     C                   MOVE      @Q(P2)        @Z(P1)                           Valid data
     C                   SETON                                        91          In number
     C                   END                                                    FI
      *                    |
     C                   ADD       1             P1                               Incr.ptr.Z
      *                    |
     C                   END                                                    OD
      *
      *----------------------------------------------------
      *
      *====================================================
     CSR   BJEXIT        ENDSR
 
      ** +--- End of subroutine converted from AB0330 --------------------+
 
     C*****************************************************************
     C/EJECT
     C*****************************************************************
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
     C                   PARM                    RetCodeIn
     C                   PARM                    AmountIn         15 0
     C                   PARM                    W@DECP            1 0
     C                   PARM                    @@DCSP            1            156689
     C                   PARM                    AmountOutP       16
     C                   PARM                    AmountOutD       17
 
     C                   Z-ADD     1             P1                5 0          Set pointer 1
     C                   Z-ADD     1             P2                5 0          Set pointer 2
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
