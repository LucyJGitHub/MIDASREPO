     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Date Bucket Identification')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRDATBID - Date Bucket Identification                 *
      *                                                               *
      *  Function:  This module will be called from another RPGLE     *
      *             program. It is passed a scheduled date whose      *
      *             bucket code must be determined. This program      *
      *             will determine this bucket code and pass it       *
      *             back to the calling program.                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CMR001  *CREATE    Date 16Aug04               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Date Schedule Bucket
     FMRDSBDPD  IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      * Maximum number of schedules
     D MaxNoSch        C                   CONST(50)
      * Maximum Midas Number 99999 equivalent to 12Oct2245
     D WMaxMD          C                   CONST(22451012)
 
      ** Arrays to hold fields from MRDATBID - Date Bucket Identification Module
     D BArrSch0        S              8A   DIM(MaxNoSch)
     D BArrSch1        S              8A   DIM(MaxNoSch)
     D BArrSch2        S              8A   DIM(MaxNoSch)
     D BArrSch3        S              8A   DIM(MaxNoSch)
     D BArrSch4        S              8A   DIM(MaxNoSch)
     D BArrSch5        S              8A   DIM(MaxNoSch)
     D BArrSch6        S              8A   DIM(MaxNoSch)
     D BArrSch7        S              8A   DIM(MaxNoSch)
     D BArrSch8        S              8A   DIM(MaxNoSch)
     D BArrSch9        S              8A   DIM(MaxNoSch)
 
      ** Date Array for Date Schedule
     D DArrSch0        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch1        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch2        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch3        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch4        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch5        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch6        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch7        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch8        S              5S 0 DIM(MaxNoSch) ASCEND
     D DArrSch9        S              5S 0 DIM(MaxNoSch) ASCEND
 
      ** Format date from ZDATE9
     D WPDtYMD         DS
     D  WDatYY                 1      4S 0
     D  WDatMM                 5      6S 0
     D  WDatDD                 7      8S 0
 
      ** Input parameters from calling program
     D PDateSch        S              1  0
     D PRepDate        S              5  0
     D PSchDate        S              5  0
     D PBckCde         S              8
 
      ** Parameter for ZDATE9 and AOBANKR0
     D PDayNo          S              5  0
     D PDatYMD         S              8
     D PRetCde         S              7
     D POption         S              7
     D PMDayNo         S              5  0
 
      ** Parameters for ZFWDT
     D ZCCY            S              3
     D ZDAYNO          S              5  0
     D ZLOC            S              3
     D ZNRDYS          S              2  0
     D ZDYNBR          S              5  0
 
     D Ctr0            S              2  0
     D Ctr1            S              2  0
     D Ctr2            S              2  0
     D Ctr3            S              2  0
     D Ctr4            S              2  0
     D Ctr5            S              2  0
     D Ctr6            S              2  0
     D Ctr7            S              2  0
     D Ctr8            S              2  0
     D Ctr9            S              2  0
     D ArrMax0         S              2  0
     D ArrMax1         S              2  0
     D ArrMax2         S              2  0
     D ArrMax3         S              2  0
     D ArrMax4         S              2  0
     D ArrMax5         S              2  0
     D ArrMax6         S              2  0
     D ArrMax7         S              2  0
     D ArrMax8         S              2  0
     D ArrMax9         S              2  0
     D WMDteChk        S              6  0
     D WDateArr        S              5  0
     D WArrNum         S              5  0
     D WDTotMM         S              3  0
     D WDivNo          S              2  0
     D WRemNo          S              2  0
     D WRemMM2         S              2  0
     D WYMDNo          S              8  0
     D I#ERMS          S             30
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Check corresponding bucket code from array
     C                   SELECT
     C                   WHEN      PDateSch = 0
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch0:1:ArrMax0)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch0(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 1
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch1:1:ArrMax1)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch1(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 2
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch2:1:ArrMax2)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch2(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 3
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch3:1:ArrMax3)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch3(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 4
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch4:1:ArrMax4)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch4(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 5
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch5:1:ArrMax5)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch5(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 6
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch6:1:ArrMax6)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch6(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 7
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch7:1:ArrMax7)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch7(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 8
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch8:1:ArrMax8)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch8(WArrNum)
     C                   ENDIF
     C                   WHEN      PDateSch = 9
     C                   EVAL      WArrNum
     C                             = %LOOKUPGE(PSchDate:DArrSch9:1:ArrMax9)
     C                   IF        WArrNum <> 0
     C                   EVAL      PBckCde = BArrSch9(WArrNum)
     C                   ENDIF
     C                   ENDSL
 
      ** If the Schedule Date not found in array return a blank code
     C                   IF        WArrNum = 0
     C                   EVAL      PBckCde = *BLANK
     C                   ENDIF
 
      ** Return bucket code value to calling program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutin to process records in the Date Array   *
      *                                                               *
      *****************************************************************
     C     SRDateArr     BEGSR
 
     C                   SELECT
 
      ** Deterimine Date Array value when Period Type is 'D'ay
     C                   WHEN      DSPDTP = 'D'
     C                   IF        DSPDCT = 'C'
     C                   EVAL      WMDteChk = PRepDate + DSPDNO
 
      ** Check date, maximum should be 99999
     C                   IF        WMDteChk > 99999
     C                   EVAL      WDateArr = 99999
     C                   ELSE
     C                   EVAL      WDateArr = PRepDate + DSPDNO
     C                   ENDIF
     C                   Else
     C                   EVAL      ZDAYNO = PRepDate
     C                   EVAL      ZNRDYS = DSPDNO
     C                   EXSR      SrZFWDT
     C                   IF        ZDYNBR < PRepDate
     C                   EVAL      WDateArr = 99999
     C                   ELSE
     C                   EVAL      WDateArr = ZDYNBR
     C                   EndIF
     C                   EndIF
     C
      ** Deterimine Date Array value when Period Type is 'M'onth
     C                   WHEN      DSPDTP = 'M'
     C                   EVAL      PDayNo = PRepDate
     C                   EXSR      SrZDATE9
     C                   EVAL      WPDtYMD = PDatYMD
     C                   EXSR      SrPrMonth
     C                   EXSR      SrPrDay
 
      ** Check date, maximum should be 99999 for midas day (WMaxMD = 22451012)
     C                   MOVEL     WPDtYMD       WYMDNo
     C                   IF        WYMDNo > WMaxMD
     C                   EVAL      WDateArr = 99999
     C                   ELSE
 
      ** Convert WPDtYMD to Midas Day
     C                   EXSR      SrZDATE10
     C                   EVAL      WDateArr = PMDayNo
     C                   ENDIF
 
      ** Deterimine Date Array value when Period Type is 'Y'ear
     C                   WHEN      DSPDTP = 'Y'
     C                   EVAL      PDayNo = PRepDate
     C                   EXSR      SrZDATE9
     C                   EVAL      WPDtYMD = PDatYMD
     C                   EVAL      WDatYY = WDatYY + DSPDNO
     C                   EXSR      SrPrDay
 
      ** Check date, maximum should be 99999(12Oct2245) for midas day (WMaxMD = 22451012)
     C                   MOVEL     WPDtYMD       WYMDNo
     C                   IF        WYMDNo > WMaxMD
     C                   EVAL      WDateArr = 99999
     C                   ELSE
 
      ** Convert WPDtYMD to Midas Day
     C                   EXSR      SrZDATE10
     C                   EVAL      WDateArr = PMDayNo
     C                   ENDIF
     C
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrMonth - Subroutine to process value of Date Array        *
      *              when Period Type is 'M' (month)                  *
      *                                                               *
      *****************************************************************
     C     SRPrMonth     BEGSR
 
     C                   EVAL      WDTotMM = WDatMM + DSPDNO
     C                   IF        WDTotMM > 12
     C                   EVAL      WDivNo = %DIV(WDTotMM:12)
     C                   EVAL      WRemNo = %REM(WDTotMM:12)
 
     C                   EVAL      WDatMM = WRemNo
     C                   IF        WDivNo > 0 and WRemNo > 0
     C                   EVAL      WDatYY  = WDatYY + WDivNo
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WDatMM = WDatMM + DSPDNO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrDay   - Subroutine to get day value in Date Array        *
      *                                                               *
      *****************************************************************
     C     SRPrDay       BEGSR
 
     C                   SELECT
     C                   WHEN      WDatMM = 2
     C                   EVAL      WRemMM2 = %REM(WDatYY:4)
     C                   IF        WRemMM2 = 0
     C                   EVAL      WDatDD = 29
     C                   ELSE
     C                   EVAL      WDatDD = 28
     C                   ENDIF
     C                   WHEN      WDatMM = 4 OR WDatMM = 6 OR
     C                             WDatMM = 9 OR WDatMM = 11
     C                   EVAL      WDatDD = 30
     C                   Other
     C                   EVAL      WDatDD = 31
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrZFWDT - Convert Midas day to DDMMMYY format                 *
      *****************************************************************
     C     SrZFWDT       BEGSR
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrZDATE2 - Convert Midas day to YYYMMDD format                *
      *****************************************************************
     C     SrZDATE9      BEGSR
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    PDayNo
     C                   PARM                    PDatYMD
     C                   PARM                    PRetCde
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrZDATE10 - Convert DDMMMYY format to Midas Day               *
      *****************************************************************
     C     SrZDATE10     BEGSR
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    WPDtYMD
     C                   PARM                    PMDayNo
 
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
 
     C     *ENTRY        PLIST
      ** Inputs
     C                   PARM                    PDateSch
     C                   PARM                    PRepDate
     C                   PARM                    PSchDate
      ** Outputs
     C                   PARM                    PBckCde
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ZCCY = BJLCCY
     C                   EVAL      ZLOC = *blanks
     C                   ENDIF
 
      ** Access date schedules from MRDSBDPD
 
      ** Initialise counter/array index
     C                   EVAL      Ctr0 = 0
     C                   EVAL      Ctr1 = 0
     C                   EVAL      Ctr2 = 0
     C                   EVAL      Ctr3 = 0
     C                   EVAL      Ctr4 = 0
     C                   EVAL      Ctr5 = 0
     C                   EVAL      Ctr6 = 0
     C                   EVAL      Ctr7 = 0
     C                   EVAL      Ctr8 = 0
     C                   EVAL      Ctr9 = 0
 
      ** Initialise array
     C                   MOVE      *BLANKS       BArrSch0
     C                   MOVE      *BLANKS       BArrSch1
     C                   MOVE      *BLANKS       BArrSch2
     C                   MOVE      *BLANKS       BArrSch3
     C                   MOVE      *BLANKS       BArrSch4
     C                   MOVE      *BLANKS       BArrSch5
     C                   MOVE      *BLANKS       BArrSch6
     C                   MOVE      *BLANKS       BArrSch7
     C                   MOVE      *BLANKS       BArrSch8
     C                   MOVE      *BLANKS       BArrSch9
     C                   MOVE      *BLANKS       DArrSch0
     C                   MOVE      *BLANKS       DArrSch1
     C                   MOVE      *BLANKS       DArrSch2
     C                   MOVE      *BLANKS       DArrSch3
     C                   MOVE      *BLANKS       DArrSch4
     C                   MOVE      *BLANKS       DArrSch5
     C                   MOVE      *BLANKS       DArrSch6
     C                   MOVE      *BLANKS       DArrSch7
     C                   MOVE      *BLANKS       DArrSch8
     C                   MOVE      *BLANKS       DArrSch9
 
     C     1             SETLL     MRDSBDPD
     C                   READ      MRDSBDPD
 
     C                   DOW       NOT %EOF(MRDSBDPD)
 
      ** Load records into array
 
     C                   SELECT
     C                   WHEN      DSSCHD = 0
     C                   EVAL      Ctr0 = Ctr0 + 1
     C                   EVAL      BArrSch0(Ctr0) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch0(Ctr0) = WDateArr
     C                   WHEN      DSSCHD = 1
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   EVAL      BArrSch1(Ctr1) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch1(Ctr1) = WDateArr
     C                   WHEN      DSSCHD = 2
     C                   EVAL      Ctr2 = Ctr2 + 1
     C                   EVAL      BArrSch2(Ctr2) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch2(Ctr2) = WDateArr
     C                   WHEN      DSSCHD = 3
     C                   EVAL      Ctr3 = Ctr3 + 1
     C                   EVAL      BArrSch3(Ctr3) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch3(Ctr3) = WDateArr
     C                   WHEN      DSSCHD = 4
     C                   EVAL      Ctr4 = Ctr4 + 1
     C                   EVAL      BArrSch4(Ctr4) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch4(Ctr4) = WDateArr
     C                   WHEN      DSSCHD = 5
     C                   EVAL      Ctr5 = Ctr5 + 1
     C                   EVAL      BArrSch5(Ctr5) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch5(Ctr5) = WDateArr
     C                   WHEN      DSSCHD = 6
     C                   EVAL      Ctr6 = Ctr6 + 1
     C                   EVAL      BArrSch6(Ctr6) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch6(Ctr6) = WDateArr
     C                   WHEN      DSSCHD = 7
     C                   EVAL      Ctr7 = Ctr7 + 1
     C                   EVAL      BArrSch7(Ctr7) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch7(Ctr7) = WDateArr
     C                   WHEN      DSSCHD = 8
     C                   EVAL      Ctr8 = Ctr8 + 1
     C                   EVAL      BArrSch8(Ctr8) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch8(Ctr8) = WDateArr
     C                   WHEN      DSSCHD = 9
     C                   EVAL      Ctr9 = Ctr9 + 1
     C                   EVAL      BArrSch9(Ctr9) = DSBCDE
     C                   EXSR      SRDateArr
     C                   EVAL      DArrSch9(Ctr9) = WDateArr
     C                   ENDSL
 
     C                   READ      MRDSBDPD
 
     C                   ENDDO
 
      ** Save number of element of arrays
     C                   EVAL      ArrMax0 = Ctr0
     C                   EVAL      ArrMax1 = Ctr1
     C                   EVAL      ArrMax2 = Ctr2
     C                   EVAL      ArrMax3 = Ctr3
     C                   EVAL      ArrMax4 = Ctr4
     C                   EVAL      ArrMax5 = Ctr5
     C                   EVAL      ArrMax6 = Ctr6
     C                   EVAL      ArrMax7 = Ctr7
     C                   EVAL      ArrMax8 = Ctr8
     C                   EVAL      ArrMax9 = Ctr9
 
 
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
