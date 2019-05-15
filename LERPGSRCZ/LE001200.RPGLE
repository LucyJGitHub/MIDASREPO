     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Fee Rate Change Amendment Audit Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE001200 - Fee Rate Change Amendment Audit Report            *
      *                                                               *
      *  Function:  This program will produce an Audit Report of      *
      *             Fee Rate change Amendments Inserted,Amended or    *
      *             deleted during that days Input Cycle and COB on   *
      *             request.This program may also be requested during *
      *             the input cycle and COB on request processing     *
      *             to get a full listing of all Fee Rate change      *
      *             Amendments.(Run Mode *FULL or *AUDIT)             *
      *                                                               *
      *  Called By: LEC001200 - Fee Rate Change Amendment Audit Ctrl  *
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
      *    U7+U8      Database Error                                  *
      *    50         OverFlow Indicator                              *
      *    20         Report Header indicator for *AUDIT              *
      *    21         Report Header indicator for *FULL               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRFormatP1  - Formats fields of P1 report before the output   *
      * SROutputP1  - Writes P1 report and handles page overflow.     *
      * SRClrFlds   - Clears all the fields except Fee Rate and Amount*
      * SRRCFP1     - RCF processing for printer file 1               *
      * SRFMtNum1   - Formats amount fields with 3 significant figures*
      *               and 3 decimal places                            *
      * SRFMtNum2   - Formats amount fields with 0 decimals and       *
      *               leading zeros with blanks                       *
      * SRZDate2    - Convert MIDAS day Number to Date Format(DDMmmYY)*
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
     FLEFERCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Fee Rate Change Amendment Detail
      *
     FLE001200P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
      ** Fee Rate Change Amendment Report file

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
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank ICD

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for Currency details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for Customer details
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      ** File Information Data Structure for LE001210P1
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
      *
     D WZFIELD         S             14
     D ZFIELD1         S             16
     D ZADEC           S              1  0
     D WPIND           S              1
     D #FACL5          S              5
     D #FACL2          S              2

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
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
     C                   EVAL      WCOUNT = 0
     C                   EVAL      RHEAD = ' '
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
      *
      ** For Run Mode = *FULL - process all the records
      *
     C                   IF        RMODE = '*FULL'
      ** Perform Detail Processing
      *
     C                   EVAL      RHEAD = 'Fee Rate Changes Full Report'
     C                   EVAL      *IN20 = *ON
      *
     C     *LOVAL        SETLL     LEFERCL1
     C                   READ      LEFERCL1
     C                   DOW       NOT %EOF(LEFERCL1)
      *
     C                   EXSR      SRFormatP1
     C                   EVAL      WCOUNT = WCOUNT + 1
      *
     C                   READ      LEFERCL1
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** For Run Mode = *AUDIT - Process only Current day records
      *
     C                   IF        RMODE = '*AUDIT'
      *
     C                   EVAL      RHEAD = 'Fee Rate Changes' +
     C                                     ' Audit Report'
     C                   EVAL      *IN21 = *ON
      *
     C     *LOVAL        SETLL     LEFERCL1
     C                   READ      LEFERCL1
     C                   DOW       NOT %EOF(LEFERCL1)
      *
     C                   IF        FCLCHD = BJRDNB
      *
     C                   EXSR      SRFormatP1
     C                   EVAL      WCOUNT = WCOUNT + 1
      *
     C                   ENDIF
      *
     C                   READ      LEFERCL1
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   IF        *IN50 = *ON
     C                   WRITE     LE001200H1
     C                   ENDIF
      *
     C                   IF        WCOUNT = 0
     C                   WRITE     LE001200T2
     C                   ELSE
     C                   WRITE     LE001200T1
     C                   ENDIF
      *
     C                   EXSR      SRRCFP1
     C
     C                   EVAL      *INLR = *ON
     C                   RETURN

      **********************************************************************
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
     C                   PARM      Pseq          ZSEQ              5
     C                   PARM      Pent          ZENT              3
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
      * Calls:  SRZDate2,SRFmtNum1,SRFmtNum2,SROutPutP1               *
      *                                                               *
      *****************************************************************
     C     SRFormatp1    BEGSR
      *
      ** Branch Code
     C                   MOVE      FCBRCA        RBRCA
      ** Customer Number
     C                   MOVE      '000000'      RCUST
     C                   MOVE      FCCNUM        RCUST
      ** Facility Type and Number
     C                   MOVEL     *OFF          *IN15
     C                   IF        FCFACL <> *ZEROS
     C                   MOVEL     *OFF          *IN15
     C                   MOVEL     *BLANKS       RFACL
     C                   MOVE      FCFACL        #FACL5
     C                   MOVE      FCFACL        #FACL2
     C                   MOVEL     #FACL5        RFACL
     C                   MOVE      '/  '         RFACL
     C                   MOVE      #FACL2        RFACL
     C                   ENDIF
      ** Loan Number
     C                   IF        FCLOAN <> *BLANKS
     C                   MOVEL     *ON           *IN15
     C                   MOVEL     FCLOAN        RLOAN
     C                   ENDIF
      ** Fee Sequence
     C                   MOVEL     FCFSEQ        RSEQ
      ** Fee Rate Change Value Date
     C                   Z-ADD     FCRCVD        ZDAYNO
     C                   EXSR      SRZDate2
     C                   EVAL      RCVD = PADATE
      ** Currency
     C                   EVAL      RCCY = FCFCCY
      ** Calculation Type
     C                   EVAL      RCALT = FCCALT
      *
     C                   MOVE      *BLANKS       FVAMT            11
      ** Fee Rate
     C                   MOVE      FCFRT1        FVAMT
     C                   EVAL      ZADEC= 5
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFRAT = WZFIELD
      ** Fee Amount
     C                   IF        FCPIND = 'A'
     C                   MOVEL     FCAMT1        FVAMT
     C                   EVAL      ZADEC= 0
     C                   EXSR      SRFmtNum2
     C                   EVAL      RFAMT = WZFIELD
     C                   ELSE
     C                   MOVEL     FCAMT1        FVAMT
     C                   EVAL      ZADEC= 3
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFAMT = WZFIELD
     C                   ENDIF
      ** Percentage Indicator
     C                   EVAL      WPIND = FCPIND
     C                   EVAL      RPIND = FCPIND
      ** Input user
     C                   EVAL      RIUSER = FCIUSR
      ** Amend user
     C                   EVAL      RAUSER = FCAUSR
      ** Authorise user
     C                   EVAL      RATUSER = FCXUSR
      ** Last Change Type
     C                   IF        FCLCHT = 'I'
     C                   EVAL      RLCTP = 'INSERT'
     C                   ELSEIF    FCLCHT = 'A'
     C                   EVAL      RLCTP = 'AMEND'
     C                   ELSEIF    FCLCHT = 'D'
     C                   EVAL      RLCTP = 'DELETE'
     C                   ELSEIF    FCLCHT = 'X'
     C                   EVAL      RLCTP = 'AUTHORISE'
     C                   ENDIF
      *
      ** Write the records
      *
     C                   EVAL      *IN20 = *ON
     C                   EXSR      SROutPutP1
     C                   EVAL      *IN20 = *OFF
      *
      ** IF Fee Rate2 or Fee Amount2 is not zero then print a record with
      ** Fee Rate2 and Fee Amount2 values.
      *
     C                   IF        FCFRT2 <> 0 or FCAMT2 <> 0
      *
     C                   EVAL      FVAMT = *BLANKS
     C                   IF        WPIND = 'A'
     C                   MOVEL     FCAMT2        FVAMT
     C                   EVAL      ZADEC= 0
     C                   EXSR      SRFmtNum2
     C                   EVAL      RFAMT = WZFIELD
     C                   ELSE
     C                   MOVEL     FCAMT2        FVAMT
     C                   EVAL      ZADEC= 3
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFAMT = WZFIELD
     C                   ENDIF
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVE      FCFRT2        FVAMT
     C                   EVAL      ZADEC= 5
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFRAT = WZFIELD
     C                   EXSR      SRClrflds
     C                   EXSR      SROutPutP1
      *
     C                   ENDIF
      *
      ** IF Fee Rate3 or Fee Amount3 is not zero then print a record with
      ** Fee Rate3 and Fee Amount3 values.
      *
     C                   IF        FCFRT3 <> 0 or FCAMT3 <> 0
      *
     C                   IF        WPIND = 'A'
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVEL     FCAMT3        FVAMT
     C                   EVAL      ZADEC= 0
     C                   EXSR      SRFmtNum2
     C                   EVAL      RFAMT = WZFIELD
     C                   ELSE
     C                   MOVEL     FCAMT3        FVAMT
     C                   EVAL      ZADEC= 3
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFAMT = WZFIELD
     C                   ENDIF
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVE      FCFRT3        FVAMT
     C                   EVAL      ZADEC= 5
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFRAT = WZFIELD
     C                   EXSR      SRClrflds
     C                   EXSR      SROutPutP1
      *
     C                   ENDIF
      *
      ** IF Fee Rate4 or Fee Amount4 is not zero then print a record with
      ** Fee Rate4 and Fee Amount4 values.
      *
     C                   IF        FCFRT4 <> 0 or FCAMT4 <> 0
      *
     C                   IF        WPIND = 'A'
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVEL     FCAMT4        FVAMT
     C                   EVAL      ZADEC= 0
     C                   EXSR      SRFmtNum2
     C                   EVAL      RFAMT = WZFIELD
     C                   ELSE
     C                   MOVEL     FCAMT4        FVAMT
     C                   EVAL      ZADEC= 3
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFAMT = WZFIELD
     C                   ENDIF
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVE      FCFRT4        FVAMT
     C                   EVAL      ZADEC= 5
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFRAT = WZFIELD
     C                   EXSR      SRClrflds
     C                   EXSR      SROutPutP1
      *
     C                   ENDIF
      *
      ** IF Fee Rate5 or Fee Amount5 is not zero then print a record with
      ** Fee Rate4 and Fee Amount4 values.
      *
     C                   IF        FCFRT5 <> 0 or FCAMT5 <> 0
      *
     C                   IF        WPIND = 'A'
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVEL     FCAMT5        FVAMT
     C                   EVAL      ZADEC= 0
     C                   EXSR      SRFmtNum2
     C                   EVAL      RFAMT = WZFIELD
     C                   ELSE
     C                   MOVEL     FCAMT5        FVAMT
     C                   EVAL      ZADEC= 3
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFAMT = WZFIELD
     C                   ENDIF
     C                   EVAL      FVAMT = *BLANKS
     C                   MOVE      FCFRT5        FVAMT
     C                   EVAL      ZADEC= 5
     C                   EXSR      SRFmtNum1
     C                   EVAL      RFRAT = WZFIELD
     C                   EXSR      SRClrflds
     C                   EXSR      SROutPutP1
      *
     C                   ENDIF
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
      * Calls:  ZEDIT                                                 *
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
      * SRFMtNum2- Formats amount fields with 0 decimal places and    *
      *            leading zeros as blanks                            *
      *                                                               *
      * Called by: SRFormatP1                                         *
      *                                                               *
      * Calls:  ZSEDIT                                                *
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
     C                   PARM      'J'           ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   EVAL      WZFIELD = %TRIM(ZOUT21)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROutputP1 - Writes P1 report and handles page overflow       *
      *                                                               *
      * Called by: SRFormatP1                                         *
      *                                                               *
      * Calls:  None.                                                 *
      *                                                               *
      *****************************************************************
     C     SROutputP1    BEGSR
      *
     C                   IF        *IN50 = *ON
     C                   WRITE     LE001200H1
     C                   WRITE     LE001200D1
     C                   EVAL      *IN50 = *OFF
     C                   ELSE
     C                   WRITE     LE001200D1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrflds - Clears all the fields to print only Fee rate and  *
      *             fee amount when they are not zero after writing   *
      *             the record Fee Rate1 and Fee Amount1              *
      *                                                               *
      * Called by: SRFormatp1                                         *
      *                                                               *
      * Calls:  None.                                                 *
      *                                                               *
      *****************************************************************
     C     SRClrflds     BEGSR
      *
     C                   EVAL      RBRCA = ' '
     C                   EVAL      RCUST = ' '
     C                   EVAL      RFACL = ' '
     C                   EVAL      RLOAN = ' '
     C                   EVAL      RSEQ  = ' '
     C                   EVAL      RCVD  = ' '
     C                   EVAL      RCCY  = ' '
     C                   EVAL      RCALT = ' '
     C                   EVAL      RPIND = ' '
     C                   EVAL      RIUSER = ' '
     C                   EVAL      RAUSER = ' '
     C                   EVAL      RATUSER = ' '
     C                   EVAL      RLCTP = ' '
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
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RMODE             6
     C                   PARM                    Pseq              5
     C                   PARM                    Pent              3
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
      ** Number of record Printed
     C                   Z-ADD     0             WCOUNT            4 0
      *
      ** Set on the Overflow Indicator
     C                   EVAL      *IN50 = *ON
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
     C                   RETURN
      *
     C                   ENDSR
      *
