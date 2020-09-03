     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Initialisation Program for CSD017')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000027 - Initialisation Program for CSD017                 *
      *                                                               *
      *  Function:  This module will initialise the new fields that   *
      *             were introduced in enhancement CSD017.            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Read indicator                                  *
      *    U7         Database error indicator                        *
      *    U8         Database error indicator                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL Account Postings Detail File
     FAPOSTPD   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Lending Fees Tomorrows Account Keys - Detail File
     FPSTTOM    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRUN            S              1

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Initialise new fields

     C     1             SETLL     APOSTPD
     C                   READ      APOSTPD                                01

     C                   DOW       *IN01 = *OFF
     C                   EVAL      ACKEY = *BLANKS
     C                   EVAL      FEEFLG = *BLANKS
     C                   Z-ADD     *ZEROS        FEEVAL
     C                   Z-ADD     *ZEROS        FEEPCT
     C                   EVAL      RORACT = *BLANKS
     C                   EVAL      RORCTY = *BLANKS
     C                   EVAL      RORBNK = *BLANKS
     C                   EVAL      RORCDE = *BLANKS
     C                   EVAL      PORACT = *BLANKS
     C                   EVAL      PORCTY = *BLANKS
     C                   EVAL      PORBNK = *BLANKS
     C                   EVAL      PORCDE = *BLANKS
     C                   EVAL      DSTACT = *BLANKS
     C                   EVAL      DSTCTY = *BLANKS
     C                   EVAL      DSTBNK = *BLANKS
     C                   Z-ADD     *ZEROS        SETDAT
     C                   EVAL      TICKER = *BLANKS
     C                   EVAL      EXCHNG = *BLANKS
     C                   Z-ADD     *ZEROS        NOMINL
     C                   EVAL      FDTRID = *BLANKS
     C                   UPDATE    APOSTPDF
     C                   READ      APOSTPD                                01
     C                   ENDDO
      *
     C     1             SETLL     PSTTOM
     C                   READ      PSTTOM                                 01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      F1FFLG = *BLANKS
     C                   Z-ADD     *ZEROS        F1FVAL
     C                   Z-ADD     *ZEROS        F1FPCT
     C                   EVAL      F1RACT = *BLANKS
     C                   EVAL      F1RCTY = *BLANKS
     C                   EVAL      F1RBNK = *BLANKS
     C                   EVAL      F1RCDE = *BLANKS
     C                   EVAL      F1PACT = *BLANKS
     C                   EVAL      F1PCTY = *BLANKS
     C                   EVAL      F1PBNK = *BLANKS
     C                   EVAL      F1PCDE = *BLANKS
     C                   EVAL      F1DACT = *BLANKS
     C                   EVAL      F1DCTY = *BLANKS
     C                   EVAL      F1DBNK = *BLANKS
     C                   Z-ADD     *ZEROS        F1SDAT
     C                   UPDATE    PSTTOMF
     C                   READ      PSTTOM                                 01
     C                   ENDDO
      *
     C                   COMMIT
     C                   EVAL      *INLR = *ON

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
