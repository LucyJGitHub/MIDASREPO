     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBIA*  DSPFFD FILE(GPZONEPD) OUTPUT(*OUTFILE)                       *
/*XBIA*  OUTFILE(QTEMP/QWHDRFFD) OUTMBR(*FIRST *REPLACE)              *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Field Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0008 - Field Retrieval                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP009             Date 22Dec04               *
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUFDL1  UF A E           K DISK    INFSR(*PSSR)
     FQWHDRFFD  IF   E             DISK    USROPN INFSR(*PSSR)
     F                                     RENAME(QWHDRFFD:FFD)
 
     D #_DS            S              1    DIM(90) CTDATA PERRCD(65)
     D #_VCH           S              1    DIM(80) CTDATA PERRCD(80)
 
 
     D #_DTC           S              1    DIM(30)
 
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C* INITIAL PROCESSING
 
     C                   EXSR      INIT
 
     C* GET FIELDS
 
     C                   EXSR      GETFDS
 
     C                   SETON                                        LR
 
      ********************************************************************
      * Get fields
      ********************************************************************
     C     GETFDS        BEGSR
 
     C* DELETE ALL EXISTING AUDIT FIELDS
 
     C     GPAUFLK       SETLL     GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               90    *
     C                   END
 
     C* LOAD FIELDS
 
     C                   MOVEA     AFFILE        #_DS(13)
     C                   Z-ADD     88            #MESLN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_DS
     C                   PARM      88            #MESLN           15 5
      *
     C                   OPEN      QWHDRFFD
     C                   READ      QWHDRFFD                               90
     C     *IN90         DOWEQ     '0'
     C                   EXSR      INTFLD
     C                   EXSR      DEFFLD
     C                   WRITE     GPAUFDD0
     C                   ADD       1             AFFLDN
     C                   READ      QWHDRFFD                               90
     C                   ENDDO
     C                   CLOSE     QWHDRFFD
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Initialize field values
      ********************************************************************
     C     INTFLD        BEGSR
     C                   MOVEL     WHFLDI        AFRPGN
     C                   MOVEL     WHFLDI        AFSNAM
     C                   Z-ADD     WHFOBO        AFFOBO
     C                   MOVEL     WHFLDT        AFTYPE
     C     AFTYPE        IFEQ      'Z'
     C                   MOVEL     'A'           AFTYPE
     C                   ENDIF
     C                   Z-ADD     WHFLDB        AFLEN
     C     WHFLDT        IFEQ      'A'
     C     WHFLDT        OREQ      'Z'
     C                   Z-ADD     WHFLDB        AFDIG
     C                   ELSE
     C                   Z-ADD     WHFLDD        AFDIG
     C                   END
     C                   Z-ADD     WHFLDP        AFDEC
 
     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     WHFTXT        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFFDES
     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     WHCHD1        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL1
     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     WHCHD2        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL2
     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     WHCHD3        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL3
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Default field values
      ********************************************************************
     C     DEFFLD        BEGSR
     C                   MOVEL     *BLANK        AFEDTW
     C                   Z-ADD     AFDIG         AFEDTS
     C                   MOVEL     *BLANK        AFREFF
     C                   MOVEL     *BLANK        AFBRCF
     C                   Z-ADD     99999         AFWSEQ
     C                   Z-ADD     99999         AFRSEQ
     C                   Z-ADD     0             AFSPCB
     C                   Z-ADD     0             AFLN
     C                   Z-ADD     0             AFPS
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Remove invalid characters
      ********************************************************************
     C     RMV_INVC      BEGSR
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     30
     C                   Z-ADD     1             Y                 3 0
     C     #_DTC(X)      LOOKUP    #_VCH(Y)                               99    *
     C  N99              MOVEL     *BLANK        #_DTC(X)
     C                   ADD       1             X
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC           40
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Check for error
      ********************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
** #_DS
DSPFFD FILE(          ) OUTPUT(*OUTFILE) OUTFILE(QTEMP/QWHDRFFD)
OUTMBR(*FIRST *REPLACE)
** #_VCH
 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#@0123456789.,:;/+*¢$%&()"|
