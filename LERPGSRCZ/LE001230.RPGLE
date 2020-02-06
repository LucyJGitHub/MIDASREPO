     H DEBUG
     H COPYRIGHT('(c) Finastra International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Fee Rate Change History Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE001230 - Fee Rate Change History Update                    *
      *                                                               *
      *  Function:  This program will run during the COB processing   *
      *             before the Main Fee Accrual processing to apply   *
      *             fee rate change amendments that have reached      *
      *             value Date to the Fee Master and History files.   *
      *             It will also generate details to the Advice file. *
      *             Finally it will delete the fee rate change        *
      *             amendment record.                                 *
      *                                                               *
      *  Called By: LEC001230 - Fee Rate Change History Update Ctrl   *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD021377           Date 18Jul18               *
      *  Prev Amend No. CLE071  *CREATE    Date 18Jul18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021377 - Reversed Fee Rate Changes have FCRECI = 'R'.      *
      *             Amend program to change the checking for reversed *
      *             Fee Rate changes from '*' to 'R'.                 *
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

     FLEFERCL1  UF   E           K DISK    INFSR(*PSSR)
      ** Midas Fee Rate Change Amendment Detail file
      *
     FLEFHSTLB  UF A E           K DISK    INFSR(*PSSR)
      ** Midas Lending Fees History for Rate Changes
      *
     FLEFEED    UF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Fees Master Detail File
      *
     FLEFRCAPD  O    E             DISK    INFSR(*PSSR)
      ** Midas LE Fee Rate Change Advice Detail File

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
      *
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
     D WSFERT1         S                   LIKE(FEFRT1)
     D WSFERT2         S                   LIKE(FEFRT2)
     D WSFERT3         S                   LIKE(FEFRT3)
     D WSFERT4         S                   LIKE(FEFRT4)
     D WSFERT5         S                   LIKE(FEFRT5)
     D WSFAMT1         S                   LIKE(FEAMT1)
     D WSFAMT2         S                   LIKE(FEAMT2)
     D WSFAMT3         S                   LIKE(FEAMT3)
     D WSFAMT4         S                   LIKE(FEAMT4)
     D WSFAMT5         S                   LIKE(FEAMT5)
     D WSFPIND         S                   LIKE(FEPIND)

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
      ** Process each Record of Fee Rate Change Amendment Detail file
      *
     C     *LOVAL        SETLL     LEFERCL1
     C                   READ      LEFERCL1
     C                   DOW       NOT %EOF(LEFERCL1)
      *
     C                   IF        FCRECI ='R'                                              MD021377
     C                   DELETE    LEFERCD0
     C                   ENDIF
      *
     C                   IF        FCRECI <> 'R' and FCRCVD < BJDNWD                        MD021377
      *
      ** Check whether record exist in the Fee Master Detail file
      *
     C     FEKEY1        CHAIN     LEFEED
     C                   IF        NOT %FOUND(LEFEED)
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEFEED'      DBFILE
     C                   MOVEL     '*KEY'        DBFILE
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Save the values of fees before update
      *
     C                   EVAL      WSFERT1 = FEFRT1
     C                   EVAL      WSFERT2 = FEFRT2
     C                   EVAL      WSFERT3 = FEFRT3
     C                   EVAL      WSFERT4 = FEFRT4
     C                   EVAL      WSFERT5 = FEFRT5
     C                   EVAL      WSFAMT1 = FEAMT1
     C                   EVAL      WSFAMT2 = FEAMT2
     C                   EVAL      WSFAMT3 = FEAMT3
     C                   EVAL      WSFAMT4 = FEAMT4
     C                   EVAL      WSFAMT5 = FEAMT5
     C                   EVAL      WSFPIND = FEPIND
      *
      ** Update the record in the Fee Details File
      *
     C                   EVAL      FEFRT1 = FCFRT1
     C                   EVAL      FEFRT2 = FCFRT2
     C                   EVAL      FEFRT3 = FCFRT3
     C                   EVAL      FEFRT4 = FCFRT4
     C                   EVAL      FEFRT5 = FCFRT5
     C                   EVAL      FEAMT1 = FCAMT1
     C                   EVAL      FEAMT2 = FCAMT2
     C                   EVAL      FEAMT3 = FCAMT3
     C                   EVAL      FEAMT4 = FCAMT4
     C                   EVAL      FEAMT5 = FCAMT5
     C                   EVAL      FEPIND = FCPIND
      *
     C                   UPDATE    LEFEEDF
      *
     C                   ENDIF
      *
      ** Check whether record exist in the History file
      *
     C     FEKEY2        CHAIN     LEFHSTLB
     C                   IF        NOT %FOUND(LEFHSTLB)
      *
      ** Write the record in the History file
      *
     C                   CLEAR                   LEFHSTF
     C                   EVAL      HIRECI = 'D'
     C                   EVAL      HIBRCA = FCBRCA
     C                   EVAL      HICNUM = FCCNUM
     C                   EVAL      HIFACL = FCFACL
     C                   EVAL      HILNRF = FCLOAN
     C                   EVAL      HIFSEQ = FCFSEQ
     C                   EVAL      HIFCOD = 0
     C                   EVAL      HIFCCY = FCFCCY
     C                   EVAL      HIAMTS = 0
     C                   EVAL      HIHDAT = 0
     C                   EVAL      HILCHD = BJRDNB
     C                   EVAL      HILCHT = 'I'
     C                   EVAL      HIAMTD = 0
     C                   EVAL      HIOSBR = ' '
     C                   EVAL      HISTTL = 0
     C                   EVAL      HIOURS = ' '
     C                   EVAL      FENLAI = ' '
     C                   EVAL      HIFRT1 = FCFRT1
     C                   EVAL      HIFRT2 = FCFRT2
     C                   EVAL      HIFRT3 = FCFRT3
     C                   EVAL      HIFRT4 = FCFRT4
     C                   EVAL      HIFRT5 = FCFRT5
     C                   EVAL      HIAMT1 = FCAMT1
     C                   EVAL      HIAMT2 = FCAMT2
     C                   EVAL      HIAMT3 = FCAMT3
     C                   EVAL      HIAMT4 = FCAMT4
     C                   EVAL      HIAMT5 = FCAMT5
     C                   EVAL      HIPIND = FCPIND
     C                   EVAL      HIRCVD = FCRCVD
     C                   EVAL      HIRCTP = 'RC'
      *
     C                   WRITE     LEFHSTF
      *
     C                   ELSE
      *
      ** Update the record in the History file
      *
     C                   EVAL      HILCHD  = BJRDNB
     C                   EVAL      HILCHT = 'A'
     C                   EVAL      HIFRT1 = FCFRT1
     C                   EVAL      HIFRT2 = FCFRT2
     C                   EVAL      HIFRT3 = FCFRT3
     C                   EVAL      HIFRT4 = FCFRT4
     C                   EVAL      HIFRT5 = FCFRT5
     C                   EVAL      HIAMT1 = FCAMT1
     C                   EVAL      HIAMT2 = FCAMT2
     C                   EVAL      HIAMT3 = FCAMT3
     C                   EVAL      HIAMT4 = FCAMT4
     C                   EVAL      HIAMT5 = FCAMT5
     C                   EVAL      HIPIND = FCPIND
      *
     C                   UPDATE    LEFHSTF
      *
     C                   ENDIF
      *
      ** Write a record in the Advice detail file
      *
     C                   CLEAR                   LEFRCAD0
     C                   EVAL      FVRECI = 'D'
     C                   EVAL      FVBRCA = FCBRCA
     C                   EVAL      FVCNUM = FCCNUM
     C                   EVAL      FVFACL = FCFACL
     C                   EVAL      FVLOAN = FCLOAN
     C                   EVAL      FVFSEQ = FCFSEQ
     C                   EVAL      FVRCVD = FCRCVD
     C                   EVAL      FVFCCY = FCFCCY
     C                   EVAL      FVCALT = FCCALT
     C                   EVAL      FVRT1B = WSFERT1
     C                   EVAL      FVRT2B = WSFERT2
     C                   EVAL      FVRT3B = WSFERT3
     C                   EVAL      FVRT4B = WSFERT4
     C                   EVAL      FVRT5B = WSFERT5
     C                   EVAL      FVAM1B = WSFAMT1
     C                   EVAL      FVAM2B = WSFAMT2
     C                   EVAL      FVAM3B = WSFAMT3
     C                   EVAL      FVAM4B = WSFAMT4
     C                   EVAL      FVAM5B = WSFAMT5
     C                   EVAL      FVPINB = WSFPIND
     C                   EVAL      FVRT1A = FEFRT1
     C                   EVAL      FVRT2A = FEFRT2
     C                   EVAL      FVRT3A = FEFRT3
     C                   EVAL      FVRT4A = FEFRT4
     C                   EVAL      FVRT5A = FEFRT5
     C                   EVAL      FVAM1A = FEAMT1
     C                   EVAL      FVAM2A = FEAMT2
     C                   EVAL      FVAM3A = FEAMT3
     C                   EVAL      FVAM4A = FEAMT4
     C                   EVAL      FVAM5A = FEAMT5
     C                   EVAL      FVPINA = FEPIND
     C                   EVAL      FVPCRF = FCPCRF
      *
     C                   WRITE     LEFRCAD0
      *
      ** Delete the record from the file LEFERCL1
      *
     C                   DELETE    LEFERCD0
      *
     C                   ENDIF
      *
     C                   READ      LEFERCL1
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
     C                   PARM      '*MSG'        PRTCD             7
     C                   PARM      '*FIRST'      POPTN             7
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
      ** Define key list for read of LEFEED file
      *
     C     FEKEY1        KLIST
     C                   KFLD                    FCBRCA
     C                   KFLD                    FCCNUM
     C                   KFLD                    FCFACL
     C                   KFLD                    FCLOAN
     C                   KFLD                    FCFSEQ
      *
      ** Define key list for read of LEFHSTLB file
      *
     C     FEKEY2        KLIST
     C                   KFLD                    FCBRCA
     C                   KFLD                    FCCNUM
     C                   KFLD                    FCFACL
     C                   KFLD                    FCLOAN
     C                   KFLD                    FCFSEQ
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
