     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Trigger Repair of Basel II Fields')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UTLE0838 - Trigger Repair of Basel II Fields                 *
      *                                                               *
      *  Function:  This program checks that if the record is a live  *
      *             fee attached to past due call loan & zero initial *
      *             date, zeroise the Basel II fields (FEBIDT, FEBCAT *
      *             & FEBCSD) to trigger repair of incorrect values   *
      *             during COB.                                       *
      *             This program runs in two modes according to the   *
      *             parameter being passed into it:                   *
      *             1. Audit ('A')                                    *
      *             2. Update ('U')                                   *
      *                                                               *
      *                                                               *
      *  Called By: UTCLE0838 - CL program                            *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053837 *CREATE   Date 02Sep19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053837 - Inconsistency in Basel II initial date and        *
      *             classification for fees. Zeroise Basel II fields  *
      *             in LEFEED to trigger repair of incorrect values   *
      *             in COB.                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR)
     FUTLE0838P1O    E             PRINTER OFLIND(*IN82)

      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *   12 -  No Details to Report                                  *
      *   16 -  Update mode                                           *
      *   80 -  EOF in LEFEED                                         *
      *   82 -  Overflow UTLE0838P1                                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Rundate data structure
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Bank Details.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data structure for Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** ZDATE2 parameters
      *
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /SPACE 5
      ************************************************D ***************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initial printing of report header
      *
     C                   WRITE     HEADER1
      *
      ** Read LEFEEDL1
      *
     C     *START        SETLL     LEFEEDL1
     C                   READ      LEFEEDL1                               80
      *
     C                   DOW       *IN80 = '0'
      *
      ** Check if a live fee that is attached to a PDCL
      *
     C                   IF        FERECI = 'D' AND FEPLNR <> *BLANKS
     C                             AND FEBIDT <> 0
      *
      ** Printer overflow checking
      *
     C                   IF        *IN82 = '1'
     C                   WRITE     HEADER1
     C                   EVAL      *IN82 = '0'
     C                   ENDIF
      *
      ** Update mode is ON
      *
     C                   IF        *IN16 = '1'
     C                   EVAL      FEBIDT = 0
     C                   EVAL      FEBCAT = 0
     C                   EVAL      FEBCSD = 0
     C                   UPDATE    LEFEEDF
     C                   ENDIF
      *
      ** Populate printer file
      *
     C                   EVAL      PCNUM = FECNUM
     C                   MOVEL     FEFACL        PFACT
     C                   MOVE      FEFACL        PFCNO
     C                   EVAL      PLOAN = *BLANKS
     C                   EVAL      PLOAN = FELOAN
     C                   EVAL      PFSEQ = FEFSEQ
     C                   EVAL      PPLNR = FEPLNR
     C                   EVAL      PBCAT = FEBCAT
      *
     C                   EVAL      ZDAYNO = FEBIDT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   EVAL      PBIDT = ZADATE
      *
     C                   EVAL      ZDAYNO = FEBCSD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   EVAL      PBCSD = ZADATE
      *
      ** Write details to printer file
      *
     C                   WRITE     DETAIL1
      *
      ** Accumulate records in error
      *
     C                   ADD       1             WRECER
      *
     C                   ENDIF
      *
     C                   READ      LEFEEDL1                               80
      *
     C                   ENDDO
      *
      ** Write footer
      *
     C                   IF        WRECER = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   WRITE     TRAILER1
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              1
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check mode if AUDIT or UPDATE
      *
     C                   IF        Mode = 'U'
     C                             OR Mode = 'u'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             WRECER            6 0
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN                                *************
     C                   EVAL      DBPGM = 'UTLE0838'                           * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2019
