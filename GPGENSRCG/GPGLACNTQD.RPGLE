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
      *  GPGLACNTQD - On-Line Update of Global File GZGLACNTQD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CRE095             Date 25Apr14               *
      *  Prev Amend No. CRE090             Date 14Feb14               *
      *                 MD022923B          Date 30Sep13               *
      *                 AR1095876          Date 30Sep13               *
      *                 MD020772           Date 30Sep13               *
      *                 MD020656A          Date 30Sep13               *
      *                 MD020656           Date 30Sep13               *
      *                 CGP017             Date 06Aug12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 AR821923           Date 29Aug11               *
      *                 CER042             Date 11May11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE040             Date 05Jul04               *
      *                 CRE010             Date 06Sep04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  MD022923B - BF2.1 SP3 Drop 02 RPG Issues                     *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  MD020772 - V_ABC SQL incorrect decimal places                *
      *           - Eval statement can return unpredicatble results.  *
      *             Use DIV instead.                                  *
      *  MD020656A - ABC check performance issue due to complex SQL vw*
      *  MD020656 - ABC check performance issue due to complex SQL vw *
      *             fix AR847269                                      *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  AR821923 - Rubbish data was saved in GZGLACNTQD file         *
      *             (Recompile)                                       *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  CRE010 - Retail Account Balance Check (Recompile)            *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
O    FGZGLACNTL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLACNTQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLACNTD0    :W_GLACNTD0     )
O    F                                     USROPN
     FGPACNTL1  UF   E           K DISK    INFSR(*PSSR) PREFIX(G1) COMMIT(D_COM)            MD020656
     F                                     USROPN                                           MD020656
     FGPACNTTD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G1) COMMIT(D_COM)            MD020656
     F                                     RENAME(GPACNTD0    :W_GPACNTD0     )             MD020656
     F                                     USROPN                                           MD020656
O
O    D Z_GLACNTQD    E DS                  EXTNAME(GZGLACNTQD)
O    D G_GLACNTQD    E DS                  EXTNAME(GZGLACNTQD) PREFIX(G_)
O    D Z_GPACNTTD    E DS                  EXTNAME(GPACNTTD) PREFIX(G0)                     MD020656
O    D G_GPACNTTD    E DS                  EXTNAME(GPACNTTD) PREFIX(G1)                     MD020656
     D*SDCURR***     E DS                  EXTNAME(SDCURRPD)                      MD020656 MD022923B
     D SDCURR        E DS                  EXTNAME(GZSDCURRPD)                             MD022923B
                                                                                            MD020656
     D DateStart       S               D   DATFMT(*ISO) INZ(D'1971-12-31')                  MD020656
     D CmdArray        S             80A   DIM(2) CTDATA PERRCD(1)                         MD020656A
     D Cmd             S             80A                                                   MD020656A
     D Len             S             15P 5                                                 MD020656A
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C                   EXSR      SRPutOvr                                                MD020656A
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_GLACNTQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLACNTQD
O    C                   ENDIF
O
O    C     K_GZGLACNTL1  CHAIN     GLACNTD0                           99
     C                   CLEAR                   G_GPACNTTD                                 MD020656
     C     K_GZGLACNTL1  CHAIN     GPACNTD0                           81                    MD020656
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLACNTD0
     C  N81              DELETE    GPACNTD0                                                 MD020656
O    C                   ELSE
O
O     * 'After'
O
     C                   IF        *IN99 = *ON OR                                             CGP017
     C                             *IN99 = *OFF AND                                           CGP017
     C                             Z_GLACNTQD <> G_GLACNTQD                                   CGP017
      *                                                                                       CGP017
O    C                   CLEAR                   G_GLACNTQD
O    C                   MOVEL     Z_GLACNTQD    G_GLACNTQD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLACNTQD'  I#FILE           10
O    C                   PARM      G_GLACNTQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLACNTQD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLACNTD0
O    C                   ELSE
O    C                   WRITE     W_GLACNTD0
O    C                   ENDIF
     C                   ENDIF                                                                CGP017
      * Map and update Update Enquiry file                                                  MD020656
     C                   EVAL      Z_GPACNTTD = G_GPACNTTD                                  MD020656
     C                   EXSR      SRMapEnqF                                                MD020656
     C     *IN81         IFEQ      *OFF                                                     MD020656
     C     Z_GPACNTTD    IFNE      G_GPACNTTD                                               MD020656
     C                   UPDATE    GPACNTD0                                                 MD020656
     C                   ENDIF                                                              MD020656
     C                   ELSE                                                               MD020656
     C                   EVAL      G1F1BRCA = G_F1BRCA                                      MD020656
     C                   EVAL      G1F1CNUM = G_F1CNUM                                      MD020656
     C                   EVAL      G1F1CCY  = G_F1CCY                                       MD020656
     C                   EVAL      G1F1ACOD = G_F1ACOD                                      MD020656
     C                   EVAL      G1F1ACSQ = G_F1ACSQ                                      MD020656
     C                   MOVE      G_F1ACOD      Alp_ACOD         10                        MD020656
     C                   MOVE      G_F1ACSQ      Alp_ACSQ          2                        MD020656
     C                   EVAL      G1RTREF= G_F1BRCA + G_F1CNUM + G_F1CCY                   MD020656
     C                                      + Alp_ACOD + Alp_ACSQ                           MD020656
     C                   WRITE     W_GPACNTD0                                               MD020656
     C                   ENDIF                                                              MD020656
