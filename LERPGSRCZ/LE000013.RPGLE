     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Initialisation Program for CLE028')           *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE000013 - Initialisation Program for CLE028                 *
      *                                                               *
      *  Function:  This module will initialise the new fields that   *
      *             were introduced in enhancement CLE028.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE154             Date 06Aug12               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE028  *CREATE    Date 27Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78)               *
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

      ** Midas LE Facilities Detail A Record
     FFCLTYFM   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Customer Loans
     FCLOANCL   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Matured Customer Loans
     FMCLONCL   UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:MCLONCLF)
     F                                     COMMIT

      ** Midas LE Midas LE Loans/Parts Purchased Invalid data
     FLEILONPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE History Amount Details
     FHISTSHP   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Matured History Amount Details
     FMHISTHP   UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(HISTSHPF:MHISTHPF)
     F                                     COMMIT

      ** Midas LE Loan Amendments
     FLOAMSDK   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas MX Saved CLOANCL
     FMXSLECLPD UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:MXSLECLF)
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

     C     1             SETLL     FCLTYFM
     C                   READ      FCLTYFM                                01

     C                   DOW       *IN01 = *OFF
     C                   EVAL      DTPX = DTPS
     C                   UPDATE    FCLTYFMF
     C                   READ      FCLTYFM                                01
     C                   ENDDO

     C     1             SETLL     CLOANCL
     C                   READ      CLOANCL                                01

     C                   DOW       *IN01 = *OFF
     C                   EVAL      ADIF = 'N'
     C                   EVAL      ADCF = 'N'
     C                   EVAL      ICIF = 'N'
     C                   Z-ADD     *ZEROS        CHGA
     C                   Z-ADD     *ZEROS        FLTI
     C                   Z-ADD     *ZEROS        FRPD
     C                   Z-ADD     *ZEROS        ACCH
     C                   UPDATE    CLOANCLF
     C                   READ      CLOANCL                                01
     C                   ENDDO

     C     1             SETLL     MCLONCL
     C                   READ      MCLONCL                                01

     C                   DOW       *IN01 = *OFF
     C                   EVAL      ADIF = 'N'
     C                   EVAL      ADCF = 'N'
     C                   EVAL      ICIF = 'N'
     C                   Z-ADD     *ZEROS        CHGA
     C                   Z-ADD     *ZEROS        FLTI
     C                   Z-ADD     *ZEROS        FRPD
     C                   Z-ADD     *ZEROS        ACCH
     C                   UPDATE    MCLONCLF
     C                   READ      MCLONCL                                01
     C                   ENDDO

     C     1             SETLL     LEILONPD
     C                   READ      LEILONPD                               01

     C                   DOW       *IN01 = *OFF
     C                   EVAL      SADIF = 'N'
     C                   EVAL      SADCF = 'N'
     C                   EVAL      SICIF = 'N'
     C                   EVAL      SCHGA = *BLANKS
     C                   UPDATE    LEILONP0
     C                   READ      LEILONPD                               01
     C                   ENDDO

     C     1             SETLL     LOAMSDK
     C                   READ      LOAMSDK                                01

     C                   DOW       *IN01 = *OFF
     C                   Z-ADD     *ZEROS        CHDU
     C                   UPDATE    LOAMSDKF
     C                   READ      LOAMSDK                                01
     C                   ENDDO

     C     1             SETLL     HISTSHP
     C                   READ      HISTSHP                                01

     C                   DOW       *IN01 = *OFF
     C                   Z-ADD     *ZEROS        CHDU
     C                   UPDATE    HISTSHPF
     C                   READ      HISTSHP                                01
     C                   ENDDO

     C     1             SETLL     MHISTHP
     C                   READ      MHISTHP                                01

     C                   DOW       *IN01 = *OFF
     C                   Z-ADD     *ZEROS        CHDU
     C                   UPDATE    MHISTHPF
     C                   READ      MHISTHP                                01
     C                   ENDDO

     C     1             SETLL     MXSLECLPD
     C                   READ      MXSLECLPD                              01

     C                   DOW       *IN01 = *OFF
     C                   EVAL      ADIF = 'N'
     C                   EVAL      ADCF = 'N'
     C                   EVAL      ICIF = 'N'
     C                   Z-ADD     *ZEROS        CHGA
     C                   Z-ADD     *ZEROS        FLTI
     C                   Z-ADD     *ZEROS        FRPD
     C                   Z-ADD     *ZEROS        ACCH
     C                   UPDATE    MXSLECLF
     C                   READ      MXSLECLPD                              01
     C                   ENDDO

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
