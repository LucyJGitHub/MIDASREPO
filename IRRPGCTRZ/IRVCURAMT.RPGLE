     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate X-Ccy amounts within 10% range')
      *****************************************************************
      *                                                               *
      *  Midas - Validate both sides of currency equivalent amounts   *
      *          are within 10% of each other only if both currencies *
      *          amounts and base currency rates are valid.           *
      *                                                               *
      *  Module Name: IRVCURAMT
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
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. 215904             Date 25Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003   *CREATE   Date 01Feb98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  215904 - Cannot input a Cross-Currency IRS due to tolerance  *
      *           levels. Fix is to change the error message to a     *
      *           warning message that could be overridden.           *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
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
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
 
      ** External data structure for Customer Details file
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * our currency indicator - *IN23
     D SUCUCYok        S              1A
 
      * our principal amount indicator - *IN24
     D SuPAmtOK        S              1A
 
      * our base currency exchange rate indicator - *IN26
     D SUBCXRok        S              1A
 
      * their currency indicator - *IN65
     D StCucyOK        S              1A
 
      * their principal amount indicator - *IN66
     D STPAmtOK        S              1A
 
      * their base currency exchange rate indicator - *IN55
     D StBCXRok        S              1A
 
      * our currency
     D SUCUCY          S              3A
 
      * their currency
     D STCUCY          S              3A
 
      * our base currency rate
     D SUBCXR          S             14A
 
      * their base currency rate
     D STBCXR          S             14A
 
      * our base currency exchange rate
     D UBCXRX          S             13  8
 
      * their base currency exchange rate
     D TBCXRX          S             13  8
 
      ** Our amount
     D UPAMTX          S             13  0
 
      ** Their amount
     D TPAMTX          S             13  0
 
      ** Currency code
     D BJCYCD          S              3A
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      **  Check both sides base currency equivalent amounts
      **  are within 10% of each other only if both currencies,amounts
      **  and base currency rates are valid.
      *
     C     SUCUCYok      IFEQ      'Y'
     C     SuPAmtOK      ANDEQ     'Y'
     C     SuBCXRok      ANDEQ     'Y'
     C     STCUCYok      ANDEQ     'Y'
     C     StPAmtOK      ANDEQ     'Y'
     C     StBCXRok      ANDEQ     'Y'
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        BCD               1 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SUCUCY        @CUCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     A6NBDP        SUB       BCD           N                 1 0
     C                   ADD       4             N
 
      **  If our base currency rate is entered override the spot rate
 
     C     SUBCXR        IFNE      *BLANKS
     C                   Z-ADD     UBCXRX        A6SPRT
     C                   END
     C     A6MDIN        IFEQ      'D'
      *   Divide
      *
     C     A6SPRT        MULT      POWER(N)      WK159            15 9
     C     UPAMTX        DIV(H)    WK159         UBAMT            13 0
      *
     C                   ELSE
      *   Multiply
      *
     C     A6SPRT        DIV       POWER(N)      WK159            15 9
     C     UPAMTX        MULT(H)   WK159         UBAMT
      *
     C                   END
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      STCUCY        @CUCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C     A6NBDP        SUB       BCD           N                 1 0
     C                   ADD       4             N
      *
      **  If their base currency rate is entered override the spot rate
      *
     C     STBCXR        IFNE      *BLANKS
     C                   Z-ADD     TBCXRX        A6SPRT
     C                   END
      *
     C     A6MDIN        IFEQ      'D'
      *   Divide
      *
     C     A6SPRT        MULT      POWER(N)      WK159
     C     TPAMTX        DIV(H)    WK159         TBAMT            13 0
      *
     C                   ELSE
      *   Multiply
      *
     C     A6SPRT        DIV       POWER(N)      WK159            15 9
     C     TPAMTX        MULT(H)   WK159         TBAMT
      *
     C                   END
      *
      ****If*equivalent*amounts*are*not*within*10%*then*error***************                  215904
      ** If equivalent amounts are not within 10%, send a warning msg.                        215904
      *
     C     TBAMT         MULT      0.1           TBAPC            15 2
     C     TBAMT         ADD       TBAPC         PLUS             15 2
     C     TBAMT         SUB       TBAPC         MINUS            15 2
      *
     C     UBAMT         IFLT      MINUS
     C     UBAMT         ORGT      PLUS
     C*
     C                   MOVE      'N'           SuBCXRok
     C                   MOVE      'N'           STBCXRok
     C                   MOVE      'MMA0051'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C*
     C/COPY WNCPYSRC,DL1603IC47
     C*
     C                   END
     C                   IF        ErrorFound = 'Y'
     C**********         EVAL      RetCodeIn = 'Error'                                        215904
     C                   EVAL      RetCodeIn = 'Warning'                                      215904
     C                   ENDIF
     C                   RETURN
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SUCUCYok
     C                   PARM                    SuPAmtok
     C                   PARM                    SUBCXRok
     C                   PARM                    STCUCYok
     C                   PARM                    StPAmtok
     C                   PARM                    StBCXRok
     C                   PARM                    BJCYCD
     C                   PARM                    SUCUCY
     C                   PARM                    STCUCY
     C                   PARM                    SUBCXR
     C                   PARM                    STBCXR
     C                   PARM                    UBCXRX
     C                   PARM                    TBCXRX
     C                   PARM                    UPAMTX
     C                   PARM                    TPAMTX
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
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
