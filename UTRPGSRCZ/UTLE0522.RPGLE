     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Correction of Loan missing/duplicate IH header')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UTLE0522 - (Utility) Datapatch to add (missing) and          *
      *             delete (duplicate) IH record and trigger          *
      *             history file recalculation.                       *
      *                                                               *
      *  (C) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR545781 *CREATE   Date 24Aug16               *
      *                 XNNNNNNN           Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  AR545781 - Missing/Multiple IH on history file. Provide a    *
      *             datapatch utility to update loan                  *
      *             History file based from loan event history.       *
      *           - Applied utility to MD-37545                       *
      *                                                               *
      *****************************************************************
     FCLOANLB   IF   E           K DISK    PREFIX(W)
     FUTLE0522L1UF   E           K DISK    INFDS(INFDS1)
     F                                     INFSR(*PSSR)
     FUTLE0522L2UF A E           K DISK    PREFIX(HN)
     F                                     INFSR(*PSSR)
     FHISTSZX   UF   E           K DISK    INFSR(*PSSR)
     FHISTR     IF   E           K DISK    PREFIX(HQ)
     F                                     INFSR(*PSSR)
     F                                     RENAME(HISTSHMF:HISTSM2F)
     F                                     IGNORE(HISTSHPF)
      *
     FUTLE0522P3O    E             PRINTER
     FUTLE0522P2O    E             PRINTER
     FUTLE0522P1O    E             PRINTER
      *****************************************************************
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  11 - Update mode indicator                                   *
      *  31 - BackValue Int Header                                    *
      *  32 - Duplicate Int Header                                    *
      *  33 - Missing Inter Header                                    *
      *  70 - 0 decimal places                                        *
      *  71 - 1 decimal places                                        *
      *  72 - 2 decimal places                                        *
      *  73 - 3 decimal places                                        *
      *  88 - Chain to CLOANCL                                        *
      *  89 - Chain to UTLE0522L2                                     *
      *  90 - Chain to UTLE0522L1                                     *
      *  LR - End/Return                                              *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Intialisation                               *
      *  SRPROC - Detail Processing for file HISTSHM                  *
      *  SRHIST - Check  Principal and Interest on history            *
      *  SRINTH - Detail Processing for file IH Header                *
      *  SRPRIH - Print Details of Interest Header                    *
      *  SRDEC  - Determine number of decimal places                  *
      *  SRDIFF - Report loans with different principal amount        *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Loan Data Access structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Branch Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Second bank details and rundate
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  RUND         E                     EXTFLD(BJRDNB)
      *
      ** External DS For Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Current Principal Amount
      *
     D                 DS
     D  LCPAM0                 1     13  0
     D  LCPAM1                 1     13  1
     D  LCPAM2                 1     13  2
     D  LCPAM3                 1     13  3
     D                 DS
     D  HCPAM0                 1     13  0
     D  HCPAM1                 1     13  1
     D  HCPAM2                 1     13  2
     D  HCPAM3                 1     13  3
     D                 DS
     D  HIPRM0                 1     13  0
     D  HIPRM1                 1     13  1
     D  HIPRM2                 1     13  2
     D  HIPRM3                 1     13  3
      *
     D                 DS
     D  XRATE                  1     11  7
     D  ZRTSP                  1     11  0
      *
      ** DS File Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File information data structure
      *
     D INFDS1          DS
     D  RECF             *RECORD
      *
      ** Program Status Data Structure For User ID
      *
     D PSDS           SDS
     D  USER                 254    263
      *
      ** Rename fields
      *
     IHISTSHMF
     I              RECI                        HMRECI
     I              BRCA                        HMBRCA
     I              CNUM                        HMCNUM
     I              FCUS                        HMFCUS
     I              FTYP                        HMFTYP
     I              FSEQ                        HMFSEQ
     I              RTSP                        HMRTSP
     I              LTYP                        HMLTYP
     I              SUTP                        HMSUTP
     I              PTYP                        HMPTYP
     I              CCY                         HMCCY
     I              FCLB                        HMFCLB
     I              SPIN                        HMSPIN
      *
     IHISTSZXF
     I              RECI                        HZRECI
     I              NORE                        HZNORE
     I              ZZ096                       HZZ096
      *
      /EJECT
      *===============================================================*
      *  P R O G R A M   S T A R T                                    *
      *===============================================================*
      *
      ** Perform Initialisation
      *
     C                   EXSR      INIT
      *
      ** Start Processing
      *
     C     *INU7         IFEQ      '0'
     C     *INU8         ANDEQ     '0'
     C                   EXSR      SRPROC
     C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROC- Subroutine to check and update LE Master File         *
      * Called By: Main Processing                                    *
      *****************************************************************
     C     SRPROC        BEGSR
      *
      ** Read records on loan file.
      *
     C     *LOVAL        SETLL     CLOANLB
     C                   READ      CLOANLB                                88
      *
     C     *IN88         DOUEQ     '1'
      *
     C     WRECI         IFEQ      'D'
     C     WVDAT         ANDLT     RUND
     C     WORED         ANDLT     RUND
      *
      ** Check if loan has history records.
      *
     C     WLNRF         SETLL     UTLE0522L1
     C     WLNRF         READE     UTLE0522L1                             90
      *
      ** Get details in Interest Header File
      *
     C     *IN90         IFEQ      '0'
     C                   EXSR      SRINTH
      *
      ** If theres a duplicate or missing IH (CTR > 0), then
      ** report this for processing.
      *
     C     CTR           IFGT      0
      *
      ** Print loans in error
      *
     C                   EXSR      SRDIFF
      *
      ** Set record to start of Loan (ST) for update of HISTSHM
      *
     C     WLNRF         SETLL     UTLE0522L1
     C     WLNRF         READE     UTLE0522L1                             91
      *
     C     HMRTSP        IFGT      0
     C                   MOVE      '0'           *IN17
     C                   ELSE
     C                   MOVE      '1'           *IN17
     C                   ENDIF
      *
     C     *IN11         IFEQ      '1'
      *
     C     *IN91         IFEQ      '0'
     C
     C     HMRTSP        IFGT      0
     C                   Z-ADD     0             CPAM             13 0
     C                   Z-ADD     0             INTR             11 7
     C                   UPDATE    HISTSHMF
     C                   ENDIF
      *
      ** Create Spread Change
      *
     C                   EXSR      SRSPRD
     C                   MOVE      '0'           *IN17
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Just Create Spread Change for Audit Mode
      *
     C     WRECI         IFEQ      'D'
     C     *IN91         ANDEQ     '0'
     C                   EXSR      SRSPRD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      CLOANLB                                88
     C                   ENDDO
      *
      ** Update Trailer file for history
      *
     C     *IN11         IFEQ      '1'
     C                   READ      HISTSZX                                18
     C     HZNORE        ADD       TOTALA        HZNORE
     C     HZNORE        SUB       TOTALD        HZNORE
     C                   UPDATE    HISTSZXF                             18
     C                   ENDIF
      *
     C     LONCTR        IFGT      0
     C                   WRITE     TRAILER1
     C                   ELSE
     C                   WRITE     NODTLS1
     C                   ENDIF
      *
     C     TOTALD        IFGT      0
     C     TOTALA        ORGT      0
     C                   WRITE     TRAILER2
     C                   ELSE
     C                   WRITE     NODTLS2
     C                   ENDIF
      *
     C                   WRITE     ENDOF2
     C                   WRITE     ENDOF3
      *
     C                   ENDSR
      *****************************************************************
      *   SRINTH- Subroutine to check on Interest Header file         *
      *   Called By: SRPROC                                           *
      *   Calls: AOCURRR0, SRPRIH                                     *
      *****************************************************************
     C     SRINTH        BEGSR
      *
      ** Check first for BV Interest Header
      *
     C                   EVAL      CTR=0
     C                   MOVEA     '000'         *IN(31)
     C     *LOVAL        SETLL     UTLE0522L2
     C     WLNRF         CHAIN     UTLE0522L2                         89
      *
     C     *IN89         DOWEQ     '0'
     C     HNAMTP        ANDEQ     'BH'
     C                   MOVE      '1'           *IN31
     C                   ADD       1             TOTALD
     C                   MOVE      HNCCY         WRKCCY
     C                   EXSR      SRDEC
     C                   EXSR      SRPRIH
     C                   MOVEA     '000'         *IN(31)
     C     *IN11         IFEQ      '1'
     C                   DELETE    HISTSHNF
     C                   ENDIF
     C                   EVAL      CTR=CTR+1
     C     WLNRF         READE     UTLE0522L2                             89
     C                   ENDDO
      *
      ** Process normal Interest Header
      *
     C     *IN89         IFEQ      '0'
      *
      ** Check and print duplicate IH records,
      ** Delete it on update mode
      *
     C     WLNRF         READE     UTLE0522L2                             89
     C     *IN89         DOWEQ     '0'
     C                   MOVEA     '000'         *IN(31)
     C     HNAMTP        IFEQ      'IH'
     C                   MOVE      '1'           *IN32
     C                   ELSE
     C                   MOVE      '1'           *IN31
     C                   ENDIF
     C                   MOVE      HNCCY         WRKCCY
     C                   EXSR      SRDEC
     C                   EXSR      SRPRIH
     C                   ADD       1             TOTALD
     C                   EVAL      CTR=CTR+1
      *
      ** If Update mode, delete duplicate IH/BH record
      *
     C     *IN11         IFEQ      '1'
     C                   DELETE    HISTSHNF
     C                   ENDIF
      *
     C     WLNRF         READE     UTLE0522L2                             89
     C                   ENDDO
      *
     C     *LOVAL        SETLL     UTLE0522L2
     C     WLNRF         CHAIN     UTLE0522L2                         89
      *
     C                   ELSE
      *
      ** If IH not exist, print then create on update mode
      *
     C     WVDAT         IFLT      RUND
     C     WORED         ANDLT     RUND
      *
      ** Get Last Principal and Interest from History file.
      *
     C                   EXSR      SRHIST
     C                   MOVE      '1'           *IN33
      *
     C                   CLEAR                   HISTSHNF
     C                   MOVEL     WRECI         HNRECI
     C                   MOVEL     'H'           HNRCDT
     C                   MOVEL     WBRCA         HNBRCA
     C                   MOVE      WCNUM         HNCNUM
     C                   MOVE      WLNRF         HNLNRF
     C                   MOVEL     'IH'          HNAMTP
     C                   Z-ADD     48            HNPRSQ
     C                   Z-ADD     000           HNLASN
     C                   MOVE      WFCUS         HNFCUS
     C                   Z-ADD     WFTYP         HNFTYP
     C                   Z-ADD     WFSEQ         HNFSEQ
     C                   Z-ADD     WPTYP         HNPTYP
     C                   MOVEL     CCY           HNCCY
     C                   Z-ADD     WKBRTE        HNBRTE
     C                   Z-ADD     WKRTSP        HNRTSP
     C                   Z-ADD     WKCALC        HNCALC
     C                   MOVEL     WKSPIN        HNSPIN
     C**********         Z-ADD     WKBRTT        HNBRTT                                       CSD103
     C                   MOVE      WKBRTT        HNBRTT                                       CSD103
     C                   Z-ADD     0             HNSTPG
     C                   Z-ADD     0             HNPPIS
     C                   Z-ADD     0             HNIPIS
     C                   Z-ADD     0             HNIPPS
     C                   Z-ADD     FSRP          HNFSRP
     C                   MOVEL     FSGN          HNFSGN
     C                   Z-ADD     ACDA          HNCOFA
     C                   MOVEL     FPRC          HNFPRC
     C                   MOVE      *BLANKS       HNZZ001
     C                   Z-ADD     0             HNINTN
     C                   Z-ADD     0             HNFSPRAM
     C                   Z-ADD     0             HNOCDT
     C                   Z-ADD     0             HNEAIR
     C                   Z-ADD     0             HNCNSP
     C                   MOVE      *BLANKS       HNCNSG
     C                   MOVE      *BLANKS       HNRDMT
     C                   MOVE      *BLANKS       HNRDFD
     C                   Z-ADD     WKVDAT        HNVDAT
     C                   Z-ADD     WKCPAM        HNPRAM
     C     WKAITC        ADD       WKAIAP        HNINTA
      *
      ** Print Missing IH
      *
     C                   MOVE      HNCCY         WRKCCY
     C                   EXSR      SRDEC
     C                   EXSR      SRPRIH
     C                   ADD       1             TOTALA
      *
     C     *IN11         IFEQ      '1'
     C                   WRITE     HISTSHNF
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CTR=CTR+1
      *
     C                   ENDIF
      *
      ** Update Interest Header Record
      *
     C     CTR           IFGT      0
     C                   ADD       1             LONUPD
      *
      ** Get Last Principal and Interest from History file.
      *
     C     *IN33         IFEQ      '0'
     C                   EXSR      SRHIST
     C                   ENDIF
      *
     C     *IN11         IFEQ      '1'
     C     *IN90         ANDEQ     '0'
     C     *LOVAL        SETLL     UTLE0522L2
     C     WLNRF         CHAIN     UTLE0522L2                         89
      *
     C     *IN89         IFEQ      '0'
     C     WRECI         IFNE      HNRECI
     C                   MOVE      WRECI         HNRECI
     C                   ENDIF
      *
     C                   MOVE      WFCUS         HNFCUS
     C                   Z-ADD     WFTYP         HNFTYP
     C                   Z-ADD     WFSEQ         HNFSEQ
     C                   Z-ADD     WPTYP         HNPTYP
     C                   MOVEL     CCY           HNCCY
     C                   Z-ADD     WKBRTE        HNBRTE
     C                   Z-ADD     WKRTSP        HNRTSP
     C                   Z-ADD     WKCALC        HNCALC
     C                   MOVEL     WKSPIN        HNSPIN
     C**********         Z-ADD     WKBRTT        HNBRTT                                       CSD103
     C                   MOVE      WKBRTT        HNBRTT                                       CSD103
      *
     C                   Z-ADD     WKCPAM        HNPRAM
     C     WKAITC        ADD       WKAIAP        HNINTA
     C                   Z-ADD     WKVDAT        HNVDAT
     C                   UPDATE    HISTSHNF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEA     '000'         *IN(31)
      *
     C                   ENDSR
      *****************************************************************
      * SRPRIH- Subroutine to print detail of Interest Header file    *
      * Called By: SRINTH                                             *
      * Calls: ZSEDIT                                                 *
      *****************************************************************
     C     SRPRIH        BEGSR
      *
      ** Format PRAM from IH record
      *
     C                   MOVE      *BLANKS       PRAMOL
     C                   Z-ADD     HNPRAM        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRAMOL
      *
      ** Format INTA from IH record
      *
     C                   MOVE      *BLANKS       INTAH
     C                   Z-ADD     HNINTA        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        INTAH
      *
      ** Format VDAT from Midas day number to DDMMMYY
      *
     C                   Z-ADD     HNVDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        EDATE
      *
      ** Print next page
      *
     C     OVNUM         IFGE      45
     C                   WRITE     HEADER2
     C                   Z-ADD     0             OVNUM
     C                   ENDIF
      *
      ** Print Detail
      *
     C                   WRITE     DETAIL2
     C                   ADD       1             OVNUM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   SRDEC - Subroutine to determine number of decimal places.   *
      *   Called By: UPROC,SRINTH                                     *
      *   Calls: AOCURRR0                                             *
      *****************************************************************
     C     SRDEC         BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WRKCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'UTLE0522'    DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     CCY           DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEA     '0000'        *IN(70)
     C     A6NBDP        IFEQ      0
     C                   MOVE      '1'           *IN70
     C                   ENDIF
     C     A6NBDP        IFEQ      1
     C                   MOVE      '1'           *IN71
     C                   ENDIF
     C     A6NBDP        IFEQ      2
     C                   MOVE      '1'           *IN72
     C                   ENDIF
     C     A6NBDP        IFEQ      3
     C                   MOVE      '1'           *IN73
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDIFF - Subroutine to report loans with different values     *
      *          in CPAM and INTR.                                    *
      * Called : SRPROC                                               *
      * Calls  : NONE                                                 *
      *****************************************************************
     C     SRDIFF        BEGSR
      *
      ** Get number of decimal places for output of amounts
      *
     C                   MOVE      CCY           WRKCCY
     C                   EXSR      SRDEC
      *
     C     *IN70         IFEQ      '1'
     C                   MOVE      WCPAM         LCPAM0
     C                   MOVE      CPAM          HCPAM0
     C                   MOVE      HNPRAM        HIPRM0
     C                   ELSE
     C     *IN71         IFEQ      '1'
     C                   MOVE      WCPAM         LCPAM1
     C                   MOVE      CPAM          HCPAM1
     C                   MOVE      HNPRAM        HIPRM1
     C                   ELSE
     C     *IN72         IFEQ      '1'
     C                   MOVE      WCPAM         LCPAM2
     C                   MOVE      CPAM          HCPAM2
     C                   MOVE      HNPRAM        HIPRM2
     C                   ELSE
     C     *IN73         IFEQ      '1'
     C                   MOVE      WCPAM         LCPAM3
     C                   MOVE      CPAM          HCPAM3
     C                   MOVE      HNPRAM        HIPRM3
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     LINE1         IFGE      50
     C                   ADD       1             PAGE1
     C                   Z-ADD     12            LINE1
     C                   WRITE     HEADER1
     C                   ENDIF
      *
      ** Write the detail in printer file
      *
     C                   WRITE     DETAIL1
     C                   ADD       2             LINE1
     C                   ADD       1             LONCTR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRHIST - Subroutine to Check CPAM of HISTR records            *
      * Called by: SRPROC                                             *
      * Calls: None.                                                  *
      *****************************************************************
     C     SRHIST        BEGSR
      *
      ** Get Last CPAM amount on HISTSHP file
      *
     C                   Z-ADD     0             WKCPAM           13 0
     C                   Z-ADD     0             WKAITC           13 0
     C                   Z-ADD     0             WKINTA           13 0
     C                   Z-ADD     0             WKVDAT            5 0
     C                   Z-ADD     0             WKAIAP           13 0
     C                   Z-ADD     0             WKCALC            1 0
     C**********         Z-ADD     0             WKBRTT            2 0                        CSD103
     C                   MOVE      *BLANKS       WKBRTT            2                          CSD103
     C                   Z-ADD     0             WKBRTE           11 7
     C                   Z-ADD     0             WKRTSP           11 7
     C                   MOVE      *BLANKS       WKSPIN            1
      *
     C     WLNRF         SETLL     UTLE0522L1
     C     WLNRF         READE     UTLE0522L1                             90
      *
     C     *IN90         DOWEQ     '0'
      *
     C     AMTP          IFEQ      'ST'
     C                   Z-ADD     CPAM          WKCPAM
     C                   Z-ADD     AITC          WKAITC
     C                   Z-ADD     VDAT          WKVDAT
     C                   MOVE      HMCCY         CCY
     C                   ENDIF
      *
     C     AMTP          IFEQ      'IN'
     C                   Z-ADD     CPAM          WKCPAM
     C                   Z-ADD     AITC          WKAITC
     C                   Z-ADD     INTA          WKINTA
     C                   Z-ADD     VDAT          WKVDAT
     C                   Z-ADD     AIAP          WKAIAP
     C                   ENDIF
      *
     C     AMTP          IFEQ      'RE'
     C     AMTP          OREQ      'MR'
     C     AMTP          OREQ      'MA'
     C     INTA          IFNE      0
     C     WKINTA        ORNE      0
     C     VDAT          ANDEQ     WKVDAT
     C                   Z-ADD     CPAM          WKCPAM
     C                   Z-ADD     AITC          WKAITC
     C                   Z-ADD     VDAT          WKVDAT
     C     INTA          IFNE      0
     C                   Z-ADD     INTA          WKINTA
     C                   ENDIF
     C                   Z-ADD     AIAP          WKAIAP
     C                   ENDIF
     C                   ENDIF
     C
     C     WLNRF         READE     UTLE0522L1                             90
     C                   ENDDO
      *
     C     KEYHIS        SETLL     HISTR
     C     KEYHIS        READE     HISTR                                  41
      *
     C     *IN41         DOWEQ     '0'
     C     HQVDAT        ANDLE     WKVDAT
     C     HQAMTP        IFEQ      'RO'
     C     HQAMTP        OREQ      'MC'
     C     HQAMTP        OREQ      'ST'
     C                   Z-ADD     HQCALC        WKCALC
     C**********         Z-ADD     HQBRTT        WKBRTT                                       CSD103
     C                   MOVE      HQBRTT        WKBRTT                                       CSD103
     C                   Z-ADD     HQBRTE        WKBRTE
     C                   Z-ADD     HQRTSP        WKRTSP
     C                   MOVE      HQSPIN        WKSPIN
     C                   ENDIF
     C     HQAMTP        IFEQ      'BC'
     C**********         Z-ADD     HQBRTT        WKBRTT                                       CSD103
     C                   MOVE      HQBRTT        WKBRTT                                       CSD103
     C                   Z-ADD     HQBRTE        WKBRTE
     C                   ENDIF
     C     HQAMTP        IFEQ      'BR'
     C**********         Z-ADD     HQBRTT        WKBRTT                                       CSD103
     C                   MOVE      HQBRTT        WKBRTT                                       CSD103
     C                   Z-ADD     HQBRTE        WKBRTE
     C                   ENDIF
     C     HQAMTP        IFEQ      'SC'
     C                   Z-ADD     HQRTSP        WKRTSP
     C                   ENDIF
      *
     C     KEYHIS        READE     HISTR                                  41
     C                   ENDDO
      *
     C     WLNRF         SETGT     UTLE0522L1
     C     WLNRF         READPE    UTLE0522L1                             90
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSPRD - Subroutine to insert spread change against loan     *
      *  Called : SRPROC                                              *
      *  Calls  : None                                                *
      *****************************************************************
     C     SRSPRD        BEGSR
      *
     C                   Z-ADD     HMRTSP        WRRTSP           11 7
     C     KEYHI2        SETLL     HISTR
     C     KEYHI2        READE     HISTR                                  40
      *
     C     *IN40         DOWEQ     '0'
     C     HQRTSP        IFNE      0
     C                   Z-ADD     HQRTSP        WRRTSP
     C                   ENDIF
     C     KEYHI2        READE     HISTR                                  40
     C                   ENDDO
      *
      *--------------------
      ** Write to report
      *--------------------
      *
     C                   MOVEL     HMBRCA        VBRCA
     C                   MOVEL     HMCNUM        VCNUM
     C                   MOVEL     LNRF          VLNRF
     C                   MOVEL     'SC'          VACTN
     C                   Z-ADD     WRRTSP        XRATE
      *
     C                   MOVE      *BLANKS       VDATE
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        VDATE
      *
     C                   MOVE      *BLANKS       VRATE
     C                   Z-ADD     7             ZDECS
     C                   Z-ADD     ZRTSP         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        VRATE
      *
     C     LINE3         IFGT      43
     C                   ADD       1             PAGE3
     C                   WRITE     HEADER3
     C                   Z-ADD     1             LINE3
     C                   ENDIF
      *
     C     *IN17         IFEQ      '1'
     C                   MOVEL     *BLANKS       VACTN
     C                   MOVEL     *BLANKS       VRATE
     C                   ENDIF
     C                   WRITE     DETAIL3
     C                   ADD       1             LINE3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Convert date to DDMMMYY format                       *
      * Called : SRPROC                                               *
      * Calls  : ZDATE2 program                                       *
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
     ******************************************************************
      /EJECT
      *****************************************************************
      * ZSEDIT - Convert amount with specif decimal number            *
      * Called : SRPROC                                               *
      * Calls  : ZFRED program                                        *
      *****************************************************************
     C     ZSEDIT        BEGSR
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  INIT - Initialisation subroutine                             *
      *  Called by:  Main Processing                                  *
      *  Calls: AOBANKR0, *PSSR                                       *
      *****************************************************************
     C     INIT          BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
     C                   MOVE      '0'           *IN11
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Check program mode
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVEL     'Update M'    MODNAM
     C                   MOVE      'ode'         MODNAM
     C                   MOVE      '1'           *IN11
     C                   ELSE
     C                   MOVEL     'Audit Mo'    MODNAM
     C                   MOVE      'de '         MODNAM
     C                   ENDIF
      *
      ** Call Access Program for Bank Details - Title, Rundate and
      ** Run Day number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    WRTCD             7
     C                   PARM      '*FIRST  '    WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     WOPTN         DBKEY
     C                   MOVEL     'UTLE0522'    DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ELSE
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *
     C     KEYHIS        KLIST
     C                   KFLD                    HMBRCA
     C                   KFLD                    HMCNUM
     C                   KFLD                    LNRF
      *
     C     KEYHI2        KLIST
     C                   KFLD                    HMBRCA
     C                   KFLD                    HMCNUM
     C                   KFLD                    LNRF
     C                   KFLD                    VDAT
      *
     C                   Z-ADD     0             OVNUM             2 0
     C                   Z-ADD     1             PAGE1             4 0
     C                   Z-ADD     1             PAGE3
     C                   Z-ADD     12            LINE1             2 0
     C                   Z-ADD     0             LINE3             2 0
     C                   Z-ADD     0             CTR               5 0
     C                   WRITE     HEADER1
     C                   WRITE     HEADER2
     C                   WRITE     HEADER3
     C                   MOVE      *BLANK        WRKCCY            3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      * Called by: INIT                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2016
