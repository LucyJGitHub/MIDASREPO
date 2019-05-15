     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CGL157 Switch off')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000563 - Midas SD CGL157 Switch off                        *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD039670           Date 26Jul16               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************

     FSDCRSHPD  UF   E           K DISK    INFSR(*PSSR)

     FSDCRSDL2  UF   E           K DISK    INFSR(*PSSR)

     FSDCRNHPD  UF   E           K DISK    INFSR(*PSSR)

     FSDCRSNL2  UF   E           K DISK    INFSR(*PSSR)

     FSDACUSL0  UF   E           K DISK    INFSR(*PSSR)

     FSDNAHOL0  UF   E           K DISK    INFSR(*PSSR)

      ** =======
      ** D-specs
      ** =======

      ** External data structure for CUSD
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data Structure for CRS Header                                                      MD039670
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                MD039670

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D X               S              2S 0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Process customers

     C                   READ      SDCRSHPD

     C                   DOW       NOT %EOF(SDCRSHPD)

     C     CRCUST        SETLL     SDCRSDL2
     C     CRCUST        READE     SDCRSDL2

     C                   EVAL      X = 1
     C     CRCUST        CHAIN     SDACUSL0

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      CRCUST        Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   DOW       NOT %EOF(SDCRSDL2)

     C                   IF        CDCTRY = BBCOLC
     C                   EVAL      E5EFF1 = CDEFFD
     C                   EVAL      E5EXP1 = CDEXPD
     C                   ENDIF

     C                   IF        X = 1
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC2 = CDCTRY
     C                   EVAL      E5TIN2 = CDTINN
     C                   EVAL      E5EFF2 = CDEFFD
     C                   EVAL      E5EXP2 = CDEXPD
     C                   ENDIF

     C                   IF        X = 2
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC3 = CDCTRY
     C                   EVAL      E5TIN3 = CDTINN
     C                   EVAL      E5EFF3 = CDEFFD
     C                   EVAL      E5EXP3 = CDEXPD
     C                   ENDIF

     C                   IF        X = 3
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC4 = CDCTRY
     C                   EVAL      E5TIN4 = CDTINN
     C                   EVAL      E5EFF4 = CDEFFD
     C                   EVAL      E5EXP4 = CDEXPD
     C                   ENDIF

     C                   IF        X = 4
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC5 = CDCTRY
     C                   EVAL      E5TIN5 = CDTINN
     C                   EVAL      E5EFF5 = CDEFFD
     C                   EVAL      E5EXP5 = CDEXPD
     C                   ENDIF

     C                   IF        X = 5
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC6 = CDCTRY
     C                   EVAL      E5TIN6 = CDTINN
     C                   EVAL      E5EFF6 = CDEFFD
     C                   EVAL      E5EXP6 = CDEXPD
     C                   ENDIF

     C                   IF        X = 6
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC7 = CDCTRY
     C                   EVAL      E5TIN7 = CDTINN
     C                   EVAL      E5EFF7 = CDEFFD
     C                   EVAL      E5EXP7 = CDEXPD
     C                   ENDIF

     C                   IF        X = 7
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC8 = CDCTRY
     C                   EVAL      E5TIN8 = CDTINN
     C                   EVAL      E5EFF8 = CDEFFD
     C                   EVAL      E5EXP8 = CDEXPD
     C                   ENDIF

     C                   IF        X = 8
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC9 = CDCTRY
     C                   EVAL      E5TIN9 = CDTINN
     C                   EVAL      E5EFF9 = CDEFFD
     C                   EVAL      E5EXP9 = CDEXPD
     C                   ENDIF

     C                   IF        X = 9
     C                             AND CDCTRY <> BBCOLC
     C                   EVAL      E5TNC0 = CDCTRY
     C                   EVAL      E5TIN0 = CDTINN
     C                   EVAL      E5EFF0 = CDEFFD
     C                   EVAL      E5EXP0 = CDEXPD
     C                   ENDIF

     C                   IF        CDCTRY <> BBCOLC
     C                   EVAL      X = X + 1
     C                   ENDIF

     C                   DELETE    SDCRSDD0
     C     CRCUST        READE     SDCRSDL2
     C                   ENDDO

     C                   IF        %FOUND(SDACUSL0)
     C                   UPDATE    @ACUSL0
     C                   ENDIF

     C                   DELETE    SDCRSHD0
     C                   READ      SDCRSHPD
     C                   ENDDO

      ** Process non account holders

     C                   READ      SDCRNHPD

     C                   DOW       NOT %EOF(SDCRNHPD)
     C                   EVAL      PKEY1 = NRNAHO                                           MD039670
     C                   IF        PKEY1 <> *BLANKS                                         MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *Blanks       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PKEY1                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNHPD                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670

     C     NRNAHO        SETLL     SDCRSNL2
     C     NRNAHO        READE     SDCRSNL2

     C                   EVAL      X = 1
     C     NRNAHO        CHAIN     SDNAHOL0

     C                   DOW       NOT %EOF(SDCRSNL2)

     C                   IF        NHCOLC = CNCTRY
     C                   EVAL      NHEFF1 = CNEFFD
     C                   EVAL      NHEXP1 = CNEXPD
     C                   ENDIF

     C                   IF        X = 1
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN2 = CNCTRY
     C                   EVAL      NHTIN2 = CNTINN
     C                   EVAL      NHEFF2 = CNEFFD
     C                   EVAL      NHEXP2 = CNEXPD
     C                   ENDIF

     C                   IF        X = 2
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN3 = CNCTRY
     C                   EVAL      NHTIN3 = CNTINN
     C                   EVAL      NHEFF3 = CNEFFD
     C                   EVAL      NHEXP3 = CNEXPD
     C                   ENDIF

     C                   IF        X = 3
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN4 = CNCTRY
     C                   EVAL      NHTIN4 = CNTINN
     C                   EVAL      NHEFF4 = CNEFFD
     C                   EVAL      NHEXP4 = CNEXPD
     C                   ENDIF

     C                   IF        X = 4
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN5 = CNCTRY
     C                   EVAL      NHTIN5 = CNTINN
     C                   EVAL      NHEFF5 = CNEFFD
     C                   EVAL      NHEXP5 = CNEXPD
     C                   ENDIF

     C                   IF        X = 5
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN6 = CNCTRY
     C                   EVAL      NHTIN6 = CNTINN
     C                   EVAL      NHEFF6 = CNEFFD
     C                   EVAL      NHEXP6 = CNEXPD
     C                   ENDIF

     C                   IF        X = 6
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN7 = CNCTRY
     C                   EVAL      NHTIN7 = CNTINN
     C                   EVAL      NHEFF7 = CNEFFD
     C                   EVAL      NHEXP7 = CNEXPD
     C                   ENDIF

     C                   IF        X = 7
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN8 = CNCTRY
     C                   EVAL      NHTIN8 = CNTINN
     C                   EVAL      NHEFF8 = CNEFFD
     C                   EVAL      NHEXP8 = CNEXPD
     C                   ENDIF

     C                   IF        X = 8
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN9 = CNCTRY
     C                   EVAL      NHTIN9 = CNTINN
     C                   EVAL      NHEFF9 = CNEFFD
     C                   EVAL      NHEXP9 = CNEXPD
     C                   ENDIF

     C                   IF        X = 9
     C                             AND NHCOLC <> CNCTRY
     C                   EVAL      NHCTN0 = CNCTRY
     C                   EVAL      NHTIN0 = CNTINN
     C                   EVAL      NHEFF0 = CNEFFD
     C                   EVAL      NHEXP0 = CNEXPD
     C                   ENDIF

     C                   IF        NHCOLC <> CNCTRY
     C                   EVAL      X = X + 1
     C                   ENDIF

     C                   DELETE    SDCRSND0
     C     NRNAHO        READE     SDCRSNL2
     C                   ENDDO

     C                   IF        %FOUND(SDNAHOL0)
     C                   UPDATE    SDNAHOD0
     C                   ENDIF

     C                   DELETE    SDCRNHD0
     C                   READ      SDCRNHPD
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN

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
