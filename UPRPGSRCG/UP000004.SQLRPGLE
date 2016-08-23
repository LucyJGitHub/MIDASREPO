     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Remove old Switchable Feature data')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000004 - Remove old Switchable Feature data                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CUP040 *CREATE      Date 08Aug13              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     D FeatureData     S             20    DIM(18) CTDATA PERRCD(1)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFeature
      *
     C                   DO        18
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
** FeatureData
SCSARBPD  GBSARN
SCSARCPD  ACSARN
SCSARDPD  SARN
SCSAREPD  SARN
SCSARIPD  ADSARN
SCSARMPD  AESARN
SCSAROPD  AFSARN
SCSARPPD  AKSARN
SCSARRPD  AHSARN
SCSARSPD  AXSARN
SCSARTPD  GUSARN
SCSARVPD  GSSARN
SCSARWPD  GTSARN
SCSARXPD  DSON
SCSARXPD  DDON
SCSARZPD  AXSARN
SCPASSPD  P@SARN
GPCSECPD  P@SARN
