     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Insert Decimal point and zeros for numeric *MODULE')
      **********************************************************************
      *                                                                    *
      *  Midas - Common processing                                         *
      *                                                                    *
      *     ZAEDITM - Insert Dec Point and 0's for Numeric                 *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      * This is an ILE module based on ZEDIT Subroutine                    *
      * This module is a component of service program ZA0001S              *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CLE004             Date 07MAR97                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  CLE004 - Created for Customer Lending Enhancements                *
      *                                                                    *
      **********************************************************************
     D ZA1             S              1    DIM(16)
     D ZA2             S              1    DIM(16)
     C**********************************************************************
     C**
     C**  ZEDIT SUBROUTINE TO INSERT A DECIMAL POINT INTO A NUMERIC FIELD
     C**  AND TO BLANK OUT LEADING ZEROES.
     C**      INPUT FIELDS:   ZFIELD 16/
     C*                       ZADEC
     C*                       ZADIG - NOT ACTUALLY USED
     C*
     C*       ARRAYS    ZA1 ,ZA2   BOTH 16 ELEMENTS, EACH ONE BYTE LONG.
     C*
     C*       OUTPUT FIELD   ZFIELD
     C*
     C**VERSION**
     C**CONVERT DAY NUMBER TO DATE
     C                   MOVE      '01.00.00'    WWVERS            8
     C                   MOVE      'ZAEDITM'     WWPGM            10
     C*
     C**  RECEIVING/RETURNING PARAMETERS FROM/TO CALLING PROGRAM
     C*
     C     *ENTRY        PLIST
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
     C*
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADEC         ZADEC             2 0
     C**
     C*       SET UP WORK FIELDS
     C*
     C                   MOVEA     ' '           ZA1
     C                   MOVEA     ' '           ZA2
     C*
     C                   Z-ADD     16            Z1                2 0
     C                   Z-ADD     16            Z2                2 0
     C*
     C     16            SUB       ZADEC         ZADEC2            2 0
     C*
     C*
     C                   MOVEA     ZFIELD        ZA1
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZADEC         COMP      0                                      91
     C   91              GOTO      ZT20
     C**
     C     ZT10          TAG
     C**
     C*
     C*       SET UP DECIMALS
     C*
     C                   MOVE      ZA1(Z1)       ZA2(Z2)
     C     Z1            SUB       1             Z1
     C     Z2            SUB       1             Z2
     C*
     C     Z2            COMP      0                                      90
     C   90              GOTO      ZT30
     C*
     C*       CHECK IF END OF DECIMALS
     C**
     C     Z2            COMP      ZADEC2                             90
     C   90              GOTO      ZT10
     C*
     C**
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZA2(Z2)
     C     Z2            SUB       1             Z2
     C*
     C     ZT20          TAG
     C*
     C*       SET UP INTEGERS
     C*
     C                   MOVE      ZA1(Z1)       ZA2(Z2)
     C     Z1            SUB       1             Z1
     C     Z2            SUB       1             Z2
     C**
     C     Z2            COMP      0                                  90
     C   90              GOTO      ZT20
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C     ZT30          TAG
     C**
     C                   Z-ADD     1             Z2
     C**
     C     ZT40          TAG
     C*
     C     ZA2(Z2)       COMP      '0'                                9090
     C   90ZA2(Z2)       COMP      ' '                                9090
     C*
     C   90              GOTO      ZT50
     C*
     C                   MOVE      ' '           ZA2(Z2)
     C     Z2            ADD       1             Z2
     C*
     C     Z2            COMP      16                                   90
     C   90              GOTO      ZT40
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZT50          TAG
     C*
     C                   Z-ADD     ZADEC2        Z2
     C  N91Z2            SUB       1             Z2
     C     ZA2(Z2)       COMP      ' '                                    90
     C   90              MOVE      '0'           ZA2(Z2)
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C     ZT60          TAG
     C*
     C                   MOVEA     ZA2           ZFIELD           16
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C*
