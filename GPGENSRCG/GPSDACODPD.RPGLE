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
      *  GPSDACODPD - On-Line Update of Global File GZSDACODPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      *  Prev Amend No. AR645170           Date 07Nov12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG16715           Date 16Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
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
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG16715 - Slow performance unable to locate an Account      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZSDACODL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDACODPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDACODD0    :W_SDACODD0     )
O    F                                     USROPN
     FGPAMADL2  UF A E           K DISK    PREFIX(H_) INFSR(*PSSR)                          BUG16715
     F                                     COMMIT(D_COM) USROPN                             AR645170
O
O    D Z_SDACODPD    E DS                  EXTNAME(GZSDACODPD)
O    D G_SDACODPD    E DS                  EXTNAME(GZSDACODPD) PREFIX(G_)
 
     D SVA5NARR        S                   LIKE(G_A5NARR)                                     CGP017
     D SVA5ACSC        S                   LIKE(G_A5ACSC)                                     CGP017
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
O    C                   MOVEL     I#BIMG        Z_SDACODPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDACODPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        A5ZONE
O
O    C     K_GZSDACODL1  CHAIN     SDACODD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDACODD0
     C  N99              EXSR      DELAMAD                                                  BUG16715
O    C                   ELSE
O
O     * 'After'
O
     C                   EVAL      SVA5NARR = G_A5NARR                                        CGP017
     C                   EVAL      SVA5ACSC = G_A5ACSC                                        CGP017
O    C                   CLEAR                   G_SDACODPD
O    C                   MOVEL     Z_SDACODPD    G_SDACODPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDACODPD'  I#FILE           10
O    C                   PARM      G_SDACODPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDACODPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDACODD0
     C                   IF        (G_A5NARR <> SVA5NARR OR                                   CGP017
     C                              G_A5ACSC <> SVA5ACSC)                                     CGP017
     C                   EXSR      UPDAMAD                                                  BUG16715
O    C                   ENDIF                                                                CGP017
O    C                   ELSE
O    C                   WRITE     W_SDACODD0
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * DELAMAD - Delete GPAMADL2                                                           BUG16715
      ********************************************************************                  BUG16715
     C     DELAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZSDACODL1  SETLL     GPAMADL2                                                 BUG16715
     C     K_GZSDACODL1  READE     GPAMADL2                                                 BUG16715
     C                   DOW       NOT %EOF(GPAMADL2)                                       BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     *BLANK        H_A5NARR                                   BUG16715
     C                   MOVEL     *BLANK        H_A5ACSC                                   BUG16715
                                                                                            BUG16715
      * Update                                                                              BUG16715
                                                                                            BUG16715
     C                   UPDATE    AMADREC                                                  BUG16715
     C     K_GZSDACODL1  READE     GPAMADL2                                                 BUG16715
     C                   ENDDO                                                              BUG16715
                                                                                            BUG16715
     C                   ENDSR                                                              BUG16715
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * UPDAMAD - Update GPAMADL2                                                           BUG16715
      ********************************************************************                  BUG16715
     C     UPDAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZSDACODL1  SETLL     GPAMADL2                                                 BUG16715
     C     K_GZSDACODL1  READE     GPAMADL2                                                 BUG16715
     C                   DOW       NOT %EOF(GPAMADL2)                                       BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     G_A5NARR      H_A5NARR                                   BUG16715
     C                   MOVEL     G_A5ACSC      H_A5ACSC                                   BUG16715
                                                                                            BUG16715
      * Update                                                                              BUG16715
                                                                                            BUG16715
     C                   UPDATE    AMADREC                                                  BUG16715
     C     K_GZSDACODL1  READE     GPAMADL2                                                 BUG16715
     C                   ENDDO                                                              BUG16715
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
O    C                   OPEN      GZSDACODL1
O    C                   OPEN      GZSDACODPD
     C                   OPEN      GPAMADL2                                                 AR645170
O
O     * Key lists
O
O    C     K_GZSDACODL1  KLIST
O    C                   KFLD                    A5ZONE
O    C                   KFLD                    A5ACCD
 
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
