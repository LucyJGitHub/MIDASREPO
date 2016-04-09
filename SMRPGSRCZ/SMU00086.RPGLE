     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Upgrade LEFEED file')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00086 - Upgrade LEFEED with PC Reference                  *
      *                                                               *
      *  Function:  This program is run at installation time to set   *
      *             up new mandatory information on LEFEED file.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 146485             Date 19Jan99               *
      *                 147893             Date 04Dec98               *
      *                 141453             Date 05Oct98               *
      *                 158177 *CREATE     Date 05May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  BG26993- Delivery of upgrade programs to core.               *
      *         - Renamed program S15817706.                          *
      *  146485 - Upgrade program to correct fee records which contain*
      *           values in ROCN...etc even if the settlement method  *
      *           used is '05'.                                       *
      *  147893 - LER180 not including previous outstanding accrual   *
      *  141453 - Utility program to determine a fee whether it is    *
      *           an Old or New fee.  Also, this program initialises  *
      *           fields FEWOFF and FEINDC.                           *
      *  158177 - All transactions input through Midas must have      *
      *           a full PC reference                                 *
      *                                                               *
      *****************************************************************
     FLEFEED    UF   E             DISK
      *****************************************************************
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  External DS for Branch Details
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  DS for access programs, long data structure
      *
      *
      * DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
      *
     D                 DS                                                       146485
     D  RIBANK                 1     43                                         146485
     D  RIBN                   1      8                                         146485
     D  RIBA                   9     43                                         146485
     C*****************************************************************
     C*
     C                   READ      LEFEED                                 50
     C*
     C     *IN50         DOWEQ     '0'
     C*
     C*
     C** Access the SDBRCHPD for the details of Transaction Branch
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      FEBRCA        PBRCA             3
     C     SDBRCH        PARM      *BLANK        DSSDY
     C*
     C                   MOVEL     A8MQSM        W#1ST3            3
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C*
      ** Initialise FEWOFF and FEINDC to 0 and ' ' respectively.          141453
      *                                                                   141453
     C                   Z-ADD     0             FEWOFF                                        14145
     C***********          MOVE ' '       FEINDC                   141453 147893
      *                                                                   141453
     C***********FECALT    IFNE *BLANK                             141453 147893
     C***********FESDAT    ANDNE*ZEROS                             141453 147893
      *                                                                   141453
     C                   MOVEL     'Y'           FEINDC                                        14145
     C***********          ENDIF                                   141453 147893
     C*
     C     RSTM          IFEQ      05                                                          14648
      *                                                                   146485
     C     RIBANK        IFNE      *BLANK                                                      14648
     C     ROBN          ORNE      *BLANK                                                      14648
     C     ROCN          ORNE      *BLANK                                                      14648
      *                                                                   146485
     C                   MOVEL     *BLANK        RIBN                                          14648
     C                   MOVEL     *BLANK        RIBA                                          14648
     C                   MOVEL     *BLANK        ROBN                                          14648
     C                   MOVEL     *BLANK        ROCN                                          14648
     C                   ENDIF                                                                 14648
     C                   ENDIF                                                                 14648
      *                                                                   146485
     C                   UPDATE    LEFEEDF
     C                   READ      LEFEED                                 50
     C                   ENDDO
     C*
     C                   SETON                                        LR
     C*
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
