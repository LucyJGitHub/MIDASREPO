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
      *  GPRECOMD   - On-Line Update of Global File GZRECOMD          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 AR645170           Date 07Nov12               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG16715           Date 16Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  AR645170 - GL: Accounts is not present on file ACCNTAB but   *
      *             present in the Java Listview. Add commit to file  *
      *             so that GPAMADPD will be properly rollback when   *
      *             unsuccesfull write to PF/ACCNTAB.                 *
      *             (Child: AR645178)                                 *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG16715 - Slow performance unable to locate an Account      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZRECOMDL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZRECOMD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(RECOMDF     :W_RECOMDF      )
O    F                                     USROPN
     FGPAMADL1  UF A E           K DISK    PREFIX(H_) INFSR(*PSSR)                          BUG16715
     F                                     COMMIT(D_COM) USROPN                             AR645170
O
O    D Z_RECOMD      E DS                  EXTNAME(GZRECOMD  )
O    D G_RECOMD      E DS                  EXTNAME(GZRECOMD  ) PREFIX(G_)
 
     D SVCEXA          S                   LIKE(G_CEXA)                                       CGP017
     D SVCEXB          S                   LIKE(G_CEXB)                                       CGP017
     D SVCEXC          S                   LIKE(G_CEXC)                                       CGP017
     D SVCEXD          S                   LIKE(G_CEXD)                                       CGP017
     D SVCEXE          S                   LIKE(G_CEXE)                                       CGP017
     D SVCEXF          S                   LIKE(G_CEXF)                                       CGP017
     D SVCEXG          S                   LIKE(G_CEXG)                                       CGP017
     D SVACCRA         S                   LIKE(G_ACCRA)                                      CGP017
     D SVMMACC         S                   LIKE(G_MMACC)                                      CGP017
     D SVCDRR          S                   LIKE(G_CDRR)                                       CGP017
     D SVMMCDI         S                   LIKE(G_MMCDI)                                      CGP017
     D SVCHDBR         S                   LIKE(G_CHDBR)                                      CGP017
     D SVMMCHDB        S                   LIKE(G_MMCHDB)                                     CGP017
     D SVCACDC         S                   LIKE(G_CACDC)                                      CGP017
     D SVTEGRT         S                   LIKE(G_TEGRT)                                      CGP017
     D SVNOIS          S                   LIKE(G_NOIS)                                       CGP017
     D SVNOCC          S                   LIKE(G_NOCC)                                       CGP017
     D SVPESP          S                   LIKE(G_PESP)                                       CGP017
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
O    C                   MOVEL     I#BIMG        Z_RECOMD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_RECOMD
O    C                   ENDIF
O
O    C     K_GZRECOMDL1  CHAIN     RECOMDF                            99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    RECOMDF
     C  N99              EXSR      DELAMAD                                                  BUG16715
O    C                   ELSE
O
O     * 'After'
O
     C                   IF        *IN99 = *ON OR (*IN99 = *OFF AND                           CGP017
     C                             Z_RECOMD <> G_RECOMD)                                      CGP017
      *                                                                                       CGP017
     C                   IF        *IN99 = *OFF                                               CGP017
     C                   MOVEL     G_CEXA        SVCEXA                                       CGP017
     C                   MOVEL     G_CEXB        SVCEXB                                       CGP017
     C                   MOVEL     G_CEXC        SVCEXC                                       CGP017
     C                   MOVEL     G_CEXD        SVCEXD                                       CGP017
     C                   MOVEL     G_CEXE        SVCEXE                                       CGP017
     C                   MOVEL     G_CEXF        SVCEXF                                       CGP017
     C                   MOVEL     G_CEXG        SVCEXG                                       CGP017
     C                   MOVEL     G_ACCRA       SVACCRA                                      CGP017
     C                   MOVEL     G_MMACC       SVMMACC                                      CGP017
     C                   MOVEL     G_CDRR        SVCDRR                                       CGP017
     C                   MOVEL     G_MMCDI       SVMMCDI                                      CGP017
     C                   MOVEL     G_CHDBR       SVCHDBR                                      CGP017
     C                   MOVEL     G_MMCHDB      SVMMCHDB                                     CGP017
     C                   MOVEL     G_CACDC       SVCACDC                                      CGP017
     C                   MOVEL     G_TEGRT       SVTEGRT                                      CGP017
     C                   MOVEL     G_NOIS        SVNOIS                                       CGP017
     C                   MOVEL     G_NOCC        SVNOCC                                       CGP017
     C                   MOVEL     G_PESP        SVPESP                                       CGP017
     C                   ENDIF                                                                CGP017
      *                                                                                       CGP017
