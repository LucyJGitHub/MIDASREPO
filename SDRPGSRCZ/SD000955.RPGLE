     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000955 - Midas SD Interest Payment History SDINPHPD Update *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053260  *CREATE  Date 12Jul19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053260 - FBM COB - Component SDC000817 00001 terminated    *
      *             abnormally. Database error in file SDCUSTPD,      *
      *             key 000992, in , at 001                           *
      *                                                               *
      *****************************************************************
 
     FSDINPHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     EXTMBR('*ALL')
     F                                     INFDS(INFDS)
 
      ** =======
      ** D-specs
      ** =======
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Structure for Customer Master File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Data Structure for Swtichable feature
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D INFDS           DS
     D  MEMBER               129    138A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PKEY1           S             10
     D PKYST           S              7
 
     D CER048          S              1
 
     D/COPY ZSRSRC,ZHOLILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Check if CER048 is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER048'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C                   EVAL      DBPGM  = 'SD000955'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = 'CER048'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CER048 = 'Y'
     C                   ELSE
     C                   EVAL      CER048 = 'N'
     C                   ENDIF
      *
      ** If feature CER048 is present, delete any record from file
      *
     C                   IF        CER048 = 'Y'
     C                   EXSR      ReadSDINPHPD
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * ReadSDINPHPD - read SDINPHPD file                             *
      *****************************************************************
      *
     C     ReadSDINPHPD  BEGSR
      *
     C                   OPEN      SDINPHL0
     C     *LOVAL        SETLL     SDINPHL0
     C                   READ      SDINPHL0
      *
     C                   DOW       NOT %EOF(SDINPHL0)
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      TICUST        PKEY1
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*CUSCLS'
     C                             AND PRTCD <> '*CUSDEL'
     C                   DELETE    SDINPHD0
     C                   ENDIF
      *
     C                   READ      SDINPHL0
     C                   ENDDO
     C                   CLOSE     SDINPHL0
      *
     C                   ENDSR
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
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
**  CPY@
(c) Finastra International Limited 2019
