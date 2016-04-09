     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPREIACD   - On-Line Update of Global File GZREIACD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      *  Prev Amend No. AR645170           Date 07Nov12               *
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
 
O    FGZREIACDL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZREIACD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(REIACDF     :W_REIACDF      )
O    F                                     USROPN
     FGPAMADL0  UF A E           K DISK    PREFIX(H_) INFSR(*PSSR)                          BUG16715
     F                                     COMMIT(D_COM) USROPN                             AR645170
O
O    D Z_REIACD      E DS                  EXTNAME(GZREIACD  )
O    D G_REIACD      E DS                  EXTNAME(GZREIACD  ) PREFIX(G_)
 
     D SVDICT          S                   LIKE(G_DICT)                                       CGP017
     D SVDCST          S                   LIKE(G_DCST)                                       CGP017
     D SVCICT          S                   LIKE(G_CICT)                                       CGP017
     D SVCCST          S                   LIKE(G_CCST)                                       CGP017
     D SVCHGT          S                   LIKE(G_CHGT)                                       CGP017
     D SVCHST          S                   LIKE(G_CHST)                                       CGP017
     D SVDACP          S                   LIKE(G_DACP)                                       CGP017
     D SVDICP          S                   LIKE(G_DICP)                                       CGP017
     D SVCACP          S                   LIKE(G_CACP)                                       CGP017
     D SVCICP          S                   LIKE(G_CICP)                                       CGP017
     D SVCHAC          S                   LIKE(G_CHAC)                                       CGP017
     D SVPTRA          S                   LIKE(G_PTRA)                                       CGP017
     D SVPRCH          S                   LIKE(G_PRCH)                                       CGP017
     D SVNOALT         S                   LIKE(G_NOALT)                                      CGP017
     D SVTCHO          S                   LIKE(G_TCHO)                                       CGP017
     D SVDRBR          S                   LIKE(G_DRBR)                                       CGP017
     D SVCRBR          S                   LIKE(G_CRBR)                                       CGP017
     D SVCHBR          S                   LIKE(G_CHBR)                                       CGP017
     D SVPBKU          S                   LIKE(G_PBKU)                                       CGP017
                                                                                              CGP017
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
O    C                   MOVEL     I#BIMG        Z_REIACD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_REIACD
O    C                   ENDIF
O
O    C     K_GZREIACDL1  CHAIN     REIACDF                            99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    REIACDF
     C  N99              EXSR      DELAMAD                                                  BUG16715
O    C                   ELSE
O
O     * 'After'
O
     C     *IN99         IFEQ      *ON                                                        CGP017
     C     *IN99         OREQ      *Off                                                       CGP017
     C     Z_REIACD      ANDNE     G_REIACD                                                   CGP017
      *                                                                                       CGP017
     C     *IN99         IFEQ      *OFF                                                       CGP017
     C                   MOVEL     G_DICT        SVDICT                                       CGP017
     C                   MOVEL     G_DCST        SVDCST                                       CGP017
     C                   MOVEL     G_CICT        SVCICT                                       CGP017
     C                   MOVEL     G_CCST        SVCCST                                       CGP017
     C                   MOVEL     G_CHGT        SVCHGT                                       CGP017
     C                   MOVEL     G_CHST        SVCHST                                       CGP017
     C                   MOVEL     G_DACP        SVDACP                                       CGP017
     C                   MOVEL     G_DICP        SVDICP                                       CGP017
     C                   MOVEL     G_CACP        SVCACP                                       CGP017
     C                   MOVEL     G_CICP        SVCICP                                       CGP017
     C                   MOVEL     G_CHAC        SVCHAC                                       CGP017
     C                   MOVEL     G_PTRA        SVPTRA                                       CGP017
     C                   MOVEL     G_PRCH        SVPRCH                                       CGP017
     C                   MOVEL     G_NOALT       SVNOALT                                      CGP017
     C                   MOVEL     G_TCHO        SVTCHO                                       CGP017
     C                   MOVEL     G_DRBR        SVDRBR                                       CGP017
     C                   MOVEL     G_CRBR        SVCRBR                                       CGP017
     C                   MOVEL     G_CHBR        SVCHBR                                       CGP017
     C                   MOVEL     G_PBKU        SVPBKU                                       CGP017
     C                   ENDIF                                                                CGP017
                                                                                              CGP017
