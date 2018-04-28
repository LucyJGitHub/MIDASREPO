      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP OUTQ compares - mismatched spool entries')    *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0402 - Report of mis-matched spool entries for CMPOUTQ     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CUP039             Date 25Mar11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. CUP009  *CREATE    Date 14Aug00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP039 - Spool file number changed from length 4 to 6.       *
      *           (Recompile)                                         *
      *  CUP009 - Creation of CMPOUTQ command.  This is a re-write    *
      *            of CMPCOB.                                         *
      *                                                               *
      *****************************************************************
     FUPCCOBQF  IF   E             DISK
     FUP0402P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D RUNDAT          DS            13
     D  BJMRDT                 1      7
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTITL
      *
     C                   SETON                                        12
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     1             SETLL     UPCCOBD0
      *
     C                   READ      UPCCOBQF                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      * If there are no records at all write 'no records'
     C     *IN20         IFEQ      *ON
     C                   WRITE     NORECS                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   GOTO      ENDPGM
      *
     C                   ENDIF
      *
     C     *IN20         DOUEQ     *ON
      *
     C     *IN12         IFEQ      *ON
     C                   MOVEL     CCSYS         @SYS
     C                   MOVEL     CCOUTQ        @OUTQ
     C                   MOVEL     CCOQLB        @OQLB
     C                   SETOFF                                       12
     C                   ELSE
     C                   MOVEL     *BLANKS       @SYS
     C                   MOVEL     *BLANKS       @OUTQ
     C                   MOVEL     *BLANKS       @OQLB
     C                   ENDIF
     C                   MOVEL     CCFILE        @FILE
     C                   MOVEL     CCFNBR        @FNBR
     C                   MOVEL     CCUSER        @USER
     C                   MOVEL     CCUDTA        @UDTA
     C                   MOVEL     CCJNAM        @JNAM
     C                   MOVEL     CCJNBR        @JNBR
     C                   WRITE     DTL
      *
      * If overflow on then write header
     C     *IN37         IFEQ      *ON
     C                   SETON                                        12
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   READ      UPCCOBQF                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDDO
      *                                                                **
      * Write trailer and end program
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
