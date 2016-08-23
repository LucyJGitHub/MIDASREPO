     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Correct SPIN and INTR in CLOANCL')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00099 - Utility to update PF/CLOANCL                      *
      *                                                               *
      *  Function:  This program updates the interest rate and spread *
      *             indicator fields of risk loans in PF/CLOANCL.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 206257  *CREATE    Date 21Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  BG26993- Delivery of upgrade programs to core.               *
      *         - Renamed program S206257R01.                         *
      *  206257 - Utility to update interest rate INTR and spread     *
      *           indicator (SPIN) fields of risk loans in PF/CLOANCL.*
      *                                                               *
      *****************************************************************
      /EJECT
     FSMU002PD  UF   E             DISK
     FSMU00099P1O    E             PRINTER
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01  - End of File For CLOANCL                               *
      *   14  - ON: Update mode; OFF: Audit mode                      *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      /EJECT
      *****************************************************************
      *
      /SPACE 3
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details and rundate
      *
     D  RUND         E                     EXTFLD(BJRDNB)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for Access Program
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
     D  OFFLN                188    189B 0
     D  CURLIN               367    368B 0
      /EJECT
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      INIT
      *
     C                   WRITE     HEADER
     C                   WRITE     DTLSHDR
      *
     C                   READ      SMU002PD                               01
      *
     C     *IN01         DOWEQ     '0'
      *
     C                   ADD       1             NOREAD            5 0
      *
     C     RECI          IFEQ      'D'
     C     PTYP          IFEQ      70
     C     PTYP          OREQ      71
     C     PTYP          OREQ      72
     C     SPIN          IFEQ      *BLANKS
     C     RTSP          ANDEQ     0
     C     BRTT          ANDEQ     0
      *
     C                   MOVE      'A'           NSPIN
     C                   Z-ADD     0             NINTR
      *
     C     *IN14         IFEQ      '1'
     C                   MOVE      'A'           SPIN
     C                   Z-ADD     0             INTR
     C                   ENDIF
      *
     C                   Z-ADD     3             RQDLIN            2 0
     C     OFFLN         SUB       CURLIN        AVALIN            2 0
     C     AVALIN        IFLT      RQDLIN
     C                   WRITE     HEADER
     C                   WRITE     DTLSHDR
     C                   ENDIF
      *
     C                   WRITE     DTLSBDY
      *
      ** Update file
      *
     C                   EXCEPT
      *
     C                   ADD       1             NOUPDT            5 0
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SMU002PD                               01
      *
     C                   ENDDO
      *
     C                   Z-ADD     10            RQDLIN
     C     OFFLN         SUB       CURLIN        AVALIN
     C     AVALIN        IFLT      RQDLIN
     C                   WRITE     HEADER
     C                   WRITE     DTLSHDR
     C                   ENDIF
      *
     C     NOUPDT        IFNE      0
     C                   WRITE     NOREC
     C                   WRITE     TRAILER
     C                   ELSE
     C                   WRITE     NODTLS
     C                   WRITE     TRAILER
     C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      /TITLE SR/SRINIT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialization             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Receive parameter list.
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   END
      *
      ** Check mode of the program
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVE      '1'           *IN14
     C                   ELSE
     C                   MOVE      '0'           *IN14
     C                   ENDIF
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SMU00099'    DBPGM                          ************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 01 *
     C                   MOVEL     '001'         DBASE                          ************
     C                   OUT       LDA
     C                   WRITE     HEADER
     C                   WRITE     DBERR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: INIT                                               *
      *                                                               *
      * Calls: None                                                   *
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
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
     OCLOANCLF  E    14
     O                       INTR
     O                       SPIN
      *
      ********************************************************************
