     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP FATCA High Value Update Dupicate TIN')        *
      *****************************************************************
      *  Includes MD024916B                                           *
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  SD000163 - Midas SD FATCA High Value Account Identification  *
      *             Report & Update - Update duplicate TIN            *
      *                                                               *
      *  Function:  This Updates duplicate TIN                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL132   *CREATE   Date 12Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         Control Indicator                               *
      *    U8         Control Indicator                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error Processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** FATCA High Value Account Amounts File
     FSDFTHAL6  IF   E           K DISK    INFSR(*PSSR)
     FSDFTHAL7  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTHAD0:SDFTHAD7)
     FSDFTHAL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTHAD0:SDFTHAD2)
     FSDFTHAL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTHAD0:SDFTHAD3)
     FSDFTHAL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTHAD0:SDFTHAD4)
     FSDFTHAL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTHAD0:SDFTHAD5)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D ArrTIN          S             25    DIM(5)
     D ArrTINcd        S              2    DIM(5)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D SVvlK1          S             20
     D SVvl1           S            200
     D SVvlK2          S             20
     D SVvl2           S            200
     D SVvlK3          S             20
     D SVvl3           S            200
     D SVvlK4          S             20
     D SVvl4           S            200
     D SVvlK5          S             20
     D SVvl5           S            200
     D SVvlK6          S             20
     D SVvl6           S            200
     D SVvlK7          S             20
     D SVvl7           S            200
     D SVvlK8          S             20
     D SVvl8           S            200
     D SVvlK9          S             20
     D SVvl9           S            200
     D SVvlK0          S             20
     D SVvl10          S            200
     D SACust          S              6A
     D SABrca          S              3A
     D Idx             S              1  0
     D TINum           S             25
     D TINcd           S              2
     D Found           S              1
     D WRun            S              1A
     D PRtcd           S              7A
     D SysVvl1         C                   'FATCACountryofTax'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
     C     KTINum        KLIST
     C                   KFLD                    TINum
     C                   KFLD                    TINcd
     C     KHValue       KLIST
     C                   KFLD                    SABrca
     C                   KFLD                    SACust
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVvl1       SVvlK1
     C                   PARM                    SVvl1
     C                   PARM                    SVvlK2
     C                   PARM                    SVvl2
     C                   PARM                    SVvlK3
     C                   PARM                    SVvl3
     C                   PARM                    SVvlK4
     C                   PARM                    SVvl4
     C                   PARM                    SVvlK5
     C                   PARM                    SVvl5
     C                   PARM                    SVvlK6
     C                   PARM                    SVvl6
     C                   PARM                    SVvlK7
     C                   PARM                    SVvl7
     C                   PARM                    SVvlK8
     C                   PARM                    SVvl8
     C                   PARM                    SVvlK9
     C                   PARM                    SVvl9
     C                   PARM                    SVvlK0
     C                   PARM                    SVvl10
 
     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SVvlK1
     C                   EVAL      DBASE = 1
     C                   EVAL      DBPGM = 'SD000163'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SrProcHighVal
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcHighVal - Update dupicate TIN                          *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrProcHighVal BEGSR
 
     C     *LOVAL        SETLL     SDFTHAL6
     C                   READ      SDFTHAL6                             80
     C                   DOW       NOT %EOF(SDFTHAL6)
     C                   EVAL      SABrca = HABRCA
     C                   EVAL      SACust = HACUST
     C                   EVAL      ArrTIN(1) = HAUTIN
     C                   EVAL      ArrTIN(2) = HATIN2
     C                   EVAL      ArrTIN(3) = HATIN3
     C                   EVAL      ArrTIN(4) = HATIN4
     C                   EVAL      ArrTIN(5) = HATIN5
     C                   EVAL      ArrTINcd(1) = HAUTNC
     C                   EVAL      ArrTINcd(2) = HATNC2
     C                   EVAL      ArrTINcd(3) = HATNC3
     C                   EVAL      ArrTINcd(4) = HATNC4
     C                   EVAL      ArrTINcd(5) = HATNC5
     C                   Eval      Found = *BLANK
     C                   Eval      Idx = 0
 
     C                   DOW       Idx < 5  and
     C                             Found = *BLANK
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      TINum = ArrTIN(Idx)
     C                   EVAL      TINcd = ArrTINcd(Idx)
 
     C     KTINum        SETLL     SDFTHAD2
     C     KTINum        READE     SDFTHAD2                               80
     C                   DOW       *IN80 = *OFF
     C                   EXSR      SRChkCust
     C                   IF        Found = 'Y' and
     C                             SVvl1  <> HATNC2
     C                   UPDATE    SDFTHAD2
     C                   EXSR      SRUpdat
     C                   ENDIF
     C     KTINum        READE     SDFTHAD2                               80
     C                   ENDDO
     C
     C
     C                   IF        Found = *BLANK
     C     KTINum        SETLL     SDFTHAD3
     C     KTINum        READE     SDFTHAD3                               80
     C                   DOW       *IN80 = *OFF
     C                   EXSR      SRChkCust
     C                   IF        Found = 'Y' and
     C                             SVvl1  <> HATNC3
     C                   UPDATE    SDFTHAD3
     C                   EXSR      SRUpdat
     C                   ENDIF
     C     KTINum        READE     SDFTHAD3                               80
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        Found = *BLANK
     C     KTINum        SETLL     SDFTHAD4
     C     KTINum        READE     SDFTHAD4                               80
     C                   DOW       *IN80 = *OFF
     C                   EXSR      SRChkCust
     C                   IF        Found = 'Y' and
     C                             SVvl1  <> HATNC4
     C                   UPDATE    SDFTHAD4
     C                   EXSR      SRUpdat
     C                   ENDIF
     C     KTINum        READE     SDFTHAD4                               80
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        Found = *BLANK
     C     KTINum        SETLL     SDFTHAD5
     C     KTINum        READE     SDFTHAD5                               80
     C                   DOW       *IN80 = *OFF
     C                   EXSR      SRChkCust
     C                   IF        Found = 'Y' and
     C                             SVvl1  <> HATNC5
     C                   UPDATE    SDFTHAD5
     C                   EXSR      SRUpdat
     C                   ENDIF
     C     KTINum        READE     SDFTHAD5                               80
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDDO
 
     C                   READ      SDFTHAL6                             80
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkCust - Check match customer                             *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkCust     BEGSR
 
     C                   Eval      Found = ' '
     C                   EVAL      HATIND = ' '
     C                   IF        SABrca <> HABRCA  or
     C                             SACust <> HACUST
     C                   Eval      Found = 'Y'
     C                   EVAL      HATIND = 'M'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdat - Update the driver file                             *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdat       BEGSR
 
     C     KHValue       CHAIN     SDFTHAL7                             81
     C                   IF        *IN81 = *OFF
     C                   EVAL      HATIND = 'M'
     C                   UPDATE    SDFTHAD7
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'SD000163'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2014
