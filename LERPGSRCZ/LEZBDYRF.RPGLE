     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Rate Fix Date Calc. using Bus. Day Conv')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEZBDYCD - Midas LE Rate Fixing Date Calculation using       *
      *             Busniess Day Convention                           *
      *                                                               *
      *  Function:  This program will serve as Rate Fixing Date       *
      *             Calculation module using all the currencies/      *
      *             locations defined on Business Day Convention      *
      *             for Rate Fixing                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CLE141  *CREATE    Date 01Mar16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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

     D ACUR            S              3    DIM(10)
      ** Array containing Business Day Convention Currencies

     D ALOC            S              3    DIM(10)
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
     D PRFDAY          S              2  0
     D PCURR           S             30
     D PLOCN           S             30
     D PMODE           S              1
     D POUTDAY         S              5  0

      ** ZCHKH Parameters
     D PDAY            S              5  0
     D PCCY            S              3
     D PLOC            S              3
     D PHOLI           S              1

     D I1              S              2  0
     D I2              S              2  0
     D Idx             S              2  0
     D WFLD            S              3

      ** Holiday found work field
     D  WHolInd        S              1

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PDAYNO
     C                   PARM                    PRFDAY
     C                   PARM                    PCURR
     C                   PARM                    PLOCN
     C                   PARM                    PMODE
     C                   PARM                    POUTDAY

     C                   EVAL      POUTDAY = PDAYNO

     C                   IF        PRFDAY > 0

      ** Move PCURR/PLOCN in an array

     C                   EVAL      I1 = 1
     C                   EVAL      I2 = 1
     C                   EVAL      Idx = 1
     C                   DOW       I1 <= 10
     C                   EVAL      WFLD = %SUBST(PCURR:I2:3)
     C                   IF        WFLD <> *BLANKS
     C                   EVAL      ACUR(Idx) = WFLD
     C                   EVAL      ALOC(Idx) = %SUBST(PLOCN:I2:3)
     C                   EVAL      Idx = Idx + 1
     C                   ENDIF
     C                   EVAL      I1 = I1 + 1
     C                   EVAL      I2 = I2 + 3
     C                   ENDDO

      ** Calculate working day

     C                   EXSR      SRCALC
     C                   ENDIF

      ** End Program

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALC - Calculate Working Days                              *
      *                                                               *
      *****************************************************************
     C     SRCALC        BEGSR

     C                   EVAL      I1 = 1
     C                   DOW       I1 <= PRFDAY

      ** Increment/Decrement Date by 1 until it is no longer a holiday
      ** from the currencies/locations for Rate Fixing Convention

     C                   DOU       WHolInd = 'N'

     C                   EVAL      WHolInd = 'N'

      ** Calculate working days based on PMODE F=Forward or B=Backward

     C                   IF        PMODE = 'F'
     C                   EVAL      POUTDAY = POUTDAY + 1
     C                   ELSE
     C                   EVAL      POUTDAY = POUTDAY - 1
     C                   ENDIF

      ** Check if date is a holiday for each CCY/LOC convention

     C                   EVAL      Idx = 1
     C                   DOW       Idx <= 10 and
     C                             ACUR(Idx) <> *BLANKS

     C                   EVAL      ZDAYNO = POUTDAY
     C                   EVAL      ZCCY   = ACUR(Idx)
     C                   EVAL      ZLOC   = ALOC(Idx)
     C                   EXSR      ZCHKH

      ** If date is a holiday, set Holiday Found Indicator to Y

     C                   IF        ZIND = 'H'
     C                   EVAL      WHolInd = 'Y'
     C                   ENDIF

     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
     C                   ENDDO

     C                   EVAL      I1 = I1 + 1
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZCHKHLE
      *****************************************************************
