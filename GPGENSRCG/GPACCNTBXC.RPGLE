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
      *  GPACCNTBXC - On-Line Update of Global File GZACCNTBXC        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CGP017             Date 06Aug12               *
      *                 AR645170           Date 07Nov10               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
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
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZACCNTBL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZACCNTBXCO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(ACCNTBD0    :W_ACCNTBD0     )
O    F                                     USROPN
     FGPAMADL0  UF A E           K DISK    PREFIX(H_) INFSR(*PSSR)                          BUG16715
     F                                     COMMIT(D_COM) USROPN                             AR645170
O
O    D Z_ACCNTBXC    E DS                  EXTNAME(GZACCNTBXC)
O    D G_ACCNTBXC    E DS                  EXTNAME(GZACCNTBXC) PREFIX(G_)

     D SVATCRST        S                   LIKE(G_ATCRST)                                     CGP017
     D SVATSUBO        S                   LIKE(G_ATSUBO)                                     CGP017
     D SVATITAX        S                   LIKE(G_ATITAX)                                     CGP017
     D SVATSTCI        S                   LIKE(G_ATSTCI)                                     CGP017
     D SVATCHIN        S                   LIKE(G_ATCHIN)                                     CGP017
     D SVATAODR        S                   LIKE(G_ATAODR)                                     CGP017
     D SVATITRD        S                   LIKE(G_ATITRD)                                     CGP017
     D SVATORTC        S                   LIKE(G_ATORTC)                                     CGP017
     D SVATOLVD        S                   LIKE(G_ATOLVD)                                     CGP017
     D SVATPOLC        S                   LIKE(G_ATPOLC)                                     CGP017
     D SVATPOLE        S                   LIKE(G_ATPOLE)                                     CGP017
     D SVATOVRD        S                   LIKE(G_ATOVRD)                                     CGP017
     D SVATOVRC        S                   LIKE(G_ATOVRC)                                     CGP017
     D SVATDRMG        S                   LIKE(G_ATDRMG)                                     CGP017
     D SVATCRMG        S                   LIKE(G_ATCRMG)                                     CGP017
     D SVATDRMD        S                   LIKE(G_ATDRMD)                                     CGP017
     D SVATCRMD        S                   LIKE(G_ATCRMD)                                     CGP017
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
O    C                   MOVEL     I#BIMG        Z_ACCNTBXC
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_ACCNTBXC
O    C                   ENDIF
O
O    C     K_GZACCNTBL1  CHAIN     ACCNTBD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    ACCNTBD0
     C  N99              EXSR      DELAMAD                                                  BUG16715
O    C                   ELSE
O
O     * 'After'
O
     C                   IF        *IN99 = *ON OR                                             CGP017
     C                             *IN99 = *OFF AND                                           CGP017
     C                             Z_ACCNTBXC <> G_ACCNTBXC                                   CGP017
      *                                                                                       CGP017
     C                   IF        *IN99 = *OFF                                               CGP017
     C                   MOVEL     G_ATCRST      SVATCRST                                     CGP017
     C                   MOVEL     G_ATSUBO      SVATSUBO                                     CGP017
     C                   MOVEL     G_ATITAX      SVATITAX                                     CGP017
     C                   MOVEL     G_ATSTCI      SVATSTCI                                     CGP017
     C                   MOVEL     G_ATCHIN      SVATCHIN                                     CGP017
     C                   MOVEL     G_ATAODR      SVATAODR                                     CGP017
     C                   MOVEL     G_ATITRD      SVATITRD                                     CGP017
     C                   MOVEL     G_ATORTC      SVATORTC                                     CGP017
     C                   MOVEL     G_ATOLVD      SVATOLVD                                     CGP017
     C                   MOVEL     G_ATPOLC      SVATPOLC                                     CGP017
     C                   MOVEL     G_ATPOLE      SVATPOLE                                     CGP017
     C                   MOVEL     G_ATOVRD      SVATOVRD                                     CGP017
     C                   MOVEL     G_ATOVRC      SVATOVRC                                     CGP017
     C                   MOVEL     G_ATDRMG      SVATDRMG                                     CGP017
     C                   MOVEL     G_ATCRMG      SVATCRMG                                     CGP017
     C                   MOVEL     G_ATDRMD      SVATDRMD                                     CGP017
     C                   MOVEL     G_ATCRMD      SVATCRMD                                     CGP017
     C                   ENDIF                                                                CGP017
      *                                                                                       CGP017
