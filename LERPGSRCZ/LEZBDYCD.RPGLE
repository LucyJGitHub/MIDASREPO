     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Date Calculations using Business Day Conv')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEZBDYCD - Midas LE Date Calculations using Business Day     *
      *             Convention                                        *
      *                                                               *
      *  Function:  This program calculates next/previous working day *
      *             using the Business Day Convention currency/       *
      *             location set up for Lending Transactions.         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CLE141A            Date 28Apr16               *
      *  Prev Amend No. CLE141  *CREATE    Date 01Mar16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141A - CLE141 Change Control 1                            *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions - Phase 2                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

     D ArraySize       C                   CONST(11)                                         CLE141A
      ** Array Size                                                                          CLE141A
                                                                                             CLE141A
     D***ACUR***         S              3    DIM(10)                                         CLE141A
     D ACUR            S              3    DIM(ArraySize)                                    CLE141A
      ** Array containing Business Day Convention Currencies

     D***ALOC***         S              3    DIM(10)                                         CLE141A
     D ALOC            S              3    DIM(ArraySize)                                    CLE141A
      ** Array containing Business Day Convention Locations

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Program

     D/COPY ZSRSRC,ZHOLELE
     D/COPY ZSRSRC,ZHOLILE

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D PDAYNO          S              5  0
     D PCURR           S             30
     D PLOCN           S             30
     D PPAYC           S              1
     D PDFIN           S              1
     D PCCY            S              3                                                      CLE141A
     D PLOC            S              3                                                      CLE141A
     D PAJDT           S              5  0

     D WPAYC           S              1
     D I1              S              2  0
     D I2              S              2  0
     D Idx             S              2  0
     D WFLD            S              3
     D WMTH1           S              3
     D WMTH2           S              3
     D PDATE           S              6
     D PADAT           S              7
     D CURSET          S             33                                                      CLE141A
     D LOCSET          S             33                                                      CLE141A

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PDAYNO
     C                   PARM                    PCURR
     C                   PARM                    PLOCN
     C                   PARM                    PPAYC
     C                   PARM                    PDFIN
     C                   PARM                    PCCY                                        CLE141A
     C                   PARM                    PLOC                                        CLE141A
     C                   PARM                    PAJDT

      ** Compute next/previous working day

     C                   EVAL      CURSET = PCURR + PCCY                                     CLE141A
     C                   EVAL      LOCSET = PLOCN + PLOC                                     CLE141A
     C*****PCURR         IFEQ      *BLANKS                                                   CLE141A
     C     CURSET        IFEQ      *BLANKS                                                   CLE141A
     C     LOCSET        ANDEQ     *BLANKS                                                   CLE141A
     C     PPAYC         OREQ      'A'
     C                   Z-ADD     PDAYNO        PAJDT
     C                   ELSE
     C                   Z-ADD     PDAYNO        ZDAYNO
     C                   MOVEL     PPAYC         WPAYC
     C                   EXSR      SRAJDT
     C                   ENDIF

      ** End Program

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAJDT - Determines the Adjusted Date                        *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: ZDATE2, SRCHKH                                        *
      *                                                               *
      *****************************************************************
     C     SRAJDT        BEGSR

      ***Move*PCURR/PLOCN*in*an*array**********************************                      CLE141A
      ** Move Business Day Convention Currencies/Locations in an array                       CLE141A

     C                   EVAL      I1 = 1
     C                   EVAL      I2 = 1
     C                   EVAL      Idx = 1
     C**********         DOW       I1 <= 10                                                  CLE141A
     C**********         EVAL      WFLD = %SUBST(PCURR:I2:3)                                 CLE141A
     C                   DOW       I1 <= ArraySize                                           CLE141A
     C                   EVAL      WFLD = %SUBST(CURSET:I2:3)                                CLE141A
     C                   IF        WFLD <> *BLANKS
     C                   EVAL      ACUR(Idx) = WFLD
     C**********         EVAL      ALOC(Idx) = %SUBST(PLOCN:I2:3)                            CLE141A
     C                   EVAL      ALOC(Idx) = %SUBST(LOCSET:I2:3)                           CLE141A
     C                   EVAL      Idx = Idx + 1
     C                   ENDIF
     C                   EVAL      I1 = I1 + 1
     C                   EVAL      I2 = I2 + 3
     C                   ENDDO

     C                   EXSR      SRCHKH

      ** If PPAYC = M (modified) and computed date falls in a different
      ** calendar month, compute for previous working day instead

     C                   IF        PPAYC = 'M'

     C                   CALL      'ZDATE2'
     C                   PARM                    PDAYNO
     C                   PARM                    PDFIN
     C                   PARM                    PDATE
     C                   PARM                    PADAT

     C                   EVAL      WMTH1 = %SUBST(PADAT:3:3)

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    PDFIN
     C                   PARM                    PDATE
     C                   PARM                    PADAT

     C                   EVAL      WMTH2 = %SUBST(PADAT:3:3)

     C                   IF        WMTH1 <> WMTH2
     C                   EVAL      WPAYC = 'P'
     C                   SUB       1             ZDAYNO
     C                   EXSR      SRCHKH
     C                   ENDIF

     C                   ENDIF

     C                   Z-ADD     ZDAYNO        PAJDT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKH - Determines if Date is a Holiday                     *
      *                                                               *
      *  Called by: SRAJDT                                            *
      *                                                               *
      *  Calls: ZCHKH                                                 *
      *                                                               *
      *****************************************************************
     C     SRCHKH        BEGSR

      ** Check if date is a holiday for each CCY/LOC convention

     C                   EVAL      I1 = 1
     C**********         DOW       I1 <= 10 and                                              CLE141A
     C                   DOW       I1 <= ArraySize and                                       CLE141A
     C                             ACUR(I1) <> *BLANKS

     C                   EVAL      ZCCY = ACUR(I1)
     C                   EVAL      ZLOC = ALOC(I1)
     C                   EXSR      ZCHKH

     C                   IF        ZIND = 'H'

     C                   SELECT
     C                   WHEN      WPAYC = 'N' or
     C                             WPAYC = 'M' or
     C                             WPAYC = *BLANKS
     C                   ADD       1             ZDAYNO
     C                   WHEN      WPAYC = 'P'
     C                   SUB       1             ZDAYNO
     C                   OTHER
     C                   ADD       1             ZDAYNO
     C                   ENDSL

     C                   EVAL      I1 = 1

     C                   ELSE
     C                   EVAL      I1 = I1 + 1
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZCHKHLE
      *****************************************************************
