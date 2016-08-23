     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Details Convert Module')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTCVT - Forward Rates Details Conversion:                *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Forward Rates*
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 240491             Date 13Sep06               *
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 235720             Date 18Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196570             Date 24Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 09Oct00               *
      *                 CAP059  *CREATE    Date 09Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240491 - First forward rate must show updated spot rate.     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  235720 - JPY is not allowed to have 8 decimal places. Decimal*
      *           places for spot rate is selected based on its diffe-*
      *           rence to the decimal place of the base rate. This   *
      *           selection should be removed.                        *
      *  196570 - Patch for Market Data Feed                          *
      *  CSD006 - Market Data Feed                                    *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *                                                               *
      *****************************************************************
 
      ** MDF Request Details by Request Id
     FSDMDFRL1  IF   E           K DISK    INFSR(*PSSR)                         CSD006
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the FD standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D TranFilFmt    E DS                  EXTNAME(FWDRTFE)
     D                                     PREFIX(fw)
      ** Forward Rates Transaction Details in File Format
 
     D TrnDets       E DS                  EXTNAME(FDFWRTPD)
     D   DDTSDT                       6    OVERLAY(DDDFTS:3)
     D   DDTSTM                       6    OVERLAY(DDDFTS:9)
      ** Forward Rates Transaction Details in Screen Format
 
     D                 DS
     D arDFW                               LIKE(fwDFW)
     D  NoDayFrwd                     5P 0 Dim(25) OVERLAY(arDFW)
     D  NoDayFrwdA                    3    Dim(25) OVERLAY(arDFW)
      ** Number of Days Forward Array
 
     D                 DS
     D arRFW                               LIKE(fwRFW)
     D  FrwdRte                      13P 8 Dim(25) OVERLAY(arRFW)
     D  FrwdRteA                      7    Dim(25) OVERLAY(arRFW)
      ** Forward Rates Array
 
     D                 DS
     D arPNF                               LIKE(fwPNF)
     D  FrwdPte                      13P 8 Dim(25) OVERLAY(arPNF)
     D  FrwdPteA                      7    Dim(25) OVERLAY(arPNF)
      ** Forward Points Array
 
     D                 DS
     D arSFW                               LIKE(fwSFW)
     D  FrwdSign                      1A   Dim(25) OVERLAY(arSFW)
      ** Forward Sign Array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SDMAPC        E DS                  EXTNAME(SDMAPCPD)
      ** External DS for Market Data Feed Mapping Codes
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D TimeStmpDS      DS
      ** Timestamp data structure (Century, Year, Month, Day, Hour, Minute and Second)
     D WCENT                   1      2
     D WYEAR                   3      4
     D WMONTH                  5      6
     D WDAY                    7      8
     D WHOUR                   9     10
     D WMINUT                 11     12
     D WSECON                 13     14
     D WTIME                   9     14
 
     D TStmpDspDS      DS
      ** Timestamp data structure for Display
     D WCNTD                   1      2
     D WDATE                   3      8
     D  WDAT1                         2    OVERLAY (WDATE:1)
     D  WDAT2                         2    OVERLAY (WDATE:3)
     D  WYRD                          2    OVERLAY (WDATE:5)
     D WTMED                   9     14
 
     D*WKFLD12p6*******S             13P 6                                                    196570
     D*WKFLD12p7*******S             13P 7                                                    196570
     D*** WKFLD13p6       S             13P 6                                          196570 235720
     D*** WKFLD13p7       S             13P 7                                          196570 235720
     D*WKFLD12p8*******S             12P 8                                                    196570
     D WKFLD13p8       S             13P 8
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Base Currency Number of decimal places
     D BCCDP           S              1  0
 
      ** Difference in Number of decimal places between Fwrd Ccy
      ** and Base Ccy
     D*** DiffNDP         S              1  0                                                 235720
 
      ** 'IN' Currency Work Field
     D InCcy           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      INIT
 
      ** Set screen fields
 
     C                   EXSR      SCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Currency Code
     C                   Eval      DDCCY = fwCCY
 
      ** Data Request Id
 
     C                   EVAL      DDDFRI = FwFRDTRF
 
      * Move data from FWDRTFE into array
     C                   MOVE      fwDFW         arDFW
 
      * Forward Days
 
     C                   IF        NoDayFrwdA(1) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(1)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS1
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS1
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(2) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(2)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS2
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS2
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(3) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(3)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS3
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS3
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(4) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(4)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS4
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS4
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(5) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(5)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS5
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS5
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(6) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(6)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS6
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS6
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(7) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(7)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS7
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS7
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(8) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(8)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS8
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS8
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(9) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(9)  ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDYS9
     C                   ELSE
     C                   MOVE      *BLANKS       DDDYS9
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(10) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(10) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY10
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY10
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(11) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(11) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY11
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY11
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(12) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(12) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY12
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY12
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(13) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(13) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY13
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY13
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(14) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(14) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY14
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY14
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(15) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(15) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY15
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY15
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(16) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(16) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY16
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY16
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(17) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(17) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY17
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY17
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(18) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(18) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY18
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY18
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(19) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(19) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY19
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY19
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(20) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(20) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY20
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY20
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(21) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(21) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY21
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY21
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(22) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(22) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY22
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY22
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(23) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(23) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY23
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY23
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(24) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(24) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY24
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY24
     C                   ENDIF
 
     C                   IF        NoDayFrwdA(25) <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NoDayFrwd(25) ZFIELD
     C                   EXSR      ZEDITDay
     C                   MOVE      ZFIELD        DDDY25
     C                   ELSE
     C                   MOVE      *BLANKS       DDDY25
     C                   ENDIF
 
      * Access currency data for the forward rate
      * (Database error handling done in access program).
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      fwCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      * Calculate the difference in decimal places between forward
      * rate currency and base currency
 
     C**********         EVAL      DiffNDP = A6NBDP - BCCDP + 4                               235720
 
 
      * If S01432 is on diplay points, if not display the rates
 
     C                   IF        S01432 = 'Y'
     C                   EXSR      PointsSR
 
     C                   ELSE
 
     C                   EXSR      RatesSR
     C                   ENDIF
 
      * Move data from FWDRTFE into array
     C                   IF        S01432 = 'Y'
     C                   MOVE      fwSFW         arSFW
 
      * Forward Sign
     C                   IF        FrwdSign(1) <> '+'
     C                             AND FrwdSign(1) <> '-'
     C                   MOVE      *BLANKS       DDSFW1
     C                   ELSE
     C                   Eval      DDSFW1 = FrwdSign(1)
     C                   ENDIF
 
     C                   IF        FrwdSign(2) <> '+'
     C                             AND FrwdSign(2) <> '-'
     C                   MOVE      *BLANKS       DDSFW2
     C                   ELSE
     C                   Eval      DDSFW2 = FrwdSign(2)
     C                   ENDIF
 
     C                   IF        FrwdSign(3) <> '+'
     C                             AND FrwdSign(3) <> '-'
     C                   MOVE      *BLANKS       DDSFW3
     C                   ELSE
     C                   Eval      DDSFW3 = FrwdSign(3)
     C                   ENDIF
 
     C                   IF        FrwdSign(4) <> '+'
     C                             AND FrwdSign(4) <> '-'
     C                   MOVE      *BLANKS       DDSFW4
     C                   ELSE
     C                   Eval      DDSFW4 = FrwdSign(4)
     C                   ENDIF
 
     C                   IF        FrwdSign(5) <> '+'
     C                             AND FrwdSign(5) <> '-'
     C                   MOVE      *BLANKS       DDSFW5
     C                   ELSE
     C                   Eval      DDSFW5 = FrwdSign(5)
     C                   ENDIF
 
     C                   IF        FrwdSign(6) <> '+'
     C                             AND FrwdSign(6) <> '-'
     C                   MOVE      *BLANKS       DDSFW6
     C                   ELSE
     C                   Eval      DDSFW6 = FrwdSign(6)
     C                   ENDIF
 
     C                   IF        FrwdSign(7) <> '+'
     C                             AND FrwdSign(7) <> '-'
     C                   MOVE      *BLANKS       DDSFW7
     C                   ELSE
     C                   Eval      DDSFW7 = FrwdSign(7)
     C                   ENDIF
 
     C                   IF        FrwdSign(8) <> '+'
     C                             AND FrwdSign(8) <> '-'
     C                   MOVE      *BLANKS       DDSFW8
     C                   ELSE
     C                   Eval      DDSFW8 = FrwdSign(8)
     C                   ENDIF
 
     C                   IF        FrwdSign(9) <> '+'
     C                             AND FrwdSign(9) <> '-'
     C                   MOVE      *BLANKS       DDSFW9
     C                   ELSE
     C                   Eval      DDSFW9 = FrwdSign(9)
     C                   ENDIF
 
     C                   IF        FrwdSign(10) <> '+'
     C                             AND FrwdSign(10) <> '-'
     C                   MOVE      *BLANKS       DDSF10
     C                   ELSE
     C                   Eval      DDSF10 = FrwdSign(10)
     C                   ENDIF
 
     C                   IF        FrwdSign(11) <> '+'
     C                             AND FrwdSign(11) <> '-'
     C                   MOVE      *BLANKS       DDSF11
     C                   ELSE
     C                   Eval      DDSF11 = FrwdSign(11)
     C                   ENDIF
 
     C                   IF        FrwdSign(12) <> '+'
     C                             AND FrwdSign(12) <> '-'
     C                   MOVE      *BLANKS       DDSF12
     C                   ELSE
     C                   Eval      DDSF12 = FrwdSign(12)
     C                   ENDIF
 
     C                   IF        FrwdSign(13) <> '+'
     C                             AND FrwdSign(13) <> '-'
     C                   MOVE      *BLANKS       DDSF13
     C                   ELSE
     C                   Eval      DDSF13 = FrwdSign(13)
     C                   ENDIF
 
     C                   IF        FrwdSign(14) <> '+'
     C                             AND FrwdSign(14) <> '-'
     C                   MOVE      *BLANKS       DDSF14
     C                   ELSE
     C                   Eval      DDSF14 = FrwdSign(14)
     C                   ENDIF
 
     C                   IF        FrwdSign(15) <> '+'
     C                             AND FrwdSign(15) <> '-'
     C                   MOVE      *BLANKS       DDSF15
     C                   ELSE
     C                   Eval      DDSF15 = FrwdSign(15)
     C                   ENDIF
 
     C                   IF        FrwdSign(16) <> '+'
     C                             AND FrwdSign(16) <> '-'
     C                   MOVE      *BLANKS       DDSF16
     C                   ELSE
     C                   Eval      DDSF16 = FrwdSign(16)
     C                   ENDIF
 
     C                   IF        FrwdSign(17) <> '+'
     C                             AND FrwdSign(17) <> '-'
     C                   MOVE      *BLANKS       DDSF17
     C                   ELSE
     C                   Eval      DDSF17 = FrwdSign(17)
     C                   ENDIF
 
     C                   IF        FrwdSign(18) <> '+'
     C                             AND FrwdSign(18) <> '-'
     C                   MOVE      *BLANKS       DDSF18
     C                   ELSE
     C                   Eval      DDSF18 = FrwdSign(18)
     C                   ENDIF
 
     C                   IF        FrwdSign(19) <> '+'
     C                             AND FrwdSign(19) <> '-'
     C                   MOVE      *BLANKS       DDSF19
     C                   ELSE
     C                   Eval      DDSF19 = FrwdSign(19)
     C                   ENDIF
 
     C                   IF        FrwdSign(20) <> '+'
     C                             AND FrwdSign(20) <> '-'
     C                   MOVE      *BLANKS       DDSF20
     C                   ELSE
     C                   Eval      DDSF20 = FrwdSign(20)
     C                   ENDIF
 
     C                   IF        FrwdSign(21) <> '+'
     C                             AND FrwdSign(21) <> '-'
     C                   MOVE      *BLANKS       DDSF21
     C                   ELSE
     C                   Eval      DDSF21 = FrwdSign(21)
     C                   ENDIF
 
     C                   IF        FrwdSign(22) <> '+'
     C                             AND FrwdSign(22) <> '-'
     C                   MOVE      *BLANKS       DDSF22
     C                   ELSE
     C                   Eval      DDSF22 = FrwdSign(22)
     C                   ENDIF
 
     C                   IF        FrwdSign(23) <> '+'
     C                             AND FrwdSign(23) <> '-'
     C                   MOVE      *BLANKS       DDSF23
     C                   ELSE
     C                   Eval      DDSF23 = FrwdSign(23)
     C                   ENDIF
 
     C                   IF        FrwdSign(24) <> '+'
     C                             AND FrwdSign(24) <> '-'
     C                   MOVE      *BLANKS       DDSF24
     C                   ELSE
     C                   Eval      DDSF24 = FrwdSign(24)
     C                   ENDIF
 
     C                   IF        FrwdSign(25) <> '+'
     C                             AND FrwdSign(25) <> '-'
     C                   MOVE      *BLANKS       DDSF25
     C                   ELSE
     C                   Eval      DDSF25 = FrwdSign(25)
     C                   ENDIF
     C                   ENDIF
 
 
      * If CSD006 is on diplay MDF data
 
     C                   IF        CSD006 = 'Y'
      * Convert the timestamp                                                   CSD006
     C                   IF        fwFRDFTS = *ZERO                             CSD006
     C                   EVAL      DDDFTS = *BLANK                              CSD006
 
     C                   ELSE                                                   CSD006
 
      ** Check if Data Request Id exists from the Request details               CSD006
 
     C     DDDFRI        CHAIN     SDMDFRL1                           81        CSD006
 
      ** Access Market Data Feed Mapping Code to get Request type               CSD006
 
     C     *IN81         IFEQ      FALSE                                        CSD006
     C                   CALL      'AOMAPCR0'                                   CSD006
     C                   PARM      *BLANK        @RTCD                          CSD006
     C                   PARM      '*KEY   '     @OPTN                          CSD006
     C                   PARM      MRMAPC        PMAPCD           32            CSD006
     C     SDMAPC        PARM      SDMAPC        DSFDY                          CSD006
 
      ** Database error                                                         CSD006
 
     C     @RTCD         IFNE      *BLANKS                                      CSD006
     C                   MOVEL     'SDMAPCPD'    DBFILE                         CSD006
     C                   Z-ADD     7             DBASE                          CSD006
     C                   MOVEL     MRMAPC        DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
 
      ** Data Request Id is found, check if its a borrow or a lending request   CSD006
      ** otherwise blank out timestamp                                          CSD006
                                                                                CSD006
     C     @RTCD         IFEQ      *BLANK                                       CSD006
     C                   MOVE      fwFRDFTS      TimeStmpDS                     CSD006
     C                   ENDIF                                                  CSD006
     C                   ELSE                                                   CSD006
                                                                                CSD006
      ** Data Request Id not found, blank out timestamp                         CSD006
                                                                                CSD006
     C                   EVAL      DDDFTS = *BLANK                              CSD006
     C                   ENDIF                                                  CSD006
 
      ** Format timestamp for display if its not blank                          CSD006
 
     C     TimeStmpDS    IFNE      *BLANK                                       CSD006
     C                   EXSR      SrFMTTMESTMP                                 CSD006
     C                   EVAL      DDDFTS = TStmpDspDS                          CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
 
     C                   ENDIF                                                  CSD006
 
     C                   IF        DDDFRI = *BLANK                                            196570
     C                   EVAL      DDDFTS = *BLANK                                            196570
     C                   ENDIF                                                                196570
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrFMTTMESTMP - Format Timestamp for Display                   *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrFMTTMESTMP  BEGSR                                                  CSD006
 
      ** Format date according to midas date format indicator                   CSD006
 
     C     BJDFIN        IFEQ      'D'                                          CSD006
     C                   MOVE      WDAY          WDAT1                          CSD006
     C                   MOVE      WMONTH        WDAT2                          CSD006
     C                   ELSE                                                   CSD006
     C                   MOVE      WMONTH        WDAT1                          CSD006
     C                   MOVE      WDAY          WDAT2                          CSD006
     C                   ENDIF
                                                                                CSD006
     C                   EVAL      WCNTD = WCENT                                CSD006
     C                   EVAL      WYRD  = WYEAR                                CSD006
     C                   EVAL      WTMED = WTIME
                                                                                CSD006
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PointsSR - Display points if S01432 is on.                    *
      *                                                               *
      *****************************************************************
     C     PointsSR      BEGSR
 
      **If*insert*or*amend*default*spot*rate*into*first*rate*field****                        240491
      * Always default spot rate into the first rate field                                    240491
 
     C**********         IF        DDACTN = 'I' OR DDACTN = 'A'                               240491
     C                   EXSR      srCLR
     C                   MOVE      A6SPRT        WKFLD13P8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE1
 
     C**********         ELSE                                                                 240491
      **********                                                                              240491
     C**********         MOVE      fwRFW         arRFW                                        240491
      **********                                                                              240491
     C**********         IF        FrwdRteA(1) <> *BLANK                                      240491
     C**********         EXSR      SrCLR                                                      240491
     C**********         Z-ADD     FrwdRte(1)    WKFLD13p8                                    240491
     C**********         EXSR      srDECP                                                     240491
     C**********         MOVE      ZFIELD        DDRTE1                                       240491
     C**********         ELSE                                                                 240491
     C**********         MOVE      *BLANKS       DDRTE1                                       240491
     C**********         ENDIF                                                                240491
     C**********         ENDIF                                                                240491
 
      * Move data from FWDRTFE into array
     C                   MOVE      fwPNF         arPNF
 
     C                   IF        FrwdPteA(2) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(2)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE2
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE2
     C                   ENDIF
 
     C                   IF        FrwdPteA(3) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(3)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE3
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE3
     C                   ENDIF
 
     C                   IF        FrwdPteA(4) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(4)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE4
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE4
     C                   ENDIF
 
     C                   IF        FrwdPteA(5) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(5)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE5
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE5
     C                   ENDIF
 
     C                   IF        FrwdPteA(6) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(6)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE6
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE6
     C                   ENDIF
 
     C                   IF        FrwdPteA(7) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(7)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE7
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE7
     C                   ENDIF
 
     C                   IF        FrwdPteA(8) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(8)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE8
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE8
     C                   ENDIF
 
     C                   IF        FrwdPteA(9) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(9)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE9
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE9
     C                   ENDIF
 
     C                   IF        FrwdPteA(10) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(10)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT10
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT10
     C                   ENDIF
 
     C                   IF        FrwdPteA(11) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(11)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT11
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT11
     C                   ENDIF
 
     C                   IF        FrwdPteA(12) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(12)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT12
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT12
     C                   ENDIF
 
     C                   IF        FrwdPteA(13) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(13)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT13
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT13
     C                   ENDIF
 
     C                   IF        FrwdPteA(14) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(14)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT14
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT14
     C                   ENDIF
 
     C                   IF        FrwdPteA(15) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(15)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT15
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT15
     C                   ENDIF
 
     C                   IF        FrwdPteA(16) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(16)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT16
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT16
     C                   ENDIF
 
     C                   IF        FrwdPteA(17) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(17)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT17
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT17
     C                   ENDIF
 
     C                   IF        FrwdPteA(18) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(18)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT18
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT18
     C                   ENDIF
 
     C                   IF        FrwdPteA(19) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(19)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT19
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT19
     C                   ENDIF
 
     C                   IF        FrwdPteA(20) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(20)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT20
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT20
     C                   ENDIF
 
     C                   IF        FrwdPteA(21) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(21)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT21
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT21
     C                   ENDIF
 
     C                   IF        FrwdPteA(22) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(22)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT22
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT22
     C                   ENDIF
 
     C                   IF        FrwdPteA(23) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(23)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT23
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT23
     C                   ENDIF
 
     C                   IF        FrwdPteA(24) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(24)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT24
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT24
     C                   ENDIF
 
     C                   IF        FrwdPteA(25) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdPte(25)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT25
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT25
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RatesSR - Display Rates if S01432 is off.                     *
      *                                                               *
      *****************************************************************
     C     RatesSR       BEGSR
 
      * Move data from FWDRTFE into array
     C                   MOVE      fwRFW         arRFW
 
     C                   IF        FrwdRteA(1) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(1)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE1
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE1
     C                   ENDIF
 
     C                   IF        FrwdRteA(2) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(2)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE2
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE2
     C                   ENDIF
 
     C                   IF        FrwdRteA(3) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(3)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE3
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE3
     C                   ENDIF
 
     C                   IF        FrwdRteA(4) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(4)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE4
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE4
     C                   ENDIF
 
     C                   IF        FrwdRteA(5) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(5)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE5
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE5
     C                   ENDIF
 
     C                   IF        FrwdRteA(6) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(6)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE6
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE6
     C                   ENDIF
 
     C                   IF        FrwdRteA(7) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(7)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE7
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE7
     C                   ENDIF
 
     C                   IF        FrwdRteA(8) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(8)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE8
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE8
     C                   ENDIF
 
     C                   IF        FrwdRteA(9) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(9)    WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRTE9
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE9
     C                   ENDIF
 
     C                   IF        FrwdRteA(10) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(10)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT10
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT10
     C                   ENDIF
 
     C                   IF        FrwdRteA(11) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(11)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT11
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT11
     C                   ENDIF
 
     C                   IF        FrwdRteA(12) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(12)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT12
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT12
     C                   ENDIF
 
     C                   IF        FrwdRteA(13) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(13)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT13
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT13
     C                   ENDIF
 
     C                   IF        FrwdRteA(14) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(14)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT14
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT14
     C                   ENDIF
 
     C                   IF        FrwdRteA(15) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(15)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT15
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT15
     C                   ENDIF
 
     C                   IF        FrwdRteA(16) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(16)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT16
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT16
     C                   ENDIF
 
     C                   IF        FrwdRteA(17) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(17)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT17
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT17
     C                   ENDIF
 
     C                   IF        FrwdRteA(18) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(18)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT18
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT18
     C                   ENDIF
 
     C                   IF        FrwdRteA(19) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(19)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT19
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT19
     C                   ENDIF
 
     C                   IF        FrwdRteA(20) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(20)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT20
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT20
     C                   ENDIF
 
     C                   IF        FrwdRteA(21) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(21)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT21
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT21
     C                   ENDIF
 
     C                   IF        FrwdRteA(22) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(22)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT22
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT22
     C                   ENDIF
 
     C                   IF        FrwdRteA(23) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(23)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT23
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT23
     C                   ENDIF
 
     C                   IF        FrwdRteA(24) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(24)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT24
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT24
     C                   ENDIF
 
     C                   IF        FrwdRteA(25) <> *BLANK
     C                   EXSR      srCLR
     C                   Z-ADD     FrwdRte(25)   WKFLD13p8
     C                   EXSR      srDECP
     C                   MOVE      ZFIELD        DDRT25
     C                   ELSE
     C                   MOVE      *BLANKS       DDRT25
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * srDECP- Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     srDECP        BEGSR
 
     C**********         SELECT                                                               235720
 
      * Set up the number of decimal places
 
     C**********         WHEN      DiffNDP = 1                                                235720
     C*******************Z-ADD     WKFLD13p8     WKFLD12p6                                    196570
     C*******************MOVE      WKFLD12p6     ZFIELD                                       196570
     C**********         Z-ADD     WKFLD13p8     WKFLD13p6                             196570 235720
     C**********         MOVE      WKFLD13p6     ZFIELD                                196570 235720
     C**********         EVAL      ZADEC = 6                                                  235720
 
     C**********         WHEN      DiffNDP = 2                                                235720
     C*******************Z-ADD     WKFLD13p8     WKFLD12p7                                    196570
     C*******************MOVE      WKFLD12p7     ZFIELD                                       196570
     C**********         Z-ADD     WKFLD13p8     WKFLD13p7                             196570 235720
     C**********         MOVE      WKFLD13p7     ZFIELD                                196570 235720
     C**********         EVAL      ZADEC = 7                                                  235720
 
     C**********         OTHER                                                                235720
     C*******************Z-ADD     WKFLD13p8     WKFLD12p8                                    196570
     C*******************MOVE      WKFLD12p8     ZFIELD                                       196570
     C                   MOVE      WKFLD13p8     ZFIELD                                       196570
     C                   EVAL      ZADEC = 8
     C**********         ENDSL                                                                235720
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C**********         SELECT                                                               235720
 
     C**********         WHEN      DiffNDP = 1                                                235720
     C**********                   AND ZFIELD = '        0.000000'                            235720
     C**********         EVAL      ZFIELD = *BLANK                                            235720
 
     C**********         WHEN      DiffNDP = 2                                                235720
     C**********                   AND ZFIELD = '       0.0000000'                            235720
     C**********         EVAL      ZFIELD = *BLANK                                            235720
 
     C**********         OTHER                                                                235720
     C                   IF        ZFIELD = '      0.00000000'
     C                   EVAL      ZFIELD = *BLANK
     C                   ENDIF
 
     C**********         ENDSL                                                                235720
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * srCLR - Clear fields                                          *
      *                                                               *
      *****************************************************************
     C     srCLR         BEGSR
     C
     C*******************CLEAR                   WKFLD12p6                                    196570
     C*******************CLEAR                   WKFLD12p7                                    196570
     C*******************CLEAR                   WKFLD12p8                                    196570
     C**********         CLEAR                   WKFLD13p6                             196570 235720
     C**********         CLEAR                   WKFLD13p7                             196570 235720
     C                   CLEAR                   ZFIELD
     C                   CLEAR                   WKFLD13p8
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDITDay - Edit the Day Field                                 *
      *                                                               *
      *****************************************************************
     C     ZEDITDay      BEGSR
 
      * Set up the number of deciamal places
 
     C                   EVAL      ZADEC = 0
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   IF        ZFIELD = '               0'
     C                   EVAL      ZFIELD = *BLANK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZA0770 - Convert YYYYMMDD to date XXXXXX                      *
      *                                                               *
      *****************************************************************
     C     ZA0770        BEGSR
 
     C                   CALLB     'ZA0770'
     C                   PARM                    RetCodeIn
     C                   PARM                    DateIn            8 0
     C                   PARM                    BJDFIN
     C                   PARM                    DateOut           6 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs
 
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     ##ACTN        DDACTN
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Forward Rates Transaction Details File Format
     C                   PARM                    TranFilFmt
      *
 
      * Output Parameters
 
      * Forward Rates Transaction Details Screen Format
     C                   PARM                    TrnDets
 
 
      ** Initialize program name
 
     C                   MOVEL     'FDFWRTCVT'   DBPGM
 
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if switchable feature CEU026 is switched on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU026'      @SARD             6
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU026'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU026            1
     C                   ELSE
     C                   MOVE      'N'           CEU026
     C                   ENDIF
 
      ** Check if switchable feature S01432 is switched on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01432'      @SARD             6
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01432'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01432            1
     C                   ELSE
     C                   MOVE      'N'           S01432
     C                   ENDIF
 
      ** Check if switchable feature MDF - CSD006 is switched on.               CSD006
                                                                                CSD006
     C                   CALLB     'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD             6            CSD006
                                                                                CSD006
      ** Database Error                                                         CSD006
                                                                                CSD006
     C     @RTCD         IFNE      *BLANKS                                      CSD006
     C     @RTCD         ANDNE     '*NRF   '                                    CSD006
     C                   MOVEL     'CSD006'      DBKEY                          CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSD006
     C                   MOVEL     '902'         DBASE                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
 
     C     @RTCD         IFEQ      *BLANK                                       CSD006
     C                   MOVE      'Y'           CSD006            1            CSD006
     C                   ELSE                                                   CSD006
     C                   MOVE      'N'           CSD006                         CSD006
     C                   ENDIF                                                  CSD006
 
      * Access currency data
      * (Database error handling done in access program).
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      BCCDP = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
