     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Global BSPL Analysis File Update')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSANUPD - Gloabl BSPL Analysis File Update                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGOBSANSPD IP  AE           K DISK    RENAME(GPBSAND0   : FormatZON)
     FGPBSANL0  US  AE           K DISK    RENAME(GPBSAND0   : FormatGLB)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGPBSANPD  O  A E           K DISK    RENAME(GPBSAND0   : FormatGLBW)
     F                                     INFSR(*PSSR)
 
 
     D Z_GOBSAN      E DS                  EXTNAME(GOBSANSPD)
     D G_GPBSAN      E DS                  EXTNAME(GPBSANPD)
     D                                     PREFIX(G_)
 
 
     IFormatZON     01
     I                                          YR            L1M7
     I                                          PR            L1M6
     I                                          BRCA          L1M5
     I                                          CCY           L1M4
     I                                          ACOD          L1M3
     I                                          EPBLDC        L1M2
     I                                          ANLYSC        L1M1
     IFormatGLB     02
     I                                          G_YR          L1M7
     I                                          G_PR          L1M6
     I                                          G_BRCA        L1M5
     I                                          G_CCY         L1M4
     I                                          G_ACOD        L1M3
     I                                          G_EPBLDC      L1M2
     I                                          G_ANLYSC      L1M1
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
B    C                   EVAL      A1ZONE      = I_ZONE
     C                   WRITE     FormatGLBW
     C                   ELSE
     C                   DELETE    FormatGLB
     C                   ENDIF
     C                   ELSE
     C   02              EVAL      G_EPBLAC      =  EPBLAC
B    C   02              EVAL      G_A1ZONE      =  I_ZONE
     C   02              UPDATE    FormatGLB
     C                   ENDIF
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10
 
     C                   CLEAR                   Z_GOBSAN
     C                   CLEAR                   G_GPBSAN
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
