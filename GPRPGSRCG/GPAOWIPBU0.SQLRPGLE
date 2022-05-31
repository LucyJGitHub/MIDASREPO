     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP WIP Configuration Updater')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAOWIPBU0 - Midas GP WIP Configuration Updater              *
      *                                                               *
      *  Function:  This program updates the WC_AUTOA field of        *
      *             GPWIPBTD file for CLE125 enhancement.             *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CLE125  *CREATE    Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE125 - Amendment to LE Authorization Rules                 *
      *                                                               *
      *****************************************************************
      *
      ** Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
     D PMode           S              4
      *
      ** Parameters for GOGETZONE
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#FULLCHECK     S              1A
     D O#ZONE          S             10A
     D O#SHTC          S              4A
     D O#RDNB          S              5  0
     D O#DNWD          S              5  0
     D O#BCCY          S              3A
     D O#NJOB          S              1  0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main Procedure                                                *
      *****************************************************************
      *
      ** Update records in GPWIPBTD
      *
     C/EXEC SQL
     C+ update GPWIPBTD
     C+ set WC_AUTOA = 'Y' where WC_API in ('CLIP', 'FAMD', 'FCIP', 'FEAD',
     C+                     'FEEM', 'FEST', 'LERI', 'LOAM', 'MAPY', 'RPSC')
     C+                     and WC_ZONE = :O#ZONE
     C/END-EXEC
      *
      ** Check for error in SQL execution
      *
     C                   IF        SQLCODE <> 0 AND
     C                             SQLCODE <> 100
     C                   EVAL      PMode = '*ERR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** End program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Get current zone
      *
     C                   CALL      'GOGETZONE'
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
     C                   PARM      'Y'           I#FULLCHECK
     C                   PARM                    O#ZONE
     C                   PARM                    O#SHTC
     C                   PARM                    O#RDNB
     C                   PARM                    O#DNWD
     C                   PARM                    O#BCCY
     C                   PARM                    O#NJOB
      *
      ** No zone
      *
     C     O#ZONE        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO ZONE PRESENT'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR  - Abnormal Error Conditions                            *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
