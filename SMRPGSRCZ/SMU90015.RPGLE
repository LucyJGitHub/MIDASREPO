     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to Correct HKRCFR and HKRCDM of MMDELDPP')     *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  SMU90015 - Midas DL MD-45018 Utility to Correct HKRCFR and   *
      *             HKRCDM of MMDELDPP                                *
      *                                                               *
      *  Function:  This program lists and updates all fixed-term     *
      *             deals on PF/MMDELDPP that have different values   *
      *             of Rate Change Frequency and Rate Change Days     *
      *             with those on PF/DEALSDC.                         *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD045018  *CREATE   Date 08May23              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD045018 - MM deal, with a Base Rate Code, could not be      *
      *              amended due to blank Rate Change Date.           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    80      'Total Number of Deals to Update' Text in PRTF     *
      *    81      'Total Number of Deals Updated' Text in PRTF       *
      *    82      Rate Change Freq not in synch. Show *** in report  *
      *    83      Rate Change Days not in synch. Show *** in report  *
      *    84      Show 'Blank' in report if HKRCFR is blank on file  *
      *    85      Show 'Blank' in report if XKRCFR is blank on file  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas MM Loan/deposit/CD issued
     FMMDEAULL  UF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0)

      ** Midas DL Money market & loans deals details
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDCF)

      ** Midas MM Default Reporting Information Report - List
     FSMU90015P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Midas SD Rundate dataarea layout file
     D RUNDT         E DS            13    EXTNAME(RUNDAT)

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D DSLDY         E DS                  EXTNAME(DSLDY)

     D SPOOL1          DS
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PMODE           S              1

      ** Other working variables
     D WwRun           S              1
     D PRtCd           S              7
     D POptn           S              7
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D @RUN            S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Main Program

     C     *LOVAL        SETLL     DEALALL
     C                   READ      DEALALL
     C                   WRITE     HEADER
     C                   IF        %EOF(DEALALL)
      *
      ** if no records, no details to report
     C                   WRITE     NOREC
      *
     C                   ELSE
     C                   DOW       NOT %EOF(DEALALL)
      *
      ** Fixed-term deals only
     C                   IF        DTYP = 'IP'
     C                             OR DTYP = 'IT'
     C                             OR DTYP = 'TD'
     C                             OR DTYP = 'TI'
     C                             OR DTYP = 'CI'
     C                             OR DTYP = 'CF'
      *
     C     DLNO          CHAIN     MMDEAULL
     C                   IF        %FOUND(MMDEAULL)
      *
      ** Check Rate Change Frequency and Day if synchronized on
      ** DEALSDC and MMDELDPP
     C                   IF        HKRCFR <> XKRCFR
     C                             OR HKRCDM <> XKRCDM
     C                   EXSR      SrPrint
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   READ      DEALALL
     C                   ENDDO
      *
     C                   WRITE     TRAILER
     C                   ENDIF
      *
     C                   Eval      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrint  - Print detail record                               *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

      ** Check for overflow
     C                   EVAL      RqdLn1 = 28
     C                   EXSR      SrChkLin
      *
      ** Populate the output fields
      *
     C                   EVAL      RBRCA = BRCA
     C                   EVAL      RDLNO = DLNO
     C                   EVAL      RDTYP = DTYP
     C                   EVAL      RSTYP = DLST
      *
      ** Rate change frequency is not in synch
     C                   IF        HKRCFR <> XKRCFR
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
      *
      ** rate change day is not in synch
     C                   IF        HKRCDM <> XKRCDM
     C                   EVAL      *IN83 = *ON
     C                   ENDIF
      *
      ** Update mode
     C                   IF        PMODE = 'U' or PMODE = 'u'
      *
     C                   IF        HKRCFR <> XKRCFR
     C                   EVAL      HKRCFR = XKRCFR
     C                   ENDIF
      *
     C                   IF        HKRCDM <> XKRCDM
     C                   EVAL      HKRCDM = XKRCDM
     C                   ENDIF
      *
     C                   UPDATE    MMDELDP0
     C                   ENDIF
      *
     C                   EVAL      RHKRCFR = HKRCFR
      *
     C                   IF        HKRCFR = *BLANKS
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
      *
     C                   EVAL      RXKRCFR = XKRCFR
      *
     C                   IF        XKRCFR = *BLANKS
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
      *
     C                   EVAL      RHKRCDM = HKRCDM
     C                   EVAL      RXKRCDM = XKRCDM
      *

      ** Write details
     C                   WRITE     DETAIL

      ** Number of written records
     C                   ADD       1             RCOUNT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkLin - Checks for printer file overflow condition        *
      *                                                               *
      *****************************************************************
     C     SrChkLin      BEGSR

     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Receive entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    PMODE

     C                   IF        PMODE = 'U' OR PMODE = 'u'
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN81 = *OFF
     C                   ENDIF

      ** Define LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SMU90015  '
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBPGM  = 'SMU90015  '
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initialise working fields
     C                   Z-ADD     0             RCOUNT
     C                   EVAL      RqdLn1 = *ZERO
     C                   EVAL      DifLn1 = *ZERO
     C                   EVAL      PRTLN1 = *ZERO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Copyright Finastra International Limited 2023
