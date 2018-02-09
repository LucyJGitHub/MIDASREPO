     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP API Acnt Master Detail Defn file Updater')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAMADUPD - Midas GP API Account Master Detail Definition    *
      *              File Updater                                     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
     FGPAMADL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(G_)
 
     D Z_GPAMADPD    E DS                  EXTNAME(GPAMADL0)
     D G_GPAMADPD    E DS                  EXTNAME(GPAMADL0)
     D                                     PREFIX(G_)
 
      ** ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#Delete          1
     C                   PARM                    I#RecordIMAGE 32000
 
     C                   EVAL      Z_GPAMADPD = I#RecordIMAGE
 
     C     K_GPAMADPD    CHAIN     GPAMADL0
 
      ** Delete
 
     C                   IF        I#Delete = 'Y'
     C                             AND %FOUND(GPAMADL0)
     C                   DELETE    GPAMADL0
     C                   ELSE
 
      ** 'UPDATE or WRITE'
 
     C                   CLEAR                   G_GPAMADPD
     C                   EVAL      G_GPAMADPD = Z_GPAMADPD
 
     C                   IF        %FOUND(GPAMADL0)
     C                   UPDATE    AMADREC
     C                   ELSE
     C                   WRITE     AMADREC
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine called automatically at program   *
      *          start                                                *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     K_GPAMADPD    KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  --- Abnormal Error Conditions                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      I#RTCD = '*ERROR'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP
 
     C                   IF        I#ERMS = *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
 
     C                   RETURN
     C                   ENDSR
      *****************************************************************
