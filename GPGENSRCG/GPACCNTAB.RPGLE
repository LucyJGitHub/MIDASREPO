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
      *  GPACCNTAB  - On-Line Update of Global File GZACCNTAB         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD050190           Date 04Apr18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD020772           Date 30Sep13               *
      *                 MD020656A          Date 30Sep13               *
      *                 MD020656           Date 30Sep13               *
      *                 CGP017             Date 06Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG16715           Date 16Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE025             Date 20Oct03               *
      *                 BG1904             Date 15Apr03               *
      *                 BG1711             Date 31Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD050190 - Low performance of GOCACTS components.            *
      *           - Conditioned processing of ABC file GPACNTTD.      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020772 - V_ABC SQL incorrect decimal places                *
      *           - Recompiled due to changes done in GPACNTTD.       *
      *  MD020656A - ABC check performance issue due to complex SQL vw*
      *  MD020656 - ABC check performance issue due to complex SQL vw *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG16715 - Slow performance unable to locate an Account      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE025 - Credit Lines (recompile)                            *
      *  BG1904 - Missing global deliverables (BG1711 not delivered)  *
      *  BG1711 - Global updates fail with record locking on GPTRAPPD *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZACCNTL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZACCNTAB O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(ACCNTABF    :W_ACCNTABF     )
O    F                                     USROPN
O    FGPACNTL1  UF   E           K DISK    INFSR(*PSSR) PREFIX(G1) COMMIT(D_COM)            MD020656
O    F                                     USROPN                                           MD020656
O    FGPACNTTD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G1) COMMIT(D_COM)            MD020656
O    F                                     RENAME(GPACNTD0    :W_GPACNTD0     )             MD020656
O    F                                     USROPN                                           MD020656
O
O    D Z_ACCNTAB     E DS                  EXTNAME(GZACCNTAB )
O    D G_ACCNTAB     E DS                  EXTNAME(GZACCNTAB ) PREFIX(G_)
     D Upd_Amad_Flg    S              1A   INZ                                                CGP017
     D Z_GPACNTTD    E DS                  EXTNAME(GPACNTTD  ) PREFIX(G0)                   MD020656
     D G_GPACNTTD    E DS                  EXTNAME(GPACNTTD  ) PREFIX(G1)                   MD020656
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
     C                   IF        CAP205 = 'Y'                                             MD050190
     C                   EXSR      SRPutOvr                                                MD020656A
     C                   ENDIF                                                              MD050190
T
T     * GPTRAPPD Updates
T
T    C     I#TRAP        IFEQ      'Y'
T    C     I#BFAF        ANDEQ     'A'
T    C                   CALL      'GOWTTACCT '
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTACCT '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_ACCNTAB
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_ACCNTAB
O    C                   ENDIF
O
O    C     K_GZACCNTL1   CHAIN     ACCNTABF                           99
     C                   IF        CAP205 = 'Y'                                             MD050190
     C                   CLEAR                   G_GPACNTTD                                 MD020656
O    C     K_GZACCNTL1   CHAIN     GPACNTD0                           81                    MD020656
     C                   ENDIF                                                              MD050190
O
     C                   EVAL      Upd_Amad_Flg = *BLANK                                      CGP017
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    ACCNTABF
     C                   IF        CAP205 = 'Y'                                             MD050190
O    C  N81              DELETE    GPACNTD0                                                 MD020656
     C                   ENDIF                                                              MD050190
O    C                   ELSE
O
O     * 'After'
O
     C                   IF        *IN99 = *ON OR                                             CGP017
     C                             *IN99 = *OFF AND                                           CGP017
     C                             Z_ACCNTAB <> G_ACCNTAB                                     CGP017
      *                                                                                       CGP017
     C                   EVAL      Upd_Amad_Flg = 'Y'                                         CGP017
