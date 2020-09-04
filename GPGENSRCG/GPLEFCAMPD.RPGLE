     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEFCAMPD - On-Line Update of Global File GZLEFCAMPD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD049445           Date 20Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE106             Date 01Aug04               *
      *                 CGP001  *Create    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD049445 - Listview not displaying correct available amount. *
      *             Added SFAMT and SAVAILAMT computation.            *      
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZLEFCAML1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLEFCAMPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LEFCAMPF    :W_LEFCAMPF     )
O    F                                     USROPN
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)                                     MD049445
     FGPFCAML0  UF   E           K DISK    INFSR(*PSSR) PREFIX(G1_)                         MD049445
     F                                     COMMIT(D_COM) USROPN                             MD049445
     FGPFCAMPD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G1_)                         MD049445
     F                                     RENAME(GPFCAMD0  :GPFCAMD2     )                 MD049445
     F                                     COMMIT(D_COM) USROPN                             MD049445
O
O    D Z_LEFCAMPD    E DS                  EXTNAME(GZLEFCAMPD)
O    D G_LEFCAMPD    E DS                  EXTNAME(GZLEFCAMPD) PREFIX(G_)
     D WFAMD           S              1                                                     MD049445
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_LEFCAMPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LEFCAMPD
O    C                   ENDIF
O
O    C     K_GZLEFCAML1  CHAIN     LEFCAMPF                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LEFCAMPF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LEFCAMPD
O    C                   MOVEL     Z_LEFCAMPD    G_LEFCAMPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLEFCAMPD'  I#FILE           10
O    C                   PARM      G_LEFCAMPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LEFCAMPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LEFCAMPF
O    C                   ELSE
O    C                   WRITE     W_LEFCAMPF
O    C                   ENDIF
O    C                   ENDIF
     C                   EXSR      SRFAMD                                                   MD049445
 
     C                   RETURN
 
      ********************************************************************                  MD049445
     C/SPACE 5                                                                              MD049445
      ********************************************************************                  MD049445
      * SRFAMD - Compute for FIFD total                                                     MD049445
      ********************************************************************                  MD049445
     C     SRFAMD        BEGSR                                                              MD049445
      * get rundate                                                                         MD049445
     C     I#ZONE        CHAIN     GZSDBANKL1                         98                    MD049445
      * read thru facility events                                                           MD049445
     C                   EVAL      G1_GBRCA = G_BRCA                                        MD049445
     C                   EVAL      G1_GCNUM = G_CNUM                                        MD049445
     C                   EVAL      G1_GFACT = G_FACT                                        MD049445
     C                   EVAL      G1_GFCNO = G_FCNO                                        MD049445
      *                                                                                     MD049445
     C     K_GZLEFCAML2  CHAIN     GPFCAML0                           96                    MD049445
     C                   EVAL      G1_GAAMT = 0                                             MD049445
     C                   EVAL      G1_GZONE = I#ZONE                                        MD049445
      *                                                                                     MD049445
     C     K_GZLEFCAML2  SETLL     LEFCAMPF                                                 MD049445
     C     K_GZLEFCAML2  READE     LEFCAMPF                               97                MD049445
     C                   EVAL      WFAMD = 'N'                                              MD049445
      * compute for facility increase/decrease                                              MD049445
     C     *IN97         DOWEQ     *OFF                                                     MD049445
     C                   EVAL      WFAMD = 'Y'                                              MD049445
     C                   IF        G_RECI = 'D'                                             MD049445
     C                   IF        G_FATP = 'FI'                                            MD049445
     C                             AND G_VLDT <= BJRDNB                                     MD049445
     C                   EVAL      G1_GAAMT = G1_GAAMT + G_AAMT                             MD049445
     C                   ENDIF                                                              MD049445
     C                   IF        G_FATP = 'FD'                                            MD049445
     C                             AND G_VLDT <= BJRDNB                                     MD049445
     C                   EVAL      G1_GAAMT = G1_GAAMT - G_AAMT                             MD049445
     C                   ENDIF                                                              MD049445
     C                   ENDIF                                                              MD049445
     C     K_GZLEFCAML2  READE     LEFCAMPF                               97                MD049445
     C                   ENDDO                                                              MD049445
      * update GPFCAMPD                                                                     MD049445
     C     *IN96         IFEQ      *OFF                                                     MD049445
     C     WFAMD         IFEQ      'Y'                                                      MD049445
     C                   UPDATE    GPFCAMD0                                                 MD049445
     C                   ELSE                                                               MD049445
     C                   DELETE    GPFCAMD0                                                 MD049445
     C                   ENDIF                                                              MD049445
     C                   ELSE                                                               MD049445
     C                   WRITE     GPFCAMD2                                                 MD049445
     C                   ENDIF                                                              MD049445
     C                   ENDSR                                                              MD049445
      ********************************************************************                  MD049445
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GZLEFCAML1
O    C                   OPEN      GZLEFCAMPD
     C                   OPEN      GPFCAML0                                                 MD049445
     C                   OPEN      GPFCAMPD                                                 MD049445
O
O     * Key lists
O
O    C     K_GZLEFCAML1  KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    CNUM
O    C                   KFLD                    FACT
O    C                   KFLD                    FCNO
O    C                   KFLD                    VLDT
O    C                   KFLD                    SQNO
 
     C     K_GZLEFCAML2  KLIST                                                              MD049445
     C                   KFLD                    G1_GBRCA                                   MD049445
     C                   KFLD                    G1_GCNUM                                   MD049445
     C                   KFLD                    G1_GFACT                                   MD049445
     C                   KFLD                    G1_GFCNO                                   MD049445
                                                                                            MD049445
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************