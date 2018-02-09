     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRE071 Initialisation Program')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDHOL1INIT - Midas SD CRE071 Initialisation Program          *
      *                                                               *
      *  Function:  This program will populate SDHOL1PD file          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE071  *CREATE    Date 05Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE071 - BankFusion Midas Teller CBS related changes         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess  - To process records of SDHOLPD                    *
      * SRPopulate - To populate fields of SDHOL1PD from SDHOLPD      *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Program initialisation                           *
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
 
     FSDHOL1L0  UF A E           K DISK
      ** New Holidays file
 
     FSDHOLL0   IF   E           K DISK
      ** Holidays file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSHOLIDAY     E DS                  EXTNAME(SDHOLPD)
      ** External DS for Holidays file
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for Access Objects
 
     D Arr_Holiday     S              1    Dim(%Len(DSHOLIDAY))
      ** Holidays Array file
 
     D PSDAT           DS
      ** File information DS for D1SDAT field
 
     D  PYEAR                  1      4
     D  PDSH1                  5      5
     D  PMNTH                  6      7
     D  PDSH2                  8      8
     D  PDAYS                  9     10
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
     D PMODE           S              1A
     D @RUN            S              1A
     D WCount          S              2S 0
     D WIDx            S              3S 0
     D WMNTH           S             10A
     D PRetCode        S              7A
     D POptn           S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Program can only run once (PMODE = '1')
 
     C     PMODE         IFEQ      '1'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Subroutine to process records of SDHOLPD          *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SRPopulate                                             *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Clear SDHOL1PD first
 
     C     *LOVAL        SETLL     SDHOL1L0
     C                   READ      SDHOL1L0
 
     C                   IF        NOT %EOF(SDHOL1L0)
     C                   DOW       NOT %EOF(SDHOL1L0)
     C                   DELETE    SDHOL1D0
     C                   READ      SDHOL1L0
     C                   ENDDO
     C                   ENDIF
 
      ** Process records of SDHOLPD
 
     C     *LOVAL        SETLL     SDHOLL0
     C                   READ      SDHOLL0
 
     C                   DOW       NOT %EOF(SDHOLL0)
     C                   EVAL      WCount = 0
     C                   EVAL      WIDx = 17
     C                   MOVEA     DSHOLIDAY     Arr_Holiday
 
      ** Jan01 is at position 17
      ** Dec31 is at position 382
      ** Loop through each field of SDHOLPD to populate records in SDHOL1PD
      ** Each record in SDHOLPD = 365/366 records in SDHOL1PD
 
     C                   DOW       WIDx < 383
     C                   SELECT
     C                   WHEN      WIDx = 17 OR WIDx < 48
     C                   EVAL      D1MNTH = 'January'
     C                   EVAL      PMNTH = '01'
     C                   EVAL      WMNTH = D1MNTH
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 48 OR WIDx < 77
     C                   EVAL      D1MNTH = 'February'
     C                   EVAL      PMNTH = '02'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 77 OR WIDx < 108
     C                   EVAL      D1MNTH = 'March'
     C                   EVAL      PMNTH = '03'
     C                   EXSR      SRPopulate
     C
     C                   WHEN      WIDx = 108 OR WIDx < 138
     C                   EVAL      D1MNTH = 'April'
     C                   EVAL      PMNTH = '04'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 138 OR WIDx < 169
     C                   EVAL      D1MNTH = 'May'
     C                   EVAL      PMNTH = '05'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 169 OR WIDx < 199
     C                   EVAL      D1MNTH = 'June'
     C                   EVAL      PMNTH = '06'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 199 OR WIDx < 230
     C                   EVAL      D1MNTH = 'July'
     C                   EVAL      PMNTH = '07'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 230 OR WIDx < 261
     C                   EVAL      D1MNTH = 'August'
     C                   EVAL      PMNTH = '08'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 261 OR WIDx < 291
     C                   EVAL      D1MNTH = 'September'
     C                   EVAL      PMNTH = '09'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 291 OR WIDx < 322
     C                   EVAL      D1MNTH = 'October'
     C                   EVAL      PMNTH = '10'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 322 OR WIDx < 352
     C                   EVAL      D1MNTH = 'November'
     C                   EVAL      PMNTH = '11'
     C                   EXSR      SRPopulate
 
     C                   WHEN      WIDx = 352 OR WIDx < 383
     C                   EVAL      D1MNTH = 'December'
     C                   EVAL      PMNTH = '12'
     C                   EXSR      SRPopulate
 
     C                   ENDSL
 
     C                   EVAL      WIDx = WIDx + 1
     C                   EVAL      WCount = WCount + 1
 
     C                   ENDDO
 
     C                   READ      SDHOLL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopulate - Subroutine to populate fields of SDHOL1PD file   *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPopulate    BEGSR
 
      ** Currency Code
     C                   EVAL      D1CYCD = DGCYCD
 
      ** Location Code
     C                   EVAL      D1LCCD = DGLCCD
 
      ** Year Number
     C                   EVAL      D1YRNB = DGYRNB
 
      ** Changed Date
     C                   EVAL      D1CHDT = BJRDNB
 
      ** Reset counter if month has changed
 
     C                   IF        WMNTH <> D1MNTH
     C                   EVAL      WMNTH = D1MNTH
     C                   EVAL      WCount = 0
     C                   ENDIF
 
      ** Days
     C                   EVAL      D1DAYS = WCount + 1
 
      ** Holiday Flag
     C                   EVAL      D1HOLF = Arr_Holiday(WIDx)
 
      ** Populate Date
     C                   EVAL      PYEAR = DGYRNB
     C                   EVAL      PDSH1 = '-'
     C                   EVAL      PDSH2 = '-'
     C                   MOVE      D1DAYS        PDAYS
 
      ** Check if date is valid
     C     *ISO          TEST(D)                 PSDAT                  99
 
     C                   IF        *IN99 = *ON
     C                   LEAVESR
     C                   ELSE
     C                   MOVE      PSDAT         D1SDAT
     C                   ENDIF
 
     C                   WRITE     SDHOL1D0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
 
      ** Setup Local Data Area (LDA)
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE    =   *BLANKS
     C                   EVAL      DBKEY     =   *BLANKS
     C                   EVAL      DBPGM     =   'SDHOL1INIT'
     C                   EVAL      DBASE     =   001
     C                   EVAL      DBMOD     =   *BLANKS
     C                   EVAL      DBPROC    =   *BLANKS
     C                   OUT       LDA
 
      ** Call Access program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetcode
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetcode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   END
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      PRTCD = 'FAILURE'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
