     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMODE                                                  *
/*EXI *  TEXT('Midas SD Write GPGLCUSL - Trigger on SDCUSTPD')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000846 - Midas SD Write GPGLCUSL - Trigger on SDCUSTPD     *
      *                                                               *
      *  Function:  This program applies an insert Trigger to         *
      *              PF/SDCUSTPD                                      *
      *             For each record written to SDCUSTPD               *
      *             Write Record to PF/GPGLCUSL                       *
      *                                                               *
      *                                                               *
      *  (C) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056731  *CREATE    Date 28Sep20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056731 - 24x7 APIs - AMAD entry fails when account cust.   *
      *               also input from 24x7 API                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      *  SRINIT - Initial Processing.                                 *
      *  #IMAIN - Main Processing                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   LR  - Last Record Indicator                                 *
      *                                                               *
      *****************************************************************
      *
     FGPGLCUSLL2UF A E           K DISK
     FSDCUSTL1  IF   E           K DISK
     FSDBRCHL0  IF   E           K DISK
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
      ** "After image of file"
     D QFILEA        E DS                  EXTNAME(SDCUSTPD)
      *
     D KUGCUS          DS            10
     D  KUGCUS1                1      3
     D  KUGCUS2                4      4
     D  KUGCUS3                5     10
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
      *
     C                   MOVE      *BLANK        Zone_ID          10
      *
      ** If a record is added to SDCUSTPD
      ** Write a record to GPGLCUSL
      *
      ** Access GPGLCUSLL2
      *
     C                   MOVEL     BBBRCD        KUGCUS1
     C                   MOVEL     '-'           KUGCUS2
     C                   MOVE      BBCUST        KUGCUS3
      *
     C     KUGCUS        CHAIN     GPGLCUSLL2                         71
     C                   IF        *IN71 = *on
      *
      * Access Branch
     C     BBBRCD        CHAIN     SDBRCHL0                           97
      * Get zone
     C     *IN97         IFEQ      *OFF
     C                   MOVE      A8ZONE        Zone_ID          10
     C                   ENDIF
      ** If record not found, then write record
     C                   EXSR      #PWRIT
     C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
      *
      **   Exit from program
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    #PWRIT - Write record to PF/GPGLCUSL                       *
      *                                                               *
      *****************************************************************
      *
     C     #PWRIT        BEGSR
      *
      ** Write record to GPGLCUSL
      * Branch
     C                   EVAL      CGBRCD   = BBBRCD
      * Local Customer Number
      *
     C                   EVAL      CGCUST   = BBCUST
     C**********         EVAL      CGGLOB   = BBCUST
     C                   EVAL      CGGLOB   = BBBRCD + '-' + BBCUST
     C                   EVAL      CGCNUM   = BBCUST
      * Cust. Name & Address 1
      * Cust. Name & Address 2
      * Cust. Name & Address 3
      * Cust. Name & Address 4
     C                   EVAL      CGNA1    = BBCNA1
     C                   EVAL      CGNA2    = BBCNA2
     C                   EVAL      CGNA3    = BBCNA3
     C                   EVAL      CGNA4    = BBCNA4
      * Customer Report Name
      * Customer Report Town
     C                   EVAL      CGRNM    = BBCRNM
     C                   EVAL      CGRTN    = BBCRTN
      * Bank/non-bank Indicator
     C                   EVAL      CGNBI    = BBBNBI
      * Global Industry Code
     C                   EVAL      CGICD    = BBLICD
      * Global Account Officer Code
     C                   EVAL      CGACO    = BBACOC
      * Country of Citizenship
      * Country of Location
     C                   EVAL      CGCNCZ   = BBCNCZ
     C                   EVAL      CGCOLC   = BBCOLC
      * Date Deleted
     C                   EVAL      CGDTDL   = BBDTDL
      * Get zone
     C                   EVAL      CGZONE   = Zone_ID
      * Status
     C                   IF        BBDTDL > 0
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
      * Update
     C                   WRITE     GPGLCUSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *INZSR - Initial Processing                        *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  MAIN   - Control Process                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR                                                  ** *INZSR **
      *
      ** Trigger Program parameters
     C     *ENTRY        PLIST
     C                   PARM                    QPARM1
      *
      ** Set up copyright parameter
     C                   MOVEA     ARR@          CPY2@            80
      *
      ** Using offsets and lengths provided get the after
      ** images
     C     Q2ROFF        ADD       1             Q                 5 0
     C     Q2RLEN        SUBST     QPARM1:Q      QFILEA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** ARR@
(C) Copyright Finastra International Limited 2020