O    C                   CLEAR                   G_ACCNTAB
O    C                   MOVEL     Z_ACCNTAB     G_ACCNTAB
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZACCNTAB '  I#FILE           10
O    C                   PARM      G_ACCNTAB     IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_ACCNTAB
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    ACCNTABF
O    C                   ELSE
O    C                   WRITE     W_ACCNTABF
O    C                   ENDIF
     C                   ENDIF                                                                CGP017
     C                   IF        CAP205 = 'Y'                                             MD050190
      * Map and update Update Enquiry file                                                  MD020656
     C                   EVAL      Z_GPACNTTD = G_GPACNTTD                                  MD020656
     C                   EVAL      G1ACNO = G_ACNO                                          MD020656
     C                   EVAL      G1ANAM = G_ANAM                                          MD020656
     C                   EVAL      G1MINB = G_MINB                                          MD020656
     C     *IN81         IFEQ      *OFF                                                     MD020656
     C     Z_GPACNTTD    IFNE      G_GPACNTTD                                               MD020656
     C                   UPDATE    GPACNTD0                                                 MD020656
     C                   ENDIF                                                              MD020656
     C                   ELSE                                                               MD020656
     C                   EVAL      G1F1DAT1 = DateStart                                     MD020656
     C                   EVAL      G1F1DAT2 = DateStart                                     MD020656
     C                   EVAL      G1F1OAD  = DateStart                                     MD020656
     C                   EVAL      G1F1BRCA = G_BRCA                                        MD020656
     C                   EVAL      G1F1CNUM = G_CNUM                                        MD020656
     C                   EVAL      G1F1CCY  = G_CCY                                         MD020656
     C                   EVAL      G1F1ACOD = G_ACOD                                        MD020656
     C                   EVAL      G1F1ACSQ = G_ACSQ                                        MD020656
     C                   MOVE      G_ACOD        Alp_ACOD         10                        MD020656
     C                   MOVE      G_ACSQ        Alp_ACSQ          2                        MD020656
     C                   EVAL      G1RTREF= G_BRCA + G_CNUM + G_CCY                         MD020656
     C                                      + Alp_ACOD + Alp_ACSQ                           MD020656
     C                   WRITE     W_GPACNTD0                                               MD020656
     C                   ENDIF                                                              MD020656
     C                   ENDIF                                                              MD050190
O    C                   ENDIF

     C                   IF        I#BFAF = 'B' OR Upd_Amad_Flg = 'Y'                         CGP017
      *                                                                                       CGP017
O     * Generate GPAMADPD                                                                   BUG16715
     C**********         CALL      'GPAMADMRG'                                       BUG16715 CGP017
     C                   CALLB     'GPAMADMRG'                                                CGP017
     C                   PARM                    I#RTCD                                     BUG16715
     C                   PARM                    I#ERMS                                     BUG16715
O    C                   PARM                    I#ZONE                                     BUG16715
     C                   PARM                    I#BFAF                                     BUG16715
     C                   PARM                    I#BIMG                                     BUG16715
     C                   PARM                    I#AIMG                                     BUG16715
                                                                                            BUG16715
     C                   ENDIF                                                                CGP017
      *                                                                                    MD020656A
     C                   IF        CAP205 = 'Y'                                             MD050190
     C                   EXSR      SRDelOvr                                                MD020656A
     C                   ENDIF                                                              MD050190
      *                                                                                       CGP017
     C                   RETURN

     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
      *                                                                                     MD050190
      ** Check if CAP205 is switched on.                                                    MD050190
      *                                                                                     MD050190
     C                   MOVE      'N'           CAP205            1                        MD050190
     C                   CALLB     'AOSARDR0'                                               MD050190
     C                   PARM      *BLANKS       @RTCD             7                        MD050190
     C                   PARM      '*VERIFY'     @OPTN             7                        MD050190
     C                   PARM      'CAP205'      @SARD             6                        MD050190
      *                                                                                     MD050190
     C     @RTCD         IFEQ      *BLANKS                                                  MD050190
     C                   MOVE      'Y'           CAP205                                     MD050190
     C                   ENDIF
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GZACCNTL1
O    C                   OPEN      GZACCNTAB
     C                   IF        CAP205 = 'Y'                                             MD050190
O    C                   OPEN      GPACNTTD                                                 MD020656
     C                   ENDIF                                                              MD050190
O    C**********         OPEN      GPACNTL1                                       MD020656 MD020656A
O
O     * Key lists
O
O    C     K_GZACCNTL1   KLIST
O    C                   KFLD                    CNUM
O    C                   KFLD                    CCY
O    C                   KFLD                    ACOD
O    C                   KFLD                    ACSQ
O    C                   KFLD                    BRCA

     C                   ENDSR
      ********************************************************************
      /SPACE 5
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
      * SRDelOvr   - Delete override                                                       MD020656A
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
      /SPACE 5                                                                             MD020656A
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
