     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CGL132 Initialization pgm')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009700 - Midas SD CGL132 initialization                    *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************

     FSDACUSL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)

     FSDFTCSPD  IF   E             DISK

     FSDACUSPD  O    E             DISK

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


     D PRTCD           S              7
     D POPTN           S              7
     D TimeStamp       S               Z

     D/COPY ZSRSRC,ZHOLILE

      *****************************************************************
      /EJECT
      *****************************************************************


     C     1             SETLL     SDFTCSPD
     C                   READ      SDFTCSPD

     C                   DOW       NOT %EOF(SDFTCSPD)

     C     FACUST        CHAIN(N)  SDACUSL0
     C                   IF        NOT %FOUND(SDACUSL0)
     C                   CLEAR                   SDACUS
     C                   EVAL      E5CUST = FACUST
     C                   EVAL      E5LCD  = BJRDNB
     C                   EVAL      E5TYLC = 'I'
     C                   EVAL      E5JATP = 'N'
     C     FACUST        CHAIN(N)  SDJACCL4
     C                   IF        %FOUND(SDJACCL4)
     C                   EVAL      E5JATP = 'Y'
     C                   ENDIF
      ** Customer Shortname
     C     FACUST        CHAIN(N)  SDCUSTL1
     C                   IF        %FOUND(SDCUSTL1)
     C                   EVAL      E5CSSN = BBCSSN
     C                   ENDIF
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     E5TMST
     C                   WRITE     SDACUSD0
     C                   ENDIF
     C                   READ      SDFTCSPD
     C                   ENDDO

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = POPTN
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
