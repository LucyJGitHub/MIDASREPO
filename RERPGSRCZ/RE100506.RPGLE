     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Sweeps Requested Report')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100506  - Cash Management Sweeps Requested Report          *
      *                                                               *
      *  Function: This module lists records on the cash management   *
      *            sweeps requested file.                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMSRL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL4  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRE100506P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100506P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
 
      * Read the cash management sweeps requested
 
 
     C                   READ      RECMSRD0                               60
 
      * Read until EOF
 
     C     *IN60         DOWEQ     '0'
 
      * Print sweeps requested
 
     C                   EXSR      PRT_SWPRQS
 
     C                   READ      RECMSRD0                               60
     C                   ENDDO
 
      *  Produce end of report
 
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100506P1
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * Print sweeps requested
      ********************************************************************
     C     PRT_SWPRQS    BEGSR
 
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
 
      * Account details
 
     C     SRLINK        IFNE      *ZERO                                        *
 
     C     RECMHLK       CHAIN     RECMHLD0                           99
 
     C                   Z-ADD     *ZERO         C_ACNO
     C                   Z-ADD     *ZERO         P_ACNO
     C     *IN99         IFEQ      '0'
     C     CACCNTK       CHAIN     ACCNTABF                           99
     C  N99              MOVE      *ON           *IN30
     C  N99              Z-ADD     ACNO          C_ACNO           10 03535
     C     PACCNTK       CHAIN     ACCNTABF                           99
     C  N99              MOVE      *ON           *IN31
     C  N99              Z-ADD     ACNO          P_ACNO           10 03636
     C                   ENDIF
     C                   ENDIF
 
      * Time
 
     C     SRTIME        COMP      *ZERO                              4040      *
 
     C                   Z-ADD     2             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SWPRQS
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Register P1 printer file with RCF
      ********************************************************************
     C     RCFP1         BEGSR
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100506P1
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Key lists
 
     C     RECMHLK       KLIST
     C                   KFLD                    SRHIER
     C                   KFLD                    SRLINK
 
     C     CACCNTK       KLIST
     C                   KFLD                    CLCCUS
     C                   KFLD                    CLCCCY
     C                   KFLD                    CLCACD
     C                   KFLD                    CLCASN
     C                   KFLD                    CLCBRC
     C     PACCNTK       KLIST
     C                   KFLD                    CLPCUS
     C                   KFLD                    CLPCCY
     C                   KFLD                    CLPACD
     C                   KFLD                    CLPASN
     C                   KFLD                    CLPBRC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
