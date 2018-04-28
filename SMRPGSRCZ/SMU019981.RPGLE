     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Read and Reset file status for migration')             *
/*XBIA*: OVRDBF FILE(FDACPTPD) TOFILE(QAFDACCP)                       *
/*XBIB*: OVRDBF FILE(FDATRIPD) TOFILE(QAFDLGL)                        *
/*XBIC*: OVRDBF FILE(BRTEMPPD) TOFILE(QADSPDBR)                       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU019981 - Read and Reset file status for migration         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD019981A *CREATE  Date 15May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MDu019981A - Incorporate fix change to the actual migration  *
      *              process (Reopen)                                 *
      *                                                               *
      *****************************************************************
      *
     FBRTEMPPD  IF   E             DISK    USROPN INFSR(*PSSR)
     FFDACPTPD  IF   E             DISK    USROPN INFSR(*PSSR)
     FFDATRIPD  IF   E             DISK    USROPN INFSR(*PSSR)
      *
     D CHKFIL          S              8
     D RTNFIL          S             10
     D RTNVAL          S              1
     D RTNNUM          S              1  0
     D RTNEOF          S              3
     D CLOSID          S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    CHKFIL
     C                   PARM                    RTNFIL
     C                   PARM                    RTNVAL
     C                   PARM                    RTNNUM
     C                   PARM                    RTNEOF
 
     C                   SELECT
     C                   WHEN      CHKFIL = 'BRTEMPPD'
 
     C                   IF        WHREFI = *BLANKS
     C                   OPEN      BRTEMPPD
     C                   ENDIF
 
     C                   READ      BRTEMPPD                               99
     C                   EVAL      RTNFIL = WHREFI
 
     C                   IF        *IN99 = *ON
     C                   EVAL      WHREFI = *BLANKS
     C                   EVAL      RTNEOF = 'EOF'
     C                   CLOSE     BRTEMPPD
     C                   ENDIF
 
     C                   WHEN      CHKFIL = 'FDACPTPD'
 
     C                   OPEN      FDACPTPD
     C                   READ      FDACPTPD                               98
     C                   EVAL      RTNVAL = APUNIQ
     C                   CLOSE     FDACPTPD
 
     C                   WHEN      CHKFIL = 'FDATRIPD'
 
     C                   OPEN      FDATRIPD
     C                   READ      FDATRIPD                               97
     C                   EVAL      RTNNUM = LGNOMB
     C                   CLOSE     FDATRIPD
 
     C                   ENDSL
      *
     C                   RETURN
 
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
