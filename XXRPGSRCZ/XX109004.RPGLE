      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Batch Range Overlap check')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ110*-*Batch Range Overlap Change***************************
      *  XX109004 - Batch Range Overlap Change                        *
      *                                                               *
      *  Function:  Batch Range Overlap Change                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109            Date 21May18                *
      *  Prev Amend No. JMI026  *CREATE   Date 17Sep08                *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  JMI109 - Extract for G-AML Interface. (Upgrade to FB Midas)  *
      *  JMI026 - Extract for G-AML Interface.                        *
      *                                                               *
      *****************************************************************
     F*SDATYPY4  IF   E           K DISK                                                      JMI109
     FXXATYPL4  IF   E           K DISK                                                       JMI109
     F                                     INFSR(*PSSR)
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    WRTCD             7
     C                   PARM                    WSRNG             3 0
     C                   PARM                    WERNG             3 0
      *
     C                   MOVEL     *BLANKS       WRTCD
     C                   MOVE      'N'           #ERROR            1
      *
     C     *LOVAL        SETLL     @ATYPY4                            82
     C  N82              READ      @ATYPY4                                82
      *
      ** Check if start range is allowable
     C     *IN82         DOWEQ     '0'
     C     GMOD          IFEQ      'GL'
     C     WSRNG         IFGE      GSRNG
     C     WSRNG         ANDLE     GERNG
      *
      ** Set WRTCD to ERROR if range defined by the parameter overlaps
      ** existing ranges.
      *
     C                   MOVEL     'ERROR'       WRTCD
     C                   MOVE      'Y'           #ERROR
     C                   LEAVE
     C                   ENDIF
     C                   ELSE
     C                   ENDIF
      *
     C                   READ      @ATYPY4                                82
     C                   ENDDO
      *
      ** Check if end range is allowable
     C     #ERROR        IFEQ      'N'
     C     *LOVAL        SETLL     @ATYPY4                            82
     C  N82              READ      @ATYPY4                                82
      *
     C     *IN82         DOWEQ     '0'
     C     GMOD          IFEQ      'GL'
     C     WERNG         IFGE      GSRNG
     C     WERNG         ANDLE     GERNG
      *
      ** Set WRTCD to ERROR if range defined by the parameter overlaps
      ** existing ranges.
      *
     C                   MOVEL     'ERROR'       WRTCD
     C                   LEAVE
     C                   ELSE
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      @ATYPY4                                82
     C                   ENDDO
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      * Initialize
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Standard Midas PSSR processing.
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2008