O    C                   ENDIF
      *                                                                                    MD020656A
     C                   EXSR      SRDelOvr                                                MD020656A
 
     C                   RETURN
 
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
O    C                   OPEN      GZGLACNTL1
O    C                   OPEN      GZGLACNTQD
O    C                   OPEN      GPACNTTD                                                 MD020656
O    C**********         OPEN      GPACNTL1                                       MD020656 MD020656A
O
O     * Key lists
O
O    C     K_GZGLACNTL1  KLIST
O    C                   KFLD                    F1CNUM
O    C                   KFLD                    F1CCY
O    C                   KFLD                    F1ACOD
O    C                   KFLD                    F1ACSQ
O    C                   KFLD                    F1BRCA
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5                                                                              MD020656
      *********************************************************************                 MD020656
      * SRMapEnqF                                                                           MD020656
      *********************************************************************                 MD020656
     C     SRMapEnqF     BEGSR                                                              MD020656
                                                                                            MD020656
      * Currency details                                                                    MD020656
     C                   CALL      'AOCURRR0'                                               MD020656
     C                   PARM      *BLANKS       @RTCD             7                        MD020656
     C                   PARM      '*KEY   '     @OPTN             7                        MD020656
     C                   PARM      F1CCY         @AJCD             3                        MD020656
     C     SDCURR        PARM      SDCURR        SDCURR                                     MD020656
                                                                                            MD020656
     C     A6NBDP        IFEQ      0                                                        MD020772
     C     G_F1BAV1      DIV(H)    1             G1F1BAV1                                   MD020772
     C     G_F1AVA1      DIV(H)    1             G1F1AVA1                                   MD020772
     C                   ENDIF                                                              MD020772
     C     A6NBDP        IFEQ      1                                                        MD020772
     C     G_F1BAV1      DIV(H)    10            G1F1BAV1                                   MD020772
     C     G_F1AVA1      DIV(H)    10            G1F1AVA1                                   MD020772
     C                   ENDIF                                                              MD020772
     C     A6NBDP        IFEQ      2                                                        MD020772
     C     G_F1BAV1      DIV(H)    100           G1F1BAV1                                   MD020772
     C     G_F1AVA1      DIV(H)    100           G1F1AVA1                                   MD020772
     C                   ENDIF                                                              MD020772
     C     A6NBDP        IFEQ      3                                                        MD020772
     C     G_F1BAV1      DIV(H)    1000          G1F1BAV1                                   MD020772
     C     G_F1AVA1      DIV(H)    1000          G1F1AVA1                                   MD020772
     C                   ENDIF                                                              MD020772
     C**********         EVAL      G1F1BAV1 = G_F1BAV1 / (10 ** A6NBDP)            MD020656 MD020772
     C**********         EVAL      G1F1AVA1 = G_F1AVA1 / (10 ** A6NBDP)            MD020656 MD020772
     C     DateStart     ADDDUR    G_F1DAT1:*DAYSG1F1DAT1                                   MD020656
     C     DateStart     ADDDUR    G_F1DAT2:*DAYSG1F1DAT2                                   MD020656
     C     DateStart     ADDDUR    G_F1OAD:*DAYS G1F1OAD                                    MD020656
     C                   EVAL      G1F1IABC = G_F1IABC                                      MD020656
                                                                                            MD020656
     C                   ENDSR                                                              MD020656
      ********************************************************************                  MD020656
      /SPACE 5                                                                             MD020656A
      *********************************************************************                MD020656A
      * SRPutOvr   - Put override, no share and open input files                           MD020656A
      *********************************************************************                MD020656A
     C     SRPutOvr      BEGSR                                                             MD020656A
      *                                                                                    MD020656A
     C                   MOVEA     CmdArray(1)   Cmd                                       MD020656A
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPACNTL1  '                        MD020656A
     C                   Z-ADD     80            Len                                       MD020656A
     C                   CALL      'QCMDEXC'                                               MD020656A
     C                   PARM                    Cmd                                       MD020656A
     C                   PARM                    Len                                       MD020656A
     C                   OPEN      GPACNTL1                                                MD020656A
      *                                                                                    MD020656A
     C                   ENDSR                                                             MD020656A
      ********************************************************************                 MD020656A
      /SPACE 5                                                                             MD020656A
      *********************************************************************                MD020656A
      * SRDelOvre  - Delete override                                                       MD020656A
      *********************************************************************                MD020656A
     C     SRDelOvr      BEGSR                                                             MD020656A
      *                                                                                    MD020656A
     C                   CLOSE     GPACNTL1                                                MD020656A
      *                                                                                    MD020656A
     C                   MOVEA     CmdArray(2)   Cmd                                       MD020656A
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPACNTL1  '                        MD020656A
     C                   Z-ADD     80            Len                                       MD020656A
     C                   CALL      'QCMDEXC'                                               MD020656A
     C                   PARM                    Cmd                                       MD020656A
     C                   PARM                    Len                                       MD020656A
      *                                                                                    MD020656A
     C                   ENDSR                                                             MD020656A
      ********************************************************************                 MD020656A
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
** CmdArray                                                                                MD020656A
OVRDBF FILE(          ) SHARE(*NO)                                                         MD020656A
DLTOVR FILE(          )                                                                    MD020656A
