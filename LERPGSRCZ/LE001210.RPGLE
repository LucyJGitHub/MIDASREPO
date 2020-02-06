     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Fee Rate Change Advice for Fees')             *
      *****************************************************************
      *                                                               *
      *  Midas - Lenidng Module                                       *
      *                                                               *
      *  LE001210 - Fee Rate Change Advices                           *
      *                                                               *
      *  Function:  This program will produce customer Advices        *
      *             report during the COB that a Fee rate change      *
      *             amendment is Actioned.                            *
      *                                                               *
      *  Called By: LEC001210 - Fee Rate Change Advices Control       *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CLE071  *CREATE    Date 19Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating Of Rate Changes to Fees                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    60         Error Indicator for file LE001210P1             *
      *    98         Date Format                                     *
      *    U7+U8      Database Error                                  *
      *    OA         OverFlow Indicator                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRChgBranch - Change of branch processing.                    *
      * SRFormatP1  - Formats fields of P1 report before the output   *
      * SROutputP1  - Writes P1 report and handles page overflow.     *
      * SRRCFP1     - RCF processing for printer file 1               *
      * SRFMtNum1   - Formats amount fields with 3 significant figures*
      *               and 3 decimal places                            *
      * SRFmtNum2   - Insert a decimal point and remove leading       *
      *               zeros from signed numeric field                 *
      * SRZDate2    - Convert MIDAS day Number to Date Format(DDMmmYY)*
      * SRCustAdd   - Get the Customer Address through Access Object  *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
      *
     FLEFRCAL1  IF   E           K DISK    INFSR(*PSSR)
      ** Fee Rate Change Advice Details
      *
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYFNF)
     F                                     IGNORE(FCLTYZZF)
      ** Facility File
      *
     FLE001210P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1) USROPN
     F                                     OFLIND(OA)
      ** Fee Rate Advice Report Files

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details

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
     D CALTARR         S             10    DIM(17) CTDATA PERRCD(1)
      ** Fee Narratives

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank ICD

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for Currency details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
      ** Data structure for Customer details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Data structure for Branch details
      *
     D WLEFRCAPD     E DS                  EXTNAME(LEFRCAL1)
     D WFVTYP                 11     13  0
     D WFVNUM                 14     15  0
      ** For Facility Type and Number

     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      ** File Information Data Structure for LE001210P1

     D WRVFACL         DS
     D WRVCNUM                 1      6
     D WRVCTYP                 7      9  0
     D WRVNUM                 10     11  0
      ** For Facility Type and Number

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
      *
     D WZFIELD         S             14
     D ZFIELD1         S             16
     D ZFIELD          S             15  0
     D ZADEC           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
     D WPOS            S              2  0

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
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
      ** Perform Detail Processing
      *
     C     *LOVAL        SETLL     LEFRCAL1
     C                   READ      LEFRCAL1
     C                   DOW       NOT %EOF(LEFRCAL1)
      *
      ** Change of Branch
      *
     C                   IF        FVBRCA <> WBRCA
     C                   EXSR      SRChgBranch
     C                   ENDIF
      *
     C                   EXSR      SRFormatP1
     C                   EXSR      SROutputP1
      *
     C                   READ      LEFRCAL1
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChgBranch - Change of branch processing.                    *
      *                                                               *
      * Called by: Main processingrogram activation                   *
      *                                                               *
      * Calls:     *PSSR, SRRCFP1                                     *
      *                                                               *
      *****************************************************************

     C     SRChgBranch   BEGSR
      *
      ** Close P1 printer file of the old branch
      *
     C                   IF        WOpenP1 = 'Y'
     C                   CLOSE     LE001210P1
     C                   EVAL      WOpenP1 = 'N'
     C                   ENDIF
      *
      ** Open P1 printer file for the new branch
      *
     C                   OPEN      LE001210P1                           60
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE001210P1'  DBFILE
     C                   MOVEL     '*OPEN   '    DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WOpenP1 = 'Y'
     C                   EXSR      SRRCFP1
      *
      ** Save branch of the current printer file
      *
     C                   EVAL      WBRCA = FVBRCA
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - RCF processing for printer file 1                   *
      *                                                               *
      * Called by: SRChgBranch                                        *
      *                                                               *
      * Calls:     ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM      ' '           ZSEQ              5
     C                   PARM      FVBRCA        ZENT              3
     C                   PARM      SFILE1        ZSNAM            10
     C                   PARM      SFNUM1        ZSNUM             6 0
     C                   PARM      *BLANK        ZERR              1
     C                   IF        ZERR = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFormatP1 - Formats fields of P1 report before the output.   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:  SRZDate2,SRFmtNum1,SRFmtNum2                          *
      *                                                               *
      *****************************************************************
     C     SRFormatp1    BEGSR
      *
      ** Move the Branch Code
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      FVBRCA        @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C
     C                   MOVE      FVBRCA        RBRCA
     C                   MOVE      A8BRNM        RBRNM
      *
      ** Borrower field
      *
     C                   IF        FVFACL <> *ZEROS
     C                   EVAL      RCDTYP ='A'
     C     FCLKY         CHAIN     FCLTYFMF
     C                   IF        %FOUND(FCLTY)
      *
     C                   IF        PRTR = 'P'
     C                   EVAL      *IN20 = *OFF
     C                   MOVEL     PMFC          RPMFC
     C                   MOVEL     PMFC          PICust
     C                   EXSR      SRCustAdd
      *
     C                   ELSE
      *
     C                   EVAL      *IN20 = *ON
     C                   MOVEL     FVCNUM        PICust
     C                   EXSR      SRCustAdd
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'FCLTY'       DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     WRVFACL       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVLOAN <> *BLANKS
     C                   MOVEL     FVCNUM        PICust
     C                   EXSR      SRCustAdd
     C                   ENDIF
      *
      ** Current system Date
      *
     C                   MOVEL     RUNDAT        RDATE
      *
      ** Converting Fee Rate change value date
      *
     C                   EXSR      SRZDate2
      *
     C                   MOVE      PADATE        RCVD
      *
     C                   EVAL      RCCUST = '000000'
     C                   MOVEL     FVCNUM        RCCUST
     C                   EVAL      *IN15 = *OFF
      *
     C                   IF        FVFACL <> *ZEROS
     C                   EVAL      *IN15 = *OFF
     C                   MOVEL     WFVTYP        RFCTY
     C                   MOVEL     WFVNUM        RFCNO
     C                   ENDIF
     C                   IF        FVLOAN <> *BLANKS
     C                   EVAL      *IN15 = *ON
     C                   MOVEL     FVLOAN        RLOAN
     C                   ENDIF
      *
      ** Fee Sequence
      *
     C                   MOVEL     FVFSEQ        RFSEQ
      *
      ** Currency Name
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      FVFCCY        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVEL     A6CYNM        RCCY
      *
     C                   MOVEL     FVCALT        RCALT
      *
     C                   IF        FVCALT = '01'
     C                   EVAL      RCALNM  = CALTARR(4)
     C                   ELSEIF    FVCALT = '02'
     C                   EVAL      RCALNM  = CALTARR(5)
     C                   ELSEIF    FVCALT = '03'
     C                   EVAL      RCALNM  = CALTARR(6)
     C                   ELSEIF    FVCALT = '04'
     C                   EVAL      RCALNM  = CALTARR(7)
     C                   ELSEIF    FVCALT = '05'
     C                   EVAL      RCALNM  = CALTARR(8)
     C                   ELSEIF    FVCALT = '06'
     C                   EVAL      RCALNM  = CALTARR(9)
     C                   ELSEIF    FVCALT = '11'
     C                   EVAL      RCALNM  = CALTARR(10)
     C                   ELSEIF    FVCALT = '12'
     C                   EVAL      RCALNM  = CALTARR(11)
     C                   ELSEIF    FVCALT = '13'
     C                   EVAL      RCALNM  = CALTARR(12)
     C                   ELSEIF    FVCALT = '14'
     C                   EVAL      RCALNM  = CALTARR(13)
     C                   ELSEIF    FVCALT = '15'
     C                   EVAL      RCALNM  = CALTARR(14)
     C                   ELSEIF    FVCALT = '16'
     C                   EVAL      RCALNM  = CALTARR(15)
     C                   ELSEIF    FVCALT = '21'
     C                   EVAL      RCALNM  = CALTARR(16)
     C                   ELSEIF    FVCALT = '22'
     C                   EVAL      RCALNM  = CALTARR(17)
     C                   ELSEIF    FVCALT = '97'
     C                   EVAL      RCALNM  = CALTARR(3)
     C                   ELSEIF    FVCALT = '98'
     C                   EVAL      RCALNM  = CALTARR(3)
     C                   ENDIF
      *
      ** Fee Rates Before Amendment
      *
     C                   MOVE      *BLANKS       FVAMT            11
      *
     C                   IF        FVRT1B = 0
     C                   MOVE      *BLANKS       RFRAT1
     C                   ELSE
     C                   MOVE      FVRT1B        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFRAT1
     C                   ENDIF
      *
     C                   IF        FVRT2B = 0
     C                   MOVE      *BLANKS       RFRAT2
     C                   ELSE
     C                   MOVE      FVRT2B        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFRAT2
     C                   ENDIF
      *
     C                   IF        FVRT3B = 0
     C                   MOVE      *BLANKS       RFRAT3
     C                   ELSE
     C                   MOVE      FVRT3B        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFRAT3
     C                   ENDIF
      *
     C                   IF        FVRT4B = 0
     C                   MOVE      *BLANKS       RFRAT4
     C                   ELSE
     C                   MOVE      FVRT4B        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFRAT4
     C                   ENDIF
      *
     C                   IF        FVRT5B = 0
     C                   MOVE      *BLANKS       RFRAT5
     C                   ELSE
     C                   MOVE      FVRT5B        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFRAT5
     C                   ENDIF
      *
      ** Fee Amounts Before Amendment
      *
      ** Check the Percentage Indicator for P or A
      *
     C     FVPINB        IFEQ      'P'
      *
      ** Show the Amount Value as XXX.XXX%
      *
     C                   IF        FVAM1B = 0
     C                   MOVE      *BLANKS       RFAMT1
     C                   ELSE
     C                   MOVE      FVAM1B        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFAMT1
     C                   EVAL      WPOS = %LEN(%TRIM(RFAMT1))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RFAMT1:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RFAMT1:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM2B = 0
     C                   MOVE      *BLANKS       RFAMT2
     C                   ELSE
     C                   MOVE      FVAM2B        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFAMT2
     C                   EVAL      WPOS = %LEN(%TRIM(RFAMT2))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RFAMT2:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RFAMT2:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM3B = 0
     C                   MOVE      *BLANKS       RFAMT3
     C                   ELSE
     C                   MOVE      FVAM3B        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFAMT3
     C                   EVAL      WPOS = %LEN(%TRIM(RFAMT3))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RFAMT3:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RFAMT3:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM4B = 0
     C                   MOVE      *BLANKS       RFAMT4
     C                   ELSE
     C                   MOVE      FVAM4B        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFAMT4
     C                   EVAL      WPOS = %LEN(%TRIM(RFAMT4))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RFAMT4:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RFAMT4:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM5B = 0
     C                   MOVE      *BLANKS       RFAMT5
     C                   ELSE
     C                   MOVE      FVAM5B        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RFAMT5
     C                   EVAL      WPOS = %LEN(%TRIM(RFAMT5))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RFAMT5:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RFAMT5:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        FVAM1B = 0
     C                   MOVE      *BLANKS       RFAMT1
     C                   ELSE
     C                   MOVE      FVAM1B        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RFAMT1
     C                   ENDIF
      *
     C                   IF        FVAM2B = 0
     C                   MOVE      *BLANKS       RFAMT2
     C                   ELSE
     C                   MOVE      FVAM2B        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RFAMT2
     C                   ENDIF
      *
     C                   IF        FVAM3B = 0
     C                   MOVE      *BLANKS       RFAMT3
     C                   ELSE
     C                   MOVE      FVAM3B        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RFAMT3
     C                   ENDIF
      *
     C                   IF        FVAM4B = 0
     C                   MOVE      *BLANKS       RFAMT4
     C                   ELSE
     C                   MOVE      FVAM4B        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RFAMT4
     C                   ENDIF
      *
     C                   IF        FVAM5B = 0
     C                   MOVE      *BLANKS       RFAMT5
     C                   ELSE
     C                   MOVE      FVAM5B        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RFAMT5
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Rate of Fees After Amendment
      *
     C                   MOVE      *BLANKS       FVAMT
      *
     C                   IF        FVRT1A = 0
     C                   MOVE      *BLANKS       RTRAT1
     C                   ELSE
     C                   MOVE      FVRT1A        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTRAT1
     C                   ENDIF
      *
     C                   IF        FVRT2A = 0
     C                   MOVE      *BLANKS       RTRAT2
     C                   ELSE
     C                   MOVE      FVRT2A        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTRAT2
     C                   ENDIF
      *
     C                   IF        FVRT3A = 0
     C                   MOVE      *BLANKS       RTRAT3
     C                   ELSE
     C                   MOVE      FVRT3A        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTRAT3
     C                   ENDIF
      *
     C                   IF        FVRT4A = 0
     C                   MOVE      *BLANKS       RTRAT4
     C                   ELSE
     C                   MOVE      FVRT4A        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTRAT4
     C                   ENDIF
      *
     C                   IF        FVRT5A = 0
     C                   MOVE      *BLANKS       RTRAT5
     C                   ELSE
     C                   MOVE      FVRT5A        FVAMT
     C                   MOVE      5             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTRAT5
     C                   ENDIF
      *
      ** Amount Fees After Amendment
      *
     C                   MOVE      *BLANKS       FVAMT
      *
     C     FVPINA        IFEQ      'P'
      *
     C                   IF        FVAM1A = 0
     C                   MOVE      *BLANKS       RTAMT1
     C                   ELSE
     C                   MOVE      FVAM1A        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTAMT1
     C                   EVAL      WPOS = %LEN(%TRIM(RTAMT1))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RTAMT1:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RTAMT1:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM2A = 0
     C                   MOVE      *BLANKS       RTAMT2
     C                   ELSE
     C                   MOVE      FVAM2A        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTAMT2
     C                   EVAL      WPOS = %LEN(%TRIM(RTAMT2))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RTAMT2:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RTAMT2:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM3A = 0
     C                   MOVE      *BLANKS       RTAMT3
     C                   ELSE
     C                   MOVE      FVAM3A        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTAMT3
     C                   EVAL      WPOS = %LEN(%TRIM(RTAMT3))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RTAMT3:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RTAMT3:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM4A = 0
     C                   MOVE      *BLANKS       RTAMT4
     C                   ELSE
     C                   MOVE      FVAM4A        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTAMT4
     C                   EVAL      WPOS = %LEN(%TRIM(RTAMT4))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RTAMT4:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RTAMT4:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FVAM5A = 0
     C                   MOVE      *BLANKS       RTAMT5
     C                   ELSE
     C                   MOVE      FVAM5A        FVAMT
     C                   MOVE      3             ZADEC
     C                   EXSR      SRFmtNum1
     C                   MOVEL     WZFIELD       RTAMT5
     C                   EVAL      WPOS = %LEN(%TRIM(RTAMT5))
     C                   IF        WPOS < 14
     C                   EVAL      %SUBST(RTAMT5:WPOS+1:1)='%'
     C                   ELSE
     C                   EVAL      %SUBST(RTAMT5:WPOS:1)='%'
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   ELSE
      *
     C                   IF        FVAM1A = 0
     C                   MOVE      *BLANKS       RTAMT1
     C                   ELSE
     C                   MOVE      FVAM1A        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RTAMT1
     C                   ENDIF
      *
     C                   IF        FVAM2A = 0
     C                   MOVE      *BLANKS       RTAMT2
     C                   ELSE
     C                   MOVE      FVAM2A        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RTAMT2
     C                   ENDIF
      *
     C                   IF        FVAM3A = 0
     C                   MOVE      *BLANKS       RTAMT3
     C                   ELSE
     C                   MOVE      FVAM3A        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RTAMT3
     C                   ENDIF
      *
     C                   IF        FVAM4A = 0
     C                   MOVE      *BLANKS       RTAMT4
     C                   ELSE
     C                   MOVE      FVAM4A        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RTAMT4
     C                   ENDIF
      *
     C                   IF        FVAM5A = 0
     C                   MOVE      *BLANKS       RTAMT5
     C                   ELSE
     C                   MOVE      FVAM5A        FVAMT
     C                   EXSR      SRFmtNum2
     C                   MOVEL     WZFIELD       RTAMT5
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFMtNum1- Formats amount fields with 3 significant figures   *
      *            and 3 decimal places                               *
      *                                                               *
      * Called by: SRFormatP1                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRFmtNum1     BEGSR
      *
     C                   MOVE      *BLANKS       ZFIELD1
     C                   MOVE      FVAMT         ZFIELD1
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD1
     C                   PARM                    ZADEC
     C                   EVAL      WZFIELD = %TRIM(ZFIELD1)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFMtNum2 - Format amount fields with 3 significant figures   *
      *            and 3 decimal places                               *
      *                                                               *
      * Called by: SRFormatP1                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRFmtNum2     BEGSR
      *
     C                   MOVE      *BLANKS       ZFIELD           15 0
     C                   MOVE      FVAMT         ZFIELD
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C                   EVAL      WZFIELD = %TRIM(ZOUT21)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROutputP1 - Writes P1 report and handles page overflow       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:  None.                                                 *
      *                                                               *
      *****************************************************************
     C     SROutputP1    BEGSR
      *
     C                   WRITE     LE001210D1
     C                   EVAL      *INOA = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2  - Convert MIDAS Day number to Date Format(DDMmmYY)  *
      *                                                               *
      * Called by: SRFormatP1                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZdate2      BEGSR
      *
     C                   Z-ADD     FVRCVD        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut          6 0
     C                   PARM      *BLANK        PADate            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustAdd- Get the Customer Address through Access Object     *
      *                                                               *
      * Called by: SRFormatP1                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCustAdd     BEGSR
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCde           7
     C                   PARM      '*KEY   '     POption           7
     C                   PARM                    PICust           10
     C                   PARM      *BLANKS       PIChr007          7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      *
      ** Reporting the Address of the Customer
      *
     C                   MOVEL     BBCNA1        RCCNA1
     C                   MOVEL     BBCNA2        RCCNA2
     C                   MOVEL     BBCNA3        RCCNA3
     C                   MOVEL     BBCNA4        RCCNA4
      *
     C                   ENDSR
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

     C     *Entry        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PBRAN             3
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRTCD             7
     C                   PARM      '*FIRST'      POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
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
      ** Previous Branch
     C                   MOVE      *BLANK        WBRCA             3
      *
      ** Indicates if P1 printer file is already open
     C                   MOVE      *BLANK        WOpenP1           1
      *
     C     FCLKY         KLIST
     C                   KFLD                    FVCNUM
     C                   KFLD                    WFVTYP
     C                   KFLD                    WFVNUM
     C                   KFLD                    RCDTYP            1
     C
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
      *
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
** CALTARR
TIERED
THRESHLD
SINGLE
AVL/AVE/TR
AVL/AVE/TH
AVL/AVE/SI
AVL/ACT/TR
AVL/ACT/TH
AVL/ACT/SI
OUT/AVE/TR
OUT/AVE/TH
OUT/AVE/SI
OUT/ACT/TR
OUT/ACT/TH
OUT/ACT/SI
FAC/AVE/SI
FAC/ACT/SI
