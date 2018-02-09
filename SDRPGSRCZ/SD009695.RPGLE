     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CGL132 Initialization pgm 2')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009695 - Midas SD CGL132 Initialization program to         *
      *             populate US TIN field                             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
     FSDFTCSPD  UF   E             DISK    INFSR(*PSSR)
 
      ** =======
      ** D-specs
      ** =======
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCNUM           S             10
     D PCNST           S              7
     D PCUST           S              6
 
      ** Parameter variables for AOSVALR0 string
     D SValK1          S             20
     D SVal1           S            200
     D SValK2          S             20
     D SVal2           S            200
     D SValK3          S             20
     D SVal3           S            200
     D SValK4          S             20
     D SVal4           S            200
     D SValK5          S             20
     D SVal5           S            200
     D SValK6          S             20
     D SVal6           S            200
     D SValK7          S             20
     D SVal7           S            200
     D SValK8          S             20
     D SVal8           S            200
     D SValK9          S             20
     D SVal9           S            200
     D SValK0          S             20
     D SVal10          S            200
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for customer details
 
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      ** External data structure for ACUS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
     D SysVal1         C                   'FATCACountryofTax'
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM                    SValK2
     C                   PARM                    SVal2
     C                   PARM                    SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10
 
     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SValK1
     C                   EVAL      DBASE = 1
     C                   EVAL      DBPGM = 'SD009695'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     1             SETLL     SDFTCSPD
     C                   READ      SDFTCSPD
 
     C                   DOW       NOT %EOF(SDFTCSPD)
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FACUST        PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD = *BLANKS
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FACUST        PCUST
     C     SDACUS        PARM      SDACUS        DSLDY
 
     C                   IF        PRTCD = *BLANKS
 
     C                   IF        E5TNC5 = SVal1
     C                   EVAL      FAUTIN = E5TIN5
     C                   ENDIF
     C                   IF        E5TNC4 = SVal1
     C                   EVAL      FAUTIN = E5TIN4
     C                   ENDIF
     C                   IF        E5TNC3 = SVal1
     C                   EVAL      FAUTIN = E5TIN3
     C                   ENDIF
     C                   IF        E5TNC2 = SVal1
     C                   EVAL      FAUTIN = E5TIN2
     C                   ENDIF
     C                   IF        BBCOLC = SVal1
     C                   EVAL      FAUTIN = E5TINO
     C                   ENDIF
 
     C                   UPDATE    SDFTCSD0
     C
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDFTCSPD
 
     C                   ENDDO
 
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
