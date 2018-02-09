     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Format amount for output, based on CDP')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA0920 - Convert (13,0) amount to (14A) displayable field,   *
      *           edited according to the number of decimal places    *
      *           for the currency.                                   *
      *                                                               *
      *  Function:  This module accepts a (13,0) number containing an *
      *             amount, along with a figure representing the      *
      *             number of decimal places in the currency, and     *
      *             returns a 14A field containing the amount edited  *
      *             for display purposes.                             *
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
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 208051             Date 22Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  208051 - Format -ve amount with a leading '-' sign.          *
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
 
      ** Parameters received: amount in, currency decimal places,amount
      ** out and currency separator.
     D AmountIn        S             13P 0
     D AmountOut       S             14A
     D BNDCSP          S              1A
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Start of D-specs converted from MM0089 ---------------------+
 
     D @Z              S              1    DIM(14)
      **  Array @Z stores amount with decimal (Execution time array)
 
     D                 DS
     D**  Data structure to redefine array @Q as input field @@AMTW
     D  @@AMTW                 1     13  0
      **  Array @Q stores amount as it is (Execution time array)
     D  @Q                     1     13  0 DIM(13)
 
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
 
      ** Pass input parameter to subroutine field
     C                   EVAL      @@AMTW = AmountIn
     C                   EXSR      ZA0920
 
      ** Copy subroutine field to return parameter, and exit
     C                   MOVEA     @Z            AmountOut
 
     C                   RETURN
 
      ** +--- Start of subroutine converted from MM0089 ------------------+
 
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*       TITLE:BACK OFFICE AMOUNT EDITOR .                       *
     C*                                                               *
     C*       SUBROUTINE ZA0920 ACCEPTS AN AMOUNT FIELD (13N) AND     *
     C*       A FIELD (1N) SPECIFYING NO. OF DECIMALS AND WITH THIS   *
     C*       CONVERTS THE AMOUNT INTO AN ALPHAMERIC FIELD (14A)      *
     C*       WITH THE REQUIRED DECIMAL PLACE.                        *
     C*                                                               *
     C*                                                               *
     C* INPUT  :@@AMTW AMOUNT      FORMAT(13N)                     *
     C*         @@QECN DECIMAL NO. FORMAT(1N)                     *
     C*                                                               *
     C* OUTPUT :@@AMTD AMOUNT WITH DECIMAL FORMAT(14A)                *
     C*                                                               *
     C* USES :  @@AMTW AMOUNT FIELD PASSED                            *
     C*         @@QECN NO. OF DECIMAL FIELD                           *
     C*         @@QECW POSITION ON ARRAY @Z  FOR A DECIMAL POINT     *
     C*         @@SIG  POSITION ON ARRAY THAT CANNOT BE BLANK         *
     C*         @@Z    INDEX FOR ARRAY @Z                             *
     C*         @@Y    INDEX FOR PREVIOUS POSITION TO @@Z             *                       208051
     C*         @@Q    INDEX FOR ARRAY @Q                             *
     C*         @@SWT  SWITCH SAYING ZERO HAS BEEN SUPPRESSED         *
     C*         @@SWT1 SWITCH SAYING ZERO SUPPRESSION OVER            *
     C*                                                               *
     C* ARRAYS:  @Z ARRAY USED FOR DECIMAL ALIGNMENT                  *
     C*          @Q ARRAY USED FOR STORING AMOUNT PASSED TO THE SR    *
     C*                                                               *
     C*****************************************************************
     C*                                                               *
     C     ZA0920        BEGSR
     C*
     C* INITIALIZATION
     C                   MOVE      '0'           @@SWT1            1
     C*
     C* FINDING WHERE DECIMAL POSITION IS
     C*
     C     14            SUB       @@QECN        @@QECW            2 0
     C*
     C* FINDING OUT MOST SIGNIFICANT POSITION
     C*
     C     @@QECW        SUB       1             @@SIG             2 0
     C                   MOVEA     *BLANKS       @Z
     C                   Z-ADD     1             @@Q               2 0
     C*
     C* CHECK TO SEE IF NO.OF DECIMAL PLACES IS ZERO. IF ZERO
     C* THEN SIGNIFICANT POSITION IS 14 AND POSITION 1 IS BLANK
     C     @@QECW        IFEQ      14
     C                   Z-ADD     14            @@SIG
     C                   Z-ADD     2             @@Z               2 0
     C                   ELSE
     C                   Z-ADD     1             @@Z               2 0
     C                   END
     C*
     C* PERFORMING ACTUAL MOVEMENT
     C     @@Z           DOWLT     15
     C     @@Q           ANDLT     14
     C*
     C* SWITCH FOR ZERO SUPPRESSION
     C                   MOVE      '0'           @@SWT
     C*
     C* IF ELEMENT OF ARRAY @Q  IS ZERO AND INDEX @@Z FOR ARRAY @Z
     C* IS *LT SIG.POSITION AND ALSO *LT DECIMAL POSITION THEN ZERO
     C* CAN BE SUPPRESSED AND ZERO SUPPRESSION SWITCH IS SETON
     C* Display leading '_' sign if amount is negative.                                       208051
     C*
     C     @@AMTW        IFGE      0                                                          208051
     C     @Q(@@Q)       IFEQ      0
     C     @@SWT1        ANDEQ     '0'
     C     @@Z           ANDLT     @@SIG
     C     @@Z           ANDLT     @@QECW
     C                   MOVE      *BLANK        @Z(@@Z)
     C                   MOVE      '1'           @@SWT             1
     C                   END
     C                   ELSE                                                                 208051
     C     @Q(@@Q)       IFEQ      0                                                          208051
     C     @@SWT1        ANDEQ     '0'                                                        208051
     C     @@Z           ANDLT     @@SIG                                                      208051
     C     @@Z           ANDLT     @@QECW                                                     208051
     C     @@Z           SUB       1             @@Y               2 0                        208051
     C     @@Y           IFEQ      0                                                          208051
     C                   MOVE      '-'           @Z(@@Z)                                      208051
     C                   ELSE                                                                 208051
     C                   MOVEA     ' -'          @Z(@@Y)                                      208051
     C                   END                                                                  208051
     C                   MOVE      '1'           @@SWT             1                          208051
     C                   END                                                                  208051
     C                   END                                                                  208051
     C*
     C* IF INDEX @@Z FOR ARRAY @Z IS EQUAL TO THE DECIMAL POSITION
     C* AND NOT EQUAL TO THE LENGTH OF THE ARRAY @Z(14) THEN MOVE
     C* DECIMAL POSITION AND INCREMENT @@Z BY 1
     C*
     C     @@Z           IFEQ      @@QECW
     C     @@Z           ANDNE     14
     C                   MOVE      BNDCSP        @Z(@@Z)
     C                   ADD       1             @@Z
     C                   END
     C*
     C* IF ZERO HAS NOT BEEN SUPPRESSED THEN MOVE ELEMENT FROM ARRAY
     C* @Q TO @Z.SETON ZERO SUPPRESSION SWITCH OVER(@@SWT1)
     C     @@AMTW        IFGE      0                                                          208051
     C     @@Z           ORNE      14                                                         208051
     C     @@SWT         IFEQ      '0'
     C                   MOVE      @Q(@@Q)       @Z(@@Z)
     C                   MOVE      '1'           @@SWT1
     C                   END
     C* If amount is negative, the last character needs high zone change                      208051
     C* from 'D' to 'F' prior to printing. (Leave original field unchanged).                  208051
     C                   ELSE                                                                 208051
     C     @@SWT         IFEQ      '0'                                                        208051
     C                   MOVE      @Q(@@Q)       POSQ              1                          208051
     C                   BITON     '0123'        POSQ                                         208051
     C                   MOVE      POSQ          @Z(@@Z)                                      208051
     C                   MOVE      '1'           @@SWT1                                       208051
     C                   END                                                                  208051
     C                   END                                                                  208051
     C*
     C                   ADD       1             @@Q
     C                   ADD       1             @@Z
     C*
     C                   END
      *
      * Dummy moves for definition of work fields.
     C                   GOTO      ZA0929
     C                   MOVE      @@QECN        @@QECN            1 0
      *
     C     ZA0929        ENDSR
 
      ** +--- End of subroutine converted from MM0089 --------------------+
 
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
     C                   PARM                    AmountIn
     C                   PARM                    @@QECN
     C                   PARM                    BNDCSP
     C                   PARM                    AmountOut
 
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
(c) Finastra International Limited 2001
