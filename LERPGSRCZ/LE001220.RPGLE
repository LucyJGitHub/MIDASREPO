     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Fee Rate Change History Initialisation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE001220 - Fee Rate Change History Initialisation            *
      *                                                               *
      *  Function:  This program will run during the COB processing   *
      *             before the Main Fee Accrual processing to write   *
      *             an initial record for each Calculated Fees        *
      *                                                               *
      *  Called By: LEC001220 - Fee Rate Change History Intialisaion  *
      *                       Control                                 *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CLE071  *CREATE    Date 18Jul18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating Of Rate Changes to Fees                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
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

     FLEFEED    IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Fees master detail file

     FLEFHSTLB  UF A E           K DISK    INFSR(*PSSR)
      ** Midas Lending Fees History for Rate Changes

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
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank ICD

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1A
     D PRTCD           S              7A
     D POPTN           S              7A

      *****************************************************************
      /EJECT
      *****************************************************************

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
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
      ** Process each Record of Fee details Master file
      *
     C     *LOVAL        SETLL     LEFEED
     C                   READ      LEFEED
     C                   DOW       NOT %EOF(LEFEED)
      *
     C                   Z-ADD     0             FCRCVD            5 0
      *
     C                   IF        (FERECI = 'D' and FEFACL <> *ZEROS and
     C                              FECALT <> *BLANKS) OR
     C                             (FERECI = 'D' and FELOAN <> *BLANKS and
     C                             (FECALT = '97' or FECALT = '98'))
      *
      ** Check whether record exist in the History file
      *
     C     HSKEY         CHAIN     LEFHSTLB
     C                   IF        NOT %FOUND(LEFHSTLB)
     C                   CLEAR                   LEFHSTF
     C                   EVAL      HIRECI = 'D'
     C                   EVAL      HIBRCA = FEBRCA
     C                   EVAL      HICNUM = FECNUM
     C                   EVAL      HIFACL = FEFACL
     C                   EVAL      HILNRF = FELOAN
     C                   EVAL      HIFSEQ = FEFSEQ
     C                   EVAL      HIFCOD = 0
     C                   EVAL      HIFCCY = FEFCCY
     C                   EVAL      HIAMTS = 0
     C                   EVAL      HIHDAT = 0
     C                   EVAL      HILCHD = BJRDNB
     C                   EVAL      HILCHT = 'I'
     C                   EVAL      HIAMTD = 0
     C                   EVAL      HIOSBR = ' '
     C                   EVAL      HISTTL = 0
     C                   EVAL      HIOURS = ' '
     C                   EVAL      FENLAI = ' '
     C                   EVAL      HIFRT1 = FEFRT1
     C                   EVAL      HIFRT2 = FEFRT2
     C                   EVAL      HIFRT3 = FEFRT3
     C                   EVAL      HIFRT4 = FEFRT4
     C                   EVAL      HIFRT5 = FEFRT5
     C                   EVAL      HIAMT1 = FEAMT1
     C                   EVAL      HIAMT2 = FEAMT2
     C                   EVAL      HIAMT3 = FEAMT3
     C                   EVAL      HIAMT4 = FEAMT4
     C                   EVAL      HIAMT5 = FEAMT5
     C                   EVAL      HIPIND = FEPIND
     C                   EVAL      HIRCVD = 0
     C                   EVAL      HIRCTP = 'IN'
      *
      ** Write the record in the History file
      *
     C                   WRITE     LEFHSTF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      LEFEED
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN

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
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Define key list for read of LEFHSTLB file
      *
     C     HSKEY         KLIST
     C                   KFLD                    FEBRCA
     C                   KFLD                    FECNUM
     C                   KFLD                    FEFACL
     C                   KFLD                    FELOAN
     C                   KFLD                    FEFSEQ
     C                   KFLD                    FCRCVD
      *
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
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
