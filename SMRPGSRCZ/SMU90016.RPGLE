     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Housekeeping for GLJENPX0 ')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU90016 - Housekeeping for GLJENPX0                         *
      *                                                               *
      *  Called By: SMUC90016                                         *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060987 *CREATE   Date 20Apr23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060987 - Utility to move GLJENPX0 records to GLJEPHX0      *
      *             for GLACPHPD equivalent records.                  *
      *                                                               *
      *****************************************************************

     FGLACPHL2  IF   E           K DISK    IGNORE(APOSTPDF:GLPOSTD0)
     F                                     INFSR(*PSSR)
     FGLJEHPL0  IF   E           K DISK    INFSR(*PSSR)
     FGLJENPY0  UF   E           K DISK    INFSR(*PSSR)
     FGLJEPHX0  UF A E             DISK    INFSR(*PSSR)
     FSMU90016P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN99)
     F                                     INFSR(*PSSR)
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
      *
      *
      ** LOCAL DATA AREA FOR DATABASE ERROR DETAILS
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      **  Data Area RUNDAT
      *
     D RUNDT           DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
      ** Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     DNONAR1           C                   CONST('No Narrative Defined-DELETED')
      *
      *****************************************************************
      *                                                               *
      * Program Start                                                 *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      MOVREC
     C                   EXSR      OFLNSR
     C                   WRITE     ENDP1
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * MOVREC - Detail processing                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: MOVACC, OFLNSR                                         *
      *                                                               *
      *****************************************************************
      *
     C     MOVREC        BEGSR
      *
      ** Read template file.
     C     *LOVAL        SETLL     GLJENPY0
     C                   READ      GLJENPY0
     C                   DOW       NOT %EOF
      *
      ** Write record to history file
      *
     C                   Z-ADD     0             HNALN
     C                   MOVEL     *BLANKS       HNATX
     C                   MOVEL     *BLANKS       P1NAR1
      *
     C                   MOVEL     FBTNB         SPOSJ             6
     C                   MOVE      FBINB         SPOSJ
     C                   MOVEL     SPOSJ         SPOS
     C                   Z-ADD     FPTDT         PSTD
     C     KGLACP        CHAIN     GLACPHPF                           28
     C     *IN28         IFEQ      *OFF
     C                   MOVEL     FBTNB         HBTNB
     C                   Z-ADD     FBINB         HBINB
     C                   Z-ADD     FPTDT         HPTDT
     C                   EXSR      MOVACC
     C     FNA02         IFNE      *BLANKS
     C                   Z-ADD     2             HNALN
     C                   MOVEL     FNA02         HNATX
     C                   MOVEL     FNA02         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA03         IFNE      *BLANKS
     C                   Z-ADD     3             HNALN
     C                   MOVEL     FNA03         HNATX
     C                   MOVEL     FNA03         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA04         IFNE      *BLANKS
     C                   Z-ADD     4             HNALN
     C                   MOVEL     FNA04         HNATX
     C                   MOVEL     FNA04         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA05         IFNE      *BLANKS
     C                   Z-ADD     5             HNALN
     C                   MOVEL     FNA05         HNATX
     C                   MOVEL     FNA05         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA06         IFNE      *BLANKS
     C                   Z-ADD     6             HNALN
     C                   MOVEL     FNA06         HNATX
     C                   MOVEL     FNA06         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA07         IFNE      *BLANKS
     C                   Z-ADD     7             HNALN
     C                   MOVEL     FNA07         HNATX
     C                   MOVEL     FNA07         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA08         IFNE      *BLANKS
     C                   Z-ADD     8             HNALN
     C                   MOVEL     FNA08         HNATX
     C                   MOVEL     FNA08         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA09         IFNE      *BLANKS
     C                   Z-ADD     9             HNALN
     C                   MOVEL     FNA09         HNATX
     C                   MOVEL     FNA09         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA10         IFNE      *BLANKS
     C                   Z-ADD     10            HNALN
     C                   MOVEL     FNA10         HNATX
     C                   MOVEL     FNA10         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA11         IFNE      *BLANKS
     C                   Z-ADD     11            HNALN
     C                   MOVEL     FNA11         HNATX
     C                   MOVEL     FNA11         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA12         IFNE      *BLANKS
     C                   Z-ADD     12            HNALN
     C                   MOVEL     FNA12         HNATX
     C                   MOVEL     FNA12         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA13         IFNE      *BLANKS
     C                   Z-ADD     13            HNALN
     C                   MOVEL     FNA13         HNATX
     C                   MOVEL     FNA13         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA14         IFNE      *BLANKS
     C                   Z-ADD     14            HNALN
     C                   MOVEL     FNA14         HNATX
     C                   MOVEL     FNA14         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA15         IFNE      *BLANKS
     C                   Z-ADD     15            HNALN
     C                   MOVEL     FNA15         HNATX
     C                   MOVEL     FNA15         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA16         IFNE      *BLANKS
     C                   Z-ADD     16            HNALN
     C                   MOVEL     FNA16         HNATX
     C                   MOVEL     FNA16         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     FNA17         IFNE      *BLANKS
     C                   Z-ADD     17            HNALN
     C                   MOVEL     FNA17         HNATX
     C                   MOVEL     FNA02         P1NAR1
     C                   WRITE     GLJEPHD1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
     C     HNALN         IFEQ      0
     C                   MOVEL     NONAR1        P1NAR1
     C                   EXSR      OFLNSR
     C                   WRITE     NARRP1
     C                   ENDIF
      *
     C                   DELETE    GLJENPD2
      *
     C                   ENDIF
      *
     C                   READ      GLJENPY0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * MOVACC - Write Batch item detail                              *
      *                                                               *
      * Called by: MOVREC, MOVREC                                     *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
      *
     C     MOVACC        BEGSR
      *
     C     KGLJEH        CHAIN     @BFREDD                            29
     C     *IN29         IFEQ      *OFF
     C                   MOVEL     HPIBCA        P1BRCA
     C                   MOVEL     HPCUST        P1CNUM
     C                   MOVEL     HPCYCD        P1CCY
     C                   MOVEL     HPACCD        P1ACOD
     C                   MOVEL     HPACSN        P1ACSQ
     C                   MOVEL     SPOSJ         P1BTNO
     C                   ENDIF
      *
     C                   CALL      'ZDATE2'
     C                   PARM      HPTDT         ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      0             ZDATE             6 0
     C                   PARM      *Blanks       ZADATE            7
     C                   MOVE      ZADATE        P1PSTD
     C                   EXSR      OFLNSR
     C                   WRITE     DTAIL1
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * OFLNSR - Set up overflow                                      *
      *                                                               *
      * Called by: MOVACC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     OFLNSR        BEGSR
      *
     C     *IN99         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   MOVE      *OFF          *IN99
     C                   ADD       1             PAGE
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      *
      ** INITIALISE LDA VARIABLES
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SMU90016'    DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 001 *
     C                   Z-ADD     001           DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     KGLACP        KLIST
     C                   KFLD                    PSTD
     C                   KFLD                    SPOS
      *
     C     KGLJEH        KLIST
     C                   KFLD                    HPTDT
     C                   KFLD                    HBTNB
     C                   KFLD                    HBINB
      *
     C                   Z-ADD     0             PAGE
      *
      ** OUTPUT  HEADER
      *
     C                   MOVEL     BJURPT        TITL
     C                   WRITE     HEADP1
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EXSR      OFLNSR
     C                   WRITE     ERRP1
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

