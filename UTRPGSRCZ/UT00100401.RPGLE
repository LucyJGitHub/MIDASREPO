     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Stack Generation Utility by Top-Lvl Pgm')     *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT00100401 - Midas UT Stack Generation Utility by Top-Level  *
      *               program                                         *
      *                                                               *
      *  Function:  This module will generate report based on         *
      *             top-level programs                                *
      *                                                               *
      *  Called By: UTC01010 - Error Messages References Stack        *
      *                        Generation Startup                     *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas Ut Programs/Error Messages List
     FUT1004P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN81)
 
      ** LF - Output file for DSPPGMREF *ALL
     FUTPREFL1  IF   E           K DISK    RENAME(QWHDRPPR:UTPREF)
     F                                     PREFIX(PR_)
 
      ** Midas UT Error Messages/Message Files-keyed by pgm
     FUTERMUL0  IF   E           K DISK
 
      ** Error Codes/ Message Files
     FUTERCDL1  IF   E           K DISK
 
      ** Stack Generation Engine Report File - Keyed
     FUTSG01L1  IF   E           K DISK    RENAME(UTSG01F:UTSG01F1)
 
      ** Midas UT Exceptions File - Keyed
     FUTEREXL0  IF   E           K DISK
 
      ** UTSGENPD - Distinct MPGM Record Entries
     FV_UTSGENV1IF   E             DISK    RENAME(V_UTSGENV1:UTSGENV1)
 
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
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for UTPERSPRTF
     D SPOOL1          DS
     D SFILE                  83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0
 
      ** Data Structure for printer file
     D TOPPGM          DS           110
     D UPGM02                  6      7
     D UPGM03                  6      9
     D UPGM04                  6     11
     D UPGM05                  6     13
     D UPGM06                  6     15
     D UPGM07                  6     17
     D UPGM08                  6     19
     D UPGM09                  6     21
     D UPGM10                  6     23
     D UPGM11                  6     25
     D UPGM12                  6     27
     D UPGM13                  6     29
     D UPGM14                  6     31
     D UPGM15                  6     33
     D UPGM16                  6     35
     D UPGM17                  6     37
     D UPGM18                  6     39
     D UPGM19                  6     41
     D UPGM20                  6     43
 
      ** Data Structure for printer file
     D ERRMSG          DS           125
     D UBLNK                   1    100
     D UBNK2                   1      5
     D UERRC                 105    115
     D UMSGF                 116    125
     D WERMSGF               105    125
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WRTCD           S              1
 
      ** Access Object Parameters
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Other fields
     D WNoRec          S              5S 0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D RRN             S              4S 0
     D WPGM            S             10A
     D ZRPGM           S             10A
     D ZMPGM           S             10A
     D ZRLVL           S              2S 0
     D XWPGM           S             10A
     D WDESC           S             50A
     D WERRC           S              7A
     D WFLG1           S              1A
     D WFLG2           S              1A
     D UERMSG          S            100A
     D SRTN            S             10A
 
      ** Variable to store pgm + description
     D WPGDESC         S            100A
 
      ** Batch Monitor Update Varibles
     D@LEN             S             15P 5
     D@CMD             S             50A
 
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
 
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
 
     C                   EXSR      SRMAIN
     C                   EXSR      SREXIT
 
      *****************************************************************
      * SRMAIN
      *****************************************************************
     C     SRMAIN        BEGSR
 
     C                   SETON                                        75
 
      ** Read all record in UTSGENV1
 
     C                   EVAL      RRN = RRN + 1
     C     RRN           SETLL     UTSGENV1
     C                   READ      UTSGENV1                               80
 
     C                   DOW       *IN80 = *OFF
 
      ** Write header
 
     C                   IF        *IN75 = *ON
     C                   WRITE     HEADPY
     C                   WRITE     COLHDG
     C                   SETOFF                                         75
     C                   ENDIF
 
     C                   EVAL      WPGM = MPGM
 
      ** Retrieve program description
 
     C                   EXSR      SRDESC
 
      ** Retrieve all error codes used within the program
 
     C                   EVAL      SRTN = 'SRMAIN'
     C                   EXSR      SRERRC
 
      ** Build program tree
 
     C                   EVAL      SRTN = 'SRTREE'
     C                   EXSR      SRTREE
 
     C                   READ      UTSGENV1                               80
     C                   ENDDO
 
     C                   EXSR      SRP1END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDESC - Retrieve program description from UTPREFPD           *
      *****************************************************************
     C     SRDESC        BEGSR
 
     C                   EVAL      WDESC = ' '
 
     C     WPGM          CHAIN     UTPREF                             82
 
     C                   IF        *IN82 = *OFF
     C                   EVAL      WDESC = PR_WHTEXT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRERRC - Retrieve error code/s and message/file               *
      *****************************************************************
     C     SRERRC        BEGSR
 
     C                   EVAL      WFLG1 = ' '
     C                   EVAL      WFLG2 = ' '
 
      ** Retrieve all error codes used within the program
 
     C     WPGM          SETLL     UTERMUL0
     C     WPGM          READE     UTERMUL0                               88
 
     C                   DOW       *IN88 = *OFF
     C                   IF        WERRC <> ERERID
 
     C                   EVAL      WERRC = ERERID
     C                   EVAL      UERRC = ERERID
 
      ** Check for exception
 
     C     WERRC         CHAIN     UTEREXL0                           85
 
      ** If found in exceptions file, print error code marked with *EXCEPTION
 
     C                   IF        *IN85 = *OFF
 
     C                   EXSR      SREXCPT
 
      ** If not found in exceptions file, determine the message file
 
     C                   ELSE
 
     C     WERRC         CHAIN     UTERCDL1                           89
     C                   IF        *IN89 = *OFF
     C                   EVAL      UMSGF = DMFILE
 
     C                   IF        WFLG1 = ' ' AND WFLG2 = ' '
     C                   EXSR      SRLVL
     C                   EVAL      UTPERS = WPGDESC + WERMSGF
 
     C                   ELSE
     C                   EVAL      UTPERS = UBLNK + WERMSGF
     C                   ENDIF
 
     C                   ENDIF
     C                   EXSR      SRP1REC
     C                   EVAL      WFLG1 = 'Y'
     C                   EVAL      UTPERS = ' '
     C                   ENDIF
 
     C                   ENDIF
 
     C     WPGM          READE     UTERMUL0                               88
     C                   ENDDO
 
     C                   IF        *IN88 = *ON  AND WFLG1 = ' ' AND
     C                              WPGM <> ZRPGM
     C                   EXSR      SRLVL
     C                   EVAL      UTPERS = WPGDESC
     C                   EXSR      SRP1REC
     C                   EVAL      UTPERS = ' '
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTREE  - Construct the program hierarchy                     *
      *****************************************************************
     C     SRTREE        BEGSR
 
     C     WPGM          SETLL     UTSG01F1
     C     WPGM          READE     UTSG01F1                               84
 
     C                   DOW       *IN84 = *OFF
 
      ** Move value of WPGM to temporary field XWPGM where WPGM=SGMPRG
     C                   EVAL      XWPGM = WPGM
 
     C                   EVAL      WPGM = SGRPRG
     C                   EXSR      SRDESC
     C                   EXSR      SRERRC
 
     C                   EVAL      WPGM = XWPGM
 
     C     WPGM          READE     UTSG01F1                               84
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SGRLVL - determines the level of the program in the hierarchy *
      *****************************************************************
     C     SRLVL         BEGSR
 
      ** For level 2 program onwards
 
     C                   IF        SRTN = 'SRTREE'
     C                   SELECT
     C                   WHEN      SGRLVL = 2
     C                   EVAL      WPGDESC = UPGM02 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 3
     C                   EVAL      WPGDESC = UPGM03 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 4
     C                   EVAL      WPGDESC = UPGM04 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 5
     C                   EVAL      WPGDESC = UPGM05 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 6
     C                   EVAL      WPGDESC = UPGM06 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 7
     C                   EVAL      WPGDESC = UPGM07 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 8
     C                   EVAL      WPGDESC = UPGM08 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 9
     C                   EVAL      WPGDESC = UPGM09 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 10
     C                   EVAL      WPGDESC = UPGM10 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 11
     C                   EVAL      WPGDESC = UPGM11 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 12
     C                   EVAL      WPGDESC = UPGM12 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 13
     C                   EVAL      WPGDESC = UPGM13 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 14
     C                   EVAL      WPGDESC = UPGM14 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 15
     C                   EVAL      WPGDESC = UPGM15 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 16
     C                   EVAL      WPGDESC = UPGM16 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 17
     C                   EVAL      WPGDESC = UPGM17 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 18
     C                   EVAL      WPGDESC = UPGM18 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 19
     C                   EVAL      WPGDESC = UPGM19 + WPGM + ' ' + WDESC
     C                   WHEN      SGRLVL = 20
     C                   EVAL      WPGDESC = UPGM20 + WPGM + ' ' + WDESC
     C                   ENDSL
 
     C                   ELSE
 
      ** For main program
 
     C                   EVAL      WPGDESC = WPGM + ' ' + WDESC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRP1REC - this will write header, column title and details    *
      *           to the report                                       *
      *****************************************************************
     C     SRP1REC       BEGSR
 
     ** Check that sufficient lines remain for the Format. If not,
     ** write out the Main Headings on a new page.
 
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
 
     C                   IF        DIFLN1 < RQDLN1
     C                   WRITE     HEADPY
     C                   WRITE     COLHDG
     C                   ENDIF
 
     ** Write out Detail Record
 
     C                   WRITE     DETAIL
 
     C                   EVAL      *IN21 = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRP1END - this will write the end-of-report on the report     *
      *****************************************************************
     C     SRP1END       BEGSR
 
     ** Check that sufficient lines remain for the Format. If not,
     ** write out the Main Headings on a new page
 
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
 
     C                   IF        DIFLN1 < RQDLN1
     C                   WRITE     HEADPY
     C                   WRITE     COLHDG
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREXCPT - when error code is found in file UTEREXPD, msg file *
      *           will not be included in the report. It will be      *
      *           replaced by the word '*Extension'                   *
      *****************************************************************
     C     SREXCPT       BEGSR
 
      ** If not first call to sub-routine and main program is different
      ** from the previous read, reset ZRLVL and ZRPGM
 
     C                   IF        ZMPGM <> SGMPRG AND WFLG2 = 'Y'
     C                   EVAL      ZRLVL = 0
     C                   EVAL      ZRPGM = ' '
     C                   ENDIF
 
      ** For 1st error code found in the program
 
     C                   IF        ZRPGM <> WPGM AND ZMPGM <> SGMPRG
     C                             AND WFLG1 = ' ' OR
     C                             ZRLVL <> SGRLVL AND ZMPGM = SGMPRG
     C                             AND WFLG1 = ' ' OR
     C                             ZMPGM = SGMPRG AND ZRLVL = SGRLVL
     C                             AND ZRPGM <> WPGM AND WFLG1 = ' '
 
     C                   EXSR      SRLVL
     C                   EVAL      UTPERS = WPGDESC +
     C                                      UERRC + '*Exception'
     C                   EVAL      WFLG2 = 'Y'
 
     C                   ELSE
 
      ** For the succeeding error code/s
 
     C                   EVAL      UTPERS = UBLNK + UERRC + '*Exception'
     C                   ENDIF
 
      ** Write to report
 
     C                   EXSR      SRP1REC
     C                   EVAL      UTPERS = ' '
 
      ** Store to temporary storage
 
     C                   EVAL      ZRPGM = WPGM
     C                   EVAL      ZMPGM = SGMPRG
     C                   EVAL      ZRLVL = SGRLVL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREXIT - updates data area UTSGSTAT whether the job ends      *
      *          succesfully or not before exiting the program        *
      *****************************************************************
     C     SREXIT        BEGSR
 
     C                   EVAL      @CMD = 'CHGDTAARA DTAARA(UTSGSTAT (1 1 +
     C                                     )) VALUE(Y)'
     C                   EVAL      @LEN = 50
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
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
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
 
     C                   EVAL      RRN     = 0
     C                   EVAL      ZRLVL   = 0
     C                   EVAL      WPGM    = ' '
     C                   EVAL      SRTN    = ' '
     C                   EVAL      ZRPGM   = ' '
     C                   EVAL      ZMPGM   = ' '
     C                   EVAL      WDESC   = ' '
     C                   EVAL      WERRC   = ' '
     C                   EVAL      WFLG1   = ' '
     C                   EVAL      WFLG2   = ' '
     C                   EVAL      UERMSG  = ' '
     C                   EVAL      WPGDESC = ' '
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      @CMD = 'CHGDTAARA DTAARA(UTSGSTAT (1 1 +
     C                                     )) VALUE(Y)'
     C                   EVAL      @LEN = 50
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
