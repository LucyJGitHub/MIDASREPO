     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX000651 - Midas SD Flag Cust as deleted in STDSED STDADSED  *
      *                                                               *
      *  Function:  This program will flag customer to be deleted in  *
      *             STDSED and STDADSED. Update the corresponding     *
      *             trailder file                                     *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. HUT122    *CREATE  Date 10May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT122 - Deletion of PMPORTPD SDEXSTPD and STDSED Details    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Standard Additional Settlements Details
     FXXSTDAL1  UF   E           K DISK
      *

      ** SE Standard Settlement file
     FXXSTDSL1  UF   E           K DISK

     FSTDSEA    UF   E             DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Programs, Short Data Structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

     D STATUS          S              1

     D PRtcd           S              7A
     D POptn           S              7A

      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064

      ** Timestamp for the transaction
     D TimeStamp       S               Z
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

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C
     C                   EXSR      SRDelSTDDES
      *
     C                   EXSR      SRResponse
      *
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelSTDDES- Delete SE Standard Settlement                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     SRDelSTDDES   BEGSR
      *
     C     KLIST1        SETLL     XXSTDSL1
     C     KLIST1        READE     XXSTDSL1                               88
      *
     C     *IN88         DOWEQ     '0'
     C     STATUS        ANDNE     'F'
      *
     C     RECI          IFNE      '*'
     C                   EVAL      CusCount = CusCount + 1
     C                   EVAL      RECI = '*'
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'D'
      *
     C                   UPDATE    STDSEDF                              80
      *
     C                   ENDIF
      *
     C     *IN80         IFEQ      '0'
     C                   EVAL      Status = 'S'
     C                   ELSE
     C                   EVAL      Status = 'F'
     C                   ENDIF
      *
     C                   EXSR      SRDelSTDADS
      *
      ** Read next customer to delete
      *
     C     KLIST1        READE     XXSTDSL1                               88
      *
     C                   ENDDO
      *
      ** Update Customer trailer
      *
     C                   IF        CusCount > 0
     C
     C                   EXSR      SNCHRC
     C
     C                   ENDIF

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelSTDADS- Delete SE Standard Additional Settlement         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     SRDelSTDADS   BEGSR
      *
     C                   EVAL      *IN77 = *OFF
      *
     C     KLIST1        SETLL     STDADSD0
      *
     C     *IN77         DOWEQ     '0'
     C     STATUS        ANDNE     'F'
      *
     C     KLIST1        READE     STDADSD0                               77
     C     *IN77         IFEQ      '0'
     C     SARECI        ANDNE     '*'
     C                   EVAL      SARECI = '*'
      *
     C                   UPDATE    STDADSD0
      *
     C                   ENDIF
      *
     C                   ENDDO

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRResponse - Return message code                              *
      *                                                               *
      *****************************************************************
     C     SRResponse    BEGSR

      ** Check if closure is successful or failed

     C     Status        IFEQ      'S'

     C                   EVAL      Response =  'STDSEDOK'

     C                   ELSE
     C     Status        IFEQ      'F'

     C                   EVAL      Response =  'STDSEDNOK'

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNCHRC - Change Standing Data Controls                        *
      *                                                               *
      *****************************************************************
     C     SNCHRC        BEGSR

      ** GET AUDIT RECORD

     C     1             CHAIN     STDSEAF                            99

      ** UPDATE AUDIT RECORD IF FOUND

     C     *IN99         IFEQ      '0'

      ** FOR DELETIONS, UPDATE NO. DELETIONS TODAY, AND NO. OF LIVE RECS

     C                   ADD       CusCount      SDEL
     C                   SUB       CusCount      NORE

     C                   UPDATE    STDSEAF

      ** AUDIT RECORD NOT FOUND: DATABASE ERROR

     C                   ELSE
     C*
     C                   SETON                                        U7U8
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'STDSE'       DBFILE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
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

     C     *ENTRY        PLIST
      *
      ** Customer to be closed
     C                   PARM                    W0CNUM            6
      *
      ** Return Response
     C                   PARM                    Response          9

      ** INITIALIZE CUSTOMER

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBFILE = *Blanks
     C                   EVAL      DBKEY  = *Blanks
     C                   EVAL      DBMOD  = *Blanks
     C                   EVAL      DBPROC = *Blanks
     C                   OUT       LDA
      *
      ** Obtain Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'                          *************
     C                   EVAL      DBase = 001                                  * DBERR 001 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      Status = 'S'
     C                   EVAL      Response =  *BLANK
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      *IN99 = *OFF
     C                   Z-ADD     0             CusCount          5 0
      *
     C     KLIST1        KLIST
     C                   KFLD                    W0CNUM            6
     C
     C                   ENDSR

      **********************************************************************
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   ROLBK
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2023