O    C                   CLEAR                   G_RECOMD
O    C                   MOVEL     Z_RECOMD      G_RECOMD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZRECOMD  '  I#FILE           10
O    C                   PARM      G_RECOMD      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_RECOMD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    RECOMDF
     C                   IF        (G_CEXA <> SVCEXA OR                                      CGP017
     C                              G_CEXB <> SVCEXB OR                                      CGP017
     C                              G_CEXC <> SVCEXC OR                                      CGP017
     C                              G_CEXD <> SVCEXD OR                                      CGP017
     C                              G_CEXE <> SVCEXE OR                                      CGP017
     C                              G_CEXF <> SVCEXF OR                                      CGP017
     C                              G_CEXG <> SVCEXG OR                                      CGP017
     C                              G_ACCRA <> SVACCRA OR                                    CGP017
     C                              G_MMACC <> SVMMACC OR                                    CGP017
     C                              G_CDRR <> SVCDRR OR                                      CGP017
     C                              G_MMCDI <> SVMMCDI OR                                    CGP017
     C                              G_CHDBR <> SVCHDBR OR                                    CGP017
     C                              G_MMCHDB <> SVMMCHDB OR                                  CGP017
     C                              G_CACDC <> SVCACDC OR                                    CGP017
     C                              G_TEGRT <> SVTEGRT OR                                    CGP017
     C                              G_NOIS <> SVNOIS OR                                      CGP017
     C                              G_NOCC <> SVNOCC OR                                      CGP017
     C                              G_PESP <> SVPESP)                                        CGP017
     C                   EXSR      UPDAMAD                                                  BUG16715
O    C                   ENDIF                                                               CGP017
O    C                   ELSE
O    C                   WRITE     W_RECOMDF
O    C                   ENDIF
     C                   ENDIF                                                                CGP017
O    C                   ENDIF
 
     C                   RETURN
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * DELAMAD - Delete GPAMADL1                                                           BUG16715
      ********************************************************************                  BUG16715
     C     DELAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZRECOMDL1  CHAIN     GPAMADL1                           99                    BUG16715
     C                   IF        %FOUND(GPAMADL1)                                         BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     *BLANK        H_CEXA                                     BUG16715
     C                   MOVEL     *BLANK        H_CEXB                                     BUG16715
     C                   MOVEL     *BLANK        H_CEXC                                     BUG16715
     C                   MOVEL     *BLANK        H_CEXD                                     BUG16715
     C                   MOVEL     *BLANK        H_CEXE                                     BUG16715
     C                   MOVEL     *BLANK        H_CEXF                                     BUG16715
     C                   MOVEL     *BLANK        H_CEXG                                     BUG16715
     C                   MOVEL     *BLANK        H_ACCRA                                    BUG16715
     C                   MOVEL     *BLANK        H_MMACC                                    BUG16715
     C                   MOVEL     *BLANK        H_CDRR                                     BUG16715
     C                   MOVEL     *BLANK        H_MMCDI                                    BUG16715
     C                   MOVEL     *BLANK        H_CHDBR                                    BUG16715
     C                   MOVEL     *BLANK        H_MMCHDB                                   BUG16715
     C                   MOVEL     *BLANK        H_CACDC                                    BUG16715
     C                   MOVEL     *BLANK        H_TEGRT                                    BUG16715
     C                   MOVEL     *BLANK        H_NOIS                                     BUG16715
     C                   MOVEL     *BLANK        H_NOCC                                     BUG16715
     C                   MOVEL     *BLANK        H_PESP                                     BUG16715
                                                                                            BUG16715
      * Update                                                                              BUG16715
                                                                                            BUG16715
     C                   UPDATE    AMADREC                                                  BUG16715
     C                   ENDIF                                                              BUG16715
                                                                                            BUG16715
     C                   ENDSR                                                              BUG16715
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * UPDAMAD - Update GPAMADL1                                                           BUG16715
      ********************************************************************                  BUG16715
     C     UPDAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZRECOMDL1  CHAIN     GPAMADL1                           99                    BUG16715
     C                   IF        %FOUND(GPAMADL1)                                         BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     G_CEXA        H_CEXA                                     BUG16715
     C                   MOVEL     G_CEXB        H_CEXB                                     BUG16715
     C                   MOVEL     G_CEXC        H_CEXC                                     BUG16715
     C                   MOVEL     G_CEXD        H_CEXD                                     BUG16715
     C                   MOVEL     G_CEXE        H_CEXE                                     BUG16715
     C                   MOVEL     G_CEXF        H_CEXF                                     BUG16715
     C                   MOVEL     G_CEXG        H_CEXG                                     BUG16715
     C                   MOVEL     G_ACCRA       H_ACCRA                                    BUG16715
     C                   MOVEL     G_MMACC       H_MMACC                                    BUG16715
     C                   MOVEL     G_CDRR        H_CDRR                                     BUG16715
     C                   MOVEL     G_MMCDI       H_MMCDI                                    BUG16715
     C                   MOVEL     G_CHDBR       H_CHDBR                                    BUG16715
     C                   MOVEL     G_MMCHDB      H_MMCHDB                                   BUG16715
     C                   MOVEL     G_CACDC       H_CACDC                                    BUG16715
     C                   MOVEL     G_TEGRT       H_TEGRT                                    BUG16715
     C                   MOVEL     G_NOIS        H_NOIS                                     BUG16715
     C                   MOVEL     G_NOCC        H_NOCC                                     BUG16715
     C                   MOVEL     G_PESP        H_PESP                                     BUG16715
                                                                                            BUG16715
      * Update                                                                              BUG16715
                                                                                            BUG16715
     C                   UPDATE    AMADREC                                                  BUG16715
     C                   ENDIF                                                              BUG16715
                                                                                            BUG16715
     C                   ENDSR                                                              BUG16715
 
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
O    C                   OPEN      GZRECOMDL1
O    C                   OPEN      GZRECOMD
     C                   OPEN      GPAMADL1                                                 AR645170
O
O     * Key lists
O
O    C     K_GZRECOMDL1  KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    CNUM
O    C                   KFLD                    CCY
O    C                   KFLD                    ACOD
O    C                   KFLD                    ACSQ
 
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
