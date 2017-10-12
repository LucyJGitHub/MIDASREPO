     H DEBUG
     H COPYRIGHT('(c) Misys Banking Systems 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Facility history wrong sequence number')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/UTLE0793A - To correct the PF/FACHISA                  *
      *                                                               *
      *  Function:  This program will resequence the records in the   *
      *             Facility History File                             *
      *                                                               *
      *  Called By: UTCLE0793A - CL program                           *
      *                                                               *
      *  (c) Misys Banking Systems 2016                               *
      *                                                               *
      *  Last Amend No. MD022057  *Create  Date 08Nov16               *
      *  Prev Amend No. Xxxxxxxx           Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022057 - Resequence the records after correcting the zero  *
      *             value dates.                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
     FFCLTY1    IF   E           K DISK
      ** Facility file
      *
     FFACHISHL  UF   E           K DISK
      ** Facility History Header
      *
     FFACACT    UF A E           K DISK
     FUTLE793APBUF   E           K DISK
     F                                     RENAME(FACHISAF:UTL793PF)
     FUTLE793APAO    E           K DISK
      ** Facilities to be recalculated
      *
     FUTLE793AP1O    E             PRINTER
      ** Printer File
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20  - EOF of FCLTY1                                         *
      *   23  - Record not found in UTLE793APB                        *
      *   30  - Update mode                                           *
      *   98  - Indicator used in standard subroutine                 *
      *  U7+U8  - Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
      *
      ** Rename Branch code
      *
     D                 DS
     D  FACNO                  1      5  0
     D  FACT                   1      3  0
     D  FCNO                   4      5  0
      *
     D                 DS
     D  CFCTY                  1      5  0
     D  CFACT                  1      3  0
     D  CFCNO                  4      5  0
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** Database error data structure
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Rundate data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for Access Program
      *
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
      ** Main Program
      *
     C                   READ      FCLTY1                                 20
      *
      ** Read all PF/FCLTYFM records
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   ADD       1             NOTOTS
      *
      ** Process details
      *
     C                   EXSR      PROCES
      *
     C                   READ      FCLTY1                                 20
      *
     C                   ENDDO
      *
     C     *IN30         IFEQ      '1'
     C                   EXSR      SRTSEQ
     C                   ENDIF
      *
      ** Print Trailer
      *
     C                   EXSR      TRAIL
      *
      ** End of program
      *
     C                   MOVE      '1'           *INLR
      *
      /EJECT
      *****************************************************************
      *  INIT - Initialisation Subroutine                             *
      *                                                               *
      *  CALLED FROM:  Main program                                   *
      *                                                               *
      *  CALLS: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Parameter entry
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Define RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
      *
      ** Check mode if 'AUDIT' or 'UPDATE'
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVE      '1'           *IN30
     C                   ELSE
     C                   MOVE      '0'           *IN30
     C                   ENDIF
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'UTLE0793A'   DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if CLE005 is *ON.
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CLE005'      PSARD             6
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   ENDIF
      *
      ** Key List
      *
     C     KEY001        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    FACNO
     C                   KFLD                    CDATE
      *
     C     KEY002        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    FACNO
      *
     C     KEY004        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    FACNO
      *
     C     WKFAC         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CCNUM
     C                   KFLD                    CFACT
     C                   KFLD                    CFCNO
      *
      ** Initialise variables
      *
     C                   MOVEA     CPY@          @CPY             80
     C                   Z-ADD     1             PAGENO
     C                   Z-ADD     0             LINEN             2 0
     C                   Z-ADD     0             NOREAD
     C                   Z-ADD     0             NOTOTS
     C                   Z-ADD     0             NOUPDT
     C                   MOVE      *BLANKS       VBRCA
     C                   MOVE      *BLANKS       VCNUM
     C                   MOVE      *BLANKS       VFCTY
     C                   MOVE      *BLANKS       VFCCY
     C                   MOVE      *BLANKS       VFSEQ
     C                   MOVE      *BLANKS       VERR
      *
      ** Set on *IN98 if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   END
      *
      ** Write header record
      *
     C                   WRITE     HEADER
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETL - Process the details to be printed                   *
      *                                                               *
      *  CALLED FROM:  SRSEQ                                          *
      *                                                               *
      *  CALLS: ZFRPED, AOCURRR0                                      *
      *                                                               *
      *****************************************************************
     C     SRDETL        BEGSR
      *
      ** Move details to report fields
      *
     C                   MOVE      BRCA          VBRCA
     C                   MOVE      CNUM          VCNUM
     C                   MOVEL     FACT          VFCTY
     C                   MOVE      FCNO          VFCTY
     C                   MOVE      FCCY          VFCCY
      *
     C                   MOVEL     CTSEQ         VFSEQ
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      FCCY          PK101             3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDCURRPD'    DBFILE
     C                   MOVEL     FCCY          DBKEY
     C                   Z-ADD     002           DBASE
     C                   MOVEL     'UTLE0793A'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      DETDEC
     C                   EXSR      FMTAMNT
      *
     C                   MOVEL     FCCY          VFCCY
     C                   MOVEL     CLONN         VLOAN
     C                   MOVEL     CACTN         VACTN
      *
      ** Format FADATE from Midas day no. to DDMMMYY
      *
     C                   MOVE      *BLANKS       VDATE
     C     CDATE         IFNE      *ZEROS
     C                   Z-ADD     CDATE         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        VDATE             7
     C                   ELSE
     C                   MOVE      *BLANKS       VDATE
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to process the recalculation             *
      *                                                               *
      *  CALLED FROM:  Main program                                   *
      *                                                               *
      *  CALLS: SRSEQ                                                 *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
     C     RECI          IFEQ      'D'
      *
     C                   MOVE      BRCA          HBRCA             3
     C                   MOVEL     FACT          WFACT             5 0
     C                   MOVE      FCNO          WFACT
     C                   MOVE      CNUM          WCNUM             6
     C                   Z-ADD     FACT          WFCTP             3 0
     C                   Z-ADD     FCNO          WFCNO             2 0
      *
      ** Print next page
      *
     C     LINEN         IFGT      39
     C                   ADD       1             PAGENO
     C                   WRITE     HEADER
     C                   Z-ADD     0             LINEN
     C                   ENDIF
      *
      ** Process sequence no.
      *
     C                   EXSR      SRSEQ
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
      *  SRTSEQ- Print Trailer                                        *
      *                                                               *
      *  CALLED FROM:  Main program                                   *
      *                                                               *
      *  CALLS: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTSEQ        BEGSR
      *
     C     *LOVAL        SETLL     UTL793PF
     C                   READ      UTL793PF                               22
      *
     C     *IN22         DOWEQ     '0'
     C     CFSEQ         IFNE      CTSEQ
     C                   Z-ADD     CTSEQ         CFSEQ
     C                   UPDATE    UTL793PF
     C                   ENDIF
     C                   READ      UTL793PF                               22
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  TRAIL - Print Trailer                                        *
      *                                                               *
      *  CALLED FROM:  Main program                                   *
      *                                                               *
      *  CALLS: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     TRAIL         BEGSR
      *
      ** Print Next Page
      *
     C     LINEN         IFGT      39
     C                   WRITE     HEADER
     C                   ENDIF
      *
      ** Print 'No details to print' if no error found
      *
     C                   WRITE     PRECS
      *
      ** Print 'End of report'
      *
     C                   WRITE     ENDOF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSEQ  - Subroutine to Process Sequence No.                  *
      *                                                               *
      *  Called from:  PROCES                                         *
      *                                                               *
      *  Calls: SRDETL, SRUPDT                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRSEQ         BEGSR
      *
     C                   Z-ADD     0             PRVDAT            5 0
     C                   Z-ADD     0             PRVDAT            5 0
     C                   Z-ADD     0             PRLOAN            6 0
     C                   Z-ADD     0             PRAAMT           13 0
     C                   MOVE      *BLANKS       PRACTN            2
     C                   Z-ADD     0             FSEQ1             3 0
     C                   Z-ADD     0             PSEQ2             3 0
     C                   Z-ADD     0             DIFF1             2 0
     C                   Z-ADD     0             NSEQ              3 0
     C                   Z-ADD     0             CNT1              3 0
     C                   Z-ADD     0             CNT2              3 0
     C                   MOVE      *BLANKS       VERR
      *
      ** Read records from Facility History File
      *
     C     KEY002        SETLL     UTL793PF
     C     KEY002        READE     UTL793PF                               23
      *
     C     *IN23         DOWEQ     '0'
      *
     C                   Z-ADD     CTSEQ         FSEQ1
     C                   MOVEL     'N'           MATCH             1
     C                   Z-ADD     0             CNT2
      *
     C     CDATE         IFEQ      PRVDAT
      *
     C                   ADD       1             CNT1
      *
      ** If the same sequence no., error
      *
     C     FSEQ1         IFEQ      PSEQ2
     C                   ADD       1             NOREAD
     C                   MOVEL     '***'         VERR
     C                   ELSE
      *
      ** If not the same sequence no.
      *
     C     FSEQ1         IFNE      PSEQ2
      *
      ** If the previous sequence no. is greater than
      ** the sequence no. of the current record, then in error.
      *
     C     PSEQ2         IFGT      FSEQ1
     C                   ADD       1             NOREAD
     C                   MOVEL     '***'         VERR
      *
     C                   ELSE
      *
     C     FSEQ1         SUB       PSEQ2         DIFF1
      *
      ** If the current sequence no. is greater than the
      ** previous sequence no, check the difference.  If
      ** the difference is greater than 1, then in error.
      *
     C     DIFF1         IFGT      1
     C                   ADD       1             NOREAD
     C                   MOVEL     '***'         VERR
     C                   ELSE
      *
      ** If difference is equal to 1, but previous sequence
      ** is in error, then the sequence no. of the current
      ** record is still in error.
      *
     C     VERR          IFEQ      '***'
     C                   ADD       1             NOREAD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                          ** FAFSEQ IF
      *
      ** During update mode, update the records which
      ** are in error.
      *
     C     *IN30         IFEQ      '1'
     C                   ADD       1             NSEQ
     C     VERR          IFEQ      '***'
     C                   ADD       1             NOUPDT
     C                   EXSR      SRUPDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If the date of the previous record is no
      ** longer equal to the date of the current
      ** record, reset NSEQ to 1 during update mode.
      *
     C                   MOVE      *BLANKS       VERR
     C                   Z-ADD     0             PSEQ2
      *
      ** If the first sequence no. is not eq to 01,
      ** sequence is in error.
      *
     C     FSEQ1         IFGT      1
     C                   MOVEL     '***'         VERR
     C                   ADD       1             NOREAD
     C                   ENDIF
      *
     C     FSEQ1         IFEQ      0
     C                   Z-ADD     1             PSEQ2
     C                   MOVEL     '***'         VERR
     C                   ADD       1             NOREAD
     C                   ENDIF
      *
     C     *IN30         IFEQ      '1'
     C                   Z-ADD     1             NSEQ
     C                   Z-ADD     1             CNT1
     C                   MOVEL     'Y'           MATCH
     C     VERR          IFEQ      '***'
     C                   ADD       1             NOUPDT
     C                   ENDIF
     C                   EXSR      SRUPDT
     C                   ENDIF
      *
     C                   ENDIF                                                          ** FADATE IF
      *
      ** Move date and sequence to work variables.
      *
     C                   Z-ADD     CDATE         PRVDAT
     C                   MOVEL     CLONN         PRLOAN
     C                   Z-ADD     CAMNT         PRAAMT
     C                   MOVEL     CACTN         PRACTN
      *
     C     FSEQ1         IFGT      0
     C                   Z-ADD     FSEQ1         PSEQ2
     C                   ENDIF
      *
     C     VERR          IFEQ      '***'
      *
      ** Format details to be reported
      *
     C                   EXSR      SRDETL
      *
      ** Write to printer file
      *
     C                   WRITE     DETAIL
      *
     C                   ADD       1             LINEN
      *
     C     LINEN         IFGT      39
     C                   ADD       1             PAGENO
     C                   WRITE     HEADER
     C                   Z-ADD     0             LINEN
     C                   ENDIF
      *
     C                   MOVEL     BRCA          DATBRC
     C                   MOVE      CCNUM         DATNUM
     C                   Z-ADD     CFCTY         DATFAC
     C                   MOVE      *BLANKS       UPAMT
     C                   WRITE     DATEREC
      *
      ** Tag the facility for recalculation/rework on the
      ** next COB.
      *
     C     *IN30         IFEQ      '1'
     C     WKFAC         CHAIN     FACHISHL                           21
     C     *IN21         IFEQ      '0'
     C                   MOVEL     'Y'           FHRWKR
     C                   MOVEL     FHDAPP        FHRWDT
     C                   MOVEL     'M'           FHRWTP
     C                   UPDATE    FACHISHF
     C                   ENDIF
      *
     C     KEY004        CHAIN     FACACTF                            85
      *
      ** ADD RECORD IF NOT FOUND, ELSE UPDATE
      *
     C     *IN85         IFEQ      '1'
     C                   MOVE      CNUM          FCCNUM
     C                   MOVE      FACNO         FCFCTY
     C                   Z-ADD     FHDAPP        FCDATE
     C                   WRITE     FACACTF
     C                   ELSE
     C                   Z-ADD     FHDAPP        FCDATE
     C                   UPDATE    FACACTF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KEY002        READE     UTL793PF                               23
      *
     C                   ENDDO                                                          *** DO *IN23
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDT - Subroutine to Update Facility History File          *
      *                                                               *
      *  Called from:  SRSEQ                                          *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDT        BEGSR
      *
     C                   Z-ADD     0             FPLOAN            6 0
     C                   Z-ADD     0             FPAAMT           13 0
     C                   MOVE      *BLANKS       FPACTN            2
     C                   Z-ADD     0             FPDATE            5 0
      *
     C     KEY001        SETLL     UTL793PF
     C     KEY001        READE     UTL793PF                               24
      *
     C                   MOVEL     CLONN         FPLOAN
     C                   Z-ADD     CAMNT         FPAAMT
     C                   MOVEL     CACTN         FPACTN
     C                   Z-ADD     CDATE         FPDATE
      *
     C     *IN24         DOWEQ     '0'
      *
     C                   ADD       1             CNT2
      *
     C     CNT1          IFEQ      CNT2
     C                   MOVEL     'Y'           MATCH
     C                   ELSE
     C                   MOVEL     'N'           MATCH
     C                   ENDIF
      *
     C     MATCH         IFEQ      'Y'
     C                   Z-ADD     NSEQ          CTSEQ
     C                   UPDATE    UTL793PF
     C                   MOVE      '1'           *IN24
     C                   ENDIF                                                                 *** M
      *
     C                   MOVEL     CLONN         FPLOAN
     C                   Z-ADD     CAMNT         FPAAMT
     C                   MOVEL     CACTN         FPACTN
     C                   Z-ADD     CDATE         FPDATE
      *
     C     *IN24         IFEQ      '0'
     C     KEY002        READE     UTL793PF                               24
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  DETDEC - Determine number of decimal places                  *
      *                                                               *
      *****************************************************************
     C     DETDEC        BEGSR
      *
     C                   MOVEA     '0000'        *IN(60)
      *
     C                   IF        A6NBDP = 0
     C                   MOVE      '1'           *IN60
     C                   ENDIF
     C                   IF        A6NBDP = 1
     C                   MOVE      '1'           *IN61
     C                   ENDIF
     C                   IF        A6NBDP = 2
     C                   MOVE      '1'           *IN62
     C                   ENDIF
     C                   IF        A6NBDP = 3
     C                   MOVE      '1'           *IN63
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  FMTAMNT - Move amount values into corresponding display      *
      *                                                               *
      *****************************************************************
     C     FMTAMNT       BEGSR
      *
     C                   IF        *IN60 = '1'
     C                   MOVE      CAMNT         VFAMT0
     C                   ENDIF
     C                   IF        *IN61 = '1'
     C                   MOVE      CAMNT         VFAMT1
     C                   ENDIF
     C                   IF        *IN62 = '1'
     C                   MOVE      CAMNT         VFAMT2
     C                   ENDIF
     C                   IF        *IN63 = '1'
     C                   MOVE      CAMNT         VFAMT3
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  CALLED FROM:  After abnormal operation occurs                *
      *                                                               *
      *  CALLS: NOTHING                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8
     C                   DUMP
     C                   ENDIF
      *
     C                   ADD       1             PAGENO
     C     LINEN         IFGT      35
     C                   WRITE     HEADER
     C                   ENDIF
      *
     C                   WRITE     DBERR
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
     C********************************************************************
      /TITLE SR/ZDATE2
     C/COPY ZSRSRC,ZDATE2Z2LE
**  CPY@
(C) Copyright Misys Banking System Ltd. 2013
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