O    C                   CLEAR                   G_REIACD
O    C                   MOVEL     Z_REIACD      G_REIACD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZREIACD  '  I#FILE           10
O    C                   PARM      G_REIACD      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_REIACD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    REIACDF
     C                   IF        (G_DICT <> SVDICT OR                                      CGP017
     C                              G_DCST <> SVDCST OR                                      CGP017
     C                              G_CICT <> SVCICT OR                                      CGP017
     C                              G_CCST <> SVCCST OR                                      CGP017
     C                              G_CHGT <> SVCHGT OR                                      CGP017
     C                              G_CHST <> SVCHST OR                                      CGP017
     C                              G_DACP <> SVDACP OR                                      CGP017
     C                              G_DICP <> SVDICP OR                                      CGP017
     C                              G_CACP <> SVCACP OR                                      CGP017
     C                              G_CICP <> SVCICP OR                                      CGP017
     C                              G_CHAC <> SVCHAC OR                                      CGP017
     C                              G_PTRA <> SVPTRA OR                                      CGP017
     C                              G_PRCH <> SVPRCH OR                                      CGP017
     C                              G_NOALT <> SVNOALT OR                                    CGP017
     C                              G_TCHO <> SVTCHO OR                                      CGP017
     C                              G_DRBR <> SVDRBR OR                                      CGP017
     C                              G_CRBR <> SVCRBR OR                                      CGP017
     C                              G_CHBR <> SVCHBR OR                                      CGP017
     C                              G_PBKU <> SVPBKU)                                        CGP017
     C                   EXSR      UPDAMAD                                                  BUG16715
     C                   ENDIF                                                               CGP017
O    C                   ELSE
O    C                   WRITE     W_REIACDF
O    C                   ENDIF
     C                   ENDIF                                                                CGP017
O    C                   ENDIF
 
     C                   RETURN
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * DELAMAD - Delete GPAMADL0                                                           BUG16715
      ********************************************************************                  BUG16715
     C     DELAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZREIACDL1  CHAIN     GPAMADL0                           99                    BUG16715
     C                   IF        %FOUND(GPAMADL0)                                         BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     *BLANK        H_DICT                                     BUG16715
     C                   MOVEL     *BLANK        H_DCST                                     BUG16715
     C                   MOVEL     *BLANK        H_CICT                                     BUG16715
     C                   MOVEL     *BLANK        H_CCST                                     BUG16715
     C                   MOVEL     *BLANK        H_CHGT                                     BUG16715
     C                   MOVEL     *BLANK        H_CHST                                     BUG16715
     C                   MOVEL     *BLANK        H_DACP                                     BUG16715
     C                   MOVEL     *BLANK        H_DICP                                     BUG16715
     C                   MOVEL     *BLANK        H_CACP                                     BUG16715
     C                   MOVEL     *BLANK        H_CICP                                     BUG16715
     C                   MOVEL     *BLANK        H_CHAC                                     BUG16715
     C                   MOVEL     *BLANK        H_PTRA                                     BUG16715
     C                   MOVEL     *BLANK        H_PRCH                                     BUG16715
     C                   MOVEL     *BLANK        H_NOALT                                    BUG16715
     C                   MOVEL     *BLANK        H_TCHO                                     BUG16715
     C                   MOVEL     *BLANK        H_DRBR                                     BUG16715
     C                   MOVEL     *BLANK        H_CRBR                                     BUG16715
     C                   MOVEL     *BLANK        H_CHBR                                     BUG16715
     C                   MOVEL     *BLANK        H_PBKU                                     BUG16715
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
      * UPDAMAD - Update GPAMADL0                                                           BUG16715
      ********************************************************************                  BUG16715
     C     UPDAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZREIACDL1  CHAIN     GPAMADL0                           99                    BUG16715
     C                   IF        %FOUND(GPAMADL0)                                         BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     G_DICT        H_DICT                                     BUG16715
     C                   MOVEL     G_DCST        H_DCST                                     BUG16715
     C                   MOVEL     G_CICT        H_CICT                                     BUG16715
     C                   MOVEL     G_CCST        H_CCST                                     BUG16715
     C                   MOVEL     G_CHGT        H_CHGT                                     BUG16715
     C                   MOVEL     G_CHST        H_CHST                                     BUG16715
     C                   MOVEL     G_DACP        H_DACP                                     BUG16715
     C                   MOVEL     G_DICP        H_DICP                                     BUG16715
     C                   MOVEL     G_CACP        H_CACP                                     BUG16715
     C                   MOVEL     G_CICP        H_CICP                                     BUG16715
     C                   MOVEL     G_CHAC        H_CHAC                                     BUG16715
     C                   MOVEL     G_PTRA        H_PTRA                                     BUG16715
     C                   MOVEL     G_PRCH        H_PRCH                                     BUG16715
     C                   MOVEL     G_NOALT       H_NOALT                                    BUG16715
     C                   MOVEL     G_TCHO        H_TCHO                                     BUG16715
     C                   MOVEL     G_DRBR        H_DRBR                                     BUG16715
     C                   MOVEL     G_CRBR        H_CRBR                                     BUG16715
     C                   MOVEL     G_CHBR        H_CHBR                                     BUG16715
     C                   MOVEL     G_PBKU        H_PBKU                                     BUG16715
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
O    C                   OPEN      GZREIACDL1
O    C                   OPEN      GZREIACD
     C                   OPEN      GPAMADL0                                                 AR645170
O
O     * Key lists
O
O    C     K_GZREIACDL1  KLIST
O    C                   KFLD                    CNUM
O    C                   KFLD                    CCY
O    C                   KFLD                    ACOD
O    C                   KFLD                    ACSQ
O    C                   KFLD                    BRCA
 
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
