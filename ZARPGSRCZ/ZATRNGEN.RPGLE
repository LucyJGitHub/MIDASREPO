     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Transaction number generation')
/*OVRF*: OVRDBF FILE(ZAAVSTXX) TOFILE(ZAAVSTL0) SHARE(*NO)          : *         CSC024
/*OVRF*: OVRDBF FILE(ZAAVFFXX) TOFILE(ZAAVFFL0) SHARE(*NO)          : *         CSC024
/*OVRF*: OVRDBF FILE(ZAAVSDXX) TOFILE(ZAAVSDL0) SHARE(*NO)          : *         CSC024
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  ZATRNGEN - Next available transaction number generation      *
      *                                                               *
      *  Function:  This module generates the next available          *
      *             transaction numbers for a module (and optionally  *
      *             transaction type) from its transaction no. file.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 234300             Date 29Sep06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSC024             Date 09Aug05               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 10May98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC024 - Open Month End                                      *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE015 - Forward Valued Depot Movements (Recompile)          *
      *  CSE017 - Cum/Ex Indicator on Depot Movements (Recompile)     *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     FZAAVSTXX  IF   E           K DISK    RENAME(ZAAVSTD0:RTVRC1)              CSC024
     F                                     PREFIX(X_)                           CSC024
     FZAAVSDXX  IF   E           K DISK    RENAME(ZAAVSDD0:RTVRC2)              CSC024
     F                                     PREFIX(Y_)                           CSC024
     FZAAVFFXX  IF   E           K DISK    RENAME(ZAAVFFD0:RTVRC3)              CSC024
     F                                     PREFIX(Z_)                           CSC024
     FZATNRGL0  IF   E           K DISK
     FZATNRGL1  UF   E           K DISK
     F                                     RENAME(ZATNRGD0: ZATNRGD1)
     FZAAVSTL0  O  A E           K DISK    USROPN
     F                                     INFDS(@AVST)
     FZAAVSDL0  O  A E           K DISK    USROPN
     F                                     INFDS(@AVSD)
     FZAAVFFL0  O  A E           K DISK    USROPN
     F                                     INFDS(@AVFF)
     FTRADHS    IF   E           K DISK    USROPN
     FDPTMVR    IF   E           K DISK    USROPN
     FTRANS2    IF   E           K DISK    USROPN
 
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
 
     D @AVST           DS
     D  @NOR_ST              156    159B 0
      ** DATA STRUCTURE FOR AVAILABLE SECURITIES TRADES REFS
 
     D @AVSD           DS
     D  @NOR_SD              156    159B 0
      ** DATA STRUCTURE FOR AVAILABLE SECURITIES DEPOT MOVEMENT REFS
 
     D @AVFF           DS
     D  @NOR_FF              156    159B 0
      ** DATA STRUCTURE FOR AVAILABLE F&O TRANSACTION REFS
 
     D RUNDAT          DS            13
      ** DATA STRUCTURE FOR MULTIBRANCH INDICATOR USING RUNDAT.
     D  RUNDTdd                1      2  0
     D  RUNDTmm                3      5
     D  RUNDTyy                6      7  0
     D  RUNDYNO                8     10P 0
                                                                                CSC024
     DDS1              DS                                                       CSC024
     D TDRF                    1      6                                         CSC024
     D TNBF1                   1      6S 0                                      CSC024
     DDS2              DS                                                       CSC024
     D DPRN                    1      6                                         CSC024
     D TNBF2                   1      6S 0                                      CSC024
     DDS3              DS                                                       CSC024
     D TNBR                    1      6S 0                                      CSC024
     D TNBF3                   1      6S 0                                      CSC024
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     IZATNRGD1
     I              TNBF                        UPD_TNBF
 
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
 
     C                   MOVE      '   '         EndofFil
      *
      ** DO UNTIL TRANSACTION REFS CREATED IS >= TRANSACTION REFS REQUESTED
      *
     C     NoTRNCrt      DOUGE     NoTRNReq
     C                   EXSR      TRNGEN
     C                   END
      *
      **  Termination processing
      *
     C                   EXSR      TERM
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TRNGEN - TRANSACTION REFERENCES GENERATION                    *
      *                                                               *
      *****************************************************************
     C     TRNGEN        BEGSR
      *
      **  CHECK WHETHER TRANSACTION NUMBER USED ALREADY
      *
     C     CHK_TRAN      IFEQ      'Y'
     C                   EXSR      CHKTNUSED
     C                   END
      *
      **  IF NEXT TRANS. NO. >= START BACK OFFICE TRANS. NOS THEN
      **  Save the next available transaction number
      **  Set next available transaction number to 1
      **  Set end of file to YES
      **  AND CHECK WHETHER TRANSACTION NUMBER USED ALREADY
      *
     C     TNBF          IFGE      FNOR
     C                   Z-ADD     TNBF          S_TNBF            6 0
     C                   Z-ADD     1             TNBF
     C                   MOVE      'YES'         EndofFil          3
     C                   EXSR      CHKTNUSED
     C                   END
      *
      **  IF NO FURTHER NUMBERS AVAILABLE FOR ALLOCATION,
      **  Restore saved next available transaction number
      **  Exit
      *
     C     EndofFil      IFEQ      'YES'
     C     TNBF          ANDGE     Init_TNBF
     C                   Z-ADD     S_TNBF        TNBF
     C                   GOTO      ETRNGEN
     C                   END
      *
      **  Write a record to the relevant available trans ref file
      *
     C                   EXSR      WRTAV
      *
      **  ADD 1 TO NEXT AVAILABLE TRANSACTION NUMBER
      *
     C                   ADD       1             TNBF
      *
     C     ETRNGEN       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * CHKTNUSED - CHECK WHETHER TRANSACTION NUMBER USED ALREADY    *
      *                                                              *
      ****************************************************************
     C     CHKTNUSED     BEGSR
      *
      * CHECK IF SE TRADE REFERENCE USED ALREADY
      *
     C     MODU          IFEQ      'SE'
     C     TRTY          ANDEQ     'T'
     C                   MOVEL     TNBF          TDRF
     C     TDRF          SETLL     TRADSDF                                62
     C  N62TDRF          SETLL     HSTTRDF                                62
     C  N62TNBF1         SETLL     RTVRC1                                 62    CSC024
      *
     C     *IN62         DOWEQ     '1'
     C                   ADD       1             TNBF
     C                   MOVEL     TNBF          TDRF
     C     TDRF          SETLL     TRADSDF                                62
     C  N62TDRF          SETLL     HSTTRDF                                62
     C  N62TNBF1         SETLL     RTVRC1                                 62    CSC024
     C                   END
     C                   END
      *
      * CHECK IF SE DEPOT MOVEMENT REFERENCE USED ALREADY
      *
     C     MODU          IFEQ      'SE'
     C     TRTY          ANDEQ     'D'
     C                   MOVEL     TNBF          DPRN
     C     DPRN          SETLL     DPTMVR                                 62
     C  N62TNBF2         SETLL     RTVRC2                                 62    CSC024
      *
     C     *IN62         DOWEQ     '1'
     C                   ADD       1             TNBF
     C                   MOVEL     TNBF          DPRN
     C     DPRN          SETLL     DPTMVR                                 62
     C  N62TNBF2         SETLL     RTVRC2                                 62    CSC024
     C                   END
     C                   END
      *
      * CHECK IF FF TRANSACTION NUMBER USED ALREADY
      *
     C     MODU          IFEQ      'FF'
     C                   MOVEL     TNBF          TNBR
     C     TNBR          SETLL     TRANS2                                 62
     C  N62TNBF3         SETLL     RTVRC3                                 62    CSC024
      *
     C     *IN62         DOWEQ     '1'
     C                   ADD       1             TNBF
     C                   MOVEL     TNBF          TNBR
     C     TNBR          SETLL     TRANS2                                 62
     C  N62TNBF3         SETLL     RTVRC2                                 62    CSC024
     C                   END
     C                   END
      *
     C                   MOVE      'N'           CHK_TRAN          1
     C     TNBF          ADD       1             FNOR                           CSC024
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WRTAV - WRITE TO THE RELEVANT AVAILABLE TRANS REF FILE        *
      *                                                               *
      *****************************************************************
     C     WRTAV         BEGSR
 
     C                   MOVE      '0'           *IN61
      *
      **  WRITE A RECORD TO LF/ZAAVSTL0 (AVAILABLE SE TRADE REFS)
      *
     C     MODU          IFEQ      'SE'
     C     TRTY          ANDEQ     'T'
     C                   Z-ADD     TNBF          TNBR
     C                   WRITE     ZAAVSTD0                             61
     C                   END
      *
      **  WRITE A RECORD TO LF/ZAAVSDL0 (AVAILABLE SE DEPOT MOVE REFS)
      *
     C     MODU          IFEQ      'SE'
     C     TRTY          ANDEQ     'D'
     C                   Z-ADD     TNBF          TNBR
     C                   WRITE     ZAAVSDD0                             61
     C                   END
      *
      **  WRITE A RECORD TO LF/ZAAVFFL0 (AVAILABLE FF TRANS REFS)
      *
     C     MODU          IFEQ      'FF'
     C                   Z-ADD     TNBF          TNBR
     C                   WRITE     ZAAVFFD0                             61
     C                   END
      *
      **  ADD 1 TO NUMBER OF TRANSACTIONS ADDED IF WRITE EXECUTED
      *
     C     *IN61         IFEQ      '0'
     C                   ADD       1             NoTRNCrt
     C                   MOVE      'Y'           CHK_TRAN
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      *                                                              *
      *  TERM  - TERMINATION PROCESSING.                             *
      *                                                              *
      ****************************************************************
     C     TERM          BEGSR
      *
      **  IF RECORDS HAVE BEEN ADDED TO THE LF/ZAAVSTL0
      **  UPDATE NEXT TRANSACTION NUMBER ON ZATNRGPD
      *
     C     NoTRNCrt      IFGT      *ZERO
     C     ZATNRGK       CHAIN     ZATNRGL1                           61
     C     *IN61         IFEQ      '0'
     C                   Z-ADD     TNBF          UPD_TNBF
     C                   MOVE      RUNDYNO       LCD
     C                   MOVE      'A'           CHTP
     C                   UPDATE    ZATNRGD1
     C                   END
     C                   END
      *
      **  IF NO TRANSACTION NUMBERS WERE PRESENT AND
      **  NONE HAVE BEEN CREATED, IT IS A DATA BASE ERROR
      *
     C     NoTRNPrs      IFEQ      *ZERO
     C     NoTRNCrt      ANDEQ     *ZERO
     C                   MOVE      '800'         DBASE
     C                   MOVE      'ZATNRGPD'    DBFILE
     C                   MOVEL     'NO GEN'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DETTRNPRS - DETERMINE NUMBER OF TRANSACTION NUMBERS PRESENT   *
      *                                                               *
      *****************************************************************
     C     DETTRNPRS     BEGSR
      *
     C                   Z-SUB     1             NoTRNPrs          6 0
      *
      **  AVAILABLE SE TRADE REFS
      *
     C     MODU          IFEQ      'SE'
     C     TRTY          ANDEQ     'T'
     C                   OPEN      ZAAVSTL0
     C                   OPEN      TRADHS
     C                   Z-ADD     @NOR_ST       NoTRNPrs
     C                   END
      *
      **  AVAILABLE SE DEPOT MOVE REFS
      *
     C     MODU          IFEQ      'SE'
     C     TRTY          ANDEQ     'D'
     C                   OPEN      ZAAVSDL0
     C                   OPEN      DPTMVR
     C                   Z-ADD     @NOR_SD       NoTRNPrs
     C                   END
      *
      **  AVAILABLE FF TRANS REFS
      *
     C     MODU          IFEQ      'FF'
     C                   OPEN      ZAAVFFL0
     C                   OPEN      TRANS2
     C                   Z-ADD     @NOR_FF       NoTRNPrs
     C                   END
      *
      **  IF NOT SET, END PROGRAM
      *
     C     NoTRNPrs      IFLT      *ZERO
     C                   RETURN
     C                   END
 
     C                   ENDSR
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
      *
      **  RECEIVE INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    MODU              2
     C                   PARM                    TRTY              1
     C                   PARM                    NoTRNReq          6 0
      *
      **  MOVE PROGRAM NAME INTO STATUS DATA STRUCTURE FIELD.
      *
     C                   MOVEL     'ZATRNGEN'    DBPGM
      *
      ** READ DATA AREA - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      **  INITIALIZE NUMBER OF TRANSACTION NUMBERS CREATED
      *
     C                   Z-ADD     *ZERO         NoTRNCrt          6 0
      *
      **  ACCESS TRANSACTION NUMBER RANGES (AND NEXT AVAILABLE NUMBER)
      *
     C     ZATNRGK       KLIST
     C                   KFLD                    MODU
     C                   KFLD                    TRTY
     C     ZATNRGK       CHAIN     ZATNRGL0                           61
      *
      **  DATA BASE ERROR
      *
     C     *IN61         IFEQ      '1'
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     'ZATNRGL0'    DBFILE
     C                   MOVEL     MODU          DBKEY
     C                   MOVE      TRTY          DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      **  IF NEXT AVAILABLE TRANS NO. <= 0
      **  RESET TO 1.
      *
     C     TNBF          IFLE      0
     C                   Z-ADD     1             TNBF
     C                   END
      *
      **  IF NEXT AVAILABLE TRANS NO. IS >= BACK OFFICE START RANGE
      **  RESET TO 1.
      *
     C*****TNBF          IFGE      FNOR                                         CSC024
     C*****              Z-ADD     1             TNBF                           CSC024
     C*****              END                                                    CSC024
      *
      **  DETERMINE NUMBER OF TRANSACTION NUMBERS PRESENT (AND OPEN FILES)
      *
     C                   EXSR      DETTRNPRS
      *
      **  SUBTRACT NUMBER OF TRANSACTION NUMBERS PRESENT
      **  FROM NUMBER OF TRANSACTION NUMBERS TO CREATE
      *
     C                   SUB       NoTRNPrs      NoTRNReq
      *
      **  IF NUMBER OF RECORDS LEFT TO CREATE IS <= 0 - END PROGRAM
      *
     C     NoTRNReq      IFLE      *ZERO
     C                   RETURN
     C                   END
      *
      **  STORE INITIAL NEXT AVAILABLE TRANSACTION NUMBER
      *
     C                   Z-ADD     TNBF          Init_TNBF         6 0
      *
      **  CHECK WHETHER TRANSACTION NUMBER USED ALREADY
      *
     C                   EXSR      CHKTNUSED
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
