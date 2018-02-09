     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Update Global Historic Balances')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUPDHIBL  - Update Global Historic Balances                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FMRHIBLL5  IP  AE           K DISK    RENAME(MRHIBLD0   : FormatZON)
     FGPHIBLL0  US  AE           K DISK    RENAME(GPHIBLD0   : FormatGLB)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGPHIBLPD  O  A E           K DISK    RENAME(GPHIBLD0   : FormatGLBW)
     F                                     INFSR(*PSSR)
 
 
     D Z_MRHIBL      E DS                  EXTNAME(MRHIBLPD)
     D G_GPHIBL      E DS                  EXTNAME(GPHIBLPD)
     D                                     PREFIX(G_)
 
 
     IFormatZON     01
     I                                          YR            L1M7
     I                                          PR            L1M6
     I                                          BRCA          L1M5
     I                                          CCY           L1M4
     I                                          ACOD          L1M3
     I                                          CNUM          L1M2
     I                                          ACSQ          L1M1
     IFormatGLB     02
     I                                          G_YR          L1M7
     I                                          G_PR          L1M6
     I                                          G_BRCA        L1M5
     I                                          G_CCY         L1M4
     I                                          G_ACOD        L1M3
     I                                          G_CNUM        L1M2
     I                                          G_ACSQ        L1M1
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
B    C                   EVAL      HBZONE      = I_ZONE
     C                   WRITE     FormatGLBW
     C                   ELSE
     C                   DELETE    FormatGLB
     C                   ENDIF
     C                   ELSE
     C   02              EVAL      G_EPBLDC      =  EPBLDC
     C   02              EVAL      G_EPBLAC      =  EPBLAC
     C   02              EVAL      G_BSTFR       =  BSTFR
     C   02              EVAL      G_FCTFAC      =  FCTFAC
B    C   02              EVAL      G_HBZONE      =  I_ZONE
     C   02              UPDATE    FormatGLB
     C                   ENDIF
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10
 
     C                   CLEAR                   Z_MRHIBL
     C                   CLEAR                   G_GPHIBL
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
