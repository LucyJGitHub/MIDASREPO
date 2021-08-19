     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Remove old Switchable Feature data')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000004 - Remove old Switchable Feature data                *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD054346           Date 18Jul21               *
      *  Prev Amend No. MD056555           Date 31Aug20               *
      *                 MD055682           Date 31Jul20               *
      *                 MD055681           Date 31Jul20               *
      *                 CUP040 *CREATE      Date 08Aug13              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054346 - Switchable Features Password Encryption           *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD055682 - Deliverable Data Split for TRIG                   *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  CUP040 - New utility to remove Switchable Feature data.      *
      *                                                               *
      *****************************************************************
      *
     D PFeature        S              6
      *
     D File            S             10
     D Field           S             10
     D SQLString       S           5000
     D Quote           S              1    INZ('''')
     D Recursive       S              1
     D x               S              3  0 INZ(1)
      *
     D*FeatureData     S             20    DIM(18) CTDATA PERRCD(1)                         MD055682
     D*FeatureData     S             20    DIM(19) CTDATA PERRCD(1)                MD055682 MD054346
     D*FeatureData     S             20    DIM(17) CTDATA PERRCD(1)                MD054346 MD056555
     D FeatureData     S             20    DIM(28) CTDATA PERRCD(1)                         MD056555
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFeature
      *
     C**********         DO        18                                                       MD055682
     C**********         DO        19                                              MD055682 MD056555
     C                   DO        28                                                       MD056555
      *
     C                   EVAL      SQLString = 'delete from ' +
     C                             %TRIMR(%SUBST(FeatureData(x):1:10)) +
     C                             ' where ' +
     C                             %TRIMR(%SUBST(FeatureData(x):11:10)) +
     C                             ' = ' + Quote + PFeature + Quote
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C                   EVAL      x = x + 1
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANKS
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *****************************************************************
      * SCSAREPD, SCSARZPD are now removed from the array                                   MD055681
      * replace SCSARSPD by SCSRSCTD                                                        MD055681
      * add SCSRSXTD                                                                        MD055681
      * replace SCSARDPD by SCSRDCTD                                                        MD055681
      * add SCSRDXTD                                                                        MD055681
      * replace SCSARTPD by SCSRTCTD                                                        MD055682
      * add SCSRTXTD                                                                        MD055682
      * replace SCSAROPD by SCSROCTD, SCSARBTD by SCSRBCTD, SCSARCPD by SCSRCCTD,           MD056555
      * SCSARIPD by SCSRICTD, SCSARMPD by SCSRMCTD, SCSARPPD by SCSRPCTD,                   MD056555
      * SCSARRPD by SCSRRCTD, SCSARVPD by SCSRVCTD, SCSARWPD by SCSRWCTD                    MD056555
      * SCSARXPD by SCSRXCTD                                                                MD056555
      * add SCSROXTD, SCSRBXTD, SCSRCXTD, SCSRIXTD, SCSRMXTD, SCSRPXTD,                     MD056555
      * SCSRRXTD, SCSRVXTD, SCSRWXTD, SCSRXXTD                                              MD056555
      * remove SCPASSPD, GPCSECPD                                                           MD054346
** FeatureData
SCSRBCTD  GBSARN
SCSRBXTD  GBSARN
SCSRCCTD  ACSARN
SCSRCXTD  ACSARN
SCSRDCTD  SARN
SCSRDXTD  SARN
SCSRICTD  ADSARN
SCSRIXTD  ADSARN
SCSRMCTD  AESARN
SCSRMXTD  AESARN
SCSROCTD  AFSARN
SCSROXTD  AFSARN
SCSRPCTD  AKSARN
SCSRPXTD  AKSARN
SCSRRCTD  AHSARN
SCSRRXTD  AHSARN
SCSRSCTD  AXSARN
SCSRSXTD  AXSARN
SCSRTCTD  GUSARN
SCSRTXTD  GUSARN
SCSRVCTD  GSSARN
SCSRVXTD  GSSARN
SCSRWCTD  GTSARN
SCSRWXTD  GTSARN
SCSRXCTD  DSON
SCSRXCTD  DDON
SCSRXXTD  DSON
SCSRXXTD  DDON
