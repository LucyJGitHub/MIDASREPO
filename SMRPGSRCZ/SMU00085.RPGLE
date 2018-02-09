     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Upgrade LEFEEAD file')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00085 - Upgrade LEFEEAD with PC Reference                 *
      *                                                               *
      *  Function:  This program is run at installation time to set   *
      *             up new mandatory information on LEFEEAD file      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 158177 *CREATE     Date 05May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S15817705.                         *
      *  158177  - All transactions input through Midas must have     *
      *            a full PC reference                                *
      *                                                               *
      *****************************************************************
     FLEFEEAD   UF   E             DISK
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
     C*****************************************************************
     C*
     C                   READ      LEFEEAD                                50
     C*
     C     *IN50         DOWEQ     '0'
     C*
     C*
     C** Access the SDBRCHPD for the details of Transaction Branch
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      FABRCA        PBRCA             3
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
     C*
     C                   UPDATE    LEFEEADF
     C                   READ      LEFEEAD                                50
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
