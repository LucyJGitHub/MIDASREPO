     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL APR Trigger Program for DEALSDC')             *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6005- Trigger program for DEALSDC                          *
      *                                                               *
      *  Function:  This program applies an insert and amend trigger  *
      *             to PF/DEALSDC.                                    *
      *                                                               *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd. 2016  *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      *  SRINIT - Initial Processing.                                 *
      *  #IMAIN - Main Processing                                     *
      *                                                               *
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*   LR  - Last Record Indicator                                 *
     F*                                                               *
     F*****************************************************************
      *
     D ARR@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D QPARM1          DS          8000
      ** Physical file name/library/member
      *
     D  QFNAME                 1     10
     D  QLNAME                11     20
     D  QMNAME                21     30
      ** Trigger Event ('1'=Insert, '2'=Update)
     D  QEVENT                31     31
      ** Trigger Time ('1'=After, '2'=Before)
     D  QTTIME                32     32
      ** Commit Lock Level ('0'=*NONE, '1'=*CHG, '2'=*CS, '3'=*ALL)
     D  QCOMIT                33     33
      ** CCSID
     D  QCCSID                37     40B 0
      ** Offset to original record
     D  Q1ROFF                49     52B 0
      ** Length of the original record
     D  Q1RLEN                53     56B 0
      ** Offset to original record null byte map
     D  Q1NOFF                57     60B 0
      ** Length of the original null byte map
     D  Q1NLEN                61     64B 0
      ** Offset to new record
     D  Q2ROFF                65     68B 0
      ** Length of new record
     D  Q2RLEN                69     72B 0
      ** Offset to the new record null byte map
     D  Q2NOFF                73     76B 0
      ** Length of null byte map
     D  Q2NLEN                77     80B 0
      *
     D QPARM2          DS
     D  QLENG                  1      4B 0
     D QFILEB          DS          4000
     D  MDATB                 30     32P 0
     D  INTCB                 56     56
     D  NOTDB                 83     85  0
     D  ICBSB                212    212  0
     D  IPFRB                213    213
     D  NIDTB                221    223P 0
     D  AIANB                250    256P 0
     D  INTFB                345    346  0
      ** "Before image of file"
     D QFILEA          DS          4000
      ** "After image of file"
     D  DLNO                   2      7  0
     D  MDATA                 30     32P 0
     D  INTCA                 56     56
     D  NOTDA                 83     85  0
     D  ICBSA                212    212  0
     D  IPFRA                213    213
     D  NIDTA                221    223P 0
     D  AIANA                250    256P 0
     D  INTFA                345    346  0
      *
     D PSDS           SDS
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MAIN     - Control Processing.                     *
      *                                                               *
      * CALLS      SRINIT   - Initial processing.                     *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
     C*
     C**  Initial processing
     C                   EXSR      SRINIT
      *
      ** If a record is added to DEALSDC, call DLC6004
      *
     C                   MOVE      DLNO          DLNOA             6
     C     QEVENT        IFEQ      '1'
     C                   CALL      'DLC6004'                            89
     C                   PARM                    PUIRCD            7
     C                   PARM      DLNOA         PDLNO             6
     C                   ENDIF
      *
      *
      ** If a record is updated in DEALSDC, check to see what fields
      ** have been changed and call DLC6004 if necessary
      *
     C     QEVENT        IFEQ      '3'
     C     MDATA         IFNE      MDATB
     C     INTCA         ORNE      INTCB
     C     NOTDA         ORNE      NOTDA
     C     ICBSA         ORNE      ICBSB
     C     IPFRA         ORNE      IPFRB
     C     NIDTA         ORNE      NIDTB
     C     INTFA         ORNE      INTFB
     C     AIANA         ORNE      AIANB
      * interest capitalise indicator
     C                   CALL      'DLC6004'                            89
     C                   PARM                    PUIRCD
     C                   PARM      DLNOA         PDLNO
     C                   ENDIF
     C                   ENDIF
      *
      *
     C     PUIRCD        IFNE      *BLANKS
     C     *IN89         OREQ      *ON
     C                   Z-ADD     1             DBASE                          ** DB ERR 01 **
     C                   MOVEL     'DEALSDC'     DBFILE                         ***************
     C                   MOVEL     ##PGM         DBPGM
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   SETON                                        U7U8LR
     C                   ENDIF
      *
      *
      **   Exit from program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *            SRINIT - Initial Processing                        *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  MAIN   - Control Process                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR                                                  ** SRINIT **
      *
      ** Trigger Program parameters
     C     *ENTRY        PLIST
     C                   PARM                    QPARM1
     C                   PARM                    QPARM2
      *
      ** Set up copyright parameter
     C                   MOVEA     ARR@          CPY2@            80
      *
      ** Using offsets and lengths provided get the before and after
      ** images
     C     Q1ROFF        ADD       1             Q                 5 0
     C     Q1RLEN        SUBST     QPARM1:Q      QFILEB
     C     Q2ROFF        ADD       1             Q
     C     Q2RLEN        SUBST     QPARM1:Q      QFILEA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** ARR@
(C) Copyright Misys International Banking Systems Ltd. 2016