O    C                   CLEAR                   G_ACCNTBXC
O    C                   MOVEL     Z_ACCNTBXC    G_ACCNTBXC
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZACCNTBXC'  I#FILE           10
O    C                   PARM      G_ACCNTBXC    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_ACCNTBXC
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    ACCNTBD0
     C                   IF        (G_ATCRST <> SVATCRST OR                                   CGP017
     C                              G_ATSUBO <> SVATSUBO OR                                   CGP017
     C                              G_ATITAX <> SVATITAX OR                                   CGP017
     C                              G_ATSTCI <> SVATSTCI OR                                   CGP017
     C                              G_ATCHIN <> SVATCHIN OR                                   CGP017
     C                              G_ATAODR <> SVATAODR OR                                   CGP017
     C                              G_ATITRD <> SVATITRD OR                                   CGP017
     C                              G_ATORTC <> SVATORTC OR                                   CGP017
     C                              G_ATOLVD <> SVATOLVD OR                                   CGP017
     C                              G_ATPOLC <> SVATPOLC OR                                   CGP017
     C                              G_ATPOLE <> SVATPOLE OR                                   CGP017
     C                              G_ATOVRD <> SVATOVRD OR                                   CGP017
     C                              G_ATOVRC <> SVATOVRC OR                                   CGP017
     C                              G_ATDRMG <> SVATDRMG OR                                   CGP017
     C                              G_ATCRMG <> SVATCRMG OR                                   CGP017
     C                              G_ATDRMD <> SVATDRMD OR                                   CGP017
     C                              G_ATCRMD <> SVATCRMD)                                     CGP017
     C                   EXSR      UPDAMAD                                                  BUG16715
O    C                   ENDIF                                                                CGP017
O    C                   ELSE
O    C                   WRITE     W_ACCNTBD0
O    C                   ENDIF
     C                   ENDIF                                                                CGP017
O    C                   ENDIF

     C                   RETURN

     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * DELAMAD - Delete GPAMADL0                                                           BUG16715
      ********************************************************************                  BUG16715
     C     DELAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     K_GZACCNTBL1  CHAIN     GPAMADL0                           99                    BUG16715
     C                   IF        %FOUND(GPAMADL0)                                         BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     *BLANK        H_ATCRST                                   BUG16715
     C                   MOVEL     *BLANK        H_ATSUBO                                   BUG16715
     C                   MOVEL     *BLANK        H_ATITAX                                   BUG16715
     C                   MOVEL     *BLANK        H_ATSTCI                                   BUG16715
     C                   MOVEL     *BLANK        H_ATCHIN                                   BUG16715
     C                   MOVEL     *BLANK        H_ATAODR                                   BUG16715
     C                   MOVEL     *BLANK        H_ATITRD                                   BUG16715
     C                   MOVEL     *BLANK        H_ATORTC                                   BUG16715
     C                   MOVEL     *BLANK        H_ATOLVD                                   BUG16715
     C                   MOVEL     *BLANK        H_ATPOLC                                   BUG16715
     C                   MOVEL     *BLANK        H_ATPOLE                                   BUG16715
     C                   MOVEL     *BLANK        H_ATOVRD                                   BUG16715
     C                   MOVEL     *BLANK        H_ATOVRC                                   BUG16715
     C                   MOVEL     *BLANK        H_ATDRMG                                   BUG16715
     C                   MOVEL     *BLANK        H_ATCRMG                                   BUG16715
     C                   MOVEL     *BLANK        H_ATDRMD                                   BUG16715
     C                   MOVEL     *BLANK        H_ATCRMD                                   BUG16715
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
     C     K_GZACCNTBL1  CHAIN     GPAMADL0                           99                    BUG16715
     C                   IF        %FOUND(GPAMADL0)                                         BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     G_ATCRST      H_ATCRST                                   BUG16715
     C                   MOVEL     G_ATSUBO      H_ATSUBO                                   BUG16715
     C                   MOVEL     G_ATITAX      H_ATITAX                                   BUG16715
     C                   MOVEL     G_ATSTCI      H_ATSTCI                                   BUG16715
     C                   MOVEL     G_ATCHIN      H_ATCHIN                                   BUG16715
     C                   MOVEL     G_ATAODR      H_ATAODR                                   BUG16715
     C                   MOVEL     G_ATITRD      H_ATITRD                                   BUG16715
     C                   MOVEL     G_ATORTC      H_ATORTC                                   BUG16715
     C                   MOVEL     G_ATOLVD      H_ATOLVD                                   BUG16715
     C                   MOVEL     G_ATPOLC      H_ATPOLC                                   BUG16715
     C                   MOVEL     G_ATPOLE      H_ATPOLE                                   BUG16715
     C                   MOVEL     G_ATOVRD      H_ATOVRD                                   BUG16715
     C                   MOVEL     G_ATOVRC      H_ATOVRC                                   BUG16715
     C                   MOVEL     G_ATDRMG      H_ATDRMG                                   BUG16715
     C                   MOVEL     G_ATCRMG      H_ATCRMG                                   BUG16715
     C                   MOVEL     G_ATDRMD      H_ATDRMD                                   BUG16715
     C                   MOVEL     G_ATCRMD      H_ATCRMD                                   BUG16715
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
     C                   OPEN      GPAMADL0                                                 AR645170
O    C                   OPEN      GZACCNTBL1
O    C                   OPEN      GZACCNTBXC
O
O     * Key lists
O
O    C     K_GZACCNTBL1  KLIST
O    C                   KFLD                    ATCNUM
O    C                   KFLD                    ATCCY
O    C                   KFLD                    ATACOD
O    C                   KFLD                    ATACSQ
O    C                   KFLD                    ATBRCA

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
