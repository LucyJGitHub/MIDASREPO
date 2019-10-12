     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CGL157 Initialization Pgm')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000562 - Midas SD CGL157 initialization                    *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD040557           Date 17Aug16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD040557 - CRS Details Initialization Program did not run    *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************

     FSDACUSPD  UF   E           K DISK    INFSR(*PSSR)

     FSDNAHOPD  UF   E           K DISK    INFSR(*PSSR)

     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)                                     MD040557
     F                                     RENAME(SDCRSHD0:SDCRSHX0)                        MD040557
                                                                                            MD040557
     FSDCRNHL0  IF   E           K DISK    INFSR(*PSSR)                                     MD040557
     F                                     RENAME(SDCRNHD0:SDCRNHX0)                        MD040557
                                                                                            MD040557
     FSDCRSHPD  O    E             DISK

     FSDCRSDPD  O    E             DISK

     FSDCRNHPD  O    E             DISK

     FSDCRSNPD  O    E             DISK

      ** =======
      ** D-specs
      ** =======

     D/COPY ZACPYSRC,STD_D_SPEC

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for CUSD
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)
     D SDCRNH        E DS                  EXTNAME(SDCRNHPD)
     D SDCRSN        E DS                  EXTNAME(SDCRSNPD)

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   CLEAR                   SDCRSH
     C                   CLEAR                   SDCRSD
     C                   CLEAR                   SDCRNH
     C                   CLEAR                   SDCRSN

      ** Process customers

     C                   READ      SDACUSPD

     C                   DOW       NOT %EOF(SDACUSPD)

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      E5CUST        Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C     E5CUST        CHAIN     SDCRSHL0                                                 MD040557
     C                   IF        NOT %FOUND(SDCRSHL0)                                     MD040557
                                                                                            MD040557
     C                   EVAL      CRCUST = E5CUST
     C                   EVAL      CREXMG = 'N'
     C                   WRITE     SDCRSHD0

     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = BBCOLC
     C                   EVAL      CDTINN = E5TINO
     C                   EVAL      CDEFFD = E5EFF1
     C                   EVAL      CDEXPD = E5EXP1
     C                   WRITE     SDCRSDD0

     C                   IF        E5TNC2 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC2
     C                   EVAL      CDTINN = E5TIN2
     C                   EVAL      CDEFFD = E5EFF2
     C                   EVAL      CDEXPD = E5EXP2
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC3 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC3
     C                   EVAL      CDTINN = E5TIN3
     C                   EVAL      CDEFFD = E5EFF3
     C                   EVAL      CDEXPD = E5EXP3
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC4 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC4
     C                   EVAL      CDTINN = E5TIN4
     C                   EVAL      CDEFFD = E5EFF4
     C                   EVAL      CDEXPD = E5EXP4
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC5 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC5
     C                   EVAL      CDTINN = E5TIN5
     C                   EVAL      CDEFFD = E5EFF5
     C                   EVAL      CDEXPD = E5EXP5
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC6 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC6
     C                   EVAL      CDTINN = E5TIN6
     C                   EVAL      CDEFFD = E5EFF6
     C                   EVAL      CDEXPD = E5EXP6
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC7 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC7
     C                   EVAL      CDTINN = E5TIN7
     C                   EVAL      CDEFFD = E5EFF7
     C                   EVAL      CDEXPD = E5EXP7
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC8 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC8
     C                   EVAL      CDTINN = E5TIN8
     C                   EVAL      CDEFFD = E5EFF8
     C                   EVAL      CDEXPD = E5EXP8
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC9 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC9
     C                   EVAL      CDTINN = E5TIN9
     C                   EVAL      CDEFFD = E5EFF9
     C                   EVAL      CDEXPD = E5EXP9
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   IF        E5TNC0 <> *Blanks
     C                   EVAL      CDCUST = E5CUST
     C                   EVAL      CDCTRY = E5TNC0
     C                   EVAL      CDTINN = E5TIN0
     C                   EVAL      CDEFFD = E5EFF0
     C                   EVAL      CDEXPD = E5EXP0
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   EVAL      E5EFF1 = *Zero
     C                   EVAL      E5EXP1 = *Zero
     C                   EVAL      E5TIN2 = *Blanks
     C                   EVAL      E5TNC2 = *Blanks
     C                   EVAL      E5EFF2 = *Zero
     C                   EVAL      E5EXP2 = *Zero
     C                   EVAL      E5TIN3 = *Blanks
     C                   EVAL      E5TNC3 = *Blanks
     C                   EVAL      E5EFF3 = *Zero
     C                   EVAL      E5EXP3 = *Zero
     C                   EVAL      E5TIN4 = *Blanks
     C                   EVAL      E5TNC4 = *Blanks
     C                   EVAL      E5EFF4 = *Zero
     C                   EVAL      E5EXP4 = *Zero
     C                   EVAL      E5TIN5 = *Blanks
     C                   EVAL      E5TNC5 = *Blanks
     C                   EVAL      E5EFF5 = *Zero
     C                   EVAL      E5EXP5 = *Zero
     C                   EVAL      E5TIN6 = *Blanks
     C                   EVAL      E5TNC6 = *Blanks
     C                   EVAL      E5EFF6 = *Zero
     C                   EVAL      E5EXP6 = *Zero
     C                   EVAL      E5TIN7 = *Blanks
     C                   EVAL      E5TNC7 = *Blanks
     C                   EVAL      E5EFF7 = *Zero
     C                   EVAL      E5EXP7 = *Zero
     C                   EVAL      E5TIN8 = *Blanks
     C                   EVAL      E5TNC8 = *Blanks
     C                   EVAL      E5EFF8 = *Zero
     C                   EVAL      E5EXP8 = *Zero
     C                   EVAL      E5TIN9 = *Blanks
     C                   EVAL      E5TNC9 = *Blanks
     C                   EVAL      E5EFF9 = *Zero
     C                   EVAL      E5EXP9 = *Zero
     C                   EVAL      E5TIN0 = *Blanks
     C                   EVAL      E5TNC0 = *Blanks
     C                   EVAL      E5EFF0 = *Zero
     C                   EVAL      E5EXP0 = *Zero
     C                   UPDATE    SDACUSD0
                                                                                            MD040557
     C                   ENDIF                                                              MD040557

     C                   READ      SDACUSPD
     C                   ENDDO

      ** Process non-account holders

     C                   READ      SDNAHOPD

     C                   DOW       NOT %EOF(SDNAHOPD)

     C     NHNAHO        CHAIN     SDCRNHL0                                                 MD040557
     C                   IF        NOT %FOUND(SDCRNHL0)                                     MD040557
                                                                                            MD040557
     C                   EVAL      NRNAHO = NHNAHO
     C                   EVAL      NREXMG = 'N'
     C                   EVAL      NRCHTP = 'I'
     C                   EVAL      NRLCDT = BJRDNB
     C                   WRITE     SDCRNHD0

     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCOCZ
     C                   EVAL      CNTINN = NHTINO
     C                   EVAL      CNEFFD = NHEFF1
     C                   EVAL      CNEXPD = NHEXP1
     C                   WRITE     SDCRSND0

     C                   IF        NHCTN2 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN2
     C                   EVAL      CNTINN = NHTIN2
     C                   EVAL      CNEFFD = NHEFF2
     C                   EVAL      CNEXPD = NHEXP2
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN3 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN3
     C                   EVAL      CNTINN = NHTIN3
     C                   EVAL      CNEFFD = NHEFF3
     C                   EVAL      CNEXPD = NHEXP3
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN4 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN4
     C                   EVAL      CNTINN = NHTIN4
     C                   EVAL      CNEFFD = NHEFF4
     C                   EVAL      CNEXPD = NHEXP4
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN5 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN5
     C                   EVAL      CNTINN = NHTIN5
     C                   EVAL      CNEFFD = NHEFF5
     C                   EVAL      CNEXPD = NHEXP5
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN6 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN6
     C                   EVAL      CNTINN = NHTIN6
     C                   EVAL      CNEFFD = NHEFF6
     C                   EVAL      CNEXPD = NHEXP6
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN7 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN7
     C                   EVAL      CNTINN = NHTIN7
     C                   EVAL      CNEFFD = NHEFF7
     C                   EVAL      CNEXPD = NHEXP7
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN8 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN8
     C                   EVAL      CNTINN = NHTIN8
     C                   EVAL      CNEFFD = NHEFF8
     C                   EVAL      CNEXPD = NHEXP8
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN9 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN9
     C                   EVAL      CNTINN = NHTIN9
     C                   EVAL      CNEFFD = NHEFF9
     C                   EVAL      CNEXPD = NHEXP9
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   IF        NHCTN0 <> *Blanks
     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCTN0
     C                   EVAL      CNTINN = NHTIN0
     C                   EVAL      CNEFFD = NHEFF0
     C                   EVAL      CNEXPD = NHEXP0
     C                   WRITE     SDCRSND0
     C                   ENDIF

     C                   EVAL      NHEFF1 = *Zero
     C                   EVAL      NHEXP1 = *Zero
     C                   EVAL      NHTIN2 = *Blanks
     C                   EVAL      NHCTN2 = *Blanks
     C                   EVAL      NHEFF2 = *Zero
     C                   EVAL      NHEXP2 = *Zero
     C                   EVAL      NHTIN3 = *Blanks
     C                   EVAL      NHCTN3 = *Blanks
     C                   EVAL      NHEFF3 = *Zero
     C                   EVAL      NHEXP3 = *Zero
     C                   EVAL      NHTIN4 = *Blanks
     C                   EVAL      NHCTN4 = *Blanks
     C                   EVAL      NHEFF4 = *Zero
     C                   EVAL      NHEXP4 = *Zero
     C                   EVAL      NHTIN5 = *Blanks
     C                   EVAL      NHCTN5 = *Blanks
     C                   EVAL      NHEFF5 = *Zero
     C                   EVAL      NHEXP5 = *Zero
     C                   EVAL      NHTIN6 = *Blanks
     C                   EVAL      NHCTN6 = *Blanks
     C                   EVAL      NHEFF6 = *Zero
     C                   EVAL      NHEXP6 = *Zero
     C                   EVAL      NHTIN7 = *Blanks
     C                   EVAL      NHCTN7 = *Blanks
     C                   EVAL      NHEFF7 = *Zero
     C                   EVAL      NHEXP7 = *Zero
     C                   EVAL      NHTIN8 = *Blanks
     C                   EVAL      NHCTN8 = *Blanks
     C                   EVAL      NHEFF8 = *Zero
     C                   EVAL      NHEXP8 = *Zero
     C                   EVAL      NHTIN9 = *Blanks
     C                   EVAL      NHCTN9 = *Blanks
     C                   EVAL      NHEFF9 = *Zero
     C                   EVAL      NHEXP9 = *Zero
     C                   EVAL      NHTIN0 = *Blanks
     C                   EVAL      NHCTN0 = *Blanks
     C                   EVAL      NHEFF0 = *Zero
     C                   EVAL      NHEXP0 = *Zero
     C                   UPDATE    SDNAHOD0
                                                                                            MD040557
     C                   ENDIF                                                              MD040557

     C                   READ      SDNAHOPD
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
