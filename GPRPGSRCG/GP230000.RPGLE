     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Retail Acct Balance Extract Updater')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP230000 - Retail Acct Balance Extract Updater               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27926           Date 29Jul10               *
      *                 BUG27878           Date 06Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27288 *CREATE   Date 07Apr10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27926 - Record locking in GPRABEPD                        *
      *  BUG27878 - Projected Available Balance Enquiry(recompile)    *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE                                      *
      *                                                               *
      *****************************************************************
 
     FGPRABEL0  UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGPRABEPD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(GPRABED0:W_GPRABED0)
     F                                     USROPN
     FGPCUSTXL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     D Z_GPRABEPD    E DS                  EXTNAME(GPRABEPD)
     D G_GPRABEPD    E DS                  EXTNAME(GPRABEPD) PREFIX(G_)
 
      ** Override
     D ##OVR           S              1    DIM(60) CTDATA PERRCD(60)
 
     D WRun            S              1    INZ(' ')
     D WOpen           S              1    INZ(' ')
 
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Global File Updates
 
     C                   MOVEL     I#RecordIMAGE Z_GPRABEPD
 
     C     K_GPRABEL0    CHAIN     GPRABEL0                           99
 
      ** 'DELETE'
 
     C     I#Delete      IFEQ      'Y'
     C  N99              DELETE    GPRABED0
     C                   ELSE
 
      ** Access Global Customer X-Reference Details if required
 
     C     I#GPCustDet   IFEQ      'Y'
     C     K_GPCUSTX     CHAIN     GPCUSTXL1
     C                   IF        %FOUND(GPCUSTXL1)
     C                   EVAL      ABGCNM  = CUGCUS
     C                   ELSE
     C                   EVAL      ABGCNM  = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** 'UPDATE or WRITE'
 
     C                   CLEAR                   G_GPRABEPD
     C                   MOVEL     Z_GPRABEPD    G_GPRABEPD
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    GPRABED0
     C                   ELSE
     C                   WRITE     W_GPRABED0
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON                                              BUG27926
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine called automatically at program   *
      *          start                                                *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#COMMIT          1
     C                   PARM                    I#Delete          1
     C                   PARM                    I#GPCustDet       1
     C                   PARM                    I#RecordIMAGE 32000
 
      ** Open for commit?
 
     C     I#COMMIT      IFEQ      'Y'
     C                   MOVEL     '1'           D_COM             1
     C                   ELSE
     C                   MOVEL     '0'           D_COM
     C                   ENDIF
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OVR
     C                   PARM      60            MESLEN           15 5
 
     C                   IF        WOpen <> 'Y'
     C                   OPEN      GPRABEL0
     C                   OPEN      GPRABEPD
     C                   OPEN      GPCUSTXL1
     C                   EVAL      WOpen = 'Y'
     C                   ENDIF
 
      ** Key lists
 
     C     K_GPRABEL0    KLIST
     C                   KFLD                    ABBRCD
     C                   KFLD                    ABCNUM
     C                   KFLD                    ABCCY
     C                   KFLD                    ABACOD
     C                   KFLD                    ABACSQ
 
     C     K_GPCUSTX     KLIST
     C                   KFLD                    ABBRCD
     C                   KFLD                    ABCNUM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  --- Abnormal Error Conditions                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     WRun          IFEQ      *BLANKS
 
     C                   MOVE      'Y'           WRun
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
 
     C                   DUMP
 
      ** If no identified cause of error
 
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
 
     C                   CLOSE     GPRABEL0
     C                   CLOSE     GPRABEPD
     C                   CLOSE     GPCUSTXL1
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** ##OVR
OVRDBF FILE(GPRABEL0) TOFILE(GPRABEL0) SHARE(*NO)
