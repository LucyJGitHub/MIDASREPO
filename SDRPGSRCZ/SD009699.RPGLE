     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CGL132 Initialization pgm')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009699 - Midas SD CGL132 initialization                    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD026512           Date 29Apr14               *
      *                 MD026518           Date 30Apr14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  MD026512 - FATCA classification does not automatically       *
      *             default to the set default classification for     *
      *             take-on                                           *
      *  MD026518 - Incorrect drop down selection in US indicia       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)
 
     FSDNAHOPD  IF   E             DISK    INFSR(*PSSR)
 
     FSDFTCSPD  O    E             DISK
 
     FSDFTNHPD  O    E             DISK
 
      ** =======
      ** D-specs
      ** =======
 
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
     D ZHL             S              1    DIM(366)
     D ZHL1            S              1    DIM(366)
 
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,PSDS                                                                   MD026512
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
     D SDFTNH        E DS                  EXTNAME(SDFTNHPD)
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D SYSVAL1         C                    'FATCADftCLsTakeon'
     D SYSVAL2         C                    'FATCADftCLsNewCustNH'
     D SYSVAL3         C                    'FATCAEffectStartDate'
 
     D PRTCD           S              7
     D P@RTCD          S             20    INZ(*BLANKS)
     D P@OP01          S             20    INZ(*BLANKS)
     D P@VL01          S            200    INZ(*BLANKS)
     D P@OP02          S             20    INZ(*BLANKS)
     D P@VL02          S            200    INZ(*BLANKS)
     D P@OP03          S             20    INZ(*BLANKS)
     D P@VL03          S            200    INZ(*BLANKS)
     D P@OP04          S             20    INZ(*BLANKS)
     D P@VL04          S            200    INZ(*BLANKS)
     D P@OP05          S             20    INZ(*BLANKS)
     D P@VL05          S            200    INZ(*BLANKS)
     D P@OP06          S             20    INZ(*BLANKS)
     D P@VL06          S            200    INZ(*BLANKS)
     D P@OP07          S             20    INZ(*BLANKS)
     D P@VL07          S            200    INZ(*BLANKS)
     D P@OP08          S             20    INZ(*BLANKS)
     D P@VL08          S            200    INZ(*BLANKS)
     D P@OP09          S             20    INZ(*BLANKS)
     D P@VL09          S            200    INZ(*BLANKS)
     D P@OP10          S             20    INZ(*BLANKS)
     D P@VL10          S            200    INZ(*BLANKS)
     D DDCLAC          S              5
     D WHH             S              2                                                     MD026512
     D WMM             S              2                                                     MD026512
     D WSS             S              2                                                     MD026512
     D PTimeStamp      S             26Z                                                    MD026512
     D WTimeStamp      S             26A                                                    MD026512
 
     D/COPY ZSRSRC,ZHOLILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   CLEAR                   SDFTCS
     C                   CLEAR                   SDFTNH
                                                                                            MD026512
     C                   EVAL      DDCLAC = P@VL01                                          MD026512
                                                                                            MD026512
     C                   CALLB     'ZAGENTMSTM'                                             MD026512
     C                   PARM                    PTimestamp                                 MD026512
                                                                                            MD026512
     C                   MOVE      PTimestamp    WTimestamp                                 MD026512
     C                   EVAL      WHH = %SUBST(WTimestamp:12:2)                            MD026512
     C                   EVAL      WMM = %SUBST(WTimestamp:15:2)                            MD026512
     C                   EVAL      WSS = %SUBST(WTimestamp:18:2)                            MD026512
 
     C     1             SETLL     SDCUSTPD
     C                   READ      SDCUSTPD
 
     C                   DOW       NOT %EOF(SDCUSTPD)
     C                   EVAL      FACUST = BBCUST
     C                   EVAL      FABRCH = BBBRCD                                          MD026518
     C                   EVAL      FACLAC = DDCLAC
     C                   EVAL      FACLAD = BJRDNB
     C                   EVAL      FARPTT = 'U'
     C                   EVAL      FARPTD = BJRDNB                                          MD026512
     C                   EVAL      FARPTM = WHH + WMM + WSS                                 MD026512
     C                   EVAL      FARPTU = PSUSER                                          MD026512
     C                   EVAL      FALDAT = BJRDNB
     C                   IF        BBTYLC = 'D'
     C                   EVAL      FALCTP = 'D'
     C                   ELSE
     C                   EVAL      FALCTP = 'I'
     C                   ENDIF
     C                   WRITE     SDFTCSD0
     C                   READ      SDCUSTPD
     C                   ENDDO
 
     C     1             SETLL     SDNAHOPD
     C                   READ      SDNAHOPD
 
     C                   DOW       NOT %EOF(SDNAHOPD)
     C                   EVAL      FNNAHO = NHNAHO
     C                   EVAL      FNCLAC = DDCLAC
     C                   EVAL      FNCLAD = BJRDNB
     C                   EVAL      FNRPTT = 'U'
     C                   EVAL      FNRPTD = BJRDNB                                          MD026512
     C                   EVAL      FNRPTM = WHH + WMM + WSS                                 MD026512
     C                   EVAL      FNRPTU = PSUSER                                          MD026512
     C                   EVAL      FNLDAT = BJRDNB
     C                   IF        NHCHTP = 'D'
     C                   EVAL      FNLCTP = 'D'
     C                   ELSE
     C                   EVAL      FNLCTP = 'I'
     C                   ENDIF
     C                   WRITE     SDFTNHD0
     C                   READ      SDNAHOPD
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     BJDFIN        COMP      'M'                                    98
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      SYSVAL1       P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      *BLANKS       P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      *BLANKS       P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      *BLANKS       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10
 
     C     P@RTCD        IFNE      *BLANKS
     C                   EVAL      DBKEY = SYSVAL1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
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
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
