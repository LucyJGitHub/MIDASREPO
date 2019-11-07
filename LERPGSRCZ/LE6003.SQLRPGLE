     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR Trigger Program for CLOANCL')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE6003 - Midas LE APR Trigger Program for CLOANCL            *
      *                                                               *
      *  Function:  This program applies an insert and amend trigger  *
      *             to PF/CLOANCL.                                    *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *  Prev Amend No. nnnnnn             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing.                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   LR - Last Record Indicator                                  *
      *                                                               *
      *****************************************************************
      *
      *  Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *
      * Physical file name/library/member
     D PPARM1          DS          5000
     D  QFNAME                 1     10
     D  QLNAME                11     20
     D  QMNAME                21     30
      * Trigger Event ('1'=Insert, '3'=Update)
     D  QEVENT                31     31
      * Trigger Time ('1'=After, '2'=Before)
     D  QTTIME                32     32
      * Commit Lock Level ('0'=*NONE, '1'=*CHG, '2'=*CS, '3'=*ALL)
     D  QCOMIT                33     33
      * CCSID
     D  QCCSID                37     40B 0
      * Offset to original record
     D  Q1ROFF                49     52B 0
      * Length of the original record
     D  Q1RLEN                53     56B 0
      * Offset to original record null byte map
     D  Q1NOFF                57     60B 0
      * Length of the original null byte map
     D  Q1NLEN                61     64B 0
      * Offset to new record
     D  Q2ROFF                65     68B 0
      * Length of new record
     D  Q2RLEN                69     72B 0
      * Offset to the new record null byte map
     D  Q2NOFF                73     76B 0
      * Length of null byte map
     D  Q2NLEN                77     80B 0
      *
     D PPARM2          DS
     D  QLENG                  1      4B 0
     D QFILEB          DS          2500
     D  MDATB                 31     33P 0
     D  CPAMB                 50     56P 0
     D  RAMTB                 92     98P 0
     D  NRPDB                 99    101P 0
     D  RFRQB                102    102
     D  RDYNB                103    104
     D  NBRAB                207    208
     D  NRTSB                209    214P 7
     D  NSINB                215    215
     D  NCASB                216    216
     D  IPFRB                298    298
     D  NIDTB                306    308P 0
     D  AIMNB                370    376P 0
     D  IFDYB                384    385
     D  NIPDB                452    454P 0
     D  NMDTB                455    457P 0
     D  NFRSB               1160   1165P 0
      * "Before image of file"
     D QFILEA          DS          2500
      * "After image of file"
     D  LNRFA                  2      7
     D  MDATA                 31     33P 0
     D  CPAMA                 50     56P 0
     D  RAMTA                 92     98P 0
     D  NRPDA                 99    101P 0
     D  RFRQA                102    102
     D  RDYNA                103    104
     D  NBRAA                207    208
     D  NRTSA                209    214P 7
     D  NSINA                215    215
     D  NCASA                216    216
     D  IPFRA                298    298
     D  NIDTA                306    308P 0
     D  AIMNA                370    376P 0
     D  IFDYA                384    385
     D  NIPDA                452    454P 0
     D  NMDTA                455    457P 0
     D  NFRSA               1160   1165P 0
     D PSDS           SDS
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
      * Program Status Data Structure - gives Job/Workstation name and
      * User ID
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *                                     134 141 DBFILE
      *       Defines:                      142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            M A I N   P R O C E S S I N G                      *
      *                                                               *
      * Calls: SRINIT - Initial processing                            *
      *                                                               *
      *****************************************************************
      *
      * Initial processing
     C                   EXSR      SRINIT
      *
      * If a record is added to CLOANCL, call LEC6002
     C     QEVENT        IFEQ      '1'
     C                   CALL      'LEC6002'                            89
     C                   PARM                    PRCOD             7
     C                   PARM                    LNRFA
     C                   ENDIF
      *
      * If a record is updated in CLOANCL, check to see what fields
      * have been changed and call LEC6002 if necessary
     C     QEVENT        IFEQ      '3'
     C     MDATB         IFNE      MDATA
     C     NIDTB         ORNE      NIDTA
     C     IPFRB         ORNE      IPFRA
     C     IFDYB         ORNE      IFDYA
     C     CPAMB         ORNE      CPAMA
     C     NRPDB         ORNE      NRPDA
     C     RFRQB         ORNE      RFRQA
     C     RDYNB         ORNE      RDYNA
     C     NBRAB         ORNE      NBRAA
     C     NFRSB         ORNE      NFRSA
     C     NSINB         ORNE      NSINA
     C     NCASB         ORNE      NCASA
     C     NIPDB         ORNE      NIPDA
     C     NMDTB         ORNE      NMDTA
     C     AIMNB         ORNE      AIMNA
     C     RAMTB         ORNE      RAMTA
     C     NRTSB         ORNE      NRTSA
      *
     C                   CALL      'LEC6002'                            89
     C                   PARM                    PRCOD
     C                   PARM                    LNRFA
     C                   ENDIF
     C                   ENDIF
      *
     C     PRCOD         IFNE      *BLANKS
     C     *IN89         OREQ      *ON
     C                   Z-ADD     1             DBASE                          ** DB ERR 01 **
     C                   MOVEL     '*CALL  '     DBFILE                         ***************
     C                   MOVEL     ##PGM         DBPGM
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   SETON                                        U7U8LR
     C                   ENDIF
      *
      * Exit from program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      * SRINIT - Initial Processing                                   *
      * Calls:                                                        *
      * Called by: Main Processing                                    *
      *****************************************************************
      *
     C     SRINIT        BEGSR                                                  ** SRINIT **
      *
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    PPARM1
     C                   PARM                    PPARM2
      *
      * Set up copyright parameter
     C                   MOVEA     ARRCPY        WCPY             80
      *
      * Using offsets and lengths provided get the before and after
      * images
     C     Q1ROFF        ADD       1             Q                 5 0
     C     Q1RLEN        SUBST     PPARM1:Q      QFILEB
     C     Q2ROFF        ADD       1             Q
     C     Q2RLEN        SUBST     PPARM1:Q      QFILEA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** ARRCPY
(c) Finastra International Limited 2016
